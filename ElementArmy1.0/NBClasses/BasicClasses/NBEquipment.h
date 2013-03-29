//
//  NBEquipment.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 10/3/13.
//
//

#import <Foundation/Foundation.h>
#import "NBEquipmentData.h"

@interface NBEquipment : NSObject

+(NBEquipment*)getCurrentlySelectedEquipment;
+(id)createEquipment:(NSString*)equipmentID onLayer:(id)layer onSelector:(SEL)selector;// equipmentIndex:(int)index;
+(id)createEquipmentByIndex:(int)equipmentIndex onLayer:(id)layer onSelector:(SEL)selector lockedSelector:(SEL)lockedSelector;
-(id)setEquipmentIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer;
-(void)displayEquipmentIcon;
-(void)hideEquipmentIcon;
-(void)onEquipmentSelected;

@property (nonatomic, retain) NBEquipmentData* equipmentData;
@property (nonatomic, retain) NBButton* equipmentIcon;

@property (nonatomic, retain) NSString* image;

@property (nonatomic, retain) id currentLayer;
@property (nonatomic, assign) SEL currentSelector;

@end
