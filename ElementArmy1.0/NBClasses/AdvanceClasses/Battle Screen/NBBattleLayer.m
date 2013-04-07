//
//  NBBattleLayer.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 21/10/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "NBBattleLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#define SUPER_SHORT_ANIMATION 1

#pragma mark - NBBattleLayer

#define UNIT_COUNT_PER_SQUAD 8

static Boolean isAutoStart = NO;

// NBBattleLayer implementation
@implementation NBBattleLayer

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBBattleLayer sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBBattleLayer *layer = [NBBattleLayer node];
    layer.layerName = NSStringFromClass([layer class]);
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    if (makeDefault)
        [NBBasicScreenLayer setDefaultScreen:scene];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self = [super init]))
    {
		/*//
		// Leaderboards and Achievements
		//
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];*/
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

//NB ElementArmy Specific
//************************************************************************************************
-(void)onEnter
{
    [super onEnter];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    self.HUDLayer = [[NBHUDLayer alloc] init];
    CCScene* scene = (CCScene*)[self parent];
    [scene addChild:self.HUDLayer];
    
    // ask director for the window size
    /*battleStarted = false;
     ccColor4B startColor;
     startColor.r = 200;
     startColor.g = 200;
     startColor.b = 200;
     startColor.a = 250;
     CCLayerColor *backgroundColor = [CCLayerColor layerWithColor:startColor];
     [self addChild:backgroundColor];
     self.isTouchEnabled = YES;
     [self scheduleUpdate];*/

    //Prepare Sprite Batch Node
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
    self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
    [self addChild:self.characterSpritesBatchNode z:0 tag:0];

    //Prepare unit slots/arrays
    [NBSquad setupBatteFieldDimension:CGSizeMake(size.width, size.height)];
    if (!self.allySquads) self.allySquads = [[CCArray alloc] initWithCapacity:MAXIMUM_SQUAD_PER_SIDE];
    if (!self.enemySquads) self.enemySquads = [[CCArray alloc] initWithCapacity:MAXIMUM_SQUAD_PER_SIDE];
    
    [self prepareUI];
    [self prepareUnits];
    
    if (!isAutoStart)
    {
        // Default font size will be 28 points.
        [CCMenuItemFont setFontSize:28];
        
        // create and initialize a Label
        self.startBattleButton = [NBButton createWithStringHavingNormal:@"NB_chargeIcon1_400x200.png" havingSelected:@"NB_chargeIcon1_400x200.png" havingDisabled:@"NB_chargeIcon1_400x200.png" onLayer:self respondTo:nil selector:@selector(prepareBattlefield) withSize:CGSizeZero];
        [self.startBattleButton setPosition:ccp(size.width / 2, size.height / 2 - 50)];
    }
    else
    {
        [self prepareBattlefield];
    }
}

-(void)onExit
{
    [self.children removeAllObjects];
    battleStarted = false;
    
    /*[self.menu dealloc];
    [self.battleCompleteMenu dealloc];
    [self.battleResultText dealloc];*/
    
    NBSquad* squad;
    CCARRAY_FOREACH(self.allySquads, squad)
    {
        [squad dealloc];
    }
    
    CCARRAY_FOREACH(self.enemySquads, squad)
    {
        [squad dealloc];
    }
    
    self.allySquads = nil;
    self.enemySquads = nil;
}

-(void)update:(ccTime)delta
{
    [NBBasicObject update:delta];
    
    if (battleStarted)
    {
        float allyTotalHP = 0;
        float enemyTotalHP = 0;
        self.allAllyUnitAnnihilated = true;
        self.allEnemyUnitAnnihilated = true;
        
        //Simple game rule
        NBSquad* tempSquad = nil;
        
        CCARRAY_FOREACH(self.allySquads, tempSquad)
        {
            NBCharacter* allyCharacterObject = nil;
            
            CCARRAY_FOREACH(tempSquad.unitArray, allyCharacterObject)
            {
                if (self.item1.isActivated && self.item1.itemData.effectToUnitSide == itusAllyOnly)
                {
                    [self.item1 implementEffect:allyCharacterObject];
                }
                
                if (self.item2.isActivated && self.item1.itemData.effectToUnitSide == itusAllyOnly)
                {
                    [self.item2 implementEffect:allyCharacterObject];
                }
                
                if (self.item3.isActivated && self.item1.itemData.effectToUnitSide == itusAllyOnly)
                {
                    [self.item3 implementEffect:allyCharacterObject];
                }
            }
            
            [tempSquad update];
            
            if (!tempSquad.allUnitAreDead)
            {
                self.allAllyUnitAnnihilated = false;
                allyTotalHP += tempSquad.totalAliveUnitHP;
            }
        }
        
        CCARRAY_FOREACH(self.enemySquads, tempSquad)
        {
            NBCharacter* enemyCharacterObject = nil;
            
            CCARRAY_FOREACH(tempSquad.unitArray, enemyCharacterObject)
            {
                if (self.item1.isActivated && self.item1.itemData.effectToUnitSide == itusEnemyOnly)
                {
                    [self.item1 implementEffect:enemyCharacterObject];
                }
                
                if (self.item2.isActivated && self.item1.itemData.effectToUnitSide == itusEnemyOnly)
                {
                    [self.item2 implementEffect:enemyCharacterObject];
                }
                
                if (self.item3.isActivated && self.item1.itemData.effectToUnitSide == itusEnemyOnly)
                {
                    [self.item3 implementEffect:enemyCharacterObject];
                }
            }
            
            [tempSquad update];
             
            if (!tempSquad.allUnitAreDead)
            {
                self.allEnemyUnitAnnihilated = false;
                enemyTotalHP += tempSquad.totalAliveUnitHP;
            }
        }
        
        if (self.item1.isActivated) [self.item1 deactivate];
        if (self.item2.isActivated) [self.item2 deactivate];
        if (self.item3.isActivated) [self.item3 deactivate];
        
        if (totalAllyHPAtStartOfBattle > 0)
        {
            long newAllyHPBarWidth = (allyTotalHP / totalAllyHPAtStartOfBattle) * HP_BAR_LENGTH;
            [self.HUDLayer updateAllyHPScale:newAllyHPBarWidth];
            //[self.allyHPBar setToCustomSize:CGSizeMake(newAllyHPBarWidth, self.allyHPBar.sizeOnScreen.height)];
        }
        
        if (totalEnemyHPAtStartOfBattle > 0)
        {
            long newEnemyHPBarWidth = (enemyTotalHP / totalEnemyHPAtStartOfBattle) * HP_BAR_LENGTH;
            [self.HUDLayer updateEnemyHPScale:newEnemyHPBarWidth];
            //[self.enemyHPBar setToCustomSize:CGSizeMake(newEnemyHPBarWidth, self.enemyHPBar.sizeOnScreen.height)];
        }
        
        if (self.allAllyUnitAnnihilated || self.allEnemyUnitAnnihilated)
        {
            if (self.allAllyUnitAnnihilated)
            {
                self.dataManager.battleWon = false;
                self.dataManager.selectedStageData.loseCount++;
            }
            else
            {
                self.dataManager.battleWon = true;
                self.dataManager.selectedStageData.winCount++;
                self.dataManager.selectedStageData.isCompleted = true;
            }
            
            [self processBattleResult];
        }
    }
}

-(void)processBattleResult
{
    battleStarted = false;
    
    NBCharacter* tempCharacter;
    
    CCARRAY_FOREACH([NBCharacter getAllUnitList], tempCharacter)
    {
        tempCharacter.currentState = Idle;
        [tempCharacter battleIsOver];
    }
    
    if (self.allAllyUnitAnnihilated)
    {
        self.battleResultText = [[CCLabelAtlas alloc] initWithString:@"0000" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
    }
    else if (self.allEnemyUnitAnnihilated)
    {
        self.battleResultText = [[CCLabelAtlas alloc] initWithString:@"9999" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
    }
    
    self.battleResultText.anchorPoint = CGPointMake(0.5, 0.25);
    self.battleResultText.position = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
    self.battleResultText.scale = 0;
    [self addChild:self.battleResultText];
    
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
    self.battleResultBackground = [CCSprite spriteWithSpriteFrameName:@"staticbox_gray.png"];
    self.battleResultBackground.scale = 100;
    self.battleResultBackground.anchorPoint = CGPointMake(0.5, 0.5);
    self.battleResultBackground.position = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
    [self reorderChild:self.battleResultText z:(self.battleResultBackground.zOrder + 1)];
    
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.5];
    [self.battleResultBackground runAction:fadeIn];
    [self addChild:self.battleResultBackground];
    
    CCScaleTo* scale1 = [CCScaleTo actionWithDuration:1.0 scaleX:25 scaleY:15];
    CCScaleTo* scale2 = [CCScaleTo actionWithDuration:1.0 scale:2];
    CCCallFunc* animationCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onBattleCompleteAnimationCompleted)];
    CCSequence* sequence = [CCSequence actions:scale1, animationCompleted, nil];
    [self.battleResultText runAction:scale2];
    [self.battleResultBackground runAction:sequence];
    
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration:1.0 position:CGPointMake(self.layerSize.width / 2, (self.layerSize.height / 2) + 70)];
    [self.battleResultText runAction:moveTo];
}

