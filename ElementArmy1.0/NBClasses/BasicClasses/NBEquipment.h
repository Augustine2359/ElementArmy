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
+(id)createEquipment:(NBEquipmentData*)newEquipmentData onLayer:(id)layer onSelector:(SEL)selector;
-(id)setEquipmentIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer;
-(void)displayEquipmentIcon;
-(void)hideEquipmentIcon;
-(void)onEquipmentSelected;
-(CCArray*)statsEffectOfEquipment;

@property (nonatomic, retain) NBEquipmentData* equipmentData;
@property (nonatomic, retain) NBButton* equipmentIcon;

@property (nonatomic, retain) NSString* image;

@property (nonatomic, retain) id currentLayer;
@property (nonatomic, assign) SEL currentSelector;

@end
