//
//  NBHQSetupScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/2/13.
//
//

#import "NBHQSetupScreen.h"

NBBasicScreenLayer* currentOpenedMenu = nil;


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

-(void) onEnter
{
	[super onEnter];
    
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    UI_USER_INTERFACE_IDIOM();
    
    //Prepare Sprite Batch Node
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
    self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
    [self addChild:self.characterSpritesBatchNode z:0 tag:0];
    
    //Must be called everytime entering a layer
    [NBStaticObject initializeWithSpriteBatchNode:self.characterSpritesBatchNode andLayer:self andWindowsSize:self.layerSize];
    
    
    //Background
    self.backgroundImage = [NBStaticObject createStaticObject:@"troopSelectionScreen_background.png" atPosition:CGPointMake(240, 160)];
    
    //Display Title
    self.headerImage = [CCSprite spriteWithSpriteFrameName:@"HQ_Title.png"];
    self.headerImage.anchorPoint = ccp(0, 0);
    self.headerImage.position = ccp(5, winsize.height - self.headerImage.boundingBox.size.height - 5);
    [self addChild:self.headerImage];
    
    //Display Title in the middle of the screen
    //[self displayLayerTitle:@"HQ Scene"];
    
    [self addStandardMenuString:@"Battle" withSelector:@selector(gotoBattleScreen)];
    [self addStandardMenuString:@"Battle Setup" withSelector:@selector(gotoBattleSetupScreen)];
    [self addStandardMenuString:@"Map Selection" withSelector:@selector(gotoMapSelectionScreen)];
    [self addStandardMenuString:@"Story" withSelector:@selector(gotoStoryScreen)];
    [self addStandardMenuString:@"Main Menu" withSelector:@selector(gotoMainMenuScreen)];
    [self addStandardMenuString:@"Test Screen" withSelector:@selector(gotoTestScreen)];
    
//    self.titleBanner = [[NBStaticObject alloc] initWithFrameName:@"HQ_Title.png" andSpriteBatchNode:self.characterSpritesBatchNode onLayer:self];
//    self.titleBanner.position = CGPointMake((self.layerSize.width / 2) - (self.titleBanner.contentSize.width / 2), self.layerSize.height - 20);
    //Sample for NBButton
    //self.testButton = [NBButton createWithSize:CGSizeMake(100, 40)];
    //self.testButton.position = CGPointMake(200, 200);
    //[self.testButton addHandler:self selector:@selector(onTestButtonPressed)];
    
    self.gameResourcePanel = [NBGameResourcePanel getGamePanel];
    [self.gameResourcePanel removeFromParentAndCleanup:NO];
    [self addChild:self.gameResourcePanel];
    
    //Init all other layers in same scene
    self.equipmentsLayer = [[NBHQEquipments alloc] initWithLayer:self];
    self.itemsLayer = [[NBHQItems alloc] initWithLayer:self];
    self.unitsLayer = [[NBHQUnits alloc] initWithLayer:self];
    self.appStoreLayer = [[NBHQAppStore alloc] initWithLayer:self];
    self.settingsLayer = [[NBHQSettings alloc] initWithLayer:self];
    [self addChild:self.equipmentsLayer z:1];
    [self addChild:self.itemsLayer z:1];
    [self addChild:self.unitsLayer z:1];
    [self addChild:self.appStoreLayer z:1];
    [self addChild:self.settingsLayer z:1];
    
    self.equipmentsTab = [NBButton createWithStringHavingNormal:@"setup_title.png" havingSelected:@"setup_title.png" havingDisabled:@"setup_title.png" onLayer:self respondTo:nil selector:@selector(openEquipmentsMenu) withSize:CGSizeZero];
    [self.equipmentsTab setPosition:CGPointMake(60, 250)];
    [self.equipmentsTab.buttonObject setScale:0.75];
    [self.equipmentsTab show];
    
    self.itemsTab = [NBButton createWithStringHavingNormal:@"setup_title.png" havingSelected:@"setup_title.png" havingDisabled:@"setup_title.png" onLayer:self respondTo:nil selector:@selector(openItemsMenu) withSize:CGSizeZero];
    [self.itemsTab setPosition:CGPointMake(150, 250)];
    [self.itemsTab.buttonObject setScale:0.75];
    [self.itemsTab show];
    
    self.unitsTab = [NBButton createWithStringHavingNormal:@"setup_title.png" havingSelected:@"setup_title.png" havingDisabled:@"setup_title.png" onLayer:self respondTo:nil selector:@selector(openUnitsMenu) withSize:CGSizeZero];
    [self.unitsTab setPosition:CGPointMake(240, 250)];
    [self.unitsTab.buttonObject setScale:0.75];
    [self.unitsTab show];
    
    NBButton* appStoreTab = [NBButton createWithStringHavingNormal:@"setup_title.png" havingSelected:@"setup_title.png" havingDisabled:@"setup_title.png" onLayer:self respondTo:nil selector:@selector(openAppStoreMenu) withSize:CGSizeZero];
    [appStoreTab setPosition:CGPointMake(330, 250)];
    [appStoreTab.buttonObject setScale:0.75];
    [appStoreTab show];
    
    NBButton* settingsTab = [NBButton createWithStringHavingNormal:@"setup_title.png" havingSelected:@"setup_title.png" havingDisabled:@"setup_title.png" onLayer:self respondTo:nil selector:@selector(openSettingsMenu) withSize:CGSizeZero];
    [settingsTab setPosition:CGPointMake(420, 250)];
    [settingsTab.buttonObject setScale:0.75];
    [settingsTab show];
    
    self.confirmButton = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    [self.confirmButton setPosition:CGPointMake(450, 25)];
    [self.confirmButton.menu setZOrder:2];
    [self.confirmButton show];
    
    self.cancelButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(gotoMainMenuScreen) withSize:CGSizeZero];
    [self.cancelButton setPosition:CGPointMake(30, 25)];
    [self.cancelButton.menu setZOrder:2];
    [self.cancelButton show];
    
    self.canInput = YES;
    [self openEquipmentsMenu];
}

