//
//  PreguntaBotClient.m
//  PreguntaBot
//
//  Created by Fernando Mazzon on 5/4/14.
//  Copyright (c) 2014 Fer662. All rights reserved.
//

#import "PreguntaBotClient.h"
#import <AFNetworking/AFNetworking.h>
#import "NSArray+Functional.h"

@implementation PreguntaBotClient

+ (PreguntaBotClient *)sharedClient
{
    static PreguntaBotClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PreguntaBotClient alloc] init];
    });
    
    return _sharedClient;
}

- (id)init
{
    if ((self = [super initWithBaseURL:[NSURL URLWithString:@"http://api.preguntados.com"]])) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        self.parameterEncoding = AFJSONParameterEncoding;
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Eter-Agent" value:@"1|iOS-AppStr|iPhone 4S|0|iOS 7.1|0|1.5|en|en|US|1"];
        [self setDefaultHeader:@"User-Agent" value:@"Preguntados/1.5 (iPhone; iOS 7.1; Scale/2.00)"];
        self.appVersion = @"4549618";
    }
    return self;
}

- (void)setApSession:(NSString *)apSession
{
    _apSession = apSession;
    
    [self setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"ap_session=%@", self.apSession]];
}

- (void)getDashboard:(CompletionBlock)completion
{
    [self getPath:[NSString stringWithFormat:@"api/users/%@/dashboard?app_config_version=%@",
                   self.userId,
                   self.appVersion]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(YES, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
}

- (void)getGame:(NSString *)gameId completion:(CompletionBlock)completion
{
    [self getPath:[NSString stringWithFormat:@"api/users/%@/games/%@",
                   self.userId,
                   gameId]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(YES, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
}

- (void)newGame:(CompletionBlock)completion
{
    [self postPath:[NSString stringWithFormat:@"api/users/%@/games",
                    self.userId] parameters:@{@"language":@"es"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO, nil);
    }];
}

- (void)answerQuestion:(NSString *)questionId category:(NSString *)category answer:(NSNumber *)answer type:(NSString *)type game:(NSString *)gameId completion:(CompletionBlock)completion
{
    [self postPath:[NSString stringWithFormat:@"api/users/%@/games/%@/answers",
                   self.userId,
                   gameId]
       parameters:@{
                    @"type":type,
                    @"answers":
                            @[
                                @{
                                    @"id":questionId,
                                    @"category":category,
                                    @"answer":answer
                                    }
                              ]
                    
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(YES, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(NO, nil);
          }];
}

@end
