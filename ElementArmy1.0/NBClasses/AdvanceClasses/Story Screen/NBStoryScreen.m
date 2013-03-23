//
//  NBStoryScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import "NBStoryScreen.h"
#import "NBStoryScreenScrollingPicturesLayer.h"
#import "NBStoryScreenScrollingTextLayer.h"

@interface NBStoryScreen()

@property (nonatomic, strong) NBStoryScreenScrollingPicturesLayer *scrollingPicturesLayer;
@property (nonatomic, strong) NBStoryScreenScrollingTextLayer *scrollingTextLayer;

@end

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

  self.scrollingPicturesLayer = [[NBStoryScreenScrollingPicturesLayer alloc] init];
  self.scrollingPicturesLayer.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  [self addChild:self.scrollingPicturesLayer];

  self.scrollingTextLayer = [[NBStoryScreenScrollingTextLayer alloc] init];
  self.scrollingTextLayer.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  [self addChild:self.scrollingTextLayer];

    [self addStandardMenuString:@"Battle" withSelector:@selector(gotoBattleScreen)];
    [self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
    [self addStandardMenuString:@"Map Selection" withSelector:@selector(gotoMapSelectionScreen)];
    [self addStandardMenuString:@"Main Menu" withSelector:@selector(gotoMainMenuScreen)];
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
