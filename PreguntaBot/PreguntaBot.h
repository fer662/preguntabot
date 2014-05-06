//
//  PreguntaBot.h
//  PreguntaBot
//
//  Created by Fernando Mazzon on 5/4/14.
//  Copyright (c) 2014 Fer662. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreguntaBot : NSObject

- (id)initWithApSession:(NSString *)apSession userId:(NSString *)userId;
- (void)logic;

@end
