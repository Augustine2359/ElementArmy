//
//  NBStageSelectionScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 20/1/13.
//
//

#import "math.h"
#import "NBStageSelectionScreen.h"

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
    [self readStagesFromFile];
    
    //For development only
    [self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
}

-(void)onExit
{
    [self.currentCountryStage release];
}

-(void)readStagesFromFile
{
    //These data should come from file later on
    int index = 0;
    
    NBStage* stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    stage.nextStageID = @"stage1";
    
    if (![stage setGridPoint:CGPointMake(2, 2)])
        DLog(@"Stage grid not set due, Please check if both icons have been set.");
    
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(6, 2)];
    stage.previousStageID = @"stage0";
    stage.nextStageID = @"stage2";
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(6, 6)];
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(10, 6)];
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(10, 10)];
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(14, 10)];
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageA.png" withDisabledImage:@"water_stageA.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(14, 6)];
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageB.png" withDisabledImage:@"water_stageB.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(18, 6)];
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageBoss.png" withDisabledImage:@"water_stageBoss.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageBoss.png" withDisabledImage:@"water_stageBoss.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(18, 10)];
    [self.currentCountryStage addStage:stage];
    
    index++;
    stage = [NBStage createStageWithStatus:ssUnlocked withID:[NSString stringWithFormat:@"stage%i", index]];
    [stage setAvailableImage:@"water_stageSecret.png" withDisabledImage:@"water_stageSecret.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setCompletedImage:@"water_stageSecret.png" withDisabledImage:@"water_stageSecret.png" onLayer:self selector:@selector(onStageSelected)];
    [stage setGridPoint:CGPointMake(10, 14)];
    [self.currentCountryStage addStage:stage];
}

-(void)onStageSelected
{
    NBStage* stage = [NBStage getCurrentlySelectedStage];
    DLog(@"StageID selected: %@", stage.stageID);
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

@end
