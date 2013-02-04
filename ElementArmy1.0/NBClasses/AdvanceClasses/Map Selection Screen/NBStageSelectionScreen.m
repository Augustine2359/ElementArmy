 //
//  NBStageSelectionScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 20/1/13.
//
//

#import "math.h"
#import "NBStageSelectionScreen.h"
#import "NBBasicClassData.h"

@implementation NBStageSelectionScreen

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBStageSelectionScreen sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBStageSelectionScreen *layer = [NBStageSelectionScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    if (makeDefault)
        [NBBasicScreenLayer setDefaultScreen:scene];
	
	// return the scene
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    UI_USER_INTERFACE_IDIOM();
    
    //Prepare Sprite Batch Node
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
    self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
    [self addChild:self.characterSpritesBatchNode z:0 tag:0];
    
    //Prepare stage grid
    self.horizontalGridCount = 32;
    self.verticalGridCount = (int)(self.layerSize.height / STAGE_ICON_HEIGHT * 2) - 1;
    
    self.currentCountryStage = [[NBCountryStageGrid alloc] initOnLayer:self withSize:CGSizeMake((self.horizontalGridCount * STAGE_ICON_WIDTH / 2), (self.verticalGridCount * STAGE_ICON_HEIGHT / 2))];
    DLog(@"test: %d", (self.verticalGridCount * STAGE_ICON_HEIGHT / 2));
    [self readFromDataManager];
    [self readStagesFromFile];
    [self.currentCountryStage onEnter:self];
    
    self.gotoBattleButton = [NBButton createWithStringHavingNormal:@"next_arrow.png" havingSelected:@"next_arrow.png" havingDisabled:@"next_arrow.png" onLayer:self respondTo:nil selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    self.gotoBattleButton.menu.position = CGPointMake(self.layerSize.width - 20, 20);
    [self.gotoBattleButton show];
    self.backToWorldSelectionButton = [NBButton createWithStringHavingNormal:@"previous_arrow.png" havingSelected:@"previous_arrow.png" havingDisabled:@"previous_arrow.png" onLayer:self respondTo:nil selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    self.backToWorldSelectionButton.menu.position = CGPointMake(20, 20);
    [self.backToWorldSelectionButton show];
    
    //For development only
    //[self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
    //[self addStandardMenuString:@"Go to Battle" withSelector:@selector(gotoBattleScreen)];
}

-(void)onExit
{
    [self.currentCountryStage release];
}

-(void)readFromDataManager
{
    NBStage* stage = nil;
    NBStageData* stageData = nil;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        stage = [NBStage getStageByID:stageData.stageID];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        
        [self.currentCountryStage addStage:stage];
        
        if (stage.stageData.winCount > 1)
        {
            [stage createCompletedLines];
        }
    }
    
    if (self.dataManager.selectedStageData)
    {
        NBStageData* stageData = self.dataManager.selectedStageData;
        
        if (self.dataManager.battleWon)
        {
            stage = [self.currentCountryStage getStageByID:stageData.stageID];
            NSString* unlockingStageID = nil;
            
            CCARRAY_FOREACH(stage.stageData.willUnlockStageID, unlockingStageID)
            {
                NBStage* unlockingStage = [self.currentCountryStage getStageByID:unlockingStageID];
                unlockingStage.stageData.isUnlocked = true;
            }
        }
    }
    
    /*for (NBStage *stage in self.dataManager.listOfStages)
    {
        [self.currentCountryStage addStage:stage];
        [stage createCompletedLines];
    }*/
}

-(void)readStagesFromFile
{
    //These data should come from file later on
    int index = 0;
    NBStage* stage = nil;
    NBStageData* stageData = nil;
    NBBasicClassData* basicClassData = nil;
    CCArray* arrayOfEnemyData = nil;
    bool stageCreated = false;
    
    if (self.dataManager.listOfCreatedStagesID && [self.dataManager.listOfCreatedStagesID count] > 0)
    {
        CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
        {
            if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
            {
                stageCreated = true;
                break;
            }
        }
    }

    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage1"];
        [stageData.willUnlockStageID addObject:@"stage1"];
        stageData.isCompleted = false;
        stageData.isUnlocked = true;
        stageData.availableNormalImageName = @"water_stageA.png";
        stageData.completedNormalImageName = @"water_stageA.png";
        stageData.availableDisabledImageName = @"water_stageA_locked.png";
        stageData.completedDisabledImageName = @"water_stageA_locked.png";
        stageData.gridPoint = CGPointMake(2, 2);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage2"];
        [stageData.willUnlockStageID addObject:@"stage2"];
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageB.png";
        stageData.completedNormalImageName = @"water_stageB.png";
        stageData.availableDisabledImageName = @"water_stageB_locked.png";
        stageData.completedDisabledImageName = @"water_stageB_locked.png";
        stageData.gridPoint = CGPointMake(6, 2);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage3"];
        [stageData.willUnlockStageID addObject:@"stage3"];
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageA.png";
        stageData.completedNormalImageName = @"water_stageA.png";
        stageData.availableDisabledImageName = @"water_stageA_locked.png";
        stageData.completedDisabledImageName = @"water_stageA_locked.png";
        stageData.gridPoint = CGPointMake(6, 6);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage4"];
        [stageData.willUnlockStageID addObject:@"stage4"];
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageB.png";
        stageData.completedNormalImageName = @"water_stageB.png";
        stageData.availableDisabledImageName = @"water_stageB_locked.png";
        stageData.completedDisabledImageName = @"water_stageB_locked.png";
        stageData.gridPoint = CGPointMake(2, 6);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage5"];
        [stageData.willUnlockStageID addObject:@"stage5"];
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageA.png";
        stageData.completedNormalImageName = @"water_stageA.png";
        stageData.availableDisabledImageName = @"water_stageA_locked.png";
        stageData.completedDisabledImageName = @"water_stageA_locked.png";
        stageData.gridPoint = CGPointMake(2, 10);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage6"];
        [stageData.willUnlockStageID addObject:@"stage6"];
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageB.png";
        stageData.completedNormalImageName = @"water_stageB.png";
        stageData.availableDisabledImageName = @"water_stageB_locked.png";
        stageData.completedDisabledImageName = @"water_stageB_locked.png";
        stageData.gridPoint = CGPointMake(6, 10);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage7"];
        [stageData.nextStageID addObject:@"stage9"];
        [stageData.willUnlockStageID addObject:@"stage7"];
        [stageData.willUnlockStageID addObject:@"stage9"];
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageA.png";
        stageData.completedNormalImageName = @"water_stageA.png";
        stageData.availableDisabledImageName = @"water_stageA_locked.png";
        stageData.completedDisabledImageName = @"water_stageA_locked.png";
        stageData.gridPoint = CGPointMake(10, 10);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        [stageData.nextStageID addObject:@"stage8"];
        [stageData.willUnlockStageID addObject:@"stage8"];
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageB.png";
        stageData.completedNormalImageName = @"water_stageB_locked.png";
        stageData.availableDisabledImageName = @"water_stageB_locked.png";
        stageData.completedDisabledImageName = @"water_stageB_locked.png";
        stageData.gridPoint = CGPointMake(10, 6);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageBoss.png";
        stageData.completedNormalImageName = @"water_stageBoss.png";
        stageData.availableDisabledImageName = @"water_stageBoss_locked.png";
        stageData.completedDisabledImageName = @"water_stageBoss_locked.png";
        stageData.gridPoint = CGPointMake(18, 6);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
    
    index++;
    
    CCARRAY_FOREACH(self.dataManager.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:[NSString stringWithFormat:@"stage%i", index]])
        {
            stageCreated = true;
            break;
        }
    }
    
    if (!stageCreated)
    {
        stageData = [[NBStageData alloc] init];
        stageData.stageID = [NSString stringWithFormat:@"stage%i", index];
        stageData.countryID = @"Water";
        stageData.isCompleted = false;
        stageData.isUnlocked = false;
        stageData.availableNormalImageName = @"water_stageSecret.png";
        stageData.completedNormalImageName = @"water_stageSecret.png";
        stageData.availableDisabledImageName = @"water_stageSecret_locked.png";
        stageData.completedDisabledImageName = @"water_stageSecret_locked.png";
        stageData.gridPoint = CGPointMake(10, 14);
        
        arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBSoldier";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        basicClassData = [[NBBasicClassData alloc] init];
        basicClassData.className = @"NBFireMage";
        basicClassData.level = 1;
        basicClassData.availableUnit = index + 1;
        basicClassData.totalUnit = 8;
        basicClassData.timeLastBattleCompleted = [NSDate date];
        
        [arrayOfEnemyData addObject:basicClassData];
        
        stageData.enemyList = arrayOfEnemyData;
        
        stage = [NBStage createStageWithStageData:stageData onLayer:self dataManager:self.dataManager];
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
        
        stageCreated = false;
    }
}

-(void)onStageSelected
{
    NBStage* stage = [NBStage getCurrentlySelectedStage];
    self.dataManager.selectedStageData = stage.stageData;
    DLog(@"StageID selected: %@", stage.stageData.stageID);
}

-(void)update:(ccTime)delta
{
    [self.currentCountryStage update];
}

-(void)gotoBattleSetupScreen
{
    self.nextScene = @"NBBattleSetupScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoBattleScreen
{
    if (self.dataManager.selectedStageData)
    {
        self.nextScene = @"NBBattleLayer";
        [self changeToScene:self.nextScene];
    }
}

-(void)gotoMapSelectionScreen
{
    self.nextScene = @"NBMapSelectionScreen";
    [self changeToScene:self.nextScene];
}

@end
