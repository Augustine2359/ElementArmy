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
    [self createUnitSelectors];
    
    //Display buttons Navigation
    //OK
    self.battleSetupOk = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    [self.battleSetupOk setIntStorage:0];
    [self.battleSetupOk setPosition:CGPointMake(450, 50)];
    [self.battleSetupOk show];
    
    //Cancel
    self.battleSetupCancel = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    [self.battleSetupCancel setIntStorage:0];
    [self.battleSetupCancel setPosition:CGPointMake(30, 50)];
    [self.battleSetupCancel show];
    
    
    //Item selection
    self.setupItemsFrame = [[NBBattleSetupItems alloc] initWithLayer:self];
    [self addChild:self.setupItemsFrame z:1];
    
    //Display buttons Items
    self.tempNumberOfUnlockedItemsSlots = 2;
    self.selectedItem1 = [NBItem createItem:@"Potion" onLayer:self onSelector:@selector(openItemSelection)];
    self.selectedItem2 = [NBItem createItem:@"FuryPill" onLayer:self onSelector:@selector(openItemSelection)];
    self.selectedItem3 = [NBItem createItem:@"WingedBoots" onLayer:self onSelector:@selector(openItemSelection)];
    
    [self.selectedItem1 setItemIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self ];
    [self.selectedItem1.itemIcon setPosition:ccp(160, 50)];
    [self.selectedItem1 displayItemIcon];
    
    [self.selectedItem2 setItemIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    [self.selectedItem2.itemIcon setPosition:ccp(240, 50)];
    [self.selectedItem2 displayItemIcon];
    
    NBButton* lockedButton = [NBButton createWithStringHavingNormal:@"frame_item.png" havingSelected:@"frame_item.png" havingDisabled:@"frame_item.png" onLayer:self respondTo:nil selector:@selector(gotoAppStore) withSize:CGSizeZero];
    [lockedButton setIntStorage:0];
    [lockedButton setPosition:ccp(320, 50)];
    [lockedButton show];
}

- (void)createUnitSelectors {
  ccColor4B startColor;
  startColor.r = 255;
  startColor.g = 255;
  startColor.b = 255;
  startColor.a = 255;

  self.unitSelectorsContainerLayer = [[NBBattleSetupUnitSelectorsContainerLayer alloc] initWithColor:startColor width:270 height:140];
  self.unitSelectorsContainerLayer.position = CGPointMake(10, 100);
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
    //Save units and items data to DataManager first
    [[[NBDataManager dataManager] selectedItems] addObject:self.selectedItem1];
    [[[NBDataManager dataManager] selectedItems] addObject:self.selectedItem2];
    [[[NBDataManager dataManager] selectedItems] addObject:self.selectedItem3];
    
//    [[[NBDataManager dataManager] arrayOfAllySquad] addObject:self.unitSelectorsContainerLayer];
    
    self.nextScene = @"NBBattleLayer";
    [self changeToScene:self.nextScene];
}

-(void)gotoAppStore{
    DLog(@"Buy new slot with $$!");
}

-(void)openItemSelection{
    NBItem *item = [NBItem getCurrentlySelectedItem];
    [self.setupItemsFrame toggleItemSelection:item];
}

@end
