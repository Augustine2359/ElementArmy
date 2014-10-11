//
//  NBEquipmentData.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 10/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBUserInterface.h"

typedef enum
{
    eqimAdd = 0,
    eqimSubstract,
    eqimMultiply,
    eqimDivide,
} eqImpactType;

@interface NBEquipmentData : NSObject

@property (nonatomic, retain) NSString* equipmentName;
@property (nonatomic, retain) NSString* theDescription;
@property (nonatomic, retain) NSString* impactedStatus;
@property (nonatomic, retain) NSString* impactValue;
@property (nonatomic, assign) NSInteger requiredLevel;
@property (nonatomic, retain) NSString* imageNormal;
@property (nonatomic, retain) NSString* imageSelected;
@property (nonatomic, retain) NSString* imageDisabled;

@property (nonatomic, assign) int availableAmount;

@end
