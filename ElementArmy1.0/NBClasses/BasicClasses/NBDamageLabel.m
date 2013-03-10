//
//  NBDamageLabel.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 4/3/13.
//
//

#import "NBDamageLabel.h"

static CCArray* damageLabels = nil;
static CCLayer* currentLayer = nil;
static int currentDamageLabelIndex = 0;

@implementation NBDamageLabel

+(void)setCurrentLayerForDamageLabel:(CCLayer*)layer
{
    currentLayer = layer;
    
    if (!damageLabels)
    {
        damageLabels = [[CCArray alloc] initWithCapacity:100];
        for (int i = 0; i < 100; i++)
        {
            NBDamageLabel* damageLabel = [[NBDamageLabel alloc]  initWithString:@"000" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
            damageLabel.scale = 0.5;
            damageLabel.visible = NO;
            [currentLayer addChild:damageLabel];
            [damageLabels addObject:damageLabel];
        }
        currentDamageLabelIndex = 0;
    }
    
    /*else
    {
        for (int i = 0; i < 100; i++)
        {
            NBDamageLabel* damageLabel = (NBDamageLabel*)[damageLabels objectAtIndex:i];
            [damageLabel removeFromParentAndCleanup:NO];
            [layer addChild:damageLabel];
        }
    }*/
}

+(void)registerDamage:(CGPoint)position withDamageAmount:(long)damage toRight:(bool)isToRight
{
    if (!currentLayer) return;
    
    if (!damageLabels)
    {
        damageLabels = [[CCArray alloc] initWithCapacity:100];
        for (int i = 0; i < 100; i++)
        {
            NBDamageLabel* damageLabel = [[NBDamageLabel alloc]  initWithString:@"000" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
            damageLabel.scale = 0.5;
            damageLabel.visible = NO;
            [currentLayer addChild:damageLabel];
            [damageLabels addObject:damageLabel];
        }
        currentDamageLabelIndex = 0;
    }
    
    if (currentDamageLabelIndex > 99) currentDamageLabelIndex = 0;
    NBDamageLabel* damageLabel = (NBDamageLabel*)[damageLabels objectAtIndex:currentDamageLabelIndex++];
    NSString* damageString = [[NSString alloc] initWithFormat:@"%li", damage];
    [damageLabel setString:damageString];
    [damageString release];
    damageLabel.position = position;
    [damageLabel animate:isToRight];
}

-(void)animateToRight
{
    [self animate:YES];
}

-(void)animateToLeft
{
    [self animate:NO];
}

-(void)animate:(bool)isToRight
{
    CGPoint jumpToPosition = CGPointZero;
    
    if (isToRight) jumpToPosition = CGPointMake(10, 10); else jumpToPosition = CGPointMake(-10, 10);
        
    CCJumpTo* jumpTo = [CCJumpTo actionWithDuration:0.3 position:ccpAdd(self.position, jumpToPosition) height:10 jumps:1];
    CCCallFuncN* animationCompleted = [CCCallFuncN actionWithTarget:self selector:@selector(animationCompleted)];
    CCSequence* sequence = [CCSequence actions:jumpTo, animationCompleted, nil];
    self.visible = YES;
    [self runAction:sequence];
}

-(void)animationCompleted
{
    self.visible = NO;
}

@end
