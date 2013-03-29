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

@property (nonatomic, retain) NSString* equipmentID;
@property (nonatomic, retain) NSString* equipmentName;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* statusImpacted;
@property (nonatomic, retain) NSString* impactType;
@property (nonatomic, retain) NSString* impactValue;
@property (nonatomic, assign) NSInteger requiredLevel;
@property (nonatomic, assign) NSString* imageNormal;

@end
