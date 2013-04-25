//
//  NBSoldier.m
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 17/9/12.
//
//

#import "NBCharacter.h"
#import "NBAudioManager.h"

#define SKILL_PROC_CHANCE 100

static CCArray* characterList = nil;
static CCArray* allyUnitList = nil;
static CCArray* enemyUnitList = nil;

@implementation NBCharacter

+(CCArray*)getEnemyListOf:(NBCharacter*)unit
{
    if (unit.characterSide == Ally) return enemyUnitList; else return allyUnitList;
}

+(CCArray*)getAllyListOf:(NBCharacter*)unit
{
    if (unit.characterSide == Ally) return allyUnitList; else return enemyUnitList;
}

+(CCArray*)getEnemyList
{
    return enemyUnitList;
}

+(CCArray*)getAllyList
{
    return allyUnitList;
}

+(CCArray*)getAllUnitList
{
    return characterList;
}

+(bool)calculateAttackSuccessWithAttacker:(NBCharacter*)attacker andDefender:(NBCharacter*)defender
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

+ (BOOL)isSkillProcSuccessful {
  NSInteger randomNumber = arc4random()%100;
  DLog(@"%d", randomNumber);
  return arc4random()%100 <= SKILL_PROC_CHANCE;
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

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData
{
    //My intention is to create an interface so that this class can be the generic class to be used in NBSquad. NBSquad does not need to know
    //about any of the specific class like NBSoldier o NBFireMage. So this method must be impleneted by sub class instead.
    
    return [[NBCharacter alloc] initWithFrameName:basicClassData.idleFrame andSpriteBatchNode:spriteBatchNode onLayer:layer onSide:side usingBasicClassData:basicClassData];
}

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData
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
    
    if (self == [super initWithFrameName:basicClassData.idleFrame andSpriteBatchNode:spriteBatchNode onLayer:layer])
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
    
    if (self.projectileArrayList)
    {
        NBProjectile* projectile;
        CCARRAY_FOREACH(self.projectileArrayList, projectile)
        {
            [projectile dealloc];
        }
    }
    
    [characterList removeObject:self];
    [super dealloc];
}

