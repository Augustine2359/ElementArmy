//
//  NBCharacterV2.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/2/13.
//
//

#import "NBCharacterV2.h"

static CCArray* characterList = nil;
static CCArray* allyUnitList = nil;
static CCArray* enemyUnitList = nil;

@implementation NBCharacterV2

+(CCArray*)getEnemyList:(NBCharacterV2*)unit
{
    if (unit.characterSide == Ally) return enemyUnitList; else return allyUnitList;
}

+(CCArray*)getAllyList:(NBCharacterV2*)unit
{
    if (unit.characterSide == Ally) return allyUnitList; else return enemyUnitList;
}

+(CCArray*)getAllUnitList
{
    return characterList;
}

+(bool)calculateAttackSuccessWithAttacker:(NBCharacterV2*)attacker andDefender:(NBCharacterV2*)defender
{
    int totalDexAndEva = attacker.dexterityPoint + defender.evasionPoint;
    //DLog(@"totalDexAndEva = %i", totalDexAndEva);
    float attackSuccessThreshold = (attacker.dexterityPoint * 100) / totalDexAndEva;
    //DLog(@"attackSuccessThreshold = %f", attackSuccessThreshold);
    int randomNumber = arc4random() % 101;
    //DLog(@"randomNumber = %i", randomNumber);
    
    if (randomNumber < attackSuccessThreshold)
        return true;
    else
        return false;
}

-(void)setCharacterSide:(EnumCharacterSide)characterSide
{
    if (characterSide == Ally)
    {
        self.characterSideString = @"Ally";
        self.facing = Right;
    }
    else
    {
        self.characterSideString = @"Enemy";
        self.facing = Left;
    }
    
    _characterSide = characterSide;
}

-(long)getHitPoint
{
    return _hitPoint;
}

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData;
{
    //My intention is to create an interface so that this class can be the generic class to be used in NBSquad. NBSquad does not need to know
    //about any of the specific class like NBSoldier o NBFireMage. So this method must be impleneted by sub class instead.
    
    DLog(@"Cannot init directly using NBCharacter. Returning nil.");
    
    return nil;
}

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:basicClassData
{
    if (!characterList)
    {
        characterList = [[CCArray alloc] initWithCapacity:MAXIMUM_CHARACTER_CAPACITY];
    }
    
    if (!allyUnitList)
    {
        allyUnitList = [[CCArray alloc] initWithCapacity:MAXIMUM_CHARACTER_CAPACITY];
    }
    
    if (!enemyUnitList)
    {
        enemyUnitList = [[CCArray alloc] initWithCapacity:MAXIMUM_CHARACTER_CAPACITY];
    }
    
    if (self == [super initWithFrameName:frameName andSpriteBatchNode:spriteBatchNode onLayer:layer])
    {
        //self.sprite = [[CCSprite alloc] initWithSpriteFrameName:frameName];
        //[self addChild:self.sprite];
        self.basicClassData = basicClassData;
        self.characterSide = side;
        [self initialize];
        self.currentLayer = layer;
        self.objectIndex = [layer.children count];
        self.targetPreviousPosition = CGPointZero;
    }
    
    if (self.characterSide == Ally)
        [allyUnitList addObject:self];
    
    if (self.characterSide == Enemy)
        [enemyUnitList addObject:self];
    
    [characterList addObject:self];
    
    //[layer addChild:self z:[characterList count]];
    
    return self;
}

-(void)dealloc
{
    if (self.characterSide == Ally)
        [allyUnitList removeObject:self];
    
    if (self.characterSide == Enemy)
        [enemyUnitList removeObject:self];
    
    [characterList removeObject:self];
    [super dealloc];
}

-(void)initialize
{
    deadEventTriggered = false;
    updateIsActive = false;
    self.isActive = true;
    self.currentState = EnteringScene;
    self.basicSpeedPoint = OBJECT_SPEED_PIXEL_PER_SECOND;
    self.currentTarget = nil;
    self.timeUntilNextAttack = MAXIMUM_ATTACK_REFRESH_DURATION;
    self.animation = [[NBAnimatedSprite alloc] initWithAnimationCount:50 withImagePointer:self.sprite];
    self.projectileArrayList = [[CCArray alloc] initWithCapacity:MAXIMUM_PROJECTILE_COUNT];
    self.currentNumberOfMeleeEnemiesAttackingMe = 0;
    self.listOfEnemiesAttackingMe = [[CCArray alloc] initWithCapacity:50];
    self.listOfMeleeEnemiesAttackingMe = [[CCArray alloc] initWithCapacity:50];
    self.currentAttackPost = -1; //-1 means not in position
    
    [self setScale:self.basicClassData.scale];
}

