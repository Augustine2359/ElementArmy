//
//  HelloWorldLayer.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 21/10/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "NBSquad.h"
#import "NBProjectile.h"
#import "NBBasicScreenLayer.h"
#import "NBUserInterface.h"
#import "NBFancySlidingMenuLayer.h"
#import "NBRipples.h"
#import "NBSpellProjectile.h"
#import "NBLaserSight.h"
#import "NBChainLightning.h"
#import "NBAreaEffect.h"
#import "NBHUDLayer.h"
#import "NBShakeEffect.h"
#import "NBBattleResultLayer.h"

// HelloWorldLayer
@interface NBBattleLayer : NBBasicScreenLayer <NBSpellDelegate>
{
    bool battleStarted;
    bool groupClassSkillOpened;
    bool groupComboSkillOpened;
    
    long totalAllyHPAtStartOfBattle;
    long totalEnemyHPAtStartOfBattle;
    
    CGFloat targetScaleXForHPBar;
    CGFloat targetScaleYForHPBar;
    
    int currentDamageLabelIndex;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene*)scene;

-(void)performanceTest;
-(void)prepareUnits;
-(void)prepareBattlefield;
-(void)prepareUI;
-(void)startBattle;
-(void)endBattle;
-(void)processBattleResult;
-(void)gotoMapSelectionScreen;
-(void)gotoStageSelectionScreen;
-(void)entranceAnimationStep1;
-(void)entranceAnimationStep2;
-(void)entranceAnimationStep3;
-(void)entranceAnimationStep4;
-(void)onBackgroundMoveCompleted;
-(void)onBattleCompleteAnimationCompleted;

@property (nonatomic, retain) CCLabelTTF* layerTitle;
@property (nonatomic, retain) CCLabelTTF* stageNameBanner;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCMenu *battleCompleteMenu;
@property (nonatomic, retain) CCLabelAtlas* battleResultText;
@property (nonatomic, retain) CCSpriteBatchNode* characterSpritesBatchNode;
@property (nonatomic, retain) CCArray* allySquads;
@property (nonatomic, retain) CCArray* enemySquads;
@property (nonatomic, assign) bool allAllyUnitAnnihilated;
@property (nonatomic, assign) bool allEnemyUnitAnnihilated;

//UI

-(void)onClassGroupSkillButtonSelected;
-(void)onClassSkillAButtonSelected;
-(void)onClassSkillBButtonSelected;
-(void)onClassSkillCButtonSelected;
-(void)onComboGroupSkillButtonSelected;
-(void)onComboSkillAButtonSelected;
-(void)onComboSkillBButtonSelected;
-(void)onComboSkillCButtonSelected;
-(void)onItem1Selected;
-(void)onItem2Selected;
-(void)onItem3Selected;

@property (nonatomic, retain) NBFancySlidingMenuLayer *classGroupSkillMenuLayer;
@property (nonatomic, retain) NBFancySlidingMenuLayer *itemMenuLayer;

@property (nonatomic, retain) NBHUDLayer* HUDLayer;
/*@property (nonatomic, retain) NBStaticObject* allyFlagLogo;
@property (nonatomic, retain) NBStaticObject* enemyFlagLogo;
@property (nonatomic, retain) NBStaticObject* HPBarPlaceholder;
@property (nonatomic, retain) NBStaticObject* allyHPBar;
@property (nonatomic, retain) NBStaticObject* enemyHPBar;*/
@property (nonatomic, retain) NBButton* startBattleButton;
@property (nonatomic, retain) NBStaticObject* fieldBackground;
@property (nonatomic, retain) NBStaticObject* skyBackground;
@property (nonatomic, retain) CCArray* damageLabels;
@property (nonatomic, retain) NBBattleResultLayer* battleResultLayer;
@property (nonatomic, assign) long currentBattlePointsAwarded;

@property (nonatomic, retain) NBAreaEffect* itemAreaEffect;
@property (nonatomic, retain) NBItem* item1;
@property (nonatomic, retain) NBItem* item2;
@property (nonatomic, retain) NBItem* item3;

@end
