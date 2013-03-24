//
//  NBEquipment.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import "NBEquipment.h"

static NBEquipment* currentlySelectedEquipmentInBattleSetup = nil;

@implementation NBEquipment

+(NBEquipment*)getCurrentlySelectedEquipment
{
    return currentlySelectedEquipmentInBattleSetup;
}

+(id)createEquipment:(NSString*)equipmentID onLayer:(id)layer onSelector:(SEL)selector// equipmentIndex:(int)index
{
    NBEquipment* equipment = [[NBEquipment alloc] init];
    //    equipment.equipmentData = [[NBEquipmentData alloc] init];
    //    equipment.equipmentData.equipmentID = equipmentID;
    equipment.equipmentData = (NBEquipmentData*)[[[NBDataManager dataManager] listOfEquipments] objectAtIndex:0];
    equipment.currentLayer = layer;
    equipment.currentSelector = selector;
    
    return equipment;
}

+(id)createEquipment:(NSString*)equipmentID onLayer:(id)layer onSelector:(SEL)selector equipmentIndex:(int)index
{
    NBEquipment* equipment = [[NBEquipment alloc] init];
    DLog(@"before");
    equipment.equipmentData = (NBEquipmentData*)[[[NBDataManager dataManager] listOfEquipments] objectAtIndex:index];
    DLog(@"after = %@", equipment.equipmentData);
    equipment.currentLayer = layer;
    equipment.currentSelector = selector;
    
    return equipment;
}

-(id)setEquipmentIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer
{
    self.equipmentIcon = [NBButton createWithStringHavingNormal:normalImage havingSelected:selectedImage havingDisabled:disabledImage onLayer:layer respondTo:self selector:@selector(onEquipmentSelected) withSize:CGSizeZero];
    self.image = normalImage;
    return self;
}

-(void)onEquipmentSelected
{
    currentlySelectedEquipmentInBattleSetup = self;
    [self.currentLayer performSelector:self.currentSelector];
}

-(void)displayEquipmentIcon
{
    if (self.equipmentIcon)
        [self.equipmentIcon show];
}

-(void)hideEquipmentIcon
{
    if (self.equipmentIcon)
        [self.equipmentIcon hide];
}

@end