-(void)initialize
{
    currentAnimationName = @"";
    
    if (self.characterSide == Ally)
    {
        self.name = [NSString stringWithFormat:@"Ally%@%i", self.basicClassData.className, [characterList count]];
    }
    else
    {
        self.name = [NSString stringWithFormat:@"Enemy%@%i", self.basicClassData.className, [characterList count]];
    }
    
    deadEventTriggered = false;
    updateIsActive = false;
    self.isActive = true;
    
    self.basicClassData.level = self.basicClassData.startLevel;
    self.hitPoint = self.basicClassData.currentHP;
    self.spiritPoint = self.basicClassData.currentSP;
    self.attackPoint = self.basicClassData.currentSTR;
    self.defensePoint = self.basicClassData.currentDEF;
    self.intelligencePoint = self.basicClassData.currentINT;
    self.dexterityPoint = self.basicClassData.currentDEX;
    self.evasionPoint = self.basicClassData.currentEVA;
    
    self.initialHitPoint = self.hitPoint;
    self.initialSpiritPoint = self.spiritPoint;
    self.initialAttackPoint = self.attackPoint;
    self.initialDefensePoint = self.defensePoint;
    self.initialDexterityPoint = self.dexterityPoint;
    self.initialIntelligencePoint = self.intelligencePoint;
    self.initialEvasionPoint = self.evasionPoint;

    if (![self.basicClassData.passiveSkillName isEqualToString:@""])
    {
        NBSkill* skill = [NBDataManager getSkillBySkillName:self.basicClassData.passiveSkillName];
        
        if (skill.skillType == stPassive || skill.skillType == stPassiveRevolving)
            self.passiveSkill = skill;
        
        if (skill.skillType == stPassive)
        {
            [self applyPassiveBuffs];
        }
    }

    self.currentState = EnteringScene;
    self.basicSpeedPoint = OBJECT_SPEED_PIXEL_PER_SECOND;
    self.currentTarget = nil;
    self.timeUntilNextAttack = MAXIMUM_ATTACK_REFRESH_DURATION;
    
    //Add animation list here
    self.animation = [[NBAnimatedSprite alloc] initWithAnimationCount:50 withImagePointer:self.sprite];
    [self.animation addDefaultFrame:self.basicClassData.idleFrame];
    if (self.basicClassData.idleAnimFrame != nil && ![self.basicClassData.idleAnimFrame isEqualToString:@""])
        [self.animation addAnimation:@"Idle" withFileHeaderName:self.basicClassData.idleAnimFrame withAnimationCount:self.basicClassData.idleAnimFrameCount];
    if (self.basicClassData.attackAnimFrame != nil && ![self.basicClassData.attackAnimFrame isEqualToString:@""])
        [self.animation addAnimation:@"Attack" withFileHeaderName:self.basicClassData.attackAnimFrame withAnimationCount:self.basicClassData.attackAnimFrameCount];
    if (self.basicClassData.walkAnimFrame != nil && ![self.basicClassData.walkAnimFrame isEqualToString:@""])
        [self.animation addAnimation:@"Walk" withFileHeaderName:self.basicClassData.walkAnimFrame withAnimationCount:self.basicClassData.walkAnimFrameCount];
    if (self.basicClassData.shootAnimFrame != nil && ![self.basicClassData.shootAnimFrame isEqualToString:@""])
        [self.animation addAnimation:@"Shoot" withFileHeaderName:self.basicClassData.shootAnimFrame withAnimationCount:self.basicClassData.shootAnimFrameCount];
    
    //Preload your projectiles here
    if (self.basicClassData.attackType == atRange)
    {
        NBProjectileBasicData* projectileBasicData = nil;
        bool projectileFound = false;
        
        CCARRAY_FOREACH([NBDataManager getListOfProjectiles], projectileBasicData)
        {
            if ([projectileBasicData.projectileName isEqualToString:self.basicClassData.useProjectileName])
            {
                projectileFound = true;
                break;
            }
        }
        
        if (projectileFound)
        {
            self.projectileArrayList = [[CCArray alloc] initWithCapacity:MAXIMUM_PROJECTILE_COUNT];
            for (int i = 0; i < PROJECTILE_MAX_CAPACITY_PER_CHARACTER; i++)
            {
                NBProjectile* tempProjectile = [[NBProjectile alloc] initWithFrameName:projectileBasicData.idleFrame andSpriteBatchNode:self.currentSpriteBatchNode onLayer:self.currentLayer setOwner:self withBasicData:projectileBasicData];
                [tempProjectile initialize];
                
                if ([self.basicClassData.classType isEqualToString:@"INT"])
                {
                    tempProjectile.currentPower = self.intelligencePoint;
                    tempProjectile.currentSpeed = self.intelligencePoint;
                }
                else if ([self.basicClassData.classType isEqualToString:@"DEX"])
                {
                    tempProjectile.currentPower = self.dexterityPoint;
                    tempProjectile.currentSpeed = self.dexterityPoint;
                }
                
                tempProjectile.currentOwnerSide = self.characterSide;
                [self.projectileArrayList addObject:tempProjectile];
            }
        }
    }
    
    self.currentNumberOfMeleeEnemiesAttackingMe = 0;
    self.listOfEnemiesAttackingMe = [[CCArray alloc] initWithCapacity:50];
    self.listOfMeleeEnemiesAttackingMe = [[CCArray alloc] initWithCapacity:50];
    self.currentAttackPost = -1; //-1 means not in position
    
    [self setScale:self.basicClassData.scale];
    
    self.damageCounterLabel = [[CCLabelAtlas alloc]  initWithString:@"000" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
    self.damageCounterLabel.scale = 0.5;
    self.damageCounterLabel.visible = NO;
    [self.currentLayer addChild:self.damageCounterLabel];
    
    battleIsEngaged = false;
}

- (void)applyPassiveBuffs
{
    /*if ([self.basicClassData.className isEqualToString:@"metalsoldier"])
        self.attackPoint *= 1.5;*/
    
    CGFloat impactedStatusValue = 0.0f;
    
    if ([self.passiveSkill.statusImpacted isEqualToString:@"HP"])
    {
        impactedStatusValue = self.hitPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"SP"])
    {
        impactedStatusValue = self.spiritPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"ATK"])
    {
        impactedStatusValue = self.attackPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEF"])
    {
        impactedStatusValue = self.defensePoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"INT"])
    {
        impactedStatusValue = self.intelligencePoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEX"])
    {
        impactedStatusValue = self.dexterityPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"EVA"])
    {
        impactedStatusValue = self.evasionPoint;
    }
    else
    {
        DLog(@"error: unknown attribute while applying passive buff!!!");
        return;
    }
    
    if (self.passiveSkill.impactType == sitAdd)
    {
        impactedStatusValue = impactedStatusValue + self.passiveSkill.impactValue;
    }
    else if (self.passiveSkill.impactType == sitSubstract)
    {
        impactedStatusValue = impactedStatusValue - self.passiveSkill.impactValue;
    }
    else if (self.passiveSkill.impactType == sitMultiply)
    {
        impactedStatusValue = impactedStatusValue * self.passiveSkill.impactValue;
    }
    else if (self.passiveSkill.impactType == sitAdd)
    {
        impactedStatusValue = impactedStatusValue / self.passiveSkill.impactValue;
    }
    
    if ([self.passiveSkill.statusImpacted isEqualToString:@"HP"])
    {
        DLog(@"Passive buff applied for %@; HP changed from %d to %f", self.basicClassData.className, self.hitPoint, impactedStatusValue);
        self.hitPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"SP"])
    {
        DLog(@"Passive buff applied for %@; SP changed from %d to %f", self.basicClassData.className, self.spiritPoint, impactedStatusValue);
        self.spiritPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"ATK"])
    {
        DLog(@"Passive buff applied for %@; ATK changed from %d to %f", self.basicClassData.className, self.attackPoint, impactedStatusValue);
        self.attackPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEF"])
    {
        DLog(@"Passive buff applied for %@; DEF changed from %d to %f", self.basicClassData.className, self.defensePoint, impactedStatusValue);
        self.defensePoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"INT"])
    {
        DLog(@"Passive buff applied for %@; INT changed from %d to %f", self.basicClassData.className, self.intelligencePoint, impactedStatusValue);
        self.intelligencePoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEX"])
    {
        DLog(@"Passive buff applied for %@; DEX changed from %d to %f", self.basicClassData.className, self.dexterityPoint, impactedStatusValue);
        self.dexterityPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"EVA"])
    {
        DLog(@"Passive buff applied for %@; EVA changed from %d to %f", self.basicClassData.className, self.evasionPoint, impactedStatusValue);
        self.evasionPoint = impactedStatusValue;
    }
}

