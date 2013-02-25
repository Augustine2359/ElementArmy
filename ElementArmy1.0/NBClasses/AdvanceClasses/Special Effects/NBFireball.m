//
//  NBFireball.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/10/12.
//
//

#import "NBFireball.h"

//For all of your derived object, create its own array list as static. This static object can be used outside the class for other purpose
static CCArray* objectList = nil;

@implementation NBFireball

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setOwner:(NBCharacter*)owner
{
    //Implement below, but mostly you would be only changing the sprite name
    if (!objectList)
    {
        objectList = [[CCArray alloc] initWithCapacity:DEFAULT_MAXIMUM_OBJECT_CAPACITY];
    }
    
    self = [super initWithFrameName:NORMAL_FIREBALL_FILE andSpriteBatchNode:spriteBatchNode onLayer:layer setOwner:owner];
    
    [objectList addObject:self];
    
    return self;
}

-(void)initialize
{
    [super initialize];
    
    //Setup your specific initialization here
    //The intention is to give initial value, but basically the attributes of such class should be determine by the projectile owner.
    //See NBFireMage class for example on how to set.override the default power of this class.
    self.name = [NSString stringWithFormat:@"%@%i", NSStringFromClass([self class]), [objectList count]];
    self.currentPower = self.projectileBasicData.defaultPower;
    self.currentSpeed = self.projectileBasicData.defaultSpeed;
    self.basicSpeedPoint = self.currentSpeed;
}

-(void)update:(ccTime)delta
{
    //Don't change below
    [super update:delta];
    
    //Update your projectile here
    //Visibility of your projectile is based on whether the projectile is currently active, otherwise the visibility is set as false.
    //NBProjectile isActive attribute is mostly controlled by the owner, like its being set as active when owner perform shoot projectile.
    //See NBFireMage for example on how to shoot.
    if (self.isActive)
    {
        if (!self.sprite.visible)
            self.sprite.visible = YES;
        
        switch (self.currentState)
        {
            case ProjectileCreated:
                break;
                
            case ProjectileLoaded:
                break;
                
            case ProjectileShot:
                self.currentState = ProjectileTravelling;
                self.currentDirection = [NBBasicObject createDirectionFrom:self.position to:self.shootLocation];
                [self moveToDirection:self.currentDirection withDelta:delta];
                //[self MoveToPosition:self.shootLocation withDelta:delta setNextState:ProjectileCollided];
                break;
                
            case ProjectileTravelling:
                [self moveToDirection:self.currentDirection withDelta:delta];
                //[self MoveToPosition:self.shootLocation withDelta:delta setNextState:ProjectileCollided];
                break;
                
            case ProjectileCollided:
                break;
                
            case ProjectileDissapearing:
                break;
                
            default:
                break;
        }
    }
    else
    {
        self.sprite.visible = NO;
    }
}

-(void)onHit:(NBBasicObject*)object
{
    //Generally you also would not need to change below unless it is really necessary.
    id tempTarget = (id)object;
    [tempTarget onAttackedByProjectile:self];
    
    //Don't change below
    [super onHit:object];
}

-(void)isCollidedWith:(NBBasicObject*)object
{
    if (object == self.currentTarget)
    {
        [self onHit:object];
    }
}

@end