-(void)onBattleCompleteAnimationCompleted
{
    if (self.allAllyUnitAnnihilated || self.allEnemyUnitAnnihilated)
    {
        NBSquad* squadObject = nil;
        int index = 0;
        
        CCARRAY_FOREACH(self.allySquads, squadObject)
        {
            NBBasicClassData* squadClassData = [self.dataManager.arrayOfAllySquad objectAtIndex:index];
            
            squadClassData.availableUnit = squadObject.totalCurrentAliveUnit;
            squadClassData.timeLastBattleCompleted = [NSDate date];
            
            [self.dataManager.arrayOfAllySquad replaceObjectAtIndex:index withObject:squadClassData];
            
            NBBasicClassData* testClassData = [self.dataManager.arrayOfAllySquad objectAtIndex:index];
            DLog(@"%@ available unit = %i", testClassData.className, testClassData.availableUnit);
            
            index++;
        }
        
        //For enemy dont reset for now, simulating next stage will be full of enemy again
        /*
         index = 0;
         CCARRAY_FOREACH(self.enemySquads, squadObject)
         {
         NBBasicClassData* squadClassData = [self.dataManager.arrayOfEnemySquad objectAtIndex:index];
         
         squadClassData.availableUnit = squadObject.totalCurrentAliveUnit;
         squadClassData.timeLastBattleCompleted = [NSDate date];
         
         [self.dataManager.arrayOfEnemySquad replaceObjectAtIndex:index withObject:squadClassData];
         index++;
         }
         */
        
        [CCMenuItemFont setFontSize:16];
        
        // create and initialize a Label
        CCMenuItem *startGameButtonMenu = [CCMenuItemFont itemWithString:@"tap here to continue..." target:self selector:@selector(gotoStageSelectionScreen)];
        self.battleCompleteMenu = [CCMenu menuWithItems:startGameButtonMenu, nil];
        
        [self.battleCompleteMenu alignItemsHorizontallyWithPadding:20];
        [self.battleCompleteMenu setPosition:ccp(self.layerSize.width / 2, 80)];
        
        // Add the menu to the layer
        [self addChild:self.battleCompleteMenu];
    }
}

