//
//  NBSkill.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 19/9/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "NBBasicObject.h"

typedef enum
{
    stActive = 0,
    stPassive,
    stPassiveRevolving,
    stCustom,
} skillType;

typedef enum
{
    sitAdd = 0,
    sitSubstract,
    sitMultiply,
    sitDivide,
} skillImpactType;

@interface NBSkill : NSObject

@property (nonatomic, retain) NSString* skillName;
@property (nonatomic, retain) NSString* skillInGameName;
@property (nonatomic, assign) skillType skillType;
@property (nonatomic, retain) NSString* statusImpacted;
@property (nonatomic, assign) skillImpactType impactType;
@property (nonatomic, assign) CGFloat impactValue;
@property (nonatomic, assign) CGFloat frequency;
@property (nonatomic, assign) bool canExceedMaxValue;

@end
