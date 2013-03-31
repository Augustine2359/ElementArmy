//
//  NBItemData.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBUserInterface.h"

typedef enum
{
    itusAllyOnly = 0,
    itusEnemyOnly,
    itusBothSides,
} itUnitSide;

typedef enum
{
    itutOneTime = 0,
    itutDuration,
} itUsageType;

typedef enum
{
    itiaAll = 0,
    itiaArea,
} itImpactAreaType;

typedef enum
{
    itimAdd = 0,
    itimSubstract,
    itimMultiply,
    itimDivide,
} itImpactType;

@interface NBItemData : NSObject

@property (nonatomic, retain) NSString* imageNormal;
@property (nonatomic, retain) NSString* imageSelected;
@property (nonatomic, retain) NSString* imageDisabled;
@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* impactedStatus;
@property (nonatomic, assign) itUnitSide effectToUnitSide;
@property (nonatomic, assign) itUsageType usageType;
@property (nonatomic, assign) itImpactAreaType impactAreaType;
@property (nonatomic, assign) itImpactType impactType;
@property (nonatomic, retain) NSString* impactValue;
@property (nonatomic, retain) NSString* specialEffect;
@property (nonatomic, assign) BOOL allowBeyondMaximumValue;
@property (nonatomic, assign) int maximumAllowable;

@property (nonatomic, assign) int availableAmount;

@end
