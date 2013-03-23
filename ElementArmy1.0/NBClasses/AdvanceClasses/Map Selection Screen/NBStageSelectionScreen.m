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
    layer.layerName = NSStringFromClass([layer class]);
	
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
    self.currentCountryData = self.dataManager.selectedCountryData;
    self.horizontalGridCount = self.currentCountryData.gridBoardSize.width;
    self.verticalGridCount = self.currentCountryData.gridBoardSize.height;
    DLog(@"country %@ will be loaded with (width, height): %d, %d", self.currentCountryData.countryName, (self.horizontalGridCount * STAGE_ICON_WIDTH / 2), (self.verticalGridCount * STAGE_ICON_HEIGHT / 2));
    
    self.currentCountryStage = [[NBCountryStageGrid alloc] initOnLayer:self withSize:CGSizeMake((self.horizontalGridCount * STAGE_ICON_WIDTH / 2), (self.verticalGridCount * STAGE_ICON_HEIGHT / 2)) withCountryData:self.currentCountryData respondToSelector:@selector(onStageGridEnteringAnimationCompleted)];
    [self.currentCountryStage onEnter:self];
    
    self.gotoBattleButton = [NBButton createWithStringHavingNormal:@"next_arrow.png" havingSelected:@"next_arrow.png" havingDisabled:@"next_arrow.png" onLayer:self respondTo:nil selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    self.gotoBattleButton.menu.position = CGPointMake(self.layerSize.width - 20, 20);
    self.backToWorldSelectionButton = [NBButton createWithStringHavingNormal:@"previous_arrow.png" havingSelected:@"previous_arrow.png" havingDisabled:@"previous_arrow.png" onLayer:self respondTo:nil selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    self.backToWorldSelectionButton.menu.position = CGPointMake(20, 20);
    
    [self readFromDataManager];
    //Just for the time being, disable save progress.
    //[self.dataManager saveStages];
    [self readStagesFromFile];
    
    //FLAG
    self.flagCursor = [[NBSingleAnimatedObject alloc] initWithSpriteFrameName:@"flagSelection_0.jpg"];
    [self.flagCursor addAnimationFrameName:@"flagSelection" withAnimationCount:2 fileExtension:@"jpg"];
    NBStage* stage = [NBStage getCurrentlySelectedStage];
    self.flagCursor.position = stage.worldIcon.menu.position;
    self.flagCursor.scale = 0.5f;
    [self.currentCountryStage addChild:self.flagCursor z:99];
    [self.flagCursor playAnimation:true withDelay:0.5];
    
    //STAGE INFO PANEL
    self.stageInfoPanel = [[NBStageInfoPanel alloc] initOnLayer:self];
}

-(void)onExit
{
    [self.currentCountryStage release];
}

-(void)onStageGridEnteringAnimationCompleted
{
    [self.gotoBattleButton show];
    [self.backToWorldSelectionButton show];
}

-(void)readFromDataManager
{
    NBStage* stage = nil;
    NBStageData* stageData = nil;
    
    CCARRAY_FOREACH(self.dataManager.selectedCountryData.listOfCreatedStagesID, stageData)
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
        //[self.dataManager createStages];
        self.stageCreated = true;
    }
    
    for (NBStage *stage in self.dataManager.selectedCountryData.stageList)
    {
        [stage setupIconAndDisplayOnLayer:self selector:@selector(onStageSelected)];
        [stage setupGrid];
        [self.currentCountryStage addStage:stage];
        [self.dataManager.selectedCountryData.listOfCreatedStagesID addObject:stage.stageData];
    }
}

-(void)onStageSelected
{
    NBStage* stage = [NBStage getCurrentlySelectedStage];
    self.dataManager.selectedStageData = stage.stageData;
    DLog(@"StageID selected: %@", stage.stageData.stageID);
    
    self.flagCursor.position = stage.worldIcon.menu.position;
    [self.stageInfoPanel appearWithStageData:stage.stageData];
}

-(void)update:(ccTime)delta
{
    [self.currentCountryStage update];
}

-(void)gotoBattleSetupScreen
{
    [self.stageInfoPanel disappear:false];
    
    self.nextScene = @"NBBattleSetupScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoBattleScreen
{
    [self.stageInfoPanel disappear:false];
    
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
