//
//  NBSingleAnimatedObject.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 17/3/13.
//
//

#import "NBSingleAnimatedObject.h"

@implementation NBSingleAnimatedObject

-(void)addAnimationFrameName:(NSString*)animationFrameName withAnimationCount:(int)animationCount fileExtension:(NSString*)fileExtension
{
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"CharacterSprites.plist"];
    
    self.frames = [NSMutableArray arrayWithCapacity:animationCount];
    
    for (int i = 0; i < animationCount; i++)
    {
        NSString* file = [NSString stringWithFormat:@"%@_%i.%@", animationFrameName, i, fileExtension];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
        [self.frames addObject:frame];
    }
}

-(void)playAnimationWithDelay:(ccTime)delayTime informToObject:(id)object onSelector:(SEL)selector
{
    if ([self.frames count] < 1) return;
    
    CCAnimation* anim = [CCAnimation animationWithSpriteFrames:self.frames delay:delayTime];
    // Run the animation by using the CCAnimate action
    CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
    CCCallFunc* animationCompleted = [CCCallFunc actionWithTarget:object selector:selector];
    CCSequence* sequence = [CCSequence actions:animate, animationCompleted, nil];
    [self runAction:sequence];
}

-(void)playAnimation:(bool)forever withDelay:(ccTime)delayTime
{
    if ([self.frames count] < 1) return;
    
    CCAnimation* anim = [CCAnimation animationWithSpriteFrames:self.frames delay:delayTime];
    // Run the animation by using the CCAnimate action
    CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
    
    if (forever)
    {
        CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
        [self runAction:repeat];
    }
    else
        [self runAction:animate];
}

-(void)stopAnimation
{
    [self stopAllActions];
}

@end
