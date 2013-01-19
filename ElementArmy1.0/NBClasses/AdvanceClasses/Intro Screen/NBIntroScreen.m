//
//  NBIntroScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import "NBIntroScreen.h"

@implementation NBIntroScreen

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBIntroScreen sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBIntroScreen *layer = [NBIntroScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    if (makeDefault)
        [NBBasicScreenLayer setDefaultScreen:scene];
	
	// return the scene
	return scene;
}

/*-(id)init
{
    if ((self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.background.rotation = 90;
        
        //Prepare Sprite Batch Node
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
        self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
        [self addChild:self.characterSpritesBatchNode z:0 tag:0];
        
        //Display Title in the middle of the screen
        [self displayLayerTitle:@"Intro Scene"];
        
        [self addStandardMenuString:@"Battle" withSelector:@selector(gotoBattleScreen)];
        [self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
        [self addStandardMenuString:@"Map Selection" withSelector:@selector(gotoMapSelectionScreen)];
        [self addStandardMenuString:@"Story" withSelector:@selector(gotoStoryScreen)];
        [self addStandardMenuString:@"Main Menu" withSelector:@selector(gotoMainMenuScreen)];
    }
    
    return self;
}*/

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
    [self displayLayerTitle:@"Intro Scene"];
    
    [self addStandardMenuString:@"Battle" withSelector:@selector(gotoBattleScreen)];
    [self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
    [self addStandardMenuString:@"Map Selection" withSelector:@selector(gotoMapSelectionScreen)];
    [self addStandardMenuString:@"Story" withSelector:@selector(gotoStoryScreen)];
    [self addStandardMenuString:@"Main Menu" withSelector:@selector(gotoMainMenuScreen)];
    [self addStandardMenuString:@"Test Screen" withSelector:@selector(gotoTestScreen)];
    
    //Must be called everytime entering a layer
    [NBStaticObject initializeWithSpriteBatchNode:self.characterSpritesBatchNode andLayer:self andWindowsSize:self.layerSize];
    
    //Sample for NBButton
    //self.testButton = [NBButton createWithSize:CGSizeMake(100, 40)];
    //self.testButton.position = CGPointMake(200, 200);
    //[self.testButton addHandler:self selector:@selector(onTestButtonPressed)];
    
    //Sample for wastedMyTimeButton
    //self.wastedMyTimeButton = [NBButton createOnLayer:self selector:@selector(onTestButtonPressed)];
    self.wastedMyTimeButton = [NBButton createWithSize:CGSizeMake(100, 40) onLayer:self selector:@selector(onTestButtonPressed)];
    self.wastedMyTimeButton.menu.position = CGPointMake(200, 200);
    //[self.wastedMyTimeButton show];
    
    //Sample for NBStaticObject using frame named frame_item.png
    //self.sampleStaticObject = [NBStaticObject createStaticObject:@"frame_item.png" atPosition:CGPointMake(160, 300)];
}

//UI Control Events Handlers
-(void)onTestButtonPressed
{
    DLog(@"Test button clicked");
    
    //Do something here
}

@end