-(void)applyPassiveRevolvingSkill
{
    CGFloat impactedStatusValue = 0.0f;
    
    if ([self.passiveSkill.statusImpacted isEqualToString:@"HP"])
    {
        impactedStatusValue = self.hitPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"SP"])
    {
        impactedStatusValue = self.spiritPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"ATK"])
    {
        impactedStatusValue = self.attackPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEF"])
    {
        impactedStatusValue = self.defensePoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"INT"])
    {
        impactedStatusValue = self.intelligencePoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEX"])
    {
        impactedStatusValue = self.dexterityPoint;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"EVA"])
    {
        impactedStatusValue = self.evasionPoint;
    }
    else
    {
        DLog(@"error: unknown attribute while applying passive buff!!!");
        return;
    }
    
    if (self.passiveSkill.impactType == sitAdd)
    {
        impactedStatusValue = impactedStatusValue + self.passiveSkill.impactValue;
    }
    else if (self.passiveSkill.impactType == sitSubstract)
    {
        impactedStatusValue = impactedStatusValue - self.passiveSkill.impactValue;
    }
    else if (self.passiveSkill.impactType == sitMultiply)
    {
        impactedStatusValue = impactedStatusValue * self.passiveSkill.impactValue;
    }
    else if (self.passiveSkill.impactType == sitAdd)
    {
        impactedStatusValue = impactedStatusValue / self.passiveSkill.impactValue;
    }
    
    if ([self.passiveSkill.statusImpacted isEqualToString:@"HP"])
    {
        if (!self.passiveSkill.canExceedMaxValue && impactedStatusValue > self.initialHitPoint)
            impactedStatusValue = self.initialHitPoint;
        
        DLog(@"Passive buff applied for %@; HP changed from %d to %f", self.basicClassData.className, self.hitPoint, impactedStatusValue);
        self.hitPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"SP"])
    {
        if (!self.passiveSkill.canExceedMaxValue && impactedStatusValue > self.initialSpiritPoint)
            impactedStatusValue = self.initialSpiritPoint;
        
        DLog(@"Passive buff applied for %@; SP changed from %d to %f", self.basicClassData.className, self.spiritPoint, impactedStatusValue);
        self.spiritPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"ATK"])
    {
        if (!self.passiveSkill.canExceedMaxValue && impactedStatusValue > self.initialAttackPoint)
            impactedStatusValue = self.initialAttackPoint;
        
        DLog(@"Passive buff applied for %@; ATK changed from %d to %f", self.basicClassData.className, self.attackPoint, impactedStatusValue);
        self.attackPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEF"])
    {
        if (!self.passiveSkill.canExceedMaxValue && impactedStatusValue > self.initialDefensePoint)
            impactedStatusValue = self.initialDefensePoint;
        
        DLog(@"Passive buff applied for %@; DEF changed from %d to %f", self.basicClassData.className, self.defensePoint, impactedStatusValue);
        self.defensePoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"INT"])
    {
        if (!self.passiveSkill.canExceedMaxValue && impactedStatusValue > self.initialIntelligencePoint)
            impactedStatusValue = self.initialIntelligencePoint;
        
        DLog(@"Passive buff applied for %@; INT changed from %d to %f", self.basicClassData.className, self.intelligencePoint, impactedStatusValue);
        self.intelligencePoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"DEX"])
    {
        if (!self.passiveSkill.canExceedMaxValue && impactedStatusValue > self.initialDexterityPoint)
            impactedStatusValue = self.initialDexterityPoint;
        
        DLog(@"Passive buff applied for %@; DEX changed from %d to %f", self.basicClassData.className, self.dexterityPoint, impactedStatusValue);
        self.dexterityPoint = impactedStatusValue;
    }
    else if ([self.passiveSkill.statusImpacted isEqualToString:@"EVA"])
    {
        if (!self.passiveSkill.canExceedMaxValue && impactedStatusValue > self.initialEvasionPoint)
            impactedStatusValue = self.initialEvasionPoint;
        
        DLog(@"Passive buff applied for %@; EVA changed from %d to %f", self.basicClassData.className, self.evasionPoint, impactedStatusValue);
        self.evasionPoint = impactedStatusValue;
    }
}

