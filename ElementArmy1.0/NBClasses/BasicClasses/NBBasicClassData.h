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

typedef enum
{
    elUnknown = 0,
    elFire = 1,
    elWater = 2,
    elEarth = 3,
    elWood = 4,
    elMetal = 5,
    elLight = 6,
    elDark = 7
} EnumElementType;

typedef enum
{
    Unknown         = 0,
    Loaded          = 1,
    EnteringScene   = 2,
    Idle            = 3,
    Marching        = 4,
    Targetting      = 5,
    Engaging        = 6,
    Engaged         = 7,
    Attacking       = 8,
    Dying           = 9,
    Dead            = 10,
    Retreating      = 11,
    Moving          = 12,
    Waiting         = 13
} EnumCharacterState;

typedef enum
{
    Ally,
    Enemy
} EnumCharacterSide;

@interface NBBasicClassData : NSObject

@property (nonatomic, retain) NSString* className;
@property (nonatomic, retain) NSString* classType;
@property (nonatomic, assign) int startLevel;
@property (nonatomic, assign) bool isBoss;
@property (nonatomic, assign) int basicHP;
@property (nonatomic, assign) int basicSP;
@property (nonatomic, assign) int basicSTR;
@property (nonatomic, assign) int basicDEF;
@property (nonatomic, assign) int basicINT;
@property (nonatomic, assign) int basicDEX;
@property (nonatomic, assign) int basicEVA;
@property (nonatomic, assign) int minHPAdd;
@property (nonatomic, assign) int maxHPAdd;
@property (nonatomic, assign) int minSPAdd;
@property (nonatomic, assign) int maxSPAdd;
@property (nonatomic, assign) int minSTRAdd;
@property (nonatomic, assign) int maxSTRAdd;
@property (nonatomic, assign) int minDEFAdd;
@property (nonatomic, assign) int maxDEFAdd;
@property (nonatomic, assign) int minINTAdd;
@property (nonatomic, assign) int maxINTAdd;
@property (nonatomic, assign) int minDEXAdd;
@property (nonatomic, assign) int maxDEXAdd;
@property (nonatomic, assign) int minEVAAdd;
@property (nonatomic, assign) int maxEVAAdd;
@property (nonatomic, assign) int maximumAttackedStack;
@property (nonatomic, assign) EnumAttackType attackType;
@property (nonatomic, assign) bool isEnemy;
@property (nonatomic, retain) NSString* idleFrame;
@property (nonatomic, retain) NSString* idleAnimFrame;
@property (nonatomic, assign) short idleAnimFrameCount;
@property (nonatomic, retain) NSString* attackAnimFrame;
@property (nonatomic, assign) short attackAnimFrameCount;
@property (nonatomic, retain) NSString* walkAnimFrame;
@property (nonatomic, assign) short walkAnimFrameCount;
@property (nonatomic, retain) NSString* shootAnimFrame;
@property (nonatomic, assign) short shootAnimFrameCount;
@property (nonatomic, retain) NSString* useProjectileName;
@property (nonatomic, retain) NSString* activeSkillName;
@property (nonatomic, retain) NSString* passiveSkillName;

@property (nonatomic, assign) int level;
@property (nonatomic, assign) int currentHP;
@property (nonatomic, assign) int currentSP;
@property (nonatomic, assign) int currentSTR;
@property (nonatomic, assign) int currentDEF;
@property (nonatomic, assign) int currentINT;
@property (nonatomic, assign) int currentDEX;
@property (nonatomic, assign) int currentEVA;
@property (nonatomic, assign) int availableUnit;
@property (nonatomic, assign) int totalUnit;
@property (nonatomic, assign) NSDate* timeLastBattleCompleted;
@property (nonatomic, assign) EnumEnemyType enemyType;
@property (nonatomic, assign) float scale;
@property (nonatomic, assign) int battlePointsAward;

@end
