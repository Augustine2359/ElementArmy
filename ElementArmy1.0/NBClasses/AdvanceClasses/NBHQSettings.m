//
//  NBHQSettings.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 25/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "NBHQSettings.h"


@implementation NBHQSettings

-(id)initWithLayer:(id)layer{
    if (self = [super init]) {
        [self initialise];
    }
    
    return self;

}

-(void)initialise{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    [self setPosition:ccp(0, -320)];
}

@end
