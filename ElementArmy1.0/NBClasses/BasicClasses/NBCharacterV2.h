//
//  NBCharacterV2.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/2/13.
//  This is backup from NBCharacter
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

@interface NBCharacterV2 : NBBasicObject
{
    bool deadEventTriggered;
    bool updateIsActive;
    EnumCharacterSide characterSide_;
}

+(bool)calculateAttackSuccessWithAttacker:(NBCharacterV2*)attacker andDefender:(NBCharacterV2*)defender;
+(CCArray*)getEnemyList:(NBCharacterV2*)unit;
+(CCArray*)getAllyList:(NBCharacterV2*)unit;
+(CCArray*)getAllUnitList;

-(long)getHitPoint;
-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData;
-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData;
-(void)initialize;
-(void)update:(ccTime)delta;
-(void)levelUp;
-(void)attack:(NBCharacterV2*)target;
-(void)attackWithAnimation:(NBCharacterV2*)target withAnimation:(NSString*)animationName;
-(void)shootProjectile;
-(void)useSkill:(NBSkill*)skill;
-(void)useMagic:(NBMagic*)magic;
-(void)moveToPosition:(CGPoint)newPosition forDurationOf:(float)duration;
-(void)moveToWithAnimation:(CGPoint)newPosition forDurationOf:(float)duration withAnimation:(NSString*)animationName;
-(void)moveToAttackTargetPosition:(NBCharacterV2*)target;
-(void)MoveToPosition:(CGPoint)newPosition withDelta:(ccTime)delta setNextState:(EnumCharacterState)nextState;
-(void)startUpdate;
-(void)dead;
-(void)appear;
-(void)dissapear;
//-(BOOL)isTouchingMe:(CGPoint)touchLocation;
-(NBCharacterV2*)findNewTarget:(CCArray*)enemyUnits;
-(CGPoint)getAttackedPosition:(NBCharacterV2*)attacker;
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
@property (nonatomic, retain) NBCharacterV2* currentTarget;
@property (nonatomic, retain) NBCharacterV2* previousTarget;
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