-(void)gotoMapSelectionScreen
{
    self.nextScene = @"NBMapSelectionScreen";
    [self changeToScene:self.nextScene transitionWithDuration:1.0];
}

-(void)gotoStageSelectionScreen
{
    self.nextScene = @"NBStageSelectionScreen";
    [self changeToScene:self.nextScene];
}

-(void)performanceTest
{
    //Note on this test:
    //I want to test how Fire Mage fights (respond) against NBSoldier and vica versa.
    
    NBSquad* tempSquad;
    [NBSquad resetSquadPositionIndex];
    
    for (int i = 0; i < [self.dataManager.arrayOfAllySquad count]; i++)
    {
        NBBasicClassData* squadClassData = [self.dataManager.arrayOfAllySquad objectAtIndex:i];
        DLog(@"%@ available unit = %i", squadClassData.className, squadClassData.availableUnit);

#warning skip adding the one-unit squad, it's making the earthquake look ugly
      if (squadClassData.availableUnit == 1)
          continue;

        if (squadClassData)
        {
            tempSquad = [[NBSquad alloc] createSquadUsingBasicClassData:squadClassData onSide:Ally andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
            
            if (tempSquad)
            {
                [tempSquad startUpdate];
                [self.allySquads addObject:tempSquad];
            }
        }
    }
    
    for (int i = 0; i < [self.dataManager.selectedStageData.enemyList count]; i++)
    {
        NBBasicClassData* squadClassData = [self.dataManager.selectedStageData.enemyList objectAtIndex:i];
        
        if (squadClassData)
        {
            tempSquad = [[NBSquad alloc] createSquadUsingBasicClassData:squadClassData onSide:Enemy andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
            
            if (tempSquad)
            {
                [tempSquad startUpdate];
                [self.enemySquads addObject:tempSquad];
            }
        }
    }
}

-(void)prepareUnits
{
    //Test below
    [self performanceTest];
    
    NBSquad* tempSquad = nil;
    
    CCARRAY_FOREACH(self.allySquads, tempSquad)
    {
        totalAllyHPAtStartOfBattle += tempSquad.totalAliveUnitHP;
        
        //DLog(@"totalAllyHPAtStartOfBattle = %ld", totalAllyHPAtStartOfBattle);
    }
    
    CCARRAY_FOREACH(self.enemySquads, tempSquad)
    {
        totalEnemyHPAtStartOfBattle += tempSquad.totalAliveUnitHP;
    }
}

-(void)prepareBattlefield
{
    //Test below
    [self startBattle];
}

-(void)prepareUI
{
    [NBStaticObject initializeWithSpriteBatchNode:self.characterSpritesBatchNode andLayer:self andWindowsSize:self.layerSize];
    
    self.position = CGPointMake(self.position.x, -320);
    
    //background
    self.skyBackground = [NBStaticObject createWithSize:CGSizeMake(self.layerSize.width + 64, (self.layerSize.height * 1.5) + 64) usingFrame:@"staticbox_sky.png" atPosition:CGPointMake(self.layerSize.width / 2, 400)];
    self.fieldBackground = [NBStaticObject createWithSize:CGSizeMake(self.layerSize.width, self.layerSize.height * 0.75) usingFrame:@"frame_item.png" atPosition:CGPointMake(240, self.layerSize.height * 0.40)];
    
    [self.HUDLayer prepareUI:self];
    
    //Item Area Effect
    //**********************************************************************
    /*self.itemAreaEffect = [[NBAreaEffect alloc] initWithSpriteFrameName:@"staticbox_green.png"];
    self.itemAreaEffect.opacity = 125;
    [self.itemAreaEffect setAreaSize:CGSizeMake(300, 150)];
    [self addChild:self.itemAreaEffect z:99];*/
    //**********************************************************************
    
    //Augustine's Code below
    //**********************
    /* SKILLS ARE NOT USED FOR NOW. THEY ARE INVOKED ON RANDOM BASIS*/
    /*self.classGroupSkillMenuLayer = [[NBFancySlidingMenuLayer alloc] initOnLeftSide:YES];
    self.classGroupSkillMenuLayer.layerSize = CGSizeMake(100, 50);
    self.classGroupSkillMenuLayer.contentSize = CGSizeMake(100, 50);
    [self addChild:self.classGroupSkillMenuLayer];
    self.classGroupSkillMenuLayer.position = CGPointMake(-20 , -48);*/
    //**********************
    
    [NBDamageLabel setCurrentLayerForDamageLabel:self];
    
    [self entranceAnimationStep1];
}

-(void)entranceAnimationStep1
{
    CGFloat duration = SUPER_SHORT_ANIMATION ? 0 : 0.5;
    CCDelayTime* delay = [CCDelayTime actionWithDuration:duration];
    NSString *stageName = self.dataManager.selectedStageData.stageName;
    if (stageName == nil)
      stageName = @"Default";
    self.stageNameBanner = [CCLabelTTF labelWithString:stageName fontName:@"Zapfino" fontSize:32];
    self.stageNameBanner.position = CGPointMake((self.layerSize.width / 2), (self.layerSize.height / 2) + 320);
    
    duration = SUPER_SHORT_ANIMATION ? 0 : 1.80;
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:duration];
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:duration];

    CCCallFuncN* animationCompleted = [CCCallFuncN actionWithTarget:self selector:@selector(entranceAnimationStep2)];
    CCSequence* sequence = [CCSequence actions:delay, fadeIn, delay, fadeOut, animationCompleted, nil];
    [self.stageNameBanner runAction:sequence];

    [self addChild:self.stageNameBanner];
}

