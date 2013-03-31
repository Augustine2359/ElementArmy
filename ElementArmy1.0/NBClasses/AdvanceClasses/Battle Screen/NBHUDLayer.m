//
//  NBHUDLayer.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 31/3/13.
//
//

#import "NBHUDLayer.h"

@implementation NBHUDLayer

-(void)update
{
    
}

-(void)prepareUI:(id)battleLayer
{
    self.battlefieldLayer = battleLayer;
    
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    self.allyHPBar = [CCSprite spriteWithSpriteFrameName:@"staticbox_green.png"];
    self.allyHPBar.scaleX = 130 / self.allyHPBar.contentSize.width;
    self.allyHPBar.scaleY = 12 / self.allyHPBar.contentSize.height;
    targetScaleXForHPBar = self.allyHPBar.scaleX;
    targetScaleYForHPBar = self.allyHPBar.scaleY;
    self.allyHPBar.anchorPoint = CGPointMake(1, 1);
    self.allyHPBar.scaleX = 0;
    self.allyHPBar.position = CGPointMake(winsize.width / 2, 25);
    [self addChild:self.allyHPBar];
    
    self.enemyHPBar = [CCSprite spriteWithSpriteFrameName:@"staticbox_red.png"];
    self.enemyHPBar.scaleX = 130 / self.enemyHPBar.contentSize.width;
    self.enemyHPBar.scaleY = 12 / self.enemyHPBar.contentSize.height;
    self.enemyHPBar.anchorPoint = CGPointMake(0, 1);
    self.enemyHPBar.scaleX = 0;
    self.enemyHPBar.position = CGPointMake(winsize.width / 2, 25);
    [self addChild:self.enemyHPBar];
    
    self.HPBarPlaceholder = [CCSprite spriteWithSpriteFrameName:@"lifebar.png"];
    self.HPBarPlaceholder.position = CGPointMake((winsize.width / 2) - 5, -20);
    [self addChild:self.HPBarPlaceholder];
    
    self.allyFlagLogo = [CCSprite spriteWithSpriteFrameName:@"ally_logo_dummy.png"];
    self.allyFlagLogo.position = CGPointMake((-1 * (self.allyFlagLogo.contentSize.width * 2)), 30);
    [self addChild:self.allyFlagLogo];
    self.enemyFlagLogo = [CCSprite spriteWithSpriteFrameName:@"enemy_logo_dummy.png"];
    self.enemyFlagLogo.position = CGPointMake(winsize.width + (self.allyFlagLogo.contentSize.width * 2), 30);
    [self addChild:self.enemyFlagLogo];
    
    self.itemMenuLayer = [[NBFancySlidingMenuLayer alloc] initOnLeftSide:NO];
    self.itemMenuLayer.layerSize = CGSizeMake(100, 50);
    self.itemMenuLayer.contentSize = CGSizeMake(100, 50);
    [self addChild:self.itemMenuLayer];
    self.itemMenuLayer.position = CGPointMake(20, -48);
    [self.itemMenuLayer setupSelectorsForItem1:@selector(onItem1Selected) forItem2:@selector(onItem2Selected) forItem3:@selector(onItem3Selected) onBattleLayer:self.battlefieldLayer];
    
    NBItem* item = nil;
    int itemIndex = 0;
    CCARRAY_FOREACH(self.dataManager.selectedItems, item)
    {
        switch (itemIndex) {
            case 0:
                self.item1 = item;
                if ([self.item1.itemData.itemName isEqualToString:@"Potion"]) self.item1.itemData.availableAmount = 100; //For testing purpose
                [self.itemMenuLayer addItemFrameName:self.item1.itemData.imageNormal];
                break;
            case 1:
                self.item2 = item;
                if ([self.item2.itemData.itemName isEqualToString:@"Fury Pill"]) self.item2.itemData.availableAmount = 100; //For testing purpose
                [self.itemMenuLayer addItemFrameName:self.item2.itemData.imageNormal];
                break;
            case 2:
                self.item3 = item;
                //[self.itemMenuLayer addItemFrameName:self.item3.itemData.frame];
                break;
        }
        
        itemIndex++;
    }
    
    self.itemAreaEffect = [[NBAreaEffect alloc] initWithSpriteFrameName:@"staticbox_green.png"];
    self.itemAreaEffect.opacity = 125;
    [self.itemAreaEffect setAreaSize:CGSizeMake(300, 150)];
    [self addChild:self.itemAreaEffect z:99];
}

-(void)entranceAnimationStep2:(id)objectToRespond withSelector:(SEL)selector
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    CCMoveTo* move1_0 = [CCMoveTo actionWithDuration:2.0 position:CGPointMake(winsize.width / 2, self.allyFlagLogo.position.y)];
    CCMoveTo* move1_1 = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(winsize.width * 0.225, self.allyFlagLogo.position.y)];
    CCEaseIn* ease1 = [CCEaseIn actionWithAction:move1_0 rate:2];
    CCEaseOut* ease1_1 = [CCEaseOut actionWithAction:move1_1 rate:1.5];
    CCCallFuncN* animation2Completed = [CCCallFuncN actionWithTarget:objectToRespond selector:selector];
    CCSequence* sequence1 = [CCSequence actions:ease1, animation2Completed, ease1_1, nil];
    
    [self.allyFlagLogo runAction:sequence1];
}

-(void)entranceAnimationStep3:(id)objectToRespond withSelector:(SEL)selector
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    CCMoveTo* move2_0 = [CCMoveTo actionWithDuration:2.0 position:CGPointMake(winsize.width / 2, self.enemyFlagLogo.position.y)];
    CCMoveTo* move2_1 = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(winsize.width * 0.775, self.enemyFlagLogo.position.y)];
    CCMoveTo* move3_0 = [CCMoveTo actionWithDuration:2.0 position:CGPointMake((winsize.width / 2) - 5, 20)];
    
    CCEaseIn* ease2 = [CCEaseIn actionWithAction:move2_0 rate:2];
    CCEaseIn* ease3 = [CCEaseIn actionWithAction:move3_0 rate:2];
    
    CCEaseOut* ease2_1 = [CCEaseOut actionWithAction:move2_1 rate:1.5];
    
    CCCallFuncN* animation1Completed = [CCCallFuncN actionWithTarget:objectToRespond selector:selector];
    CCSequence* sequence2 = [CCSequence actions:ease2, ease2_1, animation1Completed, nil];
    CCSequence* sequence3 = [CCSequence actions:ease3, move3_0, nil];
    
    [self.enemyFlagLogo runAction:sequence2];
    [self.HPBarPlaceholder runAction:sequence3];
}

-(void)entranceAnimationStep4
{
    CCScaleTo* scale1_0 = [CCScaleTo actionWithDuration:1.5 scaleX:targetScaleXForHPBar scaleY:targetScaleYForHPBar];
    CCScaleTo* scale2_0 = [CCScaleTo actionWithDuration:1.5 scaleX:targetScaleXForHPBar scaleY:targetScaleYForHPBar];
    CCEaseOut* ease1_1 = [CCEaseOut actionWithAction:scale1_0 rate:1.5];
    CCEaseOut* ease2_1 = [CCEaseOut actionWithAction:scale2_0 rate:1.5];
    
    [self.allyHPBar runAction:ease1_1];
    [self.enemyHPBar runAction:ease2_1];
    
    CCMoveTo* move5_0 = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(0, 0)];
    
    [self.itemMenuLayer runAction:move5_0];
}

@end
