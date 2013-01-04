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

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setOwner:(NBCharacter*)owner
{
    if (!projectileList)
    {
        projectileList = [[CCArray alloc] initWithCapacity:PROJECTILE_MAX_CAPACITY_PER_CHARACTER];
    }
    
    if (self == [super initWithFrameName:frameName andSpriteBatchNode:spriteBatchNode onLayer:layer])
    {
        self.currentOwner = owner;
        self.currentLayer = layer;
        self.objectIndex = [layer.children count];
    }
    
    [projectileList addObject:self];
    
    return self;
}

-(void)initialize
{
    self.isActive = false;
    self.paddingPosition = CGPointZero;
    self.position = [self.currentOwner position];
    self.facing = self.currentOwner.facing;
    self.sprite.visible = NO;
    self.currentState = ProjectileCreated;
}

-(void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
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
        
        self.position = ccpAdd(self.position, self.paddingPosition);
        
        if (self.shootType == ProjectileTargettedShot)
        {
            if (self.currentTarget != nil)
            {
                if (ccpDistance(self.currentTarget.position, self.position) < ((self.sprite.contentSize.width / HIT_ACCURACY_MULTIPLIER) + (self.currentTarget.sprite.contentSize.width / HIT_ACCURACY_MULTIPLIER)))
                {
                    [self onHit:(NBBasicObject*)self.currentTarget];
                    self.currentTarget = nil;
                }
            }
        }
        
        self.visible = YES;
        
        switch (self.currentState)
        {
            case ProjectileCreated:
                break;
            
            case ProjectileLoaded:
                break;
                
            case ProjectileShot:
                break;
                
            case ProjectileTravelling:
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
    [self onHit:self.currentTarget];
}

-(void)onHit:(NBBasicObject*)object
{
    self.isActive = false;
}

@end