-(void)update:(ccTime)delta
{
    [self.gameResourcePanel updateResourceInfo];
}

-(void)openEquipmentsMenu{
    DLog(@"EQ");
    if (!self.canInput) {
        return;
    }
    
    if (currentOpenedMenu == self.equipmentsLayer) {
        return;
    }
    
    self.canInput = NO;
    [self confirmAndCloseMenu];
    currentOpenedMenu = self.equipmentsLayer;
    CCCallFunc* onAnimCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onMenuReady)];
    [self.equipmentsLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.5 position:ccp(0, -100)], onAnimCompleted, nil]];
}

-(void)openItemsMenu{
    DLog(@"IT");
    if (!self.canInput) {
        return;
    }
    
    if (currentOpenedMenu == self.itemsLayer) {
        return;
    }
    
    self.canInput = NO;
    [self confirmAndCloseMenu];
    currentOpenedMenu = self.itemsLayer;
    CCCallFunc* onAnimCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onMenuReady)];
    [self.itemsLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.5 position:ccp(0, -100)], onAnimCompleted, nil]];
}

-(void)openUnitsMenu{
    DLog(@"UN");
    if (!self.canInput) {
        return;
    }
    
    if (currentOpenedMenu == self.unitsLayer) {
        return;
    }
    
    self.canInput = NO;
    [self confirmAndCloseMenu];
    currentOpenedMenu = self.unitsLayer;
    CCCallFunc* onAnimCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onMenuReady)];
    [self.unitsLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.5 position:ccp(0, -100)], onAnimCompleted, nil]];
}

-(void)openAppStoreMenu{
    DLog(@"AP");
    if (!self.canInput) {
        return;
    }
    
    if (currentOpenedMenu == self.appStoreLayer) {
        return;
    }
    
    self.canInput = NO;
    [self confirmAndCloseMenu];
    currentOpenedMenu = self.appStoreLayer;
    CCCallFunc* onAnimCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onMenuReady)];
    [self.appStoreLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.5 position:ccp(0, -100)], onAnimCompleted, nil]];
}


-(void)openSettingsMenu{
    DLog(@"SE");
    if (!self.canInput) {
        return;
    }
    
    if (currentOpenedMenu == self.settingsLayer) {
        return;
    }
    
    self.canInput = NO;
    [self confirmAndCloseMenu];
    currentOpenedMenu = self.settingsLayer;
    CCCallFunc* onAnimCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onMenuReady)];
    [self.settingsLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.5 position:ccp(0, -100)], onAnimCompleted, nil]];
}

-(void)confirmAndCloseMenu{
    id close = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, -320)];
    [currentOpenedMenu runAction:close];
}

-(void)onMenuReady{
    self.canInput = YES;
}


//UI Control Events Handlers
-(void)onTestButtonPressed
{
    DLog(@"Test button clicked");
    
    //Do something here
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

@end
