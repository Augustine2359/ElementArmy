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
}

+(void)registerDamage:(CGPoint)position withDamageAmount:(long)damage
{
    if (!currentLayer) return;
    
    if (!damageLabels)
    {
        damageLabels = [[CCArray alloc] initWithCapacity:100];
        for (int i = 0; i < 100; i++)
        {
            NBDamageLabel* damageLabel = [[NBDamageLabel alloc]  initWithString:@"000" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
            damageLabel.visible = NO;
            [currentLayer addChild:damageLabel];
            [damageLabels addObject:damageLabel];
        }
        currentDamageLabelIndex = 0;
    }
    
    NBDamageLabel* damageLabel = (NBDamageLabel*)[damageLabels objectAtIndex:currentDamageLabelIndex++];
    NSString* damageString = [[NSString alloc] initWithFormat:@"%li", damage];
    [damageLabel setString:damageString];
    [damageString release];
    damageLabel.position = position;
    [damageLabel animate];
}

-(void)animate
{
    CCJumpTo* jumpTo = [CCJumpTo actionWithDuration:0.3 position:ccpAdd(self.position, CGPointMake(10, 10)) height:10 jumps:1];
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
