//
//  NBFireMage.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 30/9/12.
//
// Notes:
// - All DLog is mostly covered by this if condition "if ([self.name isEqualToString:TEST_OBJECT_NAME])"
//   reason is because sometimes we want to track only 1 object, and so that the debugger log would not be too flooded
// - You can define your own log definition if needed. Take a look at the example on NBCharacter where I defined ENABLE_REMAINING_ATK_TIME_LOG
//   the reason is i would like to be able to turn on and off the remaining time for attack log which is a lot

#import "NBFireMage.h"

//For all of your derived object, create its own array list as static. This static object can be used outside the class for other purpose
static CCArray* classObjectList = nil;

@implementation NBFireMage

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side
{
    //Implement below, but mostly you would be only changing the sprite name
    //use DEFAULT_MAXIMUM_OBJECT_CAPACITY if you dont have any specific maximum number of object you want to create for this class
    if (!classObjectList)
    {
        classObjectList = [[CCArray alloc] initWithCapacity:DEFAULT_MAXIMUM_OBJECT_CAPACITY];
    }
    
    self = [super initWithFrameName:FIRE_MAGE_FILE andSpriteBatchNode:spriteBatchNode onLayer:layer onSide:(EnumCharacterSide)side];
    
    [classObjectList addObject:self];
    
    return self;
}

-(void)dealloc
{
    //Don't change below at this moment, HOWEVER, if you do allocate array for your own use, please dealloc here as well
    [classObjectList removeObject:self];
    
    NBProjectile* projectile;
    CCARRAY_FOREACH(self.projectileArrayList, projectile)
    {
        [projectile dealloc];
    }
    
    [super dealloc];
    
    //Your own deallocation
}

-(void)initialize
{
    //Don't change the following section
    //*****************************
    [super initialize];
    
    if (self.characterSide == Ally)
    {
        self.name = [NSString stringWithFormat:@"Ally%@%i", NSStringFromClass([self class]), [classObjectList count]];
    }
    else
    {
        self.name = [NSString stringWithFormat:@"Enemy%@%i", NSStringFromClass([self class]), [classObjectList count]];
    }
    
    DLog(@"%@ added", self.name);
    //*****************************
    
    //Initialize your class here
    //Add animation list here
    [self.animation addDefaultFrame:FIRE_MAGE_FILE];
    [self.animation addAnimation:@"Idle" withFileHeaderName:FIRE_MAGE_FILE_IDLE withAnimationCount:2];
    [self.animation addAnimation:@"Attack" withFileHeaderName:FIRE_MAGE_FILE_ATTACK withAnimationCount:3];
    
    //Set basic attributes value below
    self.level = 1;
    self.hitPoint = 100;
    self.spiritPoint = 100;
    self.attackPoint = 10;
    self.defensePoint = 10;
    self.dexterityPoint = 20;
    self.intelligencePoint = 30;
    self.evasionPoint = 5;
    
    //Preload your projectiles here
    for (int i = 0; i < PROJECTILE_MAX_CAPACITY_PER_CHARACTER; i++)
    {
        NBFireball* tempFireball = [[NBFireball alloc] initWithSpriteBatchNode:self.currentSpriteBatchNode onLayer:self.currentLayer setOwner:self];
        [tempFireball initialize];
        tempFireball.power = self.intelligencePoint;
        [self.projectileArrayList addObject:tempFireball];
    }
}

//All attack would normally be initiated with an attack animation. The following method helps to do so.
//Generally you do not want to activate the attack effect during the playing of attack animation, thus do not initiate any damage in this method.
-(void)attackWithAnimation:(NBCharacter*)target withAnimation:(NSString*)animationName
{
    //Implement below (potentially no change)
    [self.animation playAnimation:animationName withDelay:0.25 andRepeatForever:NO withTarget:self andSelector:@selector(onAttackCompleted)];
    //The reason adding the target to the property is to keep a track on which target is currently active for this object as the target cannot be added as argument on the selector
    self.currentTarget = target;
    
    NBProjectile* tempProjectile;
    
    CCARRAY_FOREACH(self.projectileArrayList, tempProjectile)
    {
        [tempProjectile setTargetLocation:self.currentTarget.position];
    }
}

