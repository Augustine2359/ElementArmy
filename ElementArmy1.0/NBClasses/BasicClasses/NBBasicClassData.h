//
//  NBBasicClassData.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    etCommonEnemy = 0,
    etBoss = 1,
    etSecretBoss,
} EnumEnemyType;

typedef enum
{
    atMelee = 0,
    atRange
} EnumAttackType;

@interface NBBasicClassData : NSObject

@property (nonatomic, retain) NSString* className;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int availableUnit;
@property (nonatomic, assign) int totalUnit;
@property (nonatomic, assign) NSDate* timeLastBattleCompleted;
@property (nonatomic, assign) int maximumAttackedStack;
@property (nonatomic, assign) EnumAttackType attackType;
@property (nonatomic, assign) EnumEnemyType enemyType;
@property (nonatomic, assign) float scale;

@end