-(void)update:(ccTime)delta
{
    [super update:delta];
    
    if (!updateIsActive) return;
    
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
    {
        DLog(@"%@ is at position x = %f, y = %f", self.name, self.position.x, self.position.y);
    }
    
    NSString *currentStateString = @"Other Unknown";
    
    if (self.hitPoint <= 0 && self.currentState != Dying && self.currentState != Dead)
        [self dead];
    
    if (self.previousTarget)
    {
        if (self.previousTarget != self.currentTarget)
        {
            [self.previousTarget onTargettedByMeleeReleased:self];
        }
    }
    
    if (self.currentState != Dead)
    {
        if (!self.isAttackReady)
        {
            self.timeUntilNextAttack -= (self.dexterityPoint * delta * 30);
            
#ifdef ENABLE_REMAINING_ATK_TIME_LOG
            if ([self.name isEqualToString:@"AllySoldier0"])
                DLog(@"remaining time until next attack = %f", self.timeUntilNextAttack);
#endif
            
            if (self.timeUntilNextAttack <= 0)
                self.isAttackReady = true;
        }
    }
    else
    {
        if (self.visible) [self setVisible:NO];
    }
    
    //Check if enemy is still alive
    if (self.currentTarget.hitPoint <= 0 || self.currentTarget.currentState == Dead)
    {
        self.currentTarget = nil;
        self.currentAttackPost = -1;
    }
    
    //Update facing
    if (self.currentTarget != nil)
    {
        if (self.currentTarget.position.x > self.position.x)
            self.facing = Right;
        else
            self.facing = Left;
    }
    else
    {
        if (self.characterSide == Ally)
            self.facing = Right;
        else
            self.facing = Left;
    }
    
    //Update Z
    if (self.position.y != self.previousPosition.y)
    {
        [self reorderMe:self.position.y];
    }
    
    switch (self.currentState)
    {
        case Unknown:
            // NOTHING
            currentStateString = @"Unknown";
            break;
            
        case Loaded:
            currentStateString = @"Loaded";
            break;
            
        case EnteringScene:
            currentStateString = @"EnteringScene";
            break;
            
        case Idle:
            currentStateString = @"Idle";
            break;
            
        case Marching:
            currentStateString = @"Marching";
            break;
            
        case Targetting:
            currentStateString = @"Targetting";
            break;
            
        case Engaging:
            currentStateString = @"Engaging";
            break;
            
        case Engaged:
            currentStateString = @"Engaged";
            break;
            
        case Attacking:
            currentStateString = @"Attacking";
            break;
            
        case Dying:
            currentStateString = @"Dying";
            break;
            
        case Dead:
        {
            currentStateString = @"Dead";
            [self stopAllActions];
        }
            break;
            
        case Retreating:
            currentStateString = @"Retreating";
            break;
            
        case Moving:
        {
            currentStateString = @"Moving";
            
            if (self.currentTarget.currentState == Dying || self.currentTarget.currentState == Dead)
                self.currentTarget = nil;
        }
            break;
            
        case Waiting:
            currentStateString = @"Waiting";
            
            break;
            
        default:
            break;
    }
    
    if (self.previousState != self.currentState)
    {
        [self onStateChangedTo:self.currentState from:self.previousState];
        self.previousState = self.currentState;
    }
    
    self.previousTarget = self.currentTarget;
    self.previousPosition = self.position;
}

-(void)levelUp
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ level up", self.name);
}

-(void)attack:(NBCharacterV2*)target
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ commence attack on %@", self.name, target.name);
    
    int randomDelay = 300 - (arc4random() % self.dexterityPoint);
    
    self.timeUntilNextAttack = MAXIMUM_ATTACK_REFRESH_DURATION + randomDelay;
    self.isAttackReady = false;
    self.currentState = Engaged;
    
    if (target.hitPoint <= 0)
        self.currentState = Idle;
}

