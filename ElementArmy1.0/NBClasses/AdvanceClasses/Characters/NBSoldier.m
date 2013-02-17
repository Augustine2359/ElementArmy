//
//  NBSoldier.m
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 30/9/12.
//
// Notes:
// - All DLog is mostly covered by this if condition "if ([self.name isEqualToString:TEST_OBJECT_NAME])"
//   reason is because sometimes we want to track only 1 object, and so that the debugger log would not be too flooded
// - You can define your own log definition if needed. Take a look at the example on NBCharacter where I defined ENABLE_REMAINING_ATK_TIME_LOG
//   the reason is i would like to be able to turn on and off the remaining time for attack log which is a lot

#import "NBSoldier.h"

//For all of your derived object, create its own array list as static. This static object can be used outside the class for other purpose
static CCArray* soldierList = nil;

@implementation NBSoldier

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData
{
    //Implement below, but mostly you would be only changing the sprite name
    if (!soldierList)
    {
        soldierList = [[CCArray alloc] initWithCapacity:MAXIMUM_SOLDIER_CAPACITY];
    }
    
    self = [super initWithFrameName:METAL_SOLDIER_FILE andSpriteBatchNode:spriteBatchNode onLayer:layer onSide:(EnumCharacterSide)side usingBasicClassData:basicClassData];
    
    [soldierList addObject:self];
    
    return self;
}

-(void)dealloc
{
    //Don't change below at this moment, HOWEVER, if you do allocate array for your own use, please dealloc here as well
    [soldierList removeObject:self];
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
        self.name = [NSString stringWithFormat:@"Ally%@%i", NSStringFromClass([self class]), [soldierList count]];
    }
    else
    {
        self.name = [NSString stringWithFormat:@"Enemy%@%i", NSStringFromClass([self class]), [soldierList count]];
    }
    
    DLog(@"%@ added", self.name);
    //*****************************
    
    //Initialize your class here
    //Add animation list here
    [self.animation addDefaultFrame:METAL_SOLDIER_FILE];
    [self.animation addAnimation:@"Idle" withFileHeaderName:METAL_SOLDIER_FILE_IDLE withAnimationCount:2];
    [self.animation addAnimation:@"Attack" withFileHeaderName:METAL_SOLDIER_FILE_ATTACK withAnimationCount:2];
    
    //Set basic attributes value below
    self.basicClassData.level = 1;
    self.basicClassData.maximumAttackedStack = 6;
    self.hitPoint = 100;
    self.spiritPoint = 100;
    self.attackPoint = 20;
    self.defensePoint = 10;
    self.dexterityPoint = 100;
    self.intelligencePoint = 10;
    self.evasionPoint = 5;
}

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

-(void)attackWithAnimation:(NBCharacter*)target withAnimation:(NSString*)animationName
{
    //Implement below (potentially no change)
    [self.animation playAnimation:animationName withDelay:0.25 andRepeatForever:NO withTarget:self andSelector:@selector(onAttackCompleted)];
    //The reason adding the target to the property is to keep a track on which target is currently active for this object as the target cannot be added as argument on the selector
    self.currentTarget = target;
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
                [self.currentTarget onTargettedBy:self]; //most of the time, you want this line of code be always there
            }
        }
        
        //You will mostly busy with this part of code
        switch (self.currentState)
        {
            case Targetting:
            {
                [self.animation playAnimation:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                
                //if (self.characterSide == Ally || (self.characterSide == Enemy && (self.basicClassData.enemyType != etBoss && self.basicClassData.enemyType != etSecretBoss)))
                //{
                    self.currentState = Moving;
                    [self MoveToPosition:[self.currentTarget getAttackedPosition:self] withDelta:delta setNextState:Engaged];
                /*}
                else
                {
                    self.currentState = Waiting;
                }*/
                
                break;
            }
            case Moving:
            {
                [self.animation playAnimation:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                
                CGFloat distance = ccpDistance(self.position, self.currentTarget.position);
                
                if (distance < 50)
                {
                    if ((self.characterSide == Ally) || (self.currentNumberOfMeleeEnemiesAttackingMe < 1))
                    {
                        [self MoveToPosition:[self.currentTarget getAttackedPosition:self] withDelta:delta setNextState:Engaged];
                    }
                    else
                    {
                        self.currentState = Waiting;
                    }
                }
                else
                {
                    [self MoveToPosition:[self.currentTarget getAttackedPosition:self] withDelta:delta setNextState:Engaged];
                }
                
                break;
            }
            case Waiting:
                break;
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
    [self attack:self.currentTarget];
}

-(void)onAttacked:(id)attacker
{
    //Implement below
    NBCharacter* tempAttacker = (NBCharacter*)attacker;
    int damage = (tempAttacker.attackPoint - self.defensePoint);
    self.hitPoint -= damage;
    
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ hit by %i damage. Current hit point = %i", self.name, damage, self.hitPoint);
    
    if (self.currentState == Waiting)
    {
        self.currentState = Engaged;
    }
    
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
