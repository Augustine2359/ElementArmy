//
//  NBBasicScreenLayer.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 21/11/12.
//
//

#import "NBBasicScreenLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - NBBattleLayer

static Boolean isAutoStart = NO;
static int menuIndex = 0;
static CCScene* currentScreen = nil;
static CCScene* defaultScreen = nil;

// NBBattleLayer implementation
@implementation NBBasicScreenLayer

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBBasicScreenLayer sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBBasicScreenLayer *layer = [NBBasicScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    if (makeDefault)
        defaultScreen = scene;
	
	// return the scene
	return scene;
}

+(CCScene*)loadCurrentScene
{
    if (!currentScreen)
    {
        NSLog(@"No default screen has been initialized!");
    }
    
    return currentScreen;
}

+(void)setDefaultScreen:(CCScene*)scene
{
    defaultScreen = scene;
}

+(void)setCurrentScreen:(CCScene*)scene
{
    currentScreen = scene;
}

+(void)resetMenuIndex
{
    // Reset Menu Index
    menuIndex = 0;
}

// on "init" you need to initialize your instance
-(id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if ((self = [super init]))
    {
        //CGSize size = [[CCDirector sharedDirector] winSize];
        
		// ask director for the window size
        /*ccColor4B startColor;
        startColor.r = 200;
        startColor.g = 200;
        startColor.b = 200;
        startColor.a = 250;
        CCLayerColor *backgroundColor = [CCLayerColor layerWithColor:startColor];
        backgroundColor.rotation = 90;
        [self addChild:backgroundColor];*/
        self.isTouchEnabled = YES;
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

-(void) onEnter
{
	[super onEnter];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void)addStandardMenuString:(NSString*)menuTitle withSelector:(SEL)selectedMethod
{
    // Default font size will be 28 points.
    [CCMenuItemFont setFontSize:9];
    [CCMenuItemFont setFontName:@"Zapfino"];
    
    // create and initialize a Label
    CCLabelTTF* label = [CCLabelTTF labelWithString:menuTitle dimensions:CGSizeMake(120, 22) hAlignment:UITextAlignmentLeft fontName:@"Zapfino" fontSize:10];
    CCMenuItem *startGameButtonMenu = [CCMenuItemFont itemWithLabel:label target:self selector:selectedMethod];
    self.menu = [CCMenu menuWithItems:startGameButtonMenu, nil];
    [self.menu setColor:ccWHITE];
    
    //[self.menu alignItemsHorizontally];
    [self.menu setPosition:ccp(60, (20 + ((label.contentSize.height - 4) * menuIndex)))];
    
    // Add the menu to the layer
    [self addChild:self.menu];
    
    menuIndex++;
}

-(void)setLayerColor:(ccColor4B)color
{
    CCLayerColor *backgroundColor = [CCLayerColor layerWithColor:color];
    [self addChild:backgroundColor];
}

-(void)displayLayerTitle:(NSString*)title
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    self.layerTitle = [CCLabelTTF labelWithString:title fontName:@"Zapfino" fontSize:32];
    self.layerTitle.position = CGPointMake(size.width / 2, size.height / 2);
    [self addChild:self.layerTitle];
}

-(void)changeToScene:(NSString*)layerClassName
{
    [self changeToScene:layerClassName transitionWithDuration:1.0];
}

-(void)changeToScene:(NSString*)layerClassName transitionWithDuration:(float)duration
{
    [NBBasicScreenLayer resetMenuIndex];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:duration scene:[NSClassFromString(layerClassName) scene] withColor:ccWHITE]];
}

-(void)setCurrentBackgroundWithFileName:(NSString*)fileName stretchToScreen:(BOOL)stretch
{
    CGSize size = [[CCDirector sharedDirector] winSize];

    self.background = [CCSprite spriteWithSpriteFrameName:fileName];
    
    if (stretch)
    {
        self.background.scaleX = size.width / self.background.contentSize.width;
        self.background.scaleY = size.height / self.background.contentSize.height;
    }

    self.background.position = ccp(size.width / 2, size.height / 2);

    // add the label as a child to this Layer
    [self addChild:self.background];
}


@end