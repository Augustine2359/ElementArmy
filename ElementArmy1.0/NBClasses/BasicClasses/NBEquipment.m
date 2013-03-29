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

+(id)createEquipment:(NBEquipmentData*)newEquipmentData onLayer:(id)layer onSelector:(SEL)selector
{
    NBEquipment* equipment = [[NBEquipment alloc] init];
    equipment.equipmentData = newEquipmentData;
    equipment.currentLayer = layer;
    equipment.currentSelector = selector;
    
    [equipment setEquipmentIconWithNormalImage:equipment.equipmentData.imageNormal selectedImage:equipment.equipmentData.imageSelected disabledImage:equipment.equipmentData.imageDisabled onLayer:layer];
    
    return equipment;
}

//+(id)createEquipmentByIndex:(int)equipmentIndex onLayer:(id)layer onSelector:(SEL)selector lockedSelector:(SEL)lockedSelector
//{
//    NBEquipment* equipment = [NBEquipment new];
//    equipment.equipmentData = (NBEquipmentData*)[[[NBDataManager dataManager] listOfEquipments] objectAtIndex:equipmentIndex];
////    DLog(@"equipmentDataImage = %@", equipment.equipmentData.imageNormal);
//    equipment.currentLayer = layer;
//    
//    if (equipment.equipmentData.equipmentID == 0) {
//        equipment.currentSelector = lockedSelector;
//    }
//    else{
//        equipment.currentSelector = selector;
//    }
//    
////    [equipment setEquipmentIconWithNormalImage:equipment.equipmentData.image selectedImage:equipment.equipmentData.image disabledImage:equipment.equipmentData.image onLayer:layer];
//    
//    return equipment;
//}

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
