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
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    //Prepare Sprite Batch Node
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
    self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
    [self addChild:self.characterSpritesBatchNode z:0 tag:0];
    
    //Must be called everytime entering a layer
    [NBStaticObject initializeWithSpriteBatchNode:self.characterSpritesBatchNode andLayer:self andWindowsSize:self.layerSize];
    
    //Background
    self.background = [NBStaticObject createStaticObject:@"troopSelectionScreen_background.png" atPosition:CGPointMake(240, 160)];
    
    //Display Title
    self.battleSetupTitle = [NBStaticObject createStaticObject:@"troopSelectionScreen_header.png" atPosition:CGPointMake(240, 350)];
    
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
    CGSize spriteSize;
    NBItemData* currentItemData = [NBDataManager getItemDataByItemName:@"Potion"];
    self.selectedItem = [NBItem createItem:currentItemData onLayer:self onSelector:@selector(openItemSelection)];
    spriteSize = [self.selectedItem.itemIcon currentSize];
    [self.selectedItem.itemIcon setPosition:ccp(screenSize.width*0.5 + spriteSize.width*2.5, -screenSize.height*0.2)];
    [self.selectedItem displayItemIcon];
    
    //Equipment selection
    self.setupEquipmentsFrame = [[NBBattleSetupEquipments alloc] initWithLayer:self];
    [self addChild:self.setupEquipmentsFrame z:1];
    
    //Display buttons Equipments
    NBEquipmentData* currentEquipment1 = [NBDataManager getEquipmentDataByEquipmentName:@"Golden Armor"];
    NBEquipmentData* currentEquipment2 = [NBDataManager getEquipmentDataByEquipmentName:@"Fury Pill"];
    NBEquipmentData* currentEquipment3 = [NBDataManager getEquipmentDataByEquipmentName:@"Winged Boots"];
    self.selectedEquipment1 = [NBEquipment createEquipment:currentEquipment1 onLayer:self onSelector:@selector(openEquipmentSelection)];
    self.selectedEquipment2 = [NBEquipment createEquipment:currentEquipment2 onLayer:self onSelector:@selector(openEquipmentSelection)];
    self.selectedEquipment3 = [NBEquipment createEquipment:currentEquipment3 onLayer:self onSelector:@selector(openEquipmentSelection)];
    
    spriteSize = [self.selectedEquipment1.equipmentIcon currentSize];
    [self.selectedEquipment1.equipmentIcon setPosition:ccp(screenSize.width*0.5 - spriteSize.width*2.5, -screenSize.height*0.2)];
    [self.selectedEquipment1 displayEquipmentIcon];
    
    spriteSize = [self.selectedEquipment2.equipmentIcon currentSize];
    [self.selectedEquipment2.equipmentIcon setPosition:ccp(screenSize.width*0.5 - spriteSize.width*1.0, -screenSize.height*0.2)];
    [self.selectedEquipment2 displayEquipmentIcon];
    
    spriteSize = [self.selectedEquipment3.equipmentIcon currentSize];
    [self.selectedEquipment3.equipmentIcon setPosition:ccp(screenSize.width*0.5 + spriteSize.width*0.5, -screenSize.height*0.2)];
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

//    self.unitRespawnContainerLayer = [[NBUnitRespawnContainerLayer alloc] initWithColor:startColor width:200 height:140];
//    self.unitRespawnContainerLayer.position = CGPointMake(500, 100);
    self.unitRespawnContainerLayer = [[NBUnitRespawnContainerLayer alloc] initWithRect:CGRectMake(500, 100, 200, 140)];
  [self addChild:self.unitRespawnContainerLayer];
    
    [self.unitRespawnContainerLayer updateBonusStats:self.selectedEquipment1 equipment2:self.selectedEquipment2 equipment3:self.selectedEquipment3];
}

-(void)initialiseTransition{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize spriteSize;
    
    [self.unitRespawnContainerLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(285, 100)], nil]];
    [self.unitSelectorsContainerLayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(10, 100)], nil]];
    [self.battleSetupTitle runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(240, 280)], nil]];
    [self.battleSetupCancel.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(30, 50)], nil]];
    [self.battleSetupOk.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(450, 50)], nil]];
    
    spriteSize = [self.selectedItem.itemIcon currentSize];
    [self.selectedItem.itemIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(screenSize.width*0.5 + spriteSize.width*2.5, screenSize.height*0.2)], nil]];
    
    spriteSize = [self.selectedEquipment1.equipmentIcon currentSize];
    [self.selectedEquipment1.equipmentIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(screenSize.width*0.5 - spriteSize.width*2.5, screenSize.height*0.2)], nil]];
    
    spriteSize = [self.selectedEquipment2.equipmentIcon currentSize];
    [self.selectedEquipment2.equipmentIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(screenSize.width*0.5 - spriteSize.width*1.0, screenSize.height*0.2)], nil]];
    
    spriteSize = [self.selectedEquipment3.equipmentIcon currentSize];
    [self.selectedEquipment3.equipmentIcon.menu runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.5 position:ccp(screenSize.width*0.5 + spriteSize.width*0.5, screenSize.height*0.2)], nil]];
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
    [[[NBDataManager dataManager] selectedItems] addObject:self.selectedItem];
    
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
    if (self.setupEquipmentsFrame.equipmentSelectionOpen || self.setupItemsFrame.itemSelectionOpen) {
        return;
    }
    
    NBItem *item = [NBItem getCurrentlySelectedItem];
    [self.setupItemsFrame toggleItemSelection:item];
}

-(void)openEquipmentSelection{
    if (self.setupEquipmentsFrame.equipmentSelectionOpen || self.setupItemsFrame.itemSelectionOpen) {
        return;
    }

    NBEquipment *equipment = [NBEquipment getCurrentlySelectedEquipment];
    [self.setupEquipmentsFrame toggleEquipmentSelection:equipment];
}

@end
