//
//  NBMapSelectionScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import "NBMapSelectionScreen.h"

@implementation NBMapSelectionScreen

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBMapSelectionScreen sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBMapSelectionScreen *layer = [NBMapSelectionScreen node];
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
    
    //Display background
    [self setCurrentBackgroundWithFileName:@"NB_worldMap_960x480.png" stretchToScreen:NO];
    
    NBCountryData* countryData = nil;
    
    CCARRAY_FOREACH([NBDataManager getListOfCountries], countryData)
    {
        if (![countryData.countryName isEqualToString:@"unknown"])
        {
            NBCountry* newCountry = [[NBCountry alloc] initWithCountryData:countryData onLayer:self respondToSelector:@selector(onCountrySelected)];
        }
        //[self addChild:newCountry.icon];
    }
    
    [self addStandardMenuString:@"Battle" withSelector:@selector(gotoBattleScreen)];
    [self addStandardMenuString:@"Story" withSelector:@selector(gotoStoryScreen)];
    [self addStandardMenuString:@"Intro" withSelector:@selector(gotoIntroScreen)];
}

-(void)gotoIntroScreen
{
    self.nextScene = @"NBIntroScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoMainMenuScreen
{
    self.nextScene = @"NBMainMenuScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoStoryScreen
{
    self.nextScene = @"NBStoryScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoStageSelectionScreen
{
    self.nextScene = @"NBStageSelectionScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoBattleScreen
{
    self.nextScene = @"NBBattleLayer";
    [self changeToScene:self.nextScene];
}

-(void)onCountrySelected
{
    self.dataManager.selectedCountryData = [NBCountry getCurrentSelectedCountry];
    [self gotoStageSelectionScreen];
}

@end
