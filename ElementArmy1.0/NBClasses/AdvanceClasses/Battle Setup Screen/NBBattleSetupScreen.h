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
#import "NBGameResourcePanel.h"

@interface NBBattleSetupScreen : NBBasicScreenLayer

-(void)openItemSelection;
-(void)openEquipmentSelection;
-(void)gotoAppStore;
-(void)initialiseTransition;
-(void)updateBonusStats;

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleScreen;

@property (nonatomic, retain) NBGameResourcePanel* gameResourcePanel;

@property (nonatomic, retain) NBStaticObject* background;
@property (nonatomic, retain) CCSprite *battleSetupTitle;
@property (nonatomic, retain) NBButton *battleSetupOk;
@property (nonatomic, retain) NBButton *battleSetupCancel;

//Item selection
@property (nonatomic, retain) NBBattleSetupItems* setupItemsFrame;
@property (nonatomic, retain) NBItem* selectedItem;

//Equipment selection
@property (nonatomic, retain) NBBattleSetupEquipments* setupEquipmentsFrame;
@property (nonatomic, retain) NBEquipment* selectedEquipment1;
@property (nonatomic, retain) NBEquipment* selectedEquipment2;
@property (nonatomic, retain) NBEquipment* selectedEquipment3;

@end