-(void)entranceAnimationStep2
{
    CGFloat duration = SUPER_SHORT_ANIMATION ? 0 : 0.5;

    CCMoveTo* move = [CCMoveTo actionWithDuration:duration position:CGPointMake(self.position.x, 0)];

    CCCallFuncN* moveCompleted = [CCCallFuncN actionWithTarget:self selector:@selector(entranceAnimationStep3)];
    CCSequence* sequence = [CCSequence actions:move, moveCompleted, nil];
    [self runAction:sequence];
}

-(void)entranceAnimationStep3
{
    [self.HUDLayer entranceAnimationStep2:self withSelector:@selector(entranceAnimationStep4)];
    [self.HUDLayer entranceAnimationStep3:self withSelector:@selector(onBackgroundMoveCompleted)];
}

-(void)entranceAnimationStep4
{
    [self.HUDLayer entranceAnimationStep4];
}

-(void)onBackgroundMoveCompleted
{
    //[self reorderChild:self.HPBarPlaceholder z:10];
    //[self reorderChild:self.allyFlagLogo z:11];
    //[self reorderChild:self.enemyFlagLogo z:11];
    
    [self.startBattleButton show];
    
    //NBShakeEffect* shake = [NBShakeEffect actionWithDuration:5.0f withStrength:5];
    //[self runAction:shake];
}

