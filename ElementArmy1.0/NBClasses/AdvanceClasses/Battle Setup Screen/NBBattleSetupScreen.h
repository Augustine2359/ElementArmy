//
//  NBBattleSetupScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"
#import "NBBattleSetupItems.h"
#import "NBItem.h"
#import "NBBattleSetupEquipments.h"
#import "NBEquipment.h"

@interface NBBattleSetupScreen : NBBasicScreenLayer

-(void)openItemSelection;
-(void)openEquipmentSelection;
-(void)gotoAppStore;
-(void)initialiseTransition;

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleScreen;

@property (nonatomic, retain) NBStaticObject *battleSetupTitle;

@property (nonatomic, retain) NBButton *battleSetupOk;
@property (nonatomic, retain) NBButton *battleSetupCancel;

//Item selection
@property (nonatomic, retain) NBBattleSetupItems* setupItemsFrame;
@property (nonatomic) int tempNumberOfUnlockedItemsSlots;
@property(nonatomic, retain) NBItem* selectedItem1;
@property(nonatomic, retain) NBItem* selectedItem2;
@property(nonatomic, retain) NBItem* selectedItem3;

//Equipment selection
@property (nonatomic, retain) NBBattleSetupEquipments* setupEquipmentsFrame;
@property(nonatomic, retain) NBEquipment* selectedEquipment1;
@property(nonatomic, retain) NBEquipment* selectedEquipment2;
@property(nonatomic, retain) NBEquipment* selectedEquipment3;

@end
