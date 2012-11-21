//
//  NBBattleLayer.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 21/10/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "NBBattleLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - NBBattleLayer

static Boolean isAutoStart = NO;

// NBBattleLayer implementation
@implementation NBBattleLayer

@synthesize menu;
@synthesize characterSpritesBatchNode;
@synthesize allySquads, enemySquads;

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBBattleLayer *layer = [NBBattleLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];

		// ask director for the window size
        battleStarted = false;
        ccColor4B startColor;
        startColor.r = 200;
        startColor.g = 200;
        startColor.b = 200;
        startColor.a = 250;
        CCLayerColor *backgroundColor = [CCLayerColor layerWithColor:startColor];
        [self addChild:backgroundColor];
        self.isTouchEnabled = YES;
        [self scheduleUpdate];
		
        //Prepare Sprite Batch Node
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
        self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
        [self addChild:self.characterSpritesBatchNode z:0 tag:0];
		
        //Prepare unit slots/arrays
        [NBSquad setupBatteFieldDimension:CGSizeMake(size.width, size.height)];
        if (!allySquads) allySquads = [[CCArray alloc] initWithCapacity:MAXIMUM_SQUAD_PER_SIDE];
        if (!enemySquads) enemySquads = [[CCArray alloc] initWithCapacity:MAXIMUM_SQUAD_PER_SIDE];
        [self prepareUnits];
        
        if (!isAutoStart)
        {
            // Default font size will be 28 points.
            [CCMenuItemFont setFontSize:28];
            
            // create and initialize a Label
            CCMenuItem *startGameButtonMenu = [CCMenuItemFont itemWithString:@"Start Battle" target:self selector:@selector(prepareBattlefield)];
            self.menu = [CCMenu menuWithItems:startGameButtonMenu, nil];
            
            [self.menu alignItemsHorizontallyWithPadding:20];
            [self.menu setPosition:ccp(size.width / 2, size.height / 2 - 50)];
            
            // Add the menu to the layer
            [self addChild:self.menu];
        }
        else
        {
            [self prepareBattlefield];
        }
		
		/*//
		// Leaderboards and Achievements
		//
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];*/

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

//NB ElementArmy Specific
//************************************************************************************************
-(void)update:(ccTime)delta
{
    [NBBasicObject update:delta];
}

-(void)performanceTest
{
    //Note on this test:
    //I want to test how Fire Mage fights (respond) against NBSoldier and vica versa.
    
    NBSquad* tempSquad;
    
    //Testing single NBSoldier Squad on Enemy
    tempSquad = [[NBSquad alloc] createSquadOf:@"NBSoldier" withUnitCount:6 onSide:Ally andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
    [tempSquad retain];
    [tempSquad startUpdate];
    [allySquads addObject:tempSquad];
    
    //Testing single NBFireMage Squad on Ally
    tempSquad = [[NBSquad alloc] createSquadOf:@"NBSoldier" withUnitCount:6 onSide:Ally andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
    [tempSquad retain];
    [tempSquad startUpdate];
    [allySquads addObject:tempSquad];
    
    //Testing single NBFireMage Squad on Ally
    tempSquad = [[NBSquad alloc] createSquadOf:@"NBFireMage" withUnitCount:6 onSide:Ally andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
    [tempSquad retain];
    [tempSquad startUpdate];
    [allySquads addObject:tempSquad];
    
    //Testing single NBSoldier Squad on Enemy
    tempSquad = [[NBSquad alloc] createSquadOf:@"NBSoldier" withUnitCount:6 onSide:Enemy andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
    [tempSquad retain];
    [tempSquad startUpdate];
    [enemySquads addObject:tempSquad];
    
    //Testing single NBFireMage Squad on Ally
    tempSquad = [[NBSquad alloc] createSquadOf:@"NBFireMage" withUnitCount:6 onSide:Enemy andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
    [tempSquad retain];
    [tempSquad startUpdate];
    [enemySquads addObject:tempSquad];
    
    //Testing single NBFireMage Squad on Ally
    tempSquad = [[NBSquad alloc] createSquadOf:@"NBFireMage" withUnitCount:6 onSide:Enemy andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
    [tempSquad retain];
    [tempSquad startUpdate];
    [enemySquads addObject:tempSquad];
}

-(void)prepareUnits
{
    //Test below
    [self performanceTest];
}

-(void)prepareBattlefield
{
    //Test below
    [self startBattle];
}

-(void)startBattle
{
    if (self.menu) menu.visible = NO;
    
    battleStarted = true;
    
    NBCharacter* tempCharacter;
    
    CCARRAY_FOREACH([NBCharacter getAllUnitList], tempCharacter)
    {
        tempCharacter.currentState = Idle;
    }
}
//************************************************************************************************


@end
