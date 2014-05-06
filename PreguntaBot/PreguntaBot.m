//
//  PreguntaBot.m
//  PreguntaBot
//
//  Created by Fernando Mazzon on 5/4/14.
//  Copyright (c) 2014 Fer662. All rights reserved.
//

#import "PreguntaBot.h"
#import "PreguntaBotClient.h"
#import "NSArray+Functional.h"

@interface PreguntaBot ()

@property (nonatomic, strong) PreguntaBotClient *client;
@end

@implementation PreguntaBot

- (instancetype)initWithApSession:(NSString *)apSession userId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.client = [[PreguntaBotClient alloc] init];
        self.client.apSession = apSession;
        self.client.userId = userId;
    }
    return self;
}

- (void)logic
{
    [self.client getDashboard:^(BOOL result, id resultObject) {
        NSInteger lives = [resultObject[@"lives"][@"quantity"] intValue];
        NSDictionary *game = [resultObject[@"list"] match:^BOOL(NSDictionary *game) {
            return [game[@"my_turn"] boolValue] && ![game[@"game_status"] isEqualToString:@"ENDED"] && (![game[@"game_status"] isEqualToString:@"PENDING_APPROVAL"] || lives > 0);
        }];
        
        if (game) {
            [self.client getGame:game[@"id"] completion:^(BOOL result, id game) {
                [self playGame:game];
            }];
        }
        else if (lives > 0) {
            NSLog(@"%@::Creating random game!", self.client.userId);
            [self.client newGame:^(BOOL result, id game) {
                [self playGame:game];
            }];
        }
        else {
            NSLog(@"%@::No more games to win :(. Waiting 15!!!", self.client.userId);
            [self performSelector:@selector(logic) withObject:nil afterDelay:15];

        }
    }];
    
}

- (void)playGame:(NSDictionary *)game
{
    if (![game[@"my_turn"] boolValue] || [game[@"game_status"] isEqualToString:@"ENDED"]) {
        [self logic];
        return;
    }
    NSArray *spins = game[@"spins_data"][@"spins"];
    
    NSDictionary *spin = spins[0];

    if ([spin[@"type"] isEqualToString:@"NORMAL"]) {
        NSDictionary *question = [spin[@"questions"] objectAtIndex:0][@"question"];
        [self answerQuestion:question type:spin[@"type"] game:game[@"id"] completion:^(BOOL result, id newGame) {
            [self playGame:newGame];
        }];
    }
    else if ([spin[@"type"] isEqualToString:@"CROWN"]) {
        NSDictionary *question = [spin[@"questions"] objectAtIndex:0][@"question"];
        [self answerQuestion:question type:spin[@"type"] game:game[@"id"] completion:^(BOOL result, id newGame) {
            [self playGame:newGame];
        }];
        //NSLog(@"CROWN QUESTION FOR GAME %@", game[@"id"]);
    }
    else if ([spin[@"type"] isEqualToString:@"DUEL"]) {
        
    }
}

- (void)answerQuestion:(NSDictionary *)question type:(NSString *)type game:(NSString *)game completion:(CompletionBlock)completion
{
    NSString *questionId = question[@"id"];
    NSString *category = question[@"category"];
    NSNumber *correctAnswer = question[@"correct_answer"];
    
    NSLog(@"%@::ANSWER %@:%@", self.client.userId, game, questionId);
    
    [self.client answerQuestion:questionId
                                            category:category
                                              answer:correctAnswer
                                                type:type
                                                game:game
                                          completion:^(BOOL result, id resultObject) {
                                              if (result) {
                                                  completion(result, resultObject);
                                              }
                                              else {
                                                  [NSThread sleepForTimeInterval:3];
                                                  [self answerQuestion:question type:type game:game completion:completion];
                                              }
                                          }];
}

@end
