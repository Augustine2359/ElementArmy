//
//  NBConnectorLine.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 17/3/13.
//
//

#import "NBConnectorLine.h"

@implementation NBConnectorLine

-(id)initWithAtPosition:(CGPoint)newPosition withDirection:(EnumLineDirection)direction withLength:(CGFloat)length isVertical:(BOOL)isVertical onLayer:(CCLayer *)layer
{
    if (self = [super init])
    {
        self.isVertical = isVertical;
        self.lineDirection = direction;
        currentDotIndex = 0;
        
        NBSingleAnimatedObject* footStep = [[NBSingleAnimatedObject alloc] initWithSpriteFrameName:@"footStep_0.jpg"];
        footStep.visible = NO;
        footStep.position = newPosition;
        [footStep addAnimationFrameName:@"footStep" withAnimationCount:2 fileExtension:@"jpg"];
        [layer addChild:footStep];
        self.heightPerDot = footStep.contentSize.height;
        self.widthPerDot = footStep.contentSize.width;
        
        int objectCountNeeded = 0;
        
        if (self.lineDirection == LineDirectionUp || self.lineDirection == LineDirectionDown)
        {
            objectCountNeeded = length / self.heightPerDot;
        }
        else
        {
            objectCountNeeded = length / self.widthPerDot;
        }
        
        objectCountNeeded++;
        self.dots = [CCArray arrayWithCapacity:objectCountNeeded];
        [self.dots addObject:footStep];
        
        for (int i = 1; i < objectCountNeeded; i++)
        {
            footStep = [[NBSingleAnimatedObject alloc] initWithSpriteFrameName:@"footStep_0.jpg"];
            footStep.visible = NO;
            
            switch (self.lineDirection)
            {
                case LineDirectionUp:
                    footStep.position = CGPointMake(newPosition.x, newPosition.y + (footStep.contentSize.height * (i - 1)));
                    footStep.rotation = 270;
                    break;
                case LineDirectionDown:
                    footStep.position = CGPointMake(newPosition.x, newPosition.y - (footStep.contentSize.height * (i - 1)));
                    footStep.rotation = 90;
                    break;
                case LineDirectionRight:
                    footStep.position = CGPointMake(newPosition.x + (footStep.contentSize.width * (i - 1)), newPosition.y);
                    footStep.rotation = 0;
                    break;
                case LineDirectionLeft:
                    footStep.position = CGPointMake(newPosition.x - (footStep.contentSize.width * (i - 1)), newPosition.y);
                    footStep.rotation = 180;
                    break;
            }
            
            [footStep addAnimationFrameName:@"footStep" withAnimationCount:2 fileExtension:@"jpg"];
            [layer addChild:footStep];
            [self.dots addObject:footStep];
        }
    }

    return self;
}

-(void)show
{
    for (int i = 0; i < [self.dots count]; i++)
    {
        NBSingleAnimatedObject* currentDot = (NBSingleAnimatedObject*)[self.dots objectAtIndex:i];
        currentDot.visible = YES;
    }
}

-(void)animate
{
    if (currentDotIndex == [self.dots count])
    {
        currentDotIndex = 0;
        return;
    }
 
    NBSingleAnimatedObject* currentDot = (NBSingleAnimatedObject*)[self.dots objectAtIndex:currentDotIndex];
    currentDot.visible = YES;
    [currentDot playAnimationWithDelay:0.5 informToObject:self onSelector:@selector(animationCompleted)];
    currentDotIndex++;
}

-(void)animationCompleted
{
    [self animate];
}

@end