-(void)startBattle
{
    if (self.startBattleButton) [self.startBattleButton hide];
    
    battleStarted = true;
    
    NBCharacter* tempCharacter;
    
    CCARRAY_FOREACH([NBCharacter getAllUnitList], tempCharacter)
    {
        tempCharacter.currentState = Idle;
        [tempCharacter battleIsStarted];
    }
}

-(void)endBattle
{
    /*NBDataManager* dataManager = [NBDataManager dataManager];
    NBSquad* squadObject = nil;
    int index = 0;
    
    CCARRAY_FOREACH(self.allySquads, squadObject)
    {
        NBBasicClassData* squadClassData = [dataManager.arrayOfAllySquad objectAtIndex:index];
        
        squadClassData.availableUnit = squadObject.totalCurrentAliveUnit;
        squadClassData.timeLastBattleCompleted = [NSDate date];
    }
    
    index = 0;
    CCARRAY_FOREACH(self.enemySquads, squadObject)
    {
        NBBasicClassData* squadClassData = [dataManager.arrayOfEnemySquad objectAtIndex:index];
        
        squadClassData.availableUnit = squadObject.totalCurrentAliveUnit;
        squadClassData.timeLastBattleCompleted = [NSDate date];
    }
    
    [CCMenuItemFont setFontSize:16];
    
    // create and initialize a Label
    CCMenuItem *startGameButtonMenu = [CCMenuItemFont itemWithString:@"tap here to continue..." target:self selector:@selector(gotoMapSelectionScreen)];
    self.battleCompleteMenu = [CCMenu menuWithItems:startGameButtonMenu, nil];
    
    [self.battleCompleteMenu alignItemsHorizontallyWithPadding:20];
    [self.battleCompleteMenu setPosition:ccp(self.layerSize.width / 2, 100)];
    
    // Add the menu to the layer
    [self addChild:self.battleCompleteMenu];*/
}

//UI Control Event Handler
-(void)onClassGroupSkillButtonSelected
{
    DLog(@"Class Group Button Selected");
    
    /*if (groupClassSkillOpened) groupClassSkillOpened = false; else groupClassSkillOpened = true;
    
    if (groupClassSkillOpened)
    {
        [self.classSkillAButton moveToPosition:CGPointMake(20, 60) withDuration:.25];
        [self.classSkillBButton moveToPosition:CGPointMake(60, 60) withDuration:.25];
        [self.classSkillCButton moveToPosition:CGPointMake(100, 60) withDuration:.25];
    }
    else
    {
        [self.classSkillAButton moveToPosition:CGPointMake(20, 20) withDuration:.25];
        [self.classSkillBButton moveToPosition:CGPointMake(20, 20) withDuration:.25];
        [self.classSkillCButton moveToPosition:CGPointMake(20, 20) withDuration:.25];
    }*/
}

-(void)onClassSkillAButtonSelected
{
    DLog(@"Class Skill B Button Selected");
}

-(void)onClassSkillBButtonSelected
{
    DLog(@"Class Skill B Button Selected");
}

-(void)onClassSkillCButtonSelected
{
    DLog(@"Class Skill C Button Selected");
}

-(void)onComboGroupSkillButtonSelected
{
    DLog(@"Combo Group Button Selected");
    
    /*if (groupComboSkillOpened) groupComboSkillOpened = false; else groupComboSkillOpened = true;
    
    if (groupComboSkillOpened)
    {
        [self.comboSkillAButton moveToPosition:CGPointMake(self.layerSize.width - 20, 60) withDuration:.25];
        [self.comboSkillBButton moveToPosition:CGPointMake(self.layerSize.width - 60, 60) withDuration:.25];
        [self.comboSkillCButton moveToPosition:CGPointMake(self.layerSize.width - 100, 60) withDuration:.25];
    }
    else
    {
        [self.comboSkillAButton moveToPosition:CGPointMake(self.layerSize.width - 20, 20) withDuration:.25];
        [self.comboSkillBButton moveToPosition:CGPointMake(self.layerSize.width - 20, 20) withDuration:.25];
        [self.comboSkillCButton moveToPosition:CGPointMake(self.layerSize.width - 20, 20) withDuration:.25];
    }*/
}

