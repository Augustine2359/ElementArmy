//
//  NBAreaEffect.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/3/13.
//
//

#import "NBAreaEffect.h"

@implementation NBAreaEffect

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithSpriteFrameName:spriteFrameName])
    {
        isFollowing = false;
        self.visible = NO;
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    
    return self;
}

-(void)setAreaSize:(CGSize)areaSize
{
    _areaSize = areaSize;
    self.scaleX = areaSize.width / self.contentSize.width;
    self.scaleY = areaSize.height / self.contentSize.height;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    if ([self isTouchingMe:touchLocation])
    {
        isFollowing = true;
        return YES;
    }
    else
    {
        [self deactivate];
        return YES;
    }
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isFollowing)
    {
        CGPoint touchLocation = [touch locationInView:touch.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        self.position = touchLocation;
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isFollowing)
    {
        [self activateItemEffect];
        [self deactivate];
    }
}

-(BOOL)isTouchingMe:(CGPoint)touchLocation
{
    CGRect rect = CGRectMake(self.position.x - (self.areaSize.width / 2), self.position.y - (self.areaSize.height / 2), self.areaSize.width, self.areaSize.height);
    
    if (CGRectContainsPoint(rect, touchLocation))
        return YES;
    else
        return NO;
}

-(void)activateAreaEffect:(NBItem*)item
{
    self.currentItem = item;
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    self.position = CGPointMake(windowSize.width / 2, windowSize.height / 2);
    self.visible = YES;
}

-(void)deactivate
{
    isFollowing = false;
    self.visible = NO;
}

-(void)activateItemEffect
{
    [self.currentItem activate];
}

@end
