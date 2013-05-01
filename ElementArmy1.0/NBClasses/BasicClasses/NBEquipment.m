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

-(CCArray*)statsEffectOfEquipment{
    //0 is HP
    //1 is SP
    //2 is STR
    //3 is DEF
    //4 is INT
    //5 is DEX
    //6 is EVA
    CCArray* statsModifierArray = [[CCArray alloc] initWithCapacity:7];
    for (int x = 0; x < [statsModifierArray capacity]; x++) {
        [statsModifierArray addObject:@"1"];
    }
    
    NSArray* impactedStatusList = [self.equipmentData.impactedStatus componentsSeparatedByString:@";"];
    NSArray* impactedValueList = [self.equipmentData.impactValue componentsSeparatedByString:@";"];
    for (int effectIndex = 0; effectIndex < [impactedStatusList count]; effectIndex++)
    {
        NSString* impactedStatus = [impactedStatusList objectAtIndex:effectIndex];
        if ([impactedStatus length] < 1) continue;
    
//        NSString* valueString = nil;        
        float impactedStatusValue = [[impactedValueList objectAtIndex:effectIndex] floatValue];
//        valueString = [valueString stringByAppendingFormat:@"%f", impactedStatusValue];
        
        if ([impactedStatus isEqualToString:@"HP"])
        {
            [statsModifierArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:impactedStatusValue]];
        }
        else if ([impactedStatus isEqualToString:@"SP"])
        {
            [statsModifierArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:impactedStatusValue]];
        }
        else if ([impactedStatus isEqualToString:@"ATK"])
        {
            [statsModifierArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:impactedStatusValue]];
        }
        else if ([impactedStatus isEqualToString:@"DEF"])
        {
            [statsModifierArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithFloat:impactedStatusValue]];
        }
        else if ([impactedStatus isEqualToString:@"INT"])
        {
            [statsModifierArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithFloat:impactedStatusValue]];
        }
        else if ([impactedStatus isEqualToString:@"DEX"])
        {
            [statsModifierArray replaceObjectAtIndex:5 withObject:[NSNumber numberWithFloat:impactedStatusValue]];
        }
        else if ([impactedStatus isEqualToString:@"EVA"])
        {
            [statsModifierArray replaceObjectAtIndex:6 withObject:[NSNumber numberWithFloat:impactedStatusValue]];
        }
        else
        {
            DLog(@"error: unknown attribute: %@", impactedStatus);
        }
        DLog(@"%@ = x%f", impactedStatus, impactedStatusValue);
    }
    DLog(@"end");
    return statsModifierArray;
}


@end
