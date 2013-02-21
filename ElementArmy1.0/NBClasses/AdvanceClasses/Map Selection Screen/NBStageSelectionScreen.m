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
    [self.dataManager saveStages];
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
                NBStage* unlockingStage = nil;
                unlockingStage = (NBStage*)[self.currentCountryStage getStageByID:unlockingStageID];
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
    if (!self.stageCreated)
    {
        [self.dataManager createStages];
        self.stageCreated = true;
    }
    
    for (NBStage *stage in self.dataManager.listOfStages)
    {
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.listOfCreatedStagesID addObject:stage.stageData];
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