-(void)onComboSkillAButtonSelected
{
    DLog(@"Combo Skill B Button Selected");
}

-(void)onComboSkillBButtonSelected
{
    DLog(@"Combo Skill B Button Selected");
}

-(void)onComboSkillCButtonSelected
{
    DLog(@"Combo Skill C Button Selected");
}

-(void)onItem1Selected
{
    DLog(@"Item 1 Selected");
    [self.itemAreaEffect activateAreaEffect:self.item1];
}

-(void)onItem2Selected
{
    DLog(@"Item 2 Selected");
    [self.itemAreaEffect activateAreaEffect:self.item2];
}

-(void)onItem3Selected
{
    DLog(@"Item 3 Selected");
    [self.itemAreaEffect activateAreaEffect:self.item3];
}

//************************************************************************************************

#pragma mark - Methods for handling skills

- (NBSquad *)findSquadWithCharacter:(NBCharacter *)character {
  for (NBSquad *squad in self.allySquads)
    if ([squad.unitArray containsObject:character])
      return squad;

  return nil;
}

- (NBCharacter *)findRandomCharacterFromCharacterSide:(EnumCharacterSide)characterSide {
  NSMutableArray *characters = [NSMutableArray array];
  if (characterSide == Ally) {
    for (NBSquad *squad in self.allySquads)
      for (NBCharacter *character in squad.unitArray)
#warning isAlive is causing the game to crash
//        if (character.isAlive)
          [characters addObject:character];
  }
  else {
    for (NBSquad *squad in self.enemySquads)
      for (NBCharacter *character in squad.unitArray)
//        if (character.isAlive)
          [characters addObject:character];
  }

  NSInteger numberOfCharacters = [characters count];
  NSInteger randomNumber = arc4random()%numberOfCharacters;
  return [characters objectAtIndex:randomNumber];
}

- (BOOL)isSpellReady:(NSDate *)lastCastDateOfSpell cooldown:(CGFloat)cooldown{
  CGFloat timeSinceLastCastDate = [[NSDate date] timeIntervalSinceDate:lastCastDateOfSpell];
  if (timeSinceLastCastDate >= cooldown)
    return YES;
  else
    return NO;
}

- (void)skillCastByCharacter:(NBCharacter *)character onCharacter:(NBCharacter *)target {
#warning we can use this to check which skill should be cast based on the class of the character
  if (character.characterSide == Ally) {
    NBSquad *squadWithCharacter = [self findSquadWithCharacter:character];
    if (squadWithCharacter == nil)
      return;
    NSDate *lastCastDateOfSpell = [squadWithCharacter lastCastDateOfSpell];
    if ([self isSpellReady:lastCastDateOfSpell cooldown:5] || (lastCastDateOfSpell == nil)) {
      squadWithCharacter.lastCastDateOfSpell = [NSDate date];
      if (character.basicClassData.attackType == atMelee)
        [self castEarthquake:target];
      if (character.basicClassData.attackType == atRange)
        [self castLaserSightFrom:character toTarget:target];
//        [self castThrowSomethingFrom:character toTarget:target];
//        [self castArrowRain:target];
    }
  }
}

- (void)castLaserSightFrom:(NBCharacter *)thrower toTarget:(NBCharacter *)target {
  NSMutableArray *spellProjectiles = [NSMutableArray array];
  NBSquad *squad = [self findSquadWithCharacter:thrower];

  for (NBCharacter *character in squad.unitArray) {
    NBSpellProjectile *spellProjectile = [[NBSpellProjectile alloc] init];
    spellProjectile.thrower = character;
    if ([character isEqual:thrower])
      spellProjectile.target = target;
    else
      spellProjectile.target = [self findRandomCharacterFromCharacterSide:Enemy];

    [spellProjectiles addObject:spellProjectile];
  }

  NBLaserSight *laserSight = [[NBLaserSight alloc] initWithSpellProjectiles:spellProjectiles lockOnTime:2];
  laserSight.delegate = self;
  [laserSight startLockOn];
  [self addChild:laserSight];
}