-(void)update:(ccTime)delta
{
    [super update:delta];
    
    if (!updateIsActive) return;
    
    /*if ([self.name isEqualToString:TEST_OBJECT_NAME])
    {
        DLog(@"%@ is at position x = %f, y = %f", self.name, self.position.x, self.position.y);
    }*/
    
    NSString *currentStateString = @"Other Unknown";
    
    if (self.hitPoint <= 0 && self.currentState != Dying && self.currentState != Dead)
        [self dead];
    
    if (self.currentState != Dead && self.currentState != EnteringScene)
    {
        if (battleIsEngaged)
        {
            if (self.previousTarget)
            {
                if (self.previousTarget != self.currentTarget)
                {
                    [self.previousTarget onTargettedByMeleeReleased:self];
                }
            }
            
            if (!self.isAttackReady)
            {
                self.timeUntilNextAttack -= (self.dexterityPoint * delta * 30);
                
                if ([self.name isEqualToString:TEST_OBJECT_NAME])
                    DLog(@"debugging");
                
                if (self.timeUntilNextAttack <= 0)
                {
                    if ([self.name isEqualToString:TEST_OBJECT_NAME])
                        DLog(@"debugging");
                    self.isAttackReady = true;
                }
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
            
            if (self.currentState != Dead && self.currentState != Dying)
            {
                //Below code is to automatically find a new target if the object does not have any target yet
                if (self.currentTarget == nil)
                {
                    self.currentTarget = [self findNewTarget:[NBCharacter getEnemyListOf:self]];
                    
                    if (self.currentTarget == nil)
                        self.currentState = Idle;
                    else
                    {
    #if DEBUG
                        DLog(@"%@ found new target %@", self.name, self.currentTarget.name);
    #endif
                        
                        self.currentState = Targetting;
                        [self.currentTarget onTargettedBy:self]; //most of the time, you want this line of code be always there
                    }
                }
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
                    battleIsEngaged = true;
                    break;
                    
                case Targetting:
                    currentStateString = @"Targetting";
                    
                    if (self.basicClassData.attackType == atMelee)
                    {
                        if (![self.basicClassData.walkAnimFrame isEqualToString:@""])
                        {
                            [self changeAnimationTo:@"Walk" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                            //[self.animation playAnimation:@"Walk" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                        }
                        else
                        {
                            [self changeAnimationTo:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                            //[self.animation playAnimation:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                        }
                    }
                    
                    if (self.basicClassData.attackType == atMelee)
                    {
                        if (self.characterSide == Enemy && [self.listOfMeleeEnemiesAttackingMe count] > 0)
                        {
                            self.currentState = Waiting;
                        }
                        else
                        {
                            self.currentState = Moving;
                            [self MoveToPosition:[self.currentTarget getAttackedPosition:self] withDelta:delta setNextState:Engaged];
                        }
                    }
                    else if (self.basicClassData.attackType == atRange)
                    {
                        if (self.currentTarget)
                            self.currentState = Engaged;
                    }
                    
                    break;
                    
                case Engaging:
                    currentStateString = @"Engaging";
                    break;
                    
                case Engaged:
                    currentStateString = @"Engaged";
                    
                    if (self.isAttackReady)
                    {
                        if ([self.name isEqualToString:TEST_OBJECT_NAME])
                            DLog(@"debugging");
                        
                        self.currentState = Attacking;
                        [self attackWithAnimation:self.currentTarget withAnimation:@"Attack"];
                    }
                    
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
                    {
                        self.currentTarget = nil;
                        break;
                    }
                    
                    if (![self.basicClassData.walkAnimFrame isEqualToString:@""])
                    {
                        [self changeAnimationTo:@"Walk" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                        //[self.animation playAnimation:@"Walk" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                    }
                    else
                    {
                        [self changeAnimationTo:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                        //[self.animation playAnimation:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
                    }
                    
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
                }
                    break;
                    
                case Waiting:
                    currentStateString = @"Waiting";
                    
                    break;
                    
                default:
                    break;
            }
            
            if (battleIsEngaged)
            {
                if (self.passiveSkill && self.passiveSkill.skillType == stPassiveRevolving)
                {
                    passiveRevolvingRemainingTime -= (delta * 1000);  //Cause frequency is in milliseconds
                    
                    if (passiveRevolvingRemainingTime <= 0)
                    {
                        [self applyPassiveRevolvingSkill];
                        passiveRevolvingRemainingTime = self.passiveSkill.frequency;
                    }
                }
            }
        }
    }
    else
    {
        if (self.currentState == EnteringScene)
        {
            [self changeAnimationTo:@"Idle" withDelay:0.5 andRepeatForever:YES withTarget:nil andSelector:nil];
            self.currentState = Waiting;
        }
        else if (self.currentState == Dead)
        {
            if (self.visible) [self setVisible:NO];
        }
        
        if (self.currentTarget)
            [self.currentTarget onTargettedByMeleeReleased:self];
    }
    
    if (self.previousState != self.currentState)
    {
        [self onStateChangedTo:self.currentState from:self.previousState];
        self.previousState = self.currentState;
    }
    
    self.previousTarget = self.currentTarget;
    self.previousPosition = self.position;
}

-(void)changeAnimationTo:(NSString*)animationName withDelay:(CGFloat)delay andRepeatForever:(bool)repeat withTarget:(id)target andSelector:(SEL)selector
{
    if ([currentAnimationName isEqualToString:animationName]) return;
    
    [self.animation playAnimation:animationName withDelay:delay andRepeatForever:repeat withTarget:target andSelector:selector];
}

-(void)levelUp
{
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ level up", self.name);
}

-(void)attack:(NBCharacter*)target
{
    [self refreshAttackState];
    
    if (target.currentState == Dead || target.currentState == Dying)
    {
        self.currentTarget = nil;
        return;
        
    }
    //If melee type, this method is where the attack happen, but for range type, actually its the projectile that will register the attack.
    if (self.basicClassData.attackType == atMelee)
    {
        if (self.currentState != Dead && self.currentState != Dying)
        {
            if ([NBCharacter calculateAttackSuccessWithAttacker:self andDefender:target])
            {
                [[NBAudioManager sharedInstance] playSoundEffect:@"shoryuken.wav"];
                [target onAttacked:self];
            }

#warning need to know if attack must hit before skills are allowed to proc
            if ([NBCharacter isSkillProcSuccessful]) {
              if ([self.parent respondsToSelector:@selector(skillCastByCharacter:onCharacter:)])
                [self.parent performSelector:@selector(skillCastByCharacter:onCharacter:) withObject:self withObject:target];
            }
        }
    }
    
    //Below here are the same for both range and melee attacj type
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
        DLog(@"%@ commence attack on %@", self.name, target.name);
}

-(void)refreshAttackState
{
    int randomDelay = 300 - (arc4random() % self.dexterityPoint);
    
    self.timeUntilNextAttack = MAXIMUM_ATTACK_REFRESH_DURATION + randomDelay;
    self.isAttackReady = false;
    self.currentState = Engaged;
    
    if (self.currentTarget.hitPoint <= 0)
        self.currentState = Idle;
}

-(void)attackWithAnimation:(NBCharacter*)target withAnimation:(NSString*)animationName
{
    [self changeAnimationTo:animationName withDelay:0.25 andRepeatForever:NO withTarget:self andSelector:@selector(onAttackCompleted)];
    //[self.animation playAnimation:animationName withDelay:0.25 andRepeatForever:NO withTarget:self andSelector:@selector(onAttackCompleted)];
    self.currentTarget = target;
    
    if (self.basicClassData.attackType == atRange)
    {
        NBProjectile* tempProjectile;
        [[NBAudioManager sharedInstance] playSoundEffect:@"hadouken.wav"];
      
        CCARRAY_FOREACH(self.projectileArrayList, tempProjectile)
        {
            [tempProjectile setTargetLocation:self.currentTarget.position];
        }

        if ([NBCharacter isSkillProcSuccessful]) {
            if ([self.parent respondsToSelector:@selector(skillCastByCharacter:onCharacter:)])
                [self.parent performSelector:@selector(skillCastByCharacter:onCharacter:) withObject:self withObject:target];
        }
    }
}

-(void)shootProjectile
{
    NBProjectile* tempProjectile;
    
    //When Range type character shoots projectile, it actually does the following:
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
    [self attack:self.currentTarget];
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
    //[self.animation playAnimation:animationName withDelay:0.1 andRepeatForever:YES withTarget:nil andSelector:nil];
    [self changeAnimationTo:animationName withDelay:0.1 andRepeatForever:YES withTarget:nil andSelector:nil];
    [self moveToPosition:newPosition forDurationOf:duration];
}

-(void)moveToAttackTargetPosition:(NBCharacter*)target
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

-(NBCharacter*)findNewTarget:(CCArray*)enemyUnits
{
    NBCharacter* tempEnemy = nil;
    NBCharacter* resultEnemy = nil;
    float nearestDistance = 9999;
    
    CCARRAY_FOREACH(enemyUnits, tempEnemy)
    {
        if (self.basicClassData.attackType == atMelee)
        {
            if (tempEnemy.currentNumberOfMeleeEnemiesAttackingMe >= tempEnemy.basicClassData.maximumAttackedStack)
                continue;
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

-(CGPoint)getAttackedPosition:(NBCharacter*)attacker
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
    //DLog(@"%@ state changed from %i to %i", self.name, oldState, newState);
}

-(void)onMoveCompleted
{
    [super onMoveCompleted];
    [self useNextState];
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
    
    if (self.basicClassData.attackType == atRange)
    {
        [self shootProjectile];
    }
    else if (self.basicClassData.attackType == atMelee)
    {
        [self attack:self.currentTarget];
    }
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
    [[NBAudioManager sharedInstance] playSoundEffect:@"die.wav"];
    self.currentState = Dead;
    [self dissapear];
}

-(void)onAttacked:(id)attacker
{
    if (self.currentState == Dead)
        return;
    
    NBCharacter* tempAttacker = (NBCharacter*)attacker;
    
    int damage = (tempAttacker.attackPoint - self.defensePoint);
    self.hitPoint -= damage;

    if (self.facing == Left)
        [NBDamageLabel registerDamage:self.position withDamageAmount:damage toRight:YES];
    else
        [NBDamageLabel registerDamage:self.position withDamageAmount:damage toRight:NO];
    
    //if ([self.name isEqualToString:TEST_OBJECT_NAME])
    //    DLog(@"%@ hit by %i damage. Current hit point = %i", self.name, damage, self.hitPoint);
    
    if (self.currentState == Waiting)
    {
        self.currentState = Engaged;
    }
    
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
    //Implement below
    if (self.currentState == Dead)
        return;
    
    NBProjectile* tempProjectile = (NBProjectile*)projectile;
    int damage = (tempProjectile.currentPower - self.defensePoint);
    self.hitPoint -= damage;

    if (self.facing == Left)
        [NBDamageLabel registerDamage:self.position withDamageAmount:damage toRight:YES];
    else
        [NBDamageLabel registerDamage:self.position withDamageAmount:damage toRight:NO];
    
    //if ([self.name isEqualToString:TEST_OBJECT_NAME])
    //    DLog(@"%@ hit by %i damage. Current hit point = %i", self.name, damage, self.hitPoint);
    
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

- (void)onAttackedBySkillWithDamage:(NSInteger)damage {
  if (self.currentState == Dead)
    return;

  //assuming skills pierce resistance
  self.hitPoint -= damage;

  if (self.facing == Left)
    [NBDamageLabel registerDamage:self.position withDamageAmount:damage toRight:YES];
  else
    [NBDamageLabel registerDamage:self.position withDamageAmount:damage toRight:NO];

  //if ([self.name isEqualToString:TEST_OBJECT_NAME])
        //DLog(@"%@ hit by %i damage. Current hit point = %i", self.name, damage, self.hitPoint);

#if DEBUG
  DLog(@"%@ is attacked", self.name);
#endif

  if (self.hitPoint <= 0)
  {
    self.hitPoint = 0;
    self.currentState = Dead;
    [self dead];
  }
}

-(void)onTargetKilled:(id)target
{
    NBCharacter* tempTarget = (NBCharacter*)target;
    
    if ([self.name isEqualToString:TEST_OBJECT_NAME])
    {
        DLog(@"%@'s target, %@, is killed", self.name, tempTarget.name);
    }
    
    self.currentTarget = nil;
    self.currentState = Idle;
}

-(void)onTargettedBy:(id)attacker
{
    NBCharacter* attackerObject = (NBCharacter*)attacker;
    
    [self.listOfEnemiesAttackingMe addObject:attacker];
    
    if (attackerObject.basicClassData.attackType == atMelee)
    {
        self.currentNumberOfMeleeEnemiesAttackingMe++;
        
        NSInteger listOfPost[50];
        
        for (NSInteger i = 0; i < 50; i++)
            listOfPost[i] = 0;
        
        NBCharacter* tempAttackerObject = nil;
        
        if ([self.listOfMeleeEnemiesAttackingMe count] > 0)
        {
            for (int i = 0; i < [self.listOfMeleeEnemiesAttackingMe count]; i++)
            {
                tempAttackerObject = (NBCharacter*)[self.listOfMeleeEnemiesAttackingMe objectAtIndex:i];
                
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
    NBCharacter* attackerObject = (NBCharacter*)attacker;
    
    [self.listOfEnemiesAttackingMe removeObject:attacker];
    
    if (attackerObject.basicClassData.attackType == atMelee)
    {
        self.currentNumberOfMeleeEnemiesAttackingMe--;
        [self.listOfMeleeEnemiesAttackingMe removeObject:attacker];
    }
}

-(void)battleIsStarted
{
    battleIsEngaged = true;
    
    if (self.passiveSkill && self.passiveSkill.skillType == stPassiveRevolving)
    {
        passiveRevolvingRemainingTime = self.passiveSkill.frequency;
    }
}

-(void)battleIsOver
{
    battleIsEngaged = false;
}

@end
