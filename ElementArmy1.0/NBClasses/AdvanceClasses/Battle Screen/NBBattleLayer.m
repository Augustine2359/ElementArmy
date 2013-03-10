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
            [tempSquad update];
            
            if (!tempSquad.allUnitAreDead)
            {
                self.allAllyUnitAnnihilated = false;
                allyTotalHP += tempSquad.totalAliveUnitHP;
            }
        }
        
        CCARRAY_FOREACH(self.enemySquads, tempSquad)
        {
            [tempSquad update];
             
            if (!tempSquad.allUnitAreDead)
            {
                self.allEnemyUnitAnnihilated = false;
                enemyTotalHP += tempSquad.totalAliveUnitHP;
            }
        }
        
        if (totalAllyHPAtStartOfBattle > 0)
        {
            long newAllyHPBarWidth = (allyTotalHP / totalAllyHPAtStartOfBattle) * HP_BAR_LENGTH;
            [self.allyHPBar setToCustomSize:CGSizeMake(newAllyHPBarWidth, self.allyHPBar.sizeOnScreen.height)];
        }
        
        if (totalEnemyHPAtStartOfBattle > 0)
        {
            long newEnemyHPBarWidth = (enemyTotalHP / totalEnemyHPAtStartOfBattle) * HP_BAR_LENGTH;
            [self.enemyHPBar setToCustomSize:CGSizeMake(newEnemyHPBarWidth, self.enemyHPBar.sizeOnScreen.height)];
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
            }
            
            [self processBattleResult];
        }
    }
}

-(void)processBattleResult
{
    battleStarted = false;
    
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
        [self.battleCompleteMenu setPosition:ccp(self.layerSize.width / 2, 100)];
        
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
    
    //The HP Bar
    //**********************************************************************
    self.allyHPBar = [NBStaticObject createWithSize:CGSizeMake(130, 12) usingFrame:@"staticbox_green.png" atPosition:CGPointMake(self.layerSize.width / 2, 25)];
    targetScaleXForHPBar = self.allyHPBar.scaleX;
    targetScaleYForHPBar = self.allyHPBar.scaleY;
    DLog(@"%f, %f", targetScaleXForHPBar, targetScaleYForHPBar);
    self.allyHPBar.sprite.anchorPoint = CGPointMake(1, 1);
    self.allyHPBar.scaleX = 0;
    self.enemyHPBar = [NBStaticObject createWithSize:CGSizeMake(130, 12) usingFrame:@"staticbox_red.png" atPosition:CGPointMake(self.layerSize.width / 2, 25)];
    self.enemyHPBar.sprite.anchorPoint = CGPointMake(0, 1);
    self.enemyHPBar.scaleX = 0;
    //**********************************************************************
    
    //The placeholder. This should be something like transparent tube later.
    //**********************************************************************
    self.HPBarPlaceholder = [NBStaticObject createWithSize:CGSizeZero usingFrame:@"lifebar.png" atPosition:CGPointMake((self.layerSize.width / 2) - 5, -20)];
    //self.HPBarPlaceholder.sprite.anchorPoint = CGPointMake(1, 1);
    //**********************************************************************
    
    self.allyFlagLogo = [NBStaticObject createStaticObject:@"ally_logo_dummy.png"];
    self.allyFlagLogo.position = CGPointMake((-1 * (self.allyFlagLogo.sprite.contentSize.width * 2)), 30);
    self.allyFlagLogo.visible = YES;
    self.enemyFlagLogo = [NBStaticObject createStaticObject:@"enemy_logo_dummy.png"];
    self.enemyFlagLogo.position = CGPointMake(self.layerSize.width + (self.allyFlagLogo.sprite.contentSize.width * 2), 30);
    self.enemyFlagLogo.visible = YES;
    
    //Augustine's Code below
    //**********************
    self.classGroupSkillMenuLayer = [[NBFancySlidingMenuLayer alloc] initOnLeftSide:YES];
    self.classGroupSkillMenuLayer.layerSize = CGSizeMake(100, 50);
    self.classGroupSkillMenuLayer.contentSize = CGSizeMake(100, 50);
    [self addChild:self.classGroupSkillMenuLayer];
    self.classGroupSkillMenuLayer.position = CGPointMake(-20 , -48);

    self.itemMenuLayer = [[NBFancySlidingMenuLayer alloc] initOnLeftSide:NO];
    self.itemMenuLayer.layerSize = CGSizeMake(100, 50);
    self.itemMenuLayer.contentSize = CGSizeMake(100, 50);
    [self addChild:self.itemMenuLayer];
    self.itemMenuLayer.position = CGPointMake(20, -48);
    //**********************
    
    [NBDamageLabel setCurrentLayerForDamageLabel:self];
    
    [self entranceAnimationStep1];
}

