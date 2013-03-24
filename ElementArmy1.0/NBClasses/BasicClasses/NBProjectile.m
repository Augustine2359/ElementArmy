//
//  NBProjectile.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 22/10/12.
//
//

#import "NBProjectile.h"

static CCArray* projectileList = nil;

@implementation NBProjectile

+(CCArray*)getProjectileList
{
    return projectileList;
}

+(void)updateObjectsWithOtherObjectList:(CCArray*)objectList withDelta:(ccTime)delta
{
    if ([projectileList count] > 0)
    {
        NBProjectile* tempProjectile;
        
        CCARRAY_FOREACH(projectileList, tempProjectile)
        {
            [tempProjectile update:delta];
        }
    }
}

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setOwner:(NBBasicObject*)owner withBasicData:(NBProjectileBasicData*)basicData
{
    if (!projectileList)
    {
        projectileList = [[CCArray alloc] initWithCapacity:PROJECTILE_MAX_CAPACITY_PER_CHARACTER];
    }
    
    if (self == [super initWithFrameName:basicData.idleFrame andSpriteBatchNode:spriteBatchNode onLayer:layer])
    {
        self.projectileBasicData = basicData;
        self.currentOwner = owner;
        self.currentLayer = layer;
        self.objectIndex = [layer.children count];
        self.currentPower = basicData.defaultPower;
        self.currentSpeed = basicData.defaultSpeed;
    }
    
    [projectileList addObject:self];
    
    return self;
}

-(void)initialize
{
    self.name = [NSString stringWithFormat:@"%@%i", self.projectileBasicData.projectileName, [projectileList count]];
    
    self.isActive = false;
    self.paddingPosition = CGPointZero;
    self.position = [self.currentOwner position];
    self.facing = self.currentOwner.facing;
    self.sprite.visible = NO;
    self.currentState = ProjectileCreated;
}

-(void)dealloc
{
    //[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [projectileList removeObject:self];
    [super dealloc];
}

-(void)setTargetLocation:(CGPoint)targetLocation
{
    self.shootLocation = targetLocation;
}

-(void)activateShootFromPosition:(CGPoint)position
{
    self.position = position;
    self.currentState = ProjectileShot;
    self.isActive = true;
}

-(void)shootAtTarget:(NBCharacter*)target
{
    self.currentState = ProjectileTravelling;
    self.currentTarget = (NBBasicObject*)target;
    self.isActive = true;
}

-(void)shootAtDirection:(CGPoint)direction
{
    
}

-(void)update:(ccTime)delta
{
    [super update:delta];
    
    if (self.isActive)
    {
        //Update facing
        /*if (self.currentTarget != nil)
        {
            if (self.currentTarget.position.x > self.position.x)
                self.facing = Right;
            else
                self.facing = Left;
        }*/
        
        if (!self.sprite.visible)
            self.sprite.visible = YES;
        
        self.visible = YES;
        
        switch (self.currentState)
        {
            case ProjectileCreated:
                break;
            
            case ProjectileLoaded:
                break;
                
            case ProjectileShot:
            {
                if (!self.currentTarget)
                    break;
                
                self.currentState = ProjectileTravelling;
                self.currentDirection = [NBBasicObject createDirectionFrom:self.position to:self.shootLocation];
                float duration = abs(ccpDistance(self.currentTarget.position, self.position)) / (([[CCDirector sharedDirector] winSize].width / 2) + self.currentSpeed);
                CCMoveTo* move = [CCMoveTo actionWithDuration:duration position:self.currentTarget.position];
                CCEaseIn* accel = [CCEaseIn actionWithAction:move rate:1.5];
                CCCallFunc* movingCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onMoveCompleted)];
                CCSequence* sequence = [CCSequence actions:accel, movingCompleted, nil];
                [self runAction:sequence];
                //[self moveToDirection:self.currentDirection withDelta:delta];
            }
                break;
                
            case ProjectileTravelling:
            {
                self.position = ccpAdd(self.position, self.paddingPosition);
                
                if (self.projectileBasicData.shootType == ProjectileTargettedShot)
                {
                    if (self.currentTarget != nil)
                    {
                        if ([self checkCollisionWith:self.currentTarget])
                        {
                            [self onHit:(NBBasicObject*)self.currentTarget];
                            self.currentTarget = nil;
                        }
                    }
                }
                else
                {
                    NBBasicObject* object = nil;
                    int collisionCount = 0;
                    CCArray* objectList = nil;
                    
                    if (self.currentOwnerSide == Ally)
                    {
                        objectList = [NBCharacter getEnemyList];
                    }
                    else
                    {
                        objectList = [NBCharacter getAllyList];
                    }
                    
                    CCARRAY_FOREACH(objectList, object)
                    {
                        collisionCount = 0;
                        
                        if (object != self && object != self.currentOwner)
                        {
                            if (object.isActive)
                            {
                                if ([self checkCollisionWith:object])
                                {
                                    collisionCount++;
                                    [self isCollidedWith:object];
                                    
                                    if (collisionCount > MAXIMUM_COLLISION_ALLOWED)
                                        continue;
                                }
                            }
                        }
                    }
                }
                
                if (![self checkWithinWorld])
                {
                    self.isActive = false;
                    self.visible = NO;
                }
                //[self moveToDirection:self.currentDirection withDelta:delta];
            }
                break;
                
            case ProjectileCollided:
                break;
                
            case ProjectileDissapearing:
                break;
                
            default:
                break;
        }
        
        if (self.previousState != self.currentState)
        {
            [self onStateChangedTo:self.currentState from:self.previousState];
            self.previousState = self.currentState;
        }
    }
    else
    {
        self.visible = NO;
        self.position = OFF_AREA_POSITION;
    }
}

-(void)MoveToPosition:(CGPoint)newPosition withDelta:(ccTime)delta setNextState:(EnumProjectileState)objectNextState
{
    self.nextState = objectNextState;
    [super moveToPosition:newPosition withDelta:delta];
}

//Events
-(void)onStateChangedTo:(EnumProjectileState)newState from:(EnumProjectileState)oldState
{
    DLog(@"%@ state changed from %i to %i", self.name, oldState, newState);
}

-(void)onMoveCompleted
{
    //[self onHit:self.currentTarget];
    self.visible = NO;
    self.position = OFF_AREA_POSITION;
}

-(void)onHit:(NBBasicObject*)object
{
    //Generally you also would not need to change below unless it is really necessary.
    id tempTarget = (id)object;
    [tempTarget onAttackedByProjectile:self];
    
    self.isActive = false;
}

-(void)isCollidedWith:(NBBasicObject*)object
{
    if (object == self.currentTarget)
    {
        [self onHit:object];
    }
}

@end