-(void)attackWithAnimation:(NBCharacterV2*)target withAnimation:(NSString*)animationName
{
    [self.animation playAnimation:animationName withDelay:0.1 andRepeatForever:NO withTarget:nil andSelector:nil];
    //[self attack:target];
}

-(void)shootProjectile
{
    
}

-(void)useSkill:(NBSkill*)skill
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ activates skill %@", self.name, skill.skillName);
}

-(void)useMagic:(NBMagic*)magic
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ activates magic %@", self.name, magic.name);
}

-(void)moveToPosition:(CGPoint)newPosition forDurationOf:(float)duration
{
    CCCallFunc *callFunction = [CCCallFunc actionWithTarget:self selector:@selector(onMoveCompleted)];
    
    CCMoveTo* move = [CCMoveTo actionWithDuration:duration position:newPosition];
    CCSequence *sequence = [CCSequence actions:move, callFunction, nil];
    [self runAction:sequence];
}

-(void)moveToWithAnimation:(CGPoint)newPosition forDurationOf:(float)duration withAnimation:(NSString*)animationName
{
    [self.animation playAnimation:animationName withDelay:0.1 andRepeatForever:YES withTarget:nil andSelector:nil];
    [self moveToPosition:newPosition forDurationOf:duration];
}

-(void)moveToAttackTargetPosition:(NBCharacterV2*)target
{
    if ((self.targetPreviousPosition.x != target.position.x) || (self.targetPreviousPosition.y != target.position.y))
    {
        //[self stopAllActions];
        
        ccTime duration = ccpDistance(self.position, target.position) / self.dexterityPoint;
        [self moveToPosition:target.position forDurationOf:duration];
        
        self.targetPreviousPosition = target.position;
    }
}

-(void)MoveToPosition:(CGPoint)newPosition withDelta:(ccTime)delta setNextState:(EnumCharacterState)nextState
{
    self.nextState = nextState;
    [super moveToPosition:newPosition withDelta:delta];
}

-(void)startUpdate
{
    updateIsActive = true;
}

-(void)dead
{
    [self onBeforeDeath];
    [self onDeath];
}

-(void)appear
{
    [self.currentLayer addChild:self];
}

-(void)dissapear
{
    [self.currentLayer removeChild:self cleanup:NO];
}

-(NBCharacterV2*)findNewTarget:(CCArray*)enemyUnits
{
    NBCharacterV2* tempEnemy = nil;
    NBCharacterV2* resultEnemy = nil;
    float nearestDistance = 9999;
    
    CCARRAY_FOREACH(enemyUnits, tempEnemy)
    {
        if (self.basicClassData.attackType == atMelee)
        {
            if (tempEnemy.currentNumberOfMeleeEnemiesAttackingMe >= tempEnemy.basicClassData.maximumAttackedStack)
                return nil;
        }
        
        if (tempEnemy.currentState != Dead)
        {
            float distance = ccpDistance(self.position, tempEnemy.position);
            
            if (distance < nearestDistance)
            {
                nearestDistance = distance;
                resultEnemy = tempEnemy;
                [resultEnemy retain];
            }
        }
    }
    
    return resultEnemy;
}

-(CGPoint)getAttackedPosition:(NBCharacterV2*)attacker
{
    CGPoint tempPosition;
    CGFloat verticalGap = (self.sprite.contentSize.height / 2) / (self.basicClassData.maximumAttackedStack / 2);
    CGFloat yPos = 0;
    
    if (attacker.currentAttackPost == 0)
    {
        yPos = self.position.y;
    }
    else
    {
        if (fmodf(attacker.currentAttackPost, 2) == 0)
        {
            yPos = self.position.y - ((verticalGap * (attacker.currentAttackPost / 2)) * self.basicClassData.scale);
        }
        else
        {
            yPos = self.position.y + ((verticalGap * ((attacker.currentAttackPost + 1) / 2)) * self.basicClassData.scale);
        }
    }
    
    if (attacker.position.x < self.position.x)
    {
        tempPosition = CGPointMake(self.position.x - (attacker.sprite.contentSize.width * self.basicClassData.scale), yPos);
    }
    else
    {
        tempPosition = CGPointMake(self.position.x + (attacker.sprite.contentSize.width * self.basicClassData.scale), yPos);
    }
    
    return tempPosition;
}

