//
//  NBAreaEffect.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/3/13.
//
//

#import "NBAreaEffect.h"

@implementation NBAreaEffect

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName onLayer:(CCLayer*)layer
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
#warning need to fix this move by touch issue
    if (isFollowing)
    {
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        
        CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
        oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
        oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
        
        CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
        CGPoint newPos = ccpAdd(self.position, translation);
        self.position = newPos;
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

-(void)activate
{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    self.position = CGPointMake(windowSize.width / 2, windowSize.height / 2);
    self.visible = YES;
}

-(void)deactivate
{
    isFollowing = false;
    self.visible = NO;
}

@end
