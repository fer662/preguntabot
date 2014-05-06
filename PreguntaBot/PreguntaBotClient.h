//
//  PreguntaBotClient.h
//  PreguntaBot
//
//  Created by Fernando Mazzon on 5/4/14.
//  Copyright (c) 2014 Fer662. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^CompletionBlock)(BOOL result, id resultObject);

@interface PreguntaBotClient : AFHTTPClient

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *apSession;
@property (nonatomic, strong) NSString *appVersion;

- (void)getDashboard:(CompletionBlock)completion;
- (void)getGame:(NSString *)gameId completion:(CompletionBlock)completion;
- (void)newGame:(CompletionBlock)completion;
- (void)answerQuestion:(NSString *)questionId category:(NSString *)category answer:(NSNumber *)answer type:(NSString *)type game:(NSString *)gameId completion:(CompletionBlock)completion;

@end
