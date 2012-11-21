//
//  NBAnimatedSprite.m
//  NebulaGame1_1
//
//  Created by Romy Irawaty on 4/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NBAnimatedSprite.h"


@implementation NBAnimatedSprite

@synthesize animationList;
@synthesize imagePointer;
@synthesize currentPlayingAnimation, previousPlayingAnimation;
@synthesize defaultFrame;

-(id)initWithAnimationCount:(int)animationCount withImagePointer:(CCSprite*)image
{
    if ((self = [super init]))
    {
        self.animationList = [CCArray arrayWithCapacity:animationCount];
        self.imagePointer = image;
    }
    
    return self;
}

-(void)addAnimation:(NSString*)animationName withFileHeaderName:(NSString*)fileName withAnimationCount:(int)animationCount
{
    NBAnimationDefinition* animationDefinition = [[NBAnimationDefinition alloc] init];
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    // Load the ship's animation frames
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:animationCount];
    [frames retain];
    
    for (int i = 0; i < animationCount; i++)
    {
        NSString* localFileName = [NSString stringWithFormat:@"%@_%i.png", fileName, i + 1];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:localFileName];
        [frames addObject:frame];
    }
    
    animationDefinition->AnimationName = animationName;
    animationDefinition->AnimationFrames = frames;
    [self.animationList addObject:animationDefinition];
    [self.animationList retain];
    NSLog(@"count of animation : %i", [self.animationList count]);
}

-(bool)playAnimation:(NSString*)animationName withDelay:(CGFloat)delay andRepeatForever:(bool)repeatForever withTarget:(id)target andSelector:(SEL)selector;
{
    NBAnimationDefinition* animationDefinition;
    
    //If the requested animation is the same with the current playing animation, ignore
    //But if it is different, stop the previous playing animation
    if ([animationName isEqualToString:currentPlayingAnimation])
        return false;
    else
        [self.imagePointer stopAction:currentAction];
    
    for (int i = 0; i < [self.animationList count]; i++)
    {
        animationDefinition = (NBAnimationDefinition*)[self.animationList objectAtIndex:i];
        
        NSString* animationNameFromDefinition = animationDefinition->AnimationName;
        
        if (animationNameFromDefinition == animationName)
        {
            if (selector)
            {
                currentAnimationTarget = target;
                currentAnimationResponseSelector = selector;
            }
            else
            {
                currentAnimationTarget = nil;
                currentAnimationResponseSelector = nil;
            }
            
            CCCallFunc *callFunction = [CCCallFunc actionWithTarget:self selector:@selector(onAnimationCompleted)];
            CCAnimation* anim = [CCAnimation animationWithSpriteFrames:animationDefinition->AnimationFrames delay:delay];
            
            // Run the animation by using the CCAnimate action
            CCAnimate* animate = [[CCAnimate alloc] initWithAnimation:anim];
            CCSequence *sequence = [CCSequence actions:animate, callFunction, nil];
            
            if (repeatForever)
            {
                CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
                currentAction = repeat;
            }
            else
            {
                currentAction = sequence;
            }
            
            [currentAction retain];
            
            [self.imagePointer runAction:currentAction];
            animationIsPlaying = true;
            
            self.currentPlayingAnimation = animationName;
            return true;
        }
    }
    
    return false;
}

-(void)stopAnimation
{
    [self.imagePointer stopAction:currentAction];
    [currentAction release];
    
    animationIsPlaying = false;
}

-(void)addDefaultFrame:(NSString*)fileName
{
    defaultFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName];
}

-(void)useDefaultframe
{
    if (self.defaultFrame == nil) return;
    
    [self.imagePointer setDisplayFrame:self.defaultFrame];
}

-(void)onAnimationCompleted
{
    animationIsPlaying = false;
    
    if (currentAnimationTarget && currentAnimationResponseSelector)
        [currentAnimationTarget performSelector:currentAnimationResponseSelector];
    //NSLog(@"Animation completed");
}

-(void)dealloc
{
    [super dealloc];
    //[_animationList removeAllObjects];
    //[_animationList release];
}

@end
