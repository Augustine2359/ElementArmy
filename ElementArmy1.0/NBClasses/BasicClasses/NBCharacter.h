//
//  NBCharacter.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 17/9/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBBasicObject.h"
#import "NBMagic.h"
#import "NBSkill.h"
#import "NBAnimatedSprite.h"
#import "NBProjectile.h"
#import "NBUpdatableCharacter.h"
#import "NBBasicClassData.h"

#define MAXIMUM_CHARACTER_CAPACITY 100
#define MAXIMUM_PROJECTILE_COUNT 50
#define MAXIMUM_ATTACK_REFRESH_DURATION 1800    //2 Seconds??
#define TEST_OBJECT_NAME @"EnemyNBSoldier"
//#define ENABLE_REMAINING_ATK_TIME_LOG

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

@interface NBCharacter : NBBasicObject
{
    bool deadEventTriggered;
    bool updateIsActive;
    EnumCharacterSide characterSide_;
}

+(bool)calculateAttackSuccessWithAttacker:(NBCharacter*)attacker andDefender:(NBCharacter*)defender;
+(CCArray*)getEnemyList:(NBCharacter*)unit;
+(CCArray*)getAllyList:(NBCharacter*)unit;
+(CCArray*)getAllUnitList;

-(long)getHitPoint;
-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData;
-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData;
-(void)initialize;
-(void)update:(ccTime)delta;
-(void)levelUp;
-(void)attack:(NBCharacter*)target;
-(void)attackWithAnimation:(NBCharacter*)target withAnimation:(NSString*)animationName;
-(void)shootProjectile;
-(void)useSkill:(NBSkill*)skill;
-(void)useMagic:(NBMagic*)magic;
-(void)moveToPosition:(CGPoint)newPosition forDurationOf:(float)duration;
-(void)moveToWithAnimation:(CGPoint)newPosition forDurationOf:(float)duration withAnimation:(NSString*)animationName;
-(void)moveToAttackTargetPosition:(NBCharacter*)target;
-(void)MoveToPosition:(CGPoint)newPosition withDelta:(ccTime)delta setNextState:(EnumCharacterState)nextState;
-(void)startUpdate;
-(void)dead;
-(void)appear;
-(void)dissapear;
//-(BOOL)isTouchingMe:(CGPoint)touchLocation;
-(NBCharacter*)findNewTarget:(CCArray*)enemyUnits;
-(CGPoint)getAttackedPosition:(NBCharacter*)attacker;
-(void)useNextState;

//Events
-(void)onStateChangedTo:(EnumCharacterState)newState from:(EnumCharacterState)oldState;
//-(void)onTouched;
-(void)onAttackCompleted;
-(void)onDying;
-(void)onDeath;
-(void)onAttacked:(id)attacker;
-(void)onAttackedByProjectile:(id)projectile;
-(void)onTargetKilled:(id)target;
-(void)onTargettedBy:(id)attacker;
-(void)onTargettedByMeleeReleased:(id)attacker;

@property (nonatomic, retain) NBBasicClassData* basicClassData;
@property (nonatomic, assign) int objectIndex;
@property (nonatomic, assign) EnumElementType elementType;
@property (nonatomic, assign) int hitPoint;
@property (nonatomic, assign) int spiritPoint;
@property (nonatomic, assign) int attackPoint;
@property (nonatomic, assign) int defensePoint;
@property (nonatomic, assign) int dexterityPoint;
@property (nonatomic, assign) int intelligencePoint;
@property (nonatomic, assign) int evasionPoint;
@property (nonatomic, retain) CCArray* skillSlots;
@property (nonatomic, retain) CCArray* magicSlots;
@property (nonatomic, assign) bool isAlive;
@property (nonatomic, assign) EnumCharacterState currentState;
@property (nonatomic, assign) EnumCharacterState previousState;
@property (nonatomic, retain) NBAnimatedSprite* animation;
@property (nonatomic, retain) NBSkill* currentActiveSkill;
@property (nonatomic, retain) NBMagic* currentActiveMagic;
@property (nonatomic, assign) EnumCharacterSide characterSide;
@property (nonatomic, retain) NSString* characterSideString;
@property (nonatomic, retain) NBCharacter* currentTarget;
@property (nonatomic, retain) NBCharacter* previousTarget;
@property (nonatomic, assign) bool isAttackReady;
@property (nonatomic, assign) ccTime timeUntilNextAttack;
@property (nonatomic, assign) CGPoint targetPreviousPosition;
@property (nonatomic, assign) EnumCharacterState nextState;
@property (nonatomic, assign) int currentNumberOfMeleeEnemiesAttackingMe;
@property (nonatomic, retain) CCArray* listOfEnemiesAttackingMe;
@property (nonatomic, retain) CCArray* listOfMeleeEnemiesAttackingMe;
@property (nonatomic, assign) int currentAttackPost;
@property (nonatomic, assign) CGPoint previousPosition;

//Adding capabilities for projectile shooter type character
@property (nonatomic, retain) CCArray* projectileArrayList;

@end
