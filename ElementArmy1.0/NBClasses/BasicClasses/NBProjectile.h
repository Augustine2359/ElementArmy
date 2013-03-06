//
//  NBProjectile.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 22/10/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicObject.h"
#import "NBCharacter.h"
#import "NBProjectileBasicData.h"

#define OFF_AREA_POSITION ccp(0, 0)
#define PROJECTILE_MAX_CAPACITY_PER_CHARACTER 10
#define HIT_ACCURACY_MULTIPLIER 4

typedef enum
{
    ProjectileCreated = 0,
    ProjectileLoaded = 1,
    ProjectileShot = 2,
    ProjectileTravelling = 3,
    ProjectileCollided = 4,
    ProjectileDissapearing = 5,
} EnumProjectileState;

@interface NBProjectile : NBBasicObject

+(CCArray*)getProjectileList;
+(void)updateObjectsWithOtherObjectList:(CCArray*)objectList withDelta:(ccTime)delta;

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setOwner:(NBBasicObject*)owner withBasicData:(NBProjectileBasicData*)basicData;
-(void)initialize;
-(void)update:(ccTime)delta;
-(void)setTargetLocation:(CGPoint)targetLocation;
-(void)activateShootFromPosition:(CGPoint)position;
-(void)shootAtTarget:(NBBasicObject*)target;
-(void)shootAtDirection:(CGPoint)direction;
-(void)MoveToPosition:(CGPoint)newPosition withDelta:(ccTime)delta setNextState:(EnumProjectileState)nextState;

//Events
-(void)onStateChangedTo:(EnumProjectileState)newState from:(EnumProjectileState)oldState;
-(void)onHit:(NBBasicObject*)object;

@property (nonatomic, retain) NBProjectileBasicData* projectileBasicData;
@property (nonatomic, assign) int currentPower;
@property (nonatomic, assign) int currentSpeed;
@property (nonatomic, retain) NBBasicObject* currentOwner;
@property (nonatomic, retain) NBBasicObject* currentTarget;
@property (nonatomic, assign) EnumCharacterSide currentOwnerSide;
@property (nonatomic, assign) EnumProjectileState currentState;
@property (nonatomic, assign) EnumProjectileState previousState;
@property (nonatomic, assign) EnumProjectileState nextState;
@property (nonatomic, assign) CGPoint paddingPosition;
@property (nonatomic, assign) CGPoint shootLocation;

@end
