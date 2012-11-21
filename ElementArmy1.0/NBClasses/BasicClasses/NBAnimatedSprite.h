//
//  NBAnimatedSprite.h
//  NebulaGame1_1
//
//  Created by Romy Irawaty on 4/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBAnimationDefinition.h"

@interface NBAnimatedSprite : NSObject
{
@public
    bool animationIsPlaying;
    CCAction* currentAction;
    
    id currentAnimationTarget;
    SEL currentAnimationResponseSelector;
}

-(id)initWithAnimationCount:(int)animationCount withImagePointer:(CCSprite*)image;
-(void)addAnimation:(NSString*)animationName withFileHeaderName:(NSString*)fileName withAnimationCount:(int)animationCount;
-(bool)playAnimation:(NSString*)animationName withDelay:(CGFloat)delay andRepeatForever:(bool)repeatForever withTarget:(id)target andSelector:(SEL)selector;
-(void)stopAnimation;
-(void)addDefaultFrame:(NSString*)fileName;
-(void)useDefaultframe;
-(void)onAnimationCompleted;

@property (nonatomic, readwrite, assign) CCArray* animationList;
@property (nonatomic, readwrite, retain) CCSprite* imagePointer;
@property (nonatomic, retain) NSString* currentPlayingAnimation;
@property (nonatomic, retain) NSString* previousPlayingAnimation;
@property (nonatomic, retain) CCSpriteFrame* defaultFrame;

@end
