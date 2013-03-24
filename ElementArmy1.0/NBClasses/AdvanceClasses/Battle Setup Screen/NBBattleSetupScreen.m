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
#import "NBUnitRespawnContainerLayer.h"

@interface NBBattleSetupScreen()
@property (nonatomic, strong) NBBattleSetupUnitSelectorsContainerLayer *unitSelectorsContainerLayer;
@property (nonatomic, strong) NBUnitRespawnContainerLayer *unitRespawnContainerLayer;
@end

int objectsLeftToTransit = 6;

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
    layer.layerName = NSStringFromClass([layer class]);
	
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
    self.battleSetupTitle = [NBStaticObject createStaticObject:@"setup_title.png" atPosition:CGPointMake(240, 350)];
    
    //Display Characters
    [self createUnitSelectors];
    [self createUnitRespawnContainerLayer];

    //Display buttons Navigation
    //OK
    self.battleSetupOk = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    [self.battleSetupOk setPosition:CGPointMake(550, -50)];
    [self.battleSetupOk show];
    
    //Cancel
    self.battleSetupCancel = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    [self.battleSetupCancel setPosition:CGPointMake(-70, -50)];
    [self.battleSetupCancel show];
    
    
    //Item selection
    self.setupItemsFrame = [[NBBattleSetupItems alloc] initWithLayer:self];
    [self addChild:self.setupItemsFrame z:1];
    
    
    //Display buttons Items
    self.tempNumberOfUnlockedItemsSlots = 2; //Not used yet
    
    /*temporary to use Potion from data manager*/
#warning Items are hardcoded now
    NBItemData* potionData = [NBDataManager getItemDataByItemName:@"Potion"];
    self.selectedItem1 = [NBItem createItem:potionData onLayer:self onSelector:@selector(openItemSelection)];
    NBItemData* furyPillData = [NBDataManager getItemDataByItemName:@"Fury Pill"];
    self.selectedItem2 = [NBItem createItem:furyPillData onLayer:self onSelector:@selector(openItemSelection)];
    
    self.selectedItem3 = [NBItem createItem:@"WingedBoots" onLayer:self onSelector:@selector(gotoAppStore)];
    
    [self.selectedItem1 setItemIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self ];
    [self.selectedItem1.itemIcon setPosition:ccp(160, -50)];
    [self.selectedItem1 displayItemIcon];
    
    [self.selectedItem2 setItemIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    [self.selectedItem2.itemIcon setPosition:ccp(240, -50)];
    [self.selectedItem2 displayItemIcon];
    
    [self.selectedItem3 setItemIconWithNormalImage:@"frame_item.png" selectedImage:@"frame_item.png" disabledImage:@"frame_item.png" onLayer:self];
    [self.selectedItem3.itemIcon setPosition:ccp(320, -50)];
    [self.selectedItem3 displayItemIcon];
    
    
    //Equipment selection
    self.setupEquipmentsFrame = [[NBBattleSetupEquipments alloc] initWithLayer:self];
    [self addChild:self.setupEquipmentsFrame z:1];
    
    //Display buttons Equipments
    self.selectedEquipment1 = [NBEquipment createEquipment:@"Potion" onLayer:self onSelector:@selector(openEquipmentSelection)];
    self.selectedEquipment2 = [NBEquipment createEquipment:@"FuryPill" onLayer:self onSelector:@selector(openEquipmentSelection)];
    self.selectedEquipment3 = [NBEquipment createEquipment:@"WingedBoots" onLayer:self onSelector:@selector(openEquipmentSelection)];
    
    [self.selectedEquipment1 setEquipmentIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self ];
    [self.selectedEquipment1.equipmentIcon setPosition:ccp(160, -150)];
    [self.selectedEquipment1 displayEquipmentIcon];
    
    [self.selectedEquipment2 setEquipmentIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    [self.selectedEquipment2.equipmentIcon setPosition:ccp(240, -150)];
    [self.selectedEquipment2 displayEquipmentIcon];
    
    [self.selectedEquipment3 setEquipmentIconWithNormalImage:@"Winged_boots.png" selectedImage:@"Winged_boots.png" disabledImage:@"Winged_boots.png" onLayer:self];
    [self.selectedEquipment3.equipmentIcon setPosition:ccp(320, -150)];
    [self.selectedEquipment3 displayEquipmentIcon];
    
    
    [self initialiseTransition];
}

- (void)createUnitSelectors {
  ccColor4B startColor;
  startColor.r = 255;
  startColor.g = 255;
  startColor.b = 255;
  startColor.a = 255;

  self.unitSelectorsContainerLayer = [[NBBattleSetupUnitSelectorsContainerLayer alloc] initWithColor:startColor width:270 height:140];
  self.unitSelectorsContainerLayer.position = CGPointMake(-300, 100);
  [self addChild:self.unitSelectorsContainerLayer];
}

- (void)createUnitRespawnContainerLayer {
  ccColor4B startColor;
  startColor.r = 255;
  startColor.g = 255;
  startColor.b = 255;
  startColor.a = 255;

  self.unitRespawnContainerLayer = [[NBUnitRespawnContainerLayer alloc] initWithColor:startColor width:200 height:140];
  self.unitRespawnContainerLayer.position = CGPointMake(500, 100);
  [self addChild:self.unitRespawnContainerLayer];
}

-(void)initialiseTransition{
    [self.unitRespawnContainerLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(285, 100)], nil]];
    [self.unitSelectorsContainerLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(10, 100)], nil]];
    [self.battleSetupTitle runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(240, 280)], nil]];
    [self.battleSetupCancel.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(30, 50)], nil]];
    [self.battleSetupOk.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(450, 50)], nil]];
    [self.selectedItem1.itemIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(160, 50)], nil]];
    [self.selectedItem2.itemIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(240, 50)], nil]];
    [self.selectedItem3.itemIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(320, 50)], nil]];
    [self.selectedEquipment1.equipmentIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(160, 100)], nil]];
    [self.selectedEquipment2.equipmentIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(240, 100)], nil]];
    [self.selectedEquipment3.equipmentIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(320, 100)], nil]];
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
    
    [[[NBDataManager dataManager] selectedEquipments] addObject:self.selectedEquipment1];
    [[[NBDataManager dataManager] selectedEquipments] addObject:self.selectedEquipment2];
    [[[NBDataManager dataManager] selectedEquipments] addObject:self.selectedEquipment3];
    
    [[[NBDataManager dataManager] arrayOfAllySquad] addObject:[self.unitSelectorsContainerLayer basicClassDataInUnitSelector:0]];
    [[[NBDataManager dataManager] arrayOfAllySquad] addObject:[self.unitSelectorsContainerLayer basicClassDataInUnitSelector:1]];
    [[[NBDataManager dataManager] arrayOfAllySquad] addObject:[self.unitSelectorsContainerLayer basicClassDataInUnitSelector:2]];
    
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

-(void)openEquipmentSelection{
    NBEquipment *equipment = [NBEquipment getCurrentlySelectedEquipment];
    [self.setupEquipmentsFrame toggleEquipmentSelection:equipment];
}

@end
