//
//  NBBattleResultLayer.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 8/4/13.
//
//

#import "NBBattleResultLayer.h"

@implementation NBBattleResultLayer

-(id)init
{
    if (self = [super init])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.background = [CCSprite spriteWithSpriteFrameName:@"staticbox_gray.png"];
        self.background.scale = INITIAL_BACKGROUND_SCALE;
        self.background.visible = NO;
        self.background.anchorPoint = CGPointMake(0.5, 0.5);
        self.background.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        [self addChild:self.background];
        
        CCSprite* doneButtonSpriteNormal = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
        CCSprite* doneButtonSpriteSelected = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
        self.doneButton = [CCMenuItemSprite itemWithNormalSprite:doneButtonSpriteNormal selectedSprite:doneButtonSpriteSelected target:self selector:@selector(onDoneButtonCompleted)];
        self.doneButtonMenu = [CCMenu menuWithItems:self.doneButton, nil];
        self.doneButtonMenu.position = ccp(winSize.width / 2, 80);
        self.doneButtonMenu.visible = NO;
        [self addChild:self.doneButtonMenu];
        
        self.battleResultText = [CCLabelTTF labelWithString:@"" dimensions:CGSizeZero hAlignment:kCCTextAlignmentCenter fontName:@"Palatino" fontSize:36];
        self.battleResultText.color = ccRED;
        self.battleResultText.anchorPoint = CGPointMake(0.5, 0.25);
        self.battleResultText.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        self.battleResultText.scale = 0;
        [self addChild:self.battleResultText];
        
        self.battlePointAwardedLabel = [CCLabelTTF labelWithString:@"Battle Points Awarded" dimensions:CGSizeZero hAlignment:kCCTextAlignmentLeft fontName:@"PF Ronda Seven" fontSize:12];
        self.battlePointAwardedLabel.position = CGPointMake(winSize.width * 0.3125, 140);
        self.battlePointAwardedLabel.visible = NO;
        [self addChild:self.battlePointAwardedLabel];
        
        self.battlePointAwardedAmountLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeZero hAlignment:kCCTextAlignmentRight fontName:@"PF Ronda Seven" fontSize:12];
        self.battlePointAwardedAmountLabel.position = CGPointMake(winSize.width * 0.6875, 140);
        self.battlePointAwardedAmountLabel.visible = NO;
        [self addChild:self.battlePointAwardedAmountLabel];
        
        self.battlePointAvailableLabel = [CCLabelTTF labelWithString:@"Battle Points Available" dimensions:CGSizeZero hAlignment:kCCTextAlignmentLeft fontName:@"PF Ronda Seven" fontSize:12];
        self.battlePointAvailableLabel.position = CGPointMake(winSize.width * 0.3125, 120);
        self.battlePointAvailableLabel.visible = NO;
        [self addChild:self.battlePointAvailableLabel];
        
        self.battlePointAvailableAmountLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeZero hAlignment:kCCTextAlignmentRight fontName:@"PF Ronda Seven" fontSize:12];
        self.battlePointAvailableAmountLabel.position = CGPointMake(winSize.width * 0.6875, 120);
        self.battlePointAvailableAmountLabel.visible = NO;
        [self addChild:self.battlePointAvailableAmountLabel];
        
        [self reorderChild:self.battleResultText z:(self.background.zOrder + 1)];
        [self reorderChild:self.battlePointAwardedLabel z:(self.background.zOrder + 1)];
        [self reorderChild:self.battlePointAwardedAmountLabel z:(self.background.zOrder + 1)];
        [self reorderChild:self.battlePointAvailableLabel z:(self.background.zOrder + 1)];
        [self reorderChild:self.battlePointAvailableAmountLabel z:(self.background.zOrder + 1)];
        
        self.visible = NO;
    }
    
    return self;
}

-(void)setupParentLayer:(id)layer selector:(SEL)selector withCurrentAvailableBattlePoints:(long)availablePoints
{
    self.battleLayer = layer;
    self.battleLayerSelectorForDoneButton = selector;
    self.battlePointAvailable = availablePoints;
}

-(void)calculateAnimationScoringRequirement
{
    targetAvailableBattlePoint = self.battlePointAvailable + self.battlePointAwarded;
    incrementalNumber = self.battlePointAwarded / 40;
}

