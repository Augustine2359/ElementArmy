//
//  NBProjectileBasicData.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/2/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    ProjectileTargettedShot = 0,
    ProjectileDirectionalShot = 1,
} EnumProjectileShootType;

@interface NBProjectileBasicData : NSObject

@property (nonatomic, retain) NSString* projectileName;
@property (nonatomic, assign) int defaultPower;
@property (nonatomic, assign) int defaultSpeed;
@property (nonatomic, assign) EnumProjectileShootType shootType;
@property (nonatomic, retain) NSString* idleFrame;

@end
