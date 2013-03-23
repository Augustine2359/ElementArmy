//
//  NBHQSetupScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/2/13.
//
//

#import "NBHQSetupScreen.h"

@implementation NBHQSetupScreen

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBHQSetupScreen sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBHQSetupScreen *layer = [NBHQSetupScreen node];
    layer.layerName = NSStringFromClass([layer class]);
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    if (makeDefault)
        [NBBasicScreenLayer setDefaultScreen:scene];
	
	// return the scene
	return scene;
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

-(void)gotoMapSelectionScreen
{
    self.nextScene = @"NBMapSelectionScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoBattleSetupScreen
{
    self.nextScene = @"NBBattleSetupScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoBattleScreen
{
    self.nextScene = @"NBBattleLayer";
    [self changeToScene:self.nextScene];
}

-(void)gotoTestScreen
{
    self.nextScene = @"NBTestScreen";
    [self changeToScene:self.nextScene];
}

-(void) onEnter
{
	[super onEnter];
    
    UI_USER_INTERFACE_IDIOM();
    
    //Prepare Sprite Batch Node
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
    self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
    [self addChild:self.characterSpritesBatchNode z:0 tag:0];
    
    //Display Title in the middle of the screen
    [self displayLayerTitle:@"HQ Scene"];
    
    [self addStandardMenuString:@"Battle" withSelector:@selector(gotoBattleScreen)];
    [self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
    [self addStandardMenuString:@"Map Selection" withSelector:@selector(gotoMapSelectionScreen)];
    [self addStandardMenuString:@"Story" withSelector:@selector(gotoStoryScreen)];
    [self addStandardMenuString:@"Main Menu" withSelector:@selector(gotoMainMenuScreen)];
    [self addStandardMenuString:@"Test Screen" withSelector:@selector(gotoTestScreen)];
    
    //Must be called everytime entering a layer
    [NBStaticObject initializeWithSpriteBatchNode:self.characterSpritesBatchNode andLayer:self andWindowsSize:self.layerSize];
    
    self.titleBanner = [[NBStaticObject alloc] initWithFrameName:@"HQ_Title.png" andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
    self.titleBanner.position = CGPointMake((self.layerSize.width / 2) - (self.titleBanner.contentSize.width / 2), self.layerSize.height - 20);
    //Sample for NBButton
    //self.testButton = [NBButton createWithSize:CGSizeMake(100, 40)];
    //self.testButton.position = CGPointMake(200, 200);
    //[self.testButton addHandler:self selector:@selector(onTestButtonPressed)];
}

//UI Control Events Handlers
-(void)onTestButtonPressed
{
    DLog(@"Test button clicked");
    
    //Do something here
}

@end
