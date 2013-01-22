//
//  NBBattleSetupScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import "NBBattleSetupScreen.h"
#import "NBBattleSetupUnitSelectorLayer.h"
#import "NBBattleSetupUnitSelectorsContainerLayer.h"

@interface NBBattleSetupScreen()

@property (nonatomic, strong) NBBattleSetupUnitSelectorsContainerLayer *unitSelectorsContainerLayer;

@end

//float slideDuration = 0.5f;
//bool itemSelectionOpen = NO;


@implementation NBBattleSetupScreen
// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBBattleSetupScreen sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBBattleSetupScreen *layer = [NBBattleSetupScreen node];
	
	// add layer as a child to scene
	[scene addChild:layer z:0];
    
    if (makeDefault)
        [NBBasicScreenLayer setDefaultScreen:scene];
    
    [NBBasicScreenLayer resetMenuIndex];
	
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
    
    
    //Must be called everytime entering a layer
    [NBStaticObject initializeWithSpriteBatchNode:self.characterSpritesBatchNode andLayer:self andWindowsSize:self.layerSize];
    
    
    //Display Title
    self.battleSetupTitle = [NBStaticObject createStaticObject:@"setup_title.png" atPosition:CGPointMake(240, 280)];
    
    
    //Display Characters
    self.battleSetupCharacter1 = [NBStaticObject createStaticObject:@"button_confirm.png" atPosition:CGPointMake(100, 180)];
    self.battleSetupCharacter2 = [NBStaticObject createStaticObject:@"button_confirm.png" atPosition:CGPointMake(240, 180)];
    self.battleSetupCharacter3 = [NBStaticObject createStaticObject:@"button_confirm.png" atPosition:CGPointMake(380, 180)];
    
    //Display buttons Navigation
    //OK
    self.battleSetupOk = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    [self.battleSetupOk setPosition:CGPointMake(450, 50)];
    [self.battleSetupOk show];
    
    //Cancel
    self.battleSetupCancel = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    [self.battleSetupCancel setPosition:CGPointMake(30, 50)];
    [self.battleSetupCancel show];
    
    
    //Display buttons Items
    //Item 1
    self.battleSetupItem1 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self respondTo:nil selector:@selector(openItemSelection) withSize:CGSizeZero];
    [self.battleSetupItem1 setPosition:CGPointMake(160, 50)];
    [self.battleSetupItem1 show];
    
    //Item 2
    self.battleSetupItem2 = [NBButton createWithStringHavingNormal:@"Fury_pill.png" havingSelected:@"Fury_pill.png" havingDisabled:@"Fury_pill.png" onLayer:self respondTo:nil selector:@selector(openItemSelection) withSize:CGSizeZero];
    [self.battleSetupItem2 setPosition:CGPointMake(240, 50)];
    [self.battleSetupItem2 show];
    
    //Item 3
    self.battleSetupItem3 = [NBButton createWithStringHavingNormal:@"Winged_boots.png" havingSelected:@"Winged_boots.png" havingDisabled:@"Winged_boots.png" onLayer:self respondTo:nil selector:@selector(openItemSelection) withSize:CGSizeZero];
    [self.battleSetupItem3 setPosition:CGPointMake(320, 50)];
    [self.battleSetupItem3 show];
    
    //[self initialiseItemSelection];
    self.setupItemsFrame = [BattleSetupItems new];
    [self addChild:self.setupItemsFrame z:1];
}

//-(void)initialiseItemSelection{
////    self.itemLayer = [NBBattleSetupScreen node];
////    [self addChild:self.itemLayer];
//    
//    self.itemSelectionFrame = [NBStaticObject createWithSize:CGSizeMake(400, 300) usingFrame:@"frame_item.png" atPosition:CGPointMake(240, -300)];
//    
//    self.item01 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self respondTo:self.itemSelectionFrame selector:@selector(toggleItemSelection) withSize:CGSizeZero];
//    [self.item01 setPosition:CGPointMake(100, 00)];
//    [self.item01 show];
//    self.item02 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
//    [self.item02 setPosition:CGPointMake(150, -300)];
//    [self.item02 show];
//    self.item03 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
//    [self.item03 setPosition:CGPointMake(200, -300)];
//    [self.item03 show];
//    self.item04 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
//    [self.item04 setPosition:CGPointMake(250, -300)];
//    [self.item04 show];
//    self.item05 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
//    [self.item05 setPosition:CGPointMake(300, -300)];
//    [self.item05 show];
//    
//    [self.itemSelectionFrame addChild:self.item01.menu z:1];
//    [self.itemSelectionFrame addChild:self.item02 z:1];
//    [self.itemSelectionFrame addChild:self.item03 z:1];
//    [self.itemSelectionFrame addChild:self.item04 z:1];
//    [self.itemSelectionFrame addChild:self.item05 z:1];
//}
//
//-(void)toggleItemSelection{
//    //Closed
//    if (!itemSelectionOpen) {
//        id open = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(240, 150)];
//        [self.itemSelectionFrame runAction:open];
//        itemSelectionOpen = YES;
//    }
//    //Opened
//    else{
//        id close = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(240, -300)];
//        [self.itemSelectionFrame runAction:close];
//        itemSelectionOpen = NO;
//    }

//    [self createUnitSelectors];
//    
//    //Item Sample
//    self.battleSetupItemSample = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self selector:@selector(gotoMainMenuScreen) withSize:CGSizeZero];
//    [self.battleSetupItemSample setPosition:CGPointMake(self.battleSetupItemSample.buttonObject.contentSize.width / 2, (self.layerSize.height - self.battleSetupItemSample.buttonObject.contentSize.height / 2))];
//    [self.battleSetupItemSample show];
//}

-(void)openItemSelection{
    [self.setupItemsFrame toggleItemSelection];
}

- (void)createUnitSelectors {
  ccColor4B startColor;
  startColor.r = 255;
  startColor.g = 255;
  startColor.b = 255;
  startColor.a = 255;

  self.unitSelectorsContainerLayer = [[NBBattleSetupUnitSelectorsContainerLayer alloc] initWithColor:startColor width:330 height:200];
  self.unitSelectorsContainerLayer.position = CGPointMake(100, 100);
  [self addChild:self.unitSelectorsContainerLayer];
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

-(void)gotoMapSelectionScreen
{
    self.nextScene = @"NBMapSelectionScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoBattleScreen
{
    self.nextScene = @"NBBattleLayer";
    [self changeToScene:self.nextScene];
}

@end
