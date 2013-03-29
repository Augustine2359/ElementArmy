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

//@property(nonatomic, retain) NSMutableArray* allEquipments;
@property(nonatomic, retain) CCArray* allEquipments;
@property (nonatomic, retain) id mainLayer;

@property (nonatomic, retain) CCLabelTTF* descriptionLabel;
@property (nonatomic, assign) NSString* descriptionString;

@property (nonatomic, retain) NBButton* confirmButton;

-(id)initWithLayer:(id)layer;
-(void)initialiseEquipmentArray;
-(void)initialiseEquipmentUI;
-(void)toggleEquipmentSelection:(NBEquipment*)selectedEquipmentButton;
-(void)selectTargetEquipment;
-(void)confirmAndCloseMenu;


@end