-(void)entranceAnimationStep1
{
    CCDelayTime* delay = [CCDelayTime actionWithDuration:0.5];
    self.stageNameBanner = [CCLabelTTF labelWithString:self.dataManager.selectedStageData.stageName fontName:@"Zapfino" fontSize:32];
    self.stageNameBanner.position = CGPointMake((self.layerSize.width / 2), (self.layerSize.height / 2) + 320);
    
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:1.80];
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:1.80];
    
    CCCallFuncN* animationCompleted = [CCCallFuncN actionWithTarget:self selector:@selector(entranceAnimationStep2)];
    CCSequence* sequence = [CCSequence actions:delay, fadeIn, delay, fadeOut, animationCompleted, nil];
    [self.stageNameBanner runAction:sequence];
    
    [self addChild:self.stageNameBanner];
}

-(void)entranceAnimationStep2
{
    CCMoveTo* move = [CCMoveTo actionWithDuration:3.0 position:CGPointMake(self.position.x, 0)];
    
    CCCallFuncN* moveCompleted = [CCCallFuncN actionWithTarget:self selector:@selector(entranceAnimationStep3)];
    CCSequence* sequence = [CCSequence actions:move, moveCompleted, nil];
    [self runAction:sequence];
}

-(void)entranceAnimationStep3
{
    CCMoveTo* move1_0 = [CCMoveTo actionWithDuration:2.0 position:CGPointMake(self.layerSize.width / 2, self.allyFlagLogo.position.y)];
    CCMoveTo* move1_1 = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(self.layerSize.width * 0.225, self.allyFlagLogo.position.y)];
    CCMoveTo* move2_0 = [CCMoveTo actionWithDuration:2.0 position:CGPointMake(self.layerSize.width / 2, self.enemyFlagLogo.position.y)];
    CCMoveTo* move2_1 = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(self.layerSize.width * 0.775, self.enemyFlagLogo.position.y)];
    CCMoveTo* move3_0 = [CCMoveTo actionWithDuration:2.0 position:CGPointMake((self.layerSize.width / 2) - 5, 20)];
    
    CCEaseIn* ease1 = [CCEaseIn actionWithAction:move1_0 rate:2];
    CCEaseIn* ease2 = [CCEaseIn actionWithAction:move2_0 rate:2];
    CCEaseIn* ease3 = [CCEaseIn actionWithAction:move3_0 rate:2];
    CCEaseOut* ease1_1 = [CCEaseOut actionWithAction:move1_1 rate:1.5];
    CCEaseOut* ease2_1 = [CCEaseOut actionWithAction:move2_1 rate:1.5];
    
    CCCallFuncN* animation1Completed = [CCCallFuncN actionWithTarget:self selector:@selector(onBackgroundMoveCompleted)];
    CCCallFuncN* animation2Completed = [CCCallFuncN actionWithTarget:self selector:@selector(entranceAnimationStep4)];
    CCSequence* sequence1 = [CCSequence actions:ease1, animation2Completed, ease1_1, nil];
    CCSequence* sequence2 = [CCSequence actions:ease2, ease2_1, animation1Completed, nil];
    CCSequence* sequence3 = [CCSequence actions:ease3, move3_0, nil];
    [self.allyFlagLogo runAction:sequence1];
    [self.enemyFlagLogo runAction:sequence2];
    [self.HPBarPlaceholder runAction:sequence3];
}

-(void)entranceAnimationStep4
{
    CCMoveTo* move4_0 = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(0, 0)];
    CCMoveTo* move5_0 = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(0, 0)];

    [self.classGroupSkillMenuLayer runAction:move4_0];
    [self.itemMenuLayer runAction:move5_0];
    
    CCScaleTo* scale1_0 = [CCScaleTo actionWithDuration:1.5 scaleX:targetScaleXForHPBar scaleY:targetScaleYForHPBar];
    CCScaleTo* scale2_0 = [CCScaleTo actionWithDuration:1.5 scaleX:targetScaleXForHPBar scaleY:targetScaleYForHPBar];
    CCEaseOut* ease1_1 = [CCEaseOut actionWithAction:scale1_0 rate:1.5];
    CCEaseOut* ease2_1 = [CCEaseOut actionWithAction:scale2_0 rate:1.5];
    
    [self.allyHPBar runAction:ease1_1];
    [self.enemyHPBar runAction:ease2_1];
}

-(void)onBackgroundMoveCompleted
{
    //self.allyHPBar.visible = YES;
    //self.enemyHPBar.visible = YES;
    //self.allyFlagLogo.visible = YES;
    //self.enemyFlagLogo.visible = YES;
    self.HPBarPlaceholder.visible = YES;
    
    [self reorderChild:self.HPBarPlaceholder z:10];
    [self reorderChild:self.allyFlagLogo z:11];
    [self reorderChild:self.enemyFlagLogo z:11];
    
    [self.startBattleButton show];
}

-(void)startBattle
{
    if (self.startBattleButton) [self.startBattleButton hide];
    
    battleStarted = true;
    
    NBCharacter* tempCharacter;
    
    CCARRAY_FOREACH([NBCharacter getAllUnitList], tempCharacter)
    {
        tempCharacter.currentState = Idle;
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

//************************************************************************************************

@end
