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

#define HP_BAR_LENGTH 130

// HelloWorldLayer
@interface NBBattleLayer : NBBasicScreenLayer
{
    bool battleStarted;
    bool groupClassSkillOpened;
    bool groupComboSkillOpened;
    
    long totalAllyHPAtStartOfBattle;
    long totalEnemyHPAtStartOfBattle;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene*)scene;

-(void)performanceTest;
-(void)prepareUnits;
-(void)prepareBattlefield;
-(void)prepareUI;
-(void)startBattle;
-(void)gotoMapSelectionScreen;

@property (nonatomic, retain) CCLabelTTF* layerTitle;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCMenu *battleCompleteMenu;
@property (nonatomic, retain) CCLabelTTF* battleResultText;
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

@property (nonatomic, retain) NBFancySlidingMenuLayer *classGroupSkillMenuLayer;
@property (nonatomic, retain) NBButton* comboGroupSkillButton;
@property (nonatomic, retain) NBButton* classSkillAButton;
@property (nonatomic, retain) NBButton* classSkillBButton;
@property (nonatomic, retain) NBButton* classSkillCButton;
@property (nonatomic, retain) NBButton* comboSkillAButton;
@property (nonatomic, retain) NBButton* comboSkillBButton;
@property (nonatomic, retain) NBButton* comboSkillCButton;
@property (nonatomic, retain) NBStaticObject* allyFlagLogo;
@property (nonatomic, retain) NBStaticObject* enemyFlagLogo;
@property (nonatomic, retain) NBStaticObject* allyHPBarPlaceholder;
@property (nonatomic, retain) NBStaticObject* enemyHPBarPlaceholder;
@property (nonatomic, retain) NBStaticObject* allyHPBar;
@property (nonatomic, retain) NBStaticObject* enemyHPBar;

@end