-(void)useNextState
{
    self.currentState = self.nextState;
    self.nextState = Idle;
}

//Events
-(void)onTouched
{
    [super onTouched];
}

-(void)onStateChangedTo:(EnumCharacterState)newState from:(EnumCharacterState)oldState
{
    DLog(@"%@ state changed from %i to %i", self.name, oldState, newState);
}

-(void)onMoveCompleted
{
    [super onMoveCompleted];
    [self useNextState];
}

-(void)onAttackCompleted
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ attack completed", self.name);
}

-(void)onDying
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ dying state commenced", self.name);
}

-(void)onBeforeDeath
{
    
}

-(void)onDeath
{
#if DEBUG
    DLog(@"%@ is dead", self.name);
#endif
}

-(void)onAttacked:(id)attacker
{
    NBCharacterV2* tempAttacker = (NBCharacterV2*)attacker;
    
#if DEBUG
    //DLog(@"%@ is attacked", self.name);
#endif
    
    if (self.hitPoint <= 0)
    {
        self.hitPoint = 0;
        self.currentState = Dead;
        [tempAttacker onTargetKilled:self];
        [self dead];
    }
}

-(void)onAttackedByProjectile:(id)projectile
{
    NBProjectile* tempProjectile = (NBProjectile*)projectile;
    
#if DEBUG
    DLog(@"%@ is attacked", self.name);
#endif
    
    if (self.hitPoint <= 0)
    {
        self.hitPoint = 0;
        self.currentState = Dead;
        [(NBCharacter*)tempProjectile.currentOwner onTargetKilled:self];
        [self dead];
    }
}

-(void)onTargetKilled:(id)target
{
    NBCharacterV2* tempTarget = (NBCharacterV2*)target;
    
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
    {
        DLog(@"%@'s target, %@, is killed", self.name, tempTarget.name);
    }
    
    self.currentTarget = nil;
    self.currentState = Idle;
}

-(void)onTargettedBy:(id)attacker
{
    NBCharacterV2* attackerObject = (NBCharacterV2*)attacker;
    
    [self.listOfEnemiesAttackingMe addObject:attacker];
    
    if (attackerObject.basicClassData.attackType == atMelee)
    {
        self.currentNumberOfMeleeEnemiesAttackingMe++;
        
        NSInteger listOfPost[50];
        
        for (NSInteger i = 0; i < 50; i++)
            listOfPost[i] = 0;
        
        NBCharacterV2* tempAttackerObject = nil;
        
        if ([self.listOfMeleeEnemiesAttackingMe count] > 0)
        {
            for (int i = 0; i < [self.listOfMeleeEnemiesAttackingMe count]; i++)
            {
                tempAttackerObject = (NBCharacterV2*)[self.listOfMeleeEnemiesAttackingMe objectAtIndex:i];
                
                if (tempAttackerObject)
                {
                    listOfPost[tempAttackerObject.currentAttackPost] = 1;
                }
            }
            
            for (NSInteger i = 0; i < 50; i++)
            {
                if (listOfPost[i] == 0)
                {
                    if (i >= [self.listOfMeleeEnemiesAttackingMe count])
                    {
                        [self.listOfMeleeEnemiesAttackingMe addObject:attacker];
                    }
                    else
                    {
                        [self.listOfMeleeEnemiesAttackingMe insertObject:attacker atIndex:i];
                    }
                    
                    attackerObject.currentAttackPost = i;
                    break;
                }
            }
        }
        else
        {
            [self.listOfMeleeEnemiesAttackingMe addObject:attacker];
            attackerObject.currentAttackPost = 0; //first to attack the target
        }
        
        if (self.currentTarget == attackerObject)
        {
            attackerObject.currentAttackPost = 0;
            self.currentAttackPost = 0;
        }
    }
}

-(void)onTargettedByMeleeReleased:(id)attacker
{
    NBCharacterV2* attackerObject = (NBCharacterV2*)attacker;
    
    [self.listOfEnemiesAttackingMe removeObject:attacker];
    
    if (attackerObject.basicClassData.attackType == atMelee)
    {
        self.currentNumberOfMeleeEnemiesAttackingMe--;
        [self.listOfMeleeEnemiesAttackingMe removeObject:attacker];
    }
}

@end