//Below method is generally more appropriate for melee classes. For NBFireMage, i'd choose shootProjectile instead.
-(void)attack:(NBCharacter*)target
{
    //Implement below
    if (self.currentState != Dead && self.currentState != Dying)
    {
        if ([NBCharacter calculateAttackSuccessWithAttacker:self andDefender:target])
        {
            [target onAttacked:self];
        }
    }
    
    //Don't change below
    [super attack:target];
}

//Below method is generally more appropriate for range classes. For NBFireMage, this should be used after attack animation is completed
-(void)shootProjectile
{
    NBProjectile* tempProjectile;
    
    //When NBFireMage shoots projectile, it actually does the following:
    //1. Find any inactive preloaded projectiles
    //2. Set its position to the position of owner, as it may have moved
    //3. Ask projectile to shoot to the target.
    //4. Activates the projectile.
    //Note that with this method, even if user has perform shootAtTarget of the projectile, if the projectile is not activated, it won't actually shoot.
    CCARRAY_FOREACH(self.projectileArrayList, tempProjectile)
    {
        if (!tempProjectile.isActive)
        {
            tempProjectile.currentTarget = (NBBasicObject*)self.currentTarget;
            [tempProjectile activateShootFromPosition:self.position];
            break;
        }
    }
    
    //Don't change below
    [super attack:self.currentTarget];
}

-(void)update:(ccTime)delta
{
    //Don't change below
    //******************
    [super update:delta];
    
    if (self.currentState == EnteringScene)
    {
        [self.animation playAnimation:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
        return;
    }
    //******************
    
    //Implement below here
    if (self.currentState != Dead && self.currentState != Dying)
    {
        //Below code is to automatically find a new target if the object does not have any target yet
        if (self.currentTarget == nil)
        {
            self.currentTarget = [self findNewTarget:[NBCharacter getEnemyList:self]];
            
            if (self.currentTarget == nil)
                self.currentState = Idle;
            else
            {
                if ([self.name isEqualToString:TEST_OBJECT_NAME])
                    DLog(@"%@ found new target %@", self.name, self.currentTarget.name);
                
                self.currentState = Targetting;
            }
        }
        
        //You will mostly busy with this part of code
        //NBFireMage may not be moving at all, thus there may not be any moving code here.
        switch (self.currentState)
        {
            case Targetting:
            {
                if (self.currentTarget)
                    self.currentState = Engaged;
                
                break;
            }
            case Moving:
            {
                break;
            }
            case Engaged:
            {
                if (self.isAttackReady)
                {
                    self.currentState = Attacking;
                    [self attackWithAnimation:self.currentTarget withAnimation:@"Attack"];
                }
                
                break;
            }
            default:
                break;
        }
    }
}

//Events
-(void)onStateChangedTo:(EnumCharacterState)newState from:(EnumCharacterState)previousState
{
    [super onStateChangedTo:newState from:previousState];
    
    //Implement below here if necessary
}

-(void)onTouched
{
    [super onTouched];
    
    //Implement below here
}

-(void)onAttackCompleted
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ attack animation completed", self.name);
    
    self.animation.currentPlayingAnimation = @"";
    
    //Implement below here
    //Generally the code next is not to be changed, because onAttackCompleted actually means the animation is completed,
    //and the object is supposed to actually attack the target. This is where we use the currentTarget property.
    //For projectile shotting units like archer or mages, instead of actually attacks the target, may need to implement shootProjectile instead
    [self.animation useDefaultframe];
    [self shootProjectile];
}

//Programmers should implement the following 2 methods as all class type can be attacked by melee or projectiles.
//Attacked by magic may be added in the future.
-(void)onAttacked:(id)attacker
{
    //Implement below
    NBCharacter* tempAttacker = (NBCharacter*)attacker;
    int damage = (tempAttacker.attackPoint - self.defensePoint);
    self.hitPoint -= damage;
    
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ hit by %i damage. Current hit point = %i", self.name, damage, self.hitPoint);
    
    //Don't remove below
    [super onAttacked:attacker];
}

-(void)onAttackedByProjectile:(id)projectile
{
    //Implement below
    NBProjectile* tempAttacker = (NBProjectile*)projectile;
    int damage = (tempAttacker.power - self.defensePoint);
    self.hitPoint -= damage;
    
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ hit by %i damage. Current hit point = %i", self.name, damage, self.hitPoint);
    
    //Don't remove below
    [super onAttackedByProjectile:projectile];
}

-(void)onDeath
{
    [self dissapear];
}

@end
