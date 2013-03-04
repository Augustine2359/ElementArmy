//
//  NBCharacter.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 17/9/12.
//  2/22/2013: Major change to support reading behavior from database. Avoiding Subclasses.
//  2/22/2013: Original NBCharacter is backed up on NBCharacterV2
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
#import "NBUserInterface.h"

#define MAXIMUM_CHARACTER_CAPACITY 100
#define MAXIMUM_PROJECTILE_COUNT 50
#define MAXIMUM_ATTACK_REFRESH_DURATION 1800    //2 Seconds??
#define TEST_OBJECT_NAME @"EnemyNBSoldier"
#define ENABLE_REMAINING_ATK_TIME_LOG

@interface NBCharacter : NBBasicObject
{
    bool deadEventTriggered;
    bool updateIsActive;
    EnumCharacterSide characterSide_;
    float damageCounterLabelRemainingTime;
}

+(bool)calculateAttackSuccessWithAttacker:(NBCharacter*)attacker andDefender:(NBCharacter*)defender;
+(CCArray*)getEnemyListOf:(NBCharacter*)unit;
+(CCArray*)getAllyListOf:(NBCharacter*)unit;
+(CCArray*)getEnemyList;
+(CCArray*)getAllyList;
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
@property (nonatomic, retain) CCLabelAtlas* damageCounterLabel;

//Adding capabilities for projectile shooter type character
@property (nonatomic, retain) CCArray* projectileArrayList;

@end