- (void)lockOnFinished:(NSTimer *)lockOnTimer {
  NBLaserSight *laserSight = [[lockOnTimer userInfo] objectForKey:@"laserSight"];
  for (NBSpellProjectile *spellProjectile in [laserSight spellProjectiles]) {
    [self castThrowSomethingFrom:spellProjectile.thrower toTarget:spellProjectile.target];
  }
  [laserSight removeFromParentAndCleanup:YES];
}

- (void)castThrowSomethingFrom:(NBCharacter *)thrower toTarget:(NBCharacter *)target {
  CCSprite *axeSprite = [CCSprite spriteWithSpriteFrameName:@"fireball_anim_1.png"];
  axeSprite.position = thrower.position;
  CCRotateBy *rotateBy = [CCRotateBy actionWithDuration:0.5 angle:360];
  [axeSprite runAction:[CCRepeatForever actionWithAction:rotateBy]];

  [self addChild:axeSprite];

  NBSpellProjectile *axeSpellProjectile = [[NBSpellProjectile alloc] initWithSpeed:10];
  axeSpellProjectile.isBoomerang = YES;
  axeSpellProjectile.thrower = thrower;
  axeSpellProjectile.target = target;

  [self checkAxeCollision:axeSprite data:axeSpellProjectile];
}

- (void)checkAxeCollision:(id)object data:(id)data {
  if ([object isKindOfClass:[CCSprite class]] == NO)
    return;

  CCSprite *axeSprite = (CCSprite *)object;
  NBSpellProjectile *axeSpellProjectile = (NBSpellProjectile *)data;
  NBCharacter *target;
  if (axeSpellProjectile.isReturningToThrower)
    target = axeSpellProjectile.thrower;
  else
    target = axeSpellProjectile.target;

  NSArray *collidingCharacters = [self charactersCollidingWithPoint:axeSprite.position radius:5];
  for (NBCharacter *character in collidingCharacters) {
    NSInteger damage = 5;
    [character onAttackedBySkillWithDamage:damage];
    DLog(@"%@ has taken %d damage from a skill", character.name, damage);
  }

  CGFloat euclideanDistance = ccpDistance(axeSprite.position, target.position);
  CGFloat speed = axeSpellProjectile.speed;
  CGPoint translationRequired = ccpSub(target.position, axeSprite.position);
  if (euclideanDistance < speed)
    translationRequired = CGPointMake(translationRequired.x, translationRequired.y);
  else {
    translationRequired = CGPointMake(speed*translationRequired.x/euclideanDistance, speed*translationRequired.y/euclideanDistance);

    //uncomment the following for a curved trajectory
//    CGFloat trajectoryOffset = M_PI/180.0*20.0;
//    CGAffineTransform rotate = CGAffineTransformMakeRotation(trajectoryOffset);
//    translationRequired = CGPointApplyAffineTransform(translationRequired, rotate);
  }

  if (CGPointEqualToPoint(CGPointZero, translationRequired)) {
    if (axeSpellProjectile.isBoomerang && axeSpellProjectile.isReturningToThrower == NO)
      axeSpellProjectile.isReturningToThrower = YES;
    else {
      [axeSprite removeFromParentAndCleanup:YES];
      return;
    }
  }

  CCMoveBy *moveBy = [CCMoveBy actionWithDuration:1.0/speed position:translationRequired];

  CCCallFuncND *callFunc = [CCCallFuncND actionWithTarget:self selector:@selector(checkAxeCollision:data:) data:axeSpellProjectile];
  CCSequence *sequence = [CCSequence actionOne:moveBy two:callFunc];
  [axeSprite runAction:sequence];
}

- (void)castEarthquake:(NBCharacter *)target {
  NSMutableArray *earthquakeSprites = [NSMutableArray array];
  NSInteger numberOfFrames = 4;
  for (NSInteger i = 0; i < numberOfFrames; i++)
    [earthquakeSprites addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"skill_earthquake_%d.png", i]]];

  CCSprite *earthquakeSprite = [CCSprite spriteWithSpriteFrameName:@"skill_earthquake_1.png"];
  earthquakeSprite.position = CGPointMake(target.position.x, target.position.y - 5);// target.position;
  earthquakeSprite.scale = 1.5;
  [self addChild:earthquakeSprite];

  CGFloat frameInterval = 0.15;
  CCAnimation *animation = [CCAnimation animationWithSpriteFrames:earthquakeSprites delay:frameInterval];
  NSInteger numberOfAnimationLoops = 5;
  CCAction *earthquakeAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:numberOfAnimationLoops];
  CCCallFunc *removeFromParentAction = [CCCallFunc actionWithTarget:earthquakeSprite selector:@selector(removeFromParentAndCleanup:)];
  CCSequence *sequence = [CCSequence actionOne:earthquakeAction two:removeFromParentAction];
  [earthquakeSprite runAction:sequence];

  NBRipples *earthquakeRipples = [[NBRipples alloc] init];
  earthquakeRipples.origin = target.position;
  earthquakeRipples.amplitude = 20;
  earthquakeRipples.rippleInterval = frameInterval * numberOfFrames/2;
  earthquakeRipples.numberOfRipples = numberOfAnimationLoops * 2;
  earthquakeRipples.delegate = self;
  [earthquakeRipples startRipples];
  [self addChild:earthquakeRipples];
}