-(void)callLayerWithBattleResult:(NSString*)result battlePointsAwarded:(long)points
{
    self.visible = YES;
    self.battlePointAwarded = points;
    [self calculateAnimationScoringRequirement];
    
    [self.battleResultText setString:result];
    
    CCScaleTo* scaleTo_0 = [CCScaleTo actionWithDuration:1.0 scale:2.50];
    CCEaseIn* easeIn_0 = [CCEaseIn actionWithAction:scaleTo_0 rate:2.0];
    CCScaleTo* scaleTo_1 = [CCScaleTo actionWithDuration:0.75 scale:2.00];
    CCDelayTime* delay = [CCDelayTime actionWithDuration:1.0];
    CCScaleTo* scaleTo_2 = [CCScaleTo actionWithDuration:0.75 scale:100.00];
    CCEaseIn* easeIn_1 = [CCEaseIn actionWithAction:scaleTo_2 rate:2.0];
    CCCallFunc* animationScaleOut = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationStep1Completed)];
    CCSequence* sequence = [CCSequence actions:easeIn_0, scaleTo_1, delay, easeIn_1, animationScaleOut, nil];
    [self.battleResultText runAction:sequence];
}

-(void)onBattleCompleteAnimationStep1Completed
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.5];
    [self.background runAction:fadeIn];
    self.background.visible = YES;
    
    CCScaleTo* scale1 = [CCScaleTo actionWithDuration:1.0 scaleX:25 scaleY:15];
    CCScaleTo* scale2 = [CCScaleTo actionWithDuration:1.0 scale:2];
    CCCallFunc* animationCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationStep2Completed)];
    CCSequence* sequence = [CCSequence actions:scale1, animationCompleted, nil];
    [self.battleResultText runAction:scale2];
    [self.background runAction:sequence];
    
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration:1.0 position:CGPointMake(winSize.width / 2, (winSize.height / 2) + 50)];
    [self.battleResultText runAction:moveTo];
}

-(void)onBattleCompleteAnimationStep2Completed
{
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.2];
    CCDelayTime* delay = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* animationCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationStep3Completed)];
    CCSequence* sequence = [CCSequence actions:fadeIn, delay, animationCompleted, nil];
    [self.battlePointAwardedLabel runAction:sequence];
    self.battlePointAwardedLabel.visible = YES;
}

-(void)onBattleCompleteAnimationStep3Completed
{
    [self.battlePointAwardedAmountLabel setString:[NSString stringWithFormat:@"%li", self.battlePointAwarded]];
    
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.2];
    CCDelayTime* delay = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* animationCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationStep4Completed)];
    CCSequence* sequence = [CCSequence actions:fadeIn, delay, animationCompleted, nil];
    [self.battlePointAwardedAmountLabel runAction:sequence];
    self.battlePointAwardedAmountLabel.visible = YES;
}

-(void)onBattleCompleteAnimationStep4Completed
{
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.2];
    CCDelayTime* delay = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* animationCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationStep5Completed)];
    CCSequence* sequence = [CCSequence actions:fadeIn, delay, animationCompleted, nil];
    [self.battlePointAvailableLabel runAction:sequence];
    self.battlePointAvailableLabel.visible = YES;
}

-(void)onBattleCompleteAnimationStep5Completed
{
    [self.battlePointAvailableAmountLabel setString:[NSString stringWithFormat:@"%li", self.battlePointAvailable]];
    
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.2];
    CCDelayTime* delay = [CCDelayTime actionWithDuration:0.5];
    CCCallFunc* animationCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationStep6Completed)];
    CCSequence* sequence = [CCSequence actions:fadeIn, delay, animationCompleted, nil];
    [self.battlePointAvailableAmountLabel runAction:sequence];
    self.battlePointAvailableAmountLabel.visible = YES;
}

-(void)onBattleCompleteAnimationStep6Completed
{
    self.battlePointAvailable += incrementalNumber;
    
    if (self.battlePointAvailable >= targetAvailableBattlePoint)
    {
        self.battlePointAvailable = targetAvailableBattlePoint;
        [self.battlePointAvailableAmountLabel setString:[NSString stringWithFormat:@"%li", self.battlePointAvailable]];
        [self onBattleCompleteAnimationStep7Completed];
    }
    else
    {
        [self.battlePointAvailableAmountLabel setString:[NSString stringWithFormat:@"%li", self.battlePointAvailable]];
        
        CCDelayTime* delay = [CCDelayTime actionWithDuration:0.005];
        CCCallFunc* delayCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationStep6Completed)];
        CCSequence* sequence = [CCSequence actions:delay, delayCompleted, nil];
        [self runAction:sequence];
    }
}

-(void)onBattleCompleteAnimationStep7Completed
{
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.2];
    [self.doneButtonMenu runAction:fadeIn];
    self.doneButtonMenu.visible = YES;
}

-(void)onDoneButtonCompleted
{
    [self.battleLayer performSelector:self.battleLayerSelectorForDoneButton];
}

@end
