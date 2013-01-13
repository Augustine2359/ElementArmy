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
    [self prepareUnits];
    [self prepareUI];
    
    if (!isAutoStart)
    {
        // Default font size will be 28 points.
        [CCMenuItemFont setFontSize:28];
        
        // create and initialize a Label
        CCMenuItem *startGameButtonMenu = [CCMenuItemFont itemWithString:@"Start Battle" target:self selector:@selector(prepareBattlefield)];
        self.menu = [CCMenu menuWithItems:startGameButtonMenu, nil];
        
        [self.menu alignItemsHorizontallyWithPadding:20];
        [self.menu setPosition:ccp(size.width / 2, size.height / 2 - 50)];
        
        // Add the menu to the layer
        [self addChild:self.menu];
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
        
        if (self.allAllyUnitAnnihilated)
        {
            self.battleResultText = [CCLabelTTF labelWithString:@"Defeat" fontName:@"Zapfino" fontSize:28];
            self.battleResultText.position = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
            [self addChild:self.battleResultText];
            //[self gotoMapSelectionScreen];
        }
        else if (self.allEnemyUnitAnnihilated)
        {
            self.battleResultText = [CCLabelTTF labelWithString:@"Victory" fontName:@"Zapfino" fontSize:28];
            self.battleResultText.position = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
            [self addChild:self.battleResultText];
        }
        
        if (self.allAllyUnitAnnihilated || self.allEnemyUnitAnnihilated)
        {
            battleStarted = false;
            
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
            CCMenuItem *startGameButtonMenu = [CCMenuItemFont itemWithString:@"tap here to continue..." target:self selector:@selector(gotoMapSelectionScreen)];
            self.battleCompleteMenu = [CCMenu menuWithItems:startGameButtonMenu, nil];
            
            [self.battleCompleteMenu alignItemsHorizontallyWithPadding:20];
            [self.battleCompleteMenu setPosition:ccp(self.layerSize.width / 2, 100)];
            
            // Add the menu to the layer
            [self addChild:self.battleCompleteMenu];
        }
    }
}

-(void)gotoMapSelectionScreen
{
    self.nextScene = @"NBMapSelectionScreen";
    [self changeToScene:self.nextScene transitionWithDuration:1.0];
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
            tempSquad = [[NBSquad alloc] createSquadOf:squadClassData.className withUnitCount:squadClassData.availableUnit onSide:Ally andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
            
            if (tempSquad)
            {
                [tempSquad startUpdate];
                [self.allySquads addObject:tempSquad];
            }
        }
    }
    
    for (int i = 0; i < [self.dataManager.arrayOfEnemySquad count]; i++)
    {
        NBBasicClassData* squadClassData = [self.dataManager.arrayOfEnemySquad objectAtIndex:i];
        
        if (squadClassData)
        {
            tempSquad = [[NBSquad alloc] createSquadOf:squadClassData.className withUnitCount:squadClassData.availableUnit onSide:Enemy andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
            
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
    
    //The placeholder. This should be something like transparent tube later.
    //**********************************************************************
    self.allyHPBarPlaceholder = [NBStaticObject createWithSize:CGSizeMake(HP_BAR_LENGTH, 16) usingFrame:@"staticemptybox_white.png" atPosition:CGPointMake(self.layerSize.width / 2, 25)];
    self.allyHPBarPlaceholder.sprite.anchorPoint = CGPointMake(1, 1);
    self.enemyHPBarPlaceholder = [NBStaticObject createWithSize:CGSizeMake(HP_BAR_LENGTH, 16) usingFrame:@"staticemptybox_white.png" atPosition:CGPointMake(self.layerSize.width / 2, 25)];
    self.enemyHPBarPlaceholder.sprite.anchorPoint = CGPointMake(0, 1);
    //**********************************************************************
    
    //The HP Bar
    //**********************************************************************
    self.allyHPBar = [NBStaticObject createWithSize:CGSizeMake(130, 16) usingFrame:@"staticbox_green.png" atPosition:CGPointMake(self.layerSize.width / 2, 25)];
    self.allyHPBar.sprite.anchorPoint = CGPointMake(1, 1);
    self.enemyHPBar = [NBStaticObject createWithSize:CGSizeMake(130, 16) usingFrame:@"staticbox_red.png" atPosition:CGPointMake(self.layerSize.width / 2, 25)];
    self.enemyHPBar.sprite.anchorPoint = CGPointMake(0, 1);
    self.allyFlagLogo = [NBStaticObject createStaticObject:@"ally_logo_dummy.png" atPosition:CGPointMake(110, 30)];
    self.enemyFlagLogo = [NBStaticObject createStaticObject:@"enemy_logo_dummy.png" atPosition:CGPointMake(self.layerSize.width - 110, 30)];
    //**********************************************************************
    
    
    //Augustine's Code below
    //**********************
    self.classGroupSkillMenuLayer = [[NBFancySlidingMenuLayer alloc] init];

    self.classGroupSkillMenuLayer.layerSize = CGSizeMake(100, 50);
    self.classGroupSkillMenuLayer.contentSize = CGSizeMake(100, 50);
    [self addChild:self.classGroupSkillMenuLayer];
    //**********************
}

-(void)startBattle
{
    if (self.menu) self.menu.visible = NO;
    
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
