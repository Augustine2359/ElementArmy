//
//  NBBattleSetupEquipments.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 10/3/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBEquipment.h"
#import "NBMessageBox.h"


@interface NBBattleSetupEquipments : NBBasicScreenLayer

@property (nonatomic) bool equipmentSelectionOpen;
@property (nonatomic) int currentSelectedEquipmentIndex;

@property (nonatomic, retain) NBEquipment* changingTargetEquipment;

@property(nonatomic, retain) NSMutableArray* allEquipments;
@property (nonatomic, retain) id mainLayer;

@property (nonatomic, retain) NBMessageBox* descriptionLabel;

-(id)initWithLayer:(id)layer;
-(void)initialiseEquipmentArray;
-(void)initialiseEquipmentUI;
-(void)toggleEquipmentSelection:(NBEquipment*)selectedEquipmentButton;
-(void)selectTargetEquipment;


@end
