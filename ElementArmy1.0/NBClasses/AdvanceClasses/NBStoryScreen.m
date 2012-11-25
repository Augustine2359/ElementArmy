//
//  NBStoryScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import "NBStoryScreen.h"

@implementation NBStoryScreen

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBStoryScreen sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBStoryScreen *layer = [NBStoryScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    if (makeDefault)
        [NBBasicScreenLayer setDefaultScreen:scene];
	
    [NBBasicScreenLayer resetMenuIndex];
    
	// return the scene
	return scene;
}

-(id)init
{
    if ((self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //Prepare Sprite Batch Node
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
        self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
        [self addChild:self.characterSpritesBatchNode z:0 tag:0];
        
        //Display Title in the middle of the screen
        self.layerTitle = [CCLabelTTF labelWithString:@"Story Scene" fontName:@"Zapfino" fontSize:32];
        self.layerTitle.position = CGPointMake(size.width / 2, size.height / 2);
        [self addChild:self.layerTitle];
        
        [self addStandardMenuString:@"Battle" withSelector:@selector(gotoBattleScreen)];
        [self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
        [self addStandardMenuString:@"Map Selection" withSelector:@selector(gotoMapSelectionScreen)];
        [self addStandardMenuString:@"Main Menu" withSelector:@selector(gotoMainMenuScreen)];
        [self addStandardMenuString:@"Intro" withSelector:@selector(gotoIntroScreen)];
    }
    
    return self;
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

@end
