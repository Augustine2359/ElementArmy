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

typedef enum
{
    ProjectileTargettedShot = 0,
    ProjectileDirectionalShot = 1,
} EnumProjectileShootType;

@interface NBProjectile : NBBasicObject

+(CCArray*)getProjectileList;
+(void)updateObjectsWithOtherObjectList:(CCArray*)objectList withDelta:(ccTime)delta;

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setOwner:(NBBasicObject*)owner;
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

@property (nonatomic, assign) int power;
@property (nonatomic, assign) int speed;
@property (nonatomic, retain) NBBasicObject* currentOwner;
@property (nonatomic, retain) NBBasicObject* currentTarget;
@property (nonatomic, assign) EnumProjectileShootType shootType;
@property (nonatomic, assign) EnumProjectileState currentState;
@property (nonatomic, assign) EnumProjectileState previousState;
@property (nonatomic, assign) EnumProjectileState nextState;
@property (nonatomic, assign) CGPoint paddingPosition;
@property (nonatomic, assign) CGPoint shootLocation;

@end
