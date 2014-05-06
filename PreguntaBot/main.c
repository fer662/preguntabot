//
//  main.c
//  PreguntaBot
//
//  Created by Fernando Mazzon on 5/4/14.
//  Copyright (c) 2014 Fer662. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreguntaBotClient.h"
#import "NSArray+Functional.h"
#import "PreguntaBot.h"

int main(int argc, const char * argv[])
{
    __strong NSMutableArray *bots = [NSMutableArray array];
    [bots addObject:[[PreguntaBot alloc] initWithApSession:@"ceb79694ecd4f27767889752226df1765218c01c" userId:@"32612727"]];
    [bots addObject:[[PreguntaBot alloc] initWithApSession:@"74001b4ce8b137380e582a1f622d91b4af3fba06" userId:@"28876178"]];

    [bots makeObjectsPerformSelector:@selector(logic)];
    
    BOOL shouldKeepRunning = YES;
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    
    return 0;
}