- (void)spawnArrows:(id)object data:(id)data {
  if ([data isKindOfClass:[NBCharacter class]] == NO)
    return;

  NBCharacter *target = (NBCharacter *)data;

  CCSprite *arrowSprite = [CCSprite spriteWithSpriteFrameName:@"normal_arrow_anim_1.png"];
  NSInteger arrowSpread = 50;
  arrowSprite.position = CGPointMake(target.position.x + arc4random()%arrowSpread - arrowSpread/2, target.position.y + [[CCDirector sharedDirector] winSize].height);
  arrowSprite.rotation = 90;

  [self addChild:arrowSprite];

  CGFloat arrowFlightDuration = 1;
  CCMoveBy *moveAction = [CCMoveBy actionWithDuration:arrowFlightDuration position:CGPointMake(0, -[[CCDirector sharedDirector] winSize].height)];
  [arrowSprite runAction:moveAction];

  CCCallFuncND *callFunc = [CCCallFuncND actionWithTarget:self selector:@selector(checkArrowCollision:data:) data:arrowSprite];
  CCDelayTime *delayAction = [CCDelayTime actionWithDuration:arrowFlightDuration];
  [self runAction:[CCSequence actionOne:delayAction two:callFunc]];
}

- (void)checkArrowCollision:(id)object data:(id)data {
  if ([data isKindOfClass:[CCSprite class]] == NO)
    return;

  CCSprite *arrowSprite = (CCSprite *)data;

  NSArray *collidingCharacters = [self charactersCollidingWithPoint:arrowSprite.position radius:5];
  for (NBCharacter *character in collidingCharacters) {
    NSInteger damage = 5;
    [character onAttackedBySkillWithDamage:damage];
    DLog(@"%@ has taken %d damage from a skill", character.name, damage);
  }

  [arrowSprite removeFromParentAndCleanup:YES];
}

- (void)castArrowRain:(NBCharacter *)target {
  CCCallFuncND *spawnArrowsAction = [CCCallFuncND actionWithTarget:self selector:@selector(spawnArrows:data:) data:target];
  CCDelayTime *delayAction = [CCDelayTime actionWithDuration:0.05];
  CCSequence *sequence = [CCSequence actionOne:spawnArrowsAction two:delayAction];
  CCRepeat *repeatingAction = [CCRepeat actionWithAction:sequence times:50];

  [self runAction:repeatingAction];
}

- (NSArray *)charactersCollidingWithPoint:(CGPoint)point radius:(CGFloat)radius {
  NSMutableArray *collidingCharacters = [NSMutableArray array];
  for (NBSquad *squad in self.enemySquads) {
    for (NBCharacter *character in squad.unitArray) {
      BOOL hasCollision = [self checkCharacter:character collisionWithRippleOrigin:point withRippleAmplitude:radius];
      if (hasCollision) {
        [collidingCharacters addObject:character];
      }
    }
  }
  return collidingCharacters;
}

- (void)rippleFinished:(CGPoint)rippleOrigin rippleAmplitude:(CGFloat)rippleAmplitude {
  NSArray *collidingCharacters = [self charactersCollidingWithPoint:rippleOrigin radius:rippleAmplitude];
  for (NBCharacter *character in collidingCharacters) {
    NSInteger damage = 1;
    [character onAttackedBySkillWithDamage:damage];
    DLog(@"%@ has taken %d damage from a skill", character.name, damage);
  }
}

- (BOOL)checkCharacter:(NBCharacter *)character collisionWithRippleOrigin:(CGPoint)rippleOrigin withRippleAmplitude:(CGFloat)rippleAmplitude {
  if (ccpDistance(character.position, rippleOrigin) <= rippleAmplitude)
    return YES;
  else
    return NO;
}

@end
