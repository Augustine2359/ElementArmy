//
//  NBSquad.m
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 14/10/12.
//
//

#import "NBSquad.h"

@implementation NBSquad

static int squadPerSide = 2;
static int battleFieldWidth = 0;
static int battleFieldHeight = 0;
static int objectCount = 0;
static int allySquadPositionIndex = 0;
static int enemySquadPositionIndex = 0;

+(void)resetSquadPositionIndex
{
    allySquadPositionIndex = 0;
    enemySquadPositionIndex = 0;
}

+(void)setupBatteFieldDimension:(CGSize)size
{
    battleFieldWidth = size.width;
    battleFieldHeight = size.height;
}

+(void)setSquadPerSide:(int)squadCount
{
    squadPerSide = squadCount;
}

-(id)createSquadOf:(NSString*)unitClassName withUnitCount:(int)count onSide:(EnumCharacterSide)side andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer
{
    int unitCount;
    
    if (count > MAXIMUM_UNIT_COUNT)
    {
        unitCount = MAXIMUM_UNIT_COUNT;
    }
    else if (count <= 0)
    {
        return nil;
    }
    else
    {
        unitCount = count;
    }

    //Determine padding pixel between units
    int tempXPadding = ((battleFieldWidth * FIRST_UNIT_X_FRONTLINE_PERCENTAGE) - (battleFieldWidth * FIRST_UNIT_X_BACKLINE_PERCENTAGE)) / squadPerSide;
    int tempYPadding = (battleFieldHeight - ((battleFieldHeight * FIRST_UNIT_Y_BOTTOM_PERCENTAGE) + TOP_BATTLEFIELD_PADDING)) / (unitCount + 1);
    
    if (self = [super init])
    {
        //If battlefield size has not been setup (0 and cannot be smaller than w(480) h(320), inform debug and exit
        if ((battleFieldWidth < 480) || (battleFieldHeight < 320))
        {
            DLog(@"Please setup battlefield dimension before creating squad unit.");
            return nil;
        }
        
        if (side == Ally)
            self.squadPositionIndex = allySquadPositionIndex++;
        else
            self.squadPositionIndex = enemySquadPositionIndex++;
        
        //Guard the position index
        if (allySquadPositionIndex > squadPerSide) allySquadPositionIndex = MAXIMUM_SQUAD_PER_SIDE;
        if (enemySquadPositionIndex > squadPerSide) enemySquadPositionIndex = MAXIMUM_SQUAD_PER_SIDE;
            
        
        //There can be only 4 layers of squad fo now. Perhaps for a more epid battle, we can increase this in the future.
        if (self.squadPositionIndex > MAXIMUM_SQUAD_PER_SIDE)
        {
            DLog(@"Cannot create more squad unit more than %i at this moment.", MAXIMUM_SQUAD_PER_SIDE);
            return nil;
        }
        
        self.skillSlot = [[CCArray alloc] initWithCapacity:MAGIC_SLOT_CAPACITY];
        self.unitArray = [[CCArray alloc] initWithCapacity:MAXIMUM_UNIT_COUNT];
        
        self.unitClass = NSClassFromString(unitClassName);
        for (int i = 0; i < unitCount; i++)
        {
            id tempCharacter = [[self.unitClass alloc] initWithSpriteBatchNode:spriteBatchNode onLayer:layer onSide:side];
            
            //[layer addChild:tempCharacter z:0 tag:[tempCharacter objectIndex]];
            [self.unitArray addObject:tempCharacter];
            
            if (side == Ally)
            {
                [tempCharacter setPosition:CGPointMake((battleFieldWidth * FIRST_UNIT_X_FRONTLINE_PERCENTAGE) - (tempXPadding * self.squadPositionIndex), (battleFieldHeight * FIRST_UNIT_Y_BOTTOM_PERCENTAGE)/* - (i * 10) */+ ((i + 1) * tempYPadding))];
            }
            else
            {
                [tempCharacter setPosition:CGPointMake(battleFieldWidth - (battleFieldWidth * FIRST_UNIT_X_FRONTLINE_PERCENTAGE) + (tempXPadding * self.squadPositionIndex), (battleFieldHeight * FIRST_UNIT_Y_BOTTOM_PERCENTAGE) + ((i + 1) * tempYPadding))];
            }
            
            objectCount++;
            self.totalAliveUnitHP += [tempCharacter getHitPoint];
            self.totalCurrentAliveUnit++;
        }
        
        self.allUnitAreDead = false;
    }
    
    return self;
}

-(void)dealloc
{
    NBCharacter* characterObject;
    
    CCARRAY_FOREACH(self.unitArray, characterObject)
    {
        [characterObject dealloc];
    }
    
    [super dealloc];
}

-(void)update
{
    self.allUnitAreDead = true;
    self.totalAliveUnitHP = 0;
    self.totalCurrentAliveUnit = 0;
    
    for (int i = 0; i < [self.unitArray count]; i++)
    {
        id tempUnit = [self.unitArray objectAtIndex:i];
        
        NBCharacter* tempCharacter = (NBCharacter*)tempUnit;
        
        self.totalAliveUnitHP += tempCharacter.hitPoint;
        
        if (tempCharacter.currentState != Dead)
        {
            self.allUnitAreDead = false;
            self.totalCurrentAliveUnit++;
        }
    }
}

-(void)updateWithAllyUnits:(CCArray*)allySquads andEnemyUnits:(CCArray*)enemySquads withDelta:(ccTime)delta
{
    NBSquad* tempSquad;
    
    self.allUnitAreDead = true;
    self.totalAliveUnitHP = 0;
    
    CCARRAY_FOREACH(enemySquads, tempSquad)
    {
        for (int i = 0; i < [self.unitArray count]; i++)
        {
            id tempUnit = [self.unitArray objectAtIndex:i];
            [tempUnit updateWithAllyUnits:self.unitArray andEnemyUnits:tempSquad.unitArray withDelta:delta];
            
            NBCharacter* tempCharacter = (NBCharacter*)tempUnit;
            
            self.totalAliveUnitHP += tempCharacter.hitPoint;
            
            if (tempCharacter.currentState != Dead)
            {
                self.allUnitAreDead = false;
            }
            
            [tempCharacter setZOrder:i + 1];

            for (int j = i - 1; j >= 0; i--)
            {
                id tempUnit1 = [self.unitArray objectAtIndex:j];
                [tempUnit1 updateWithAllyUnits:self.unitArray andEnemyUnits:tempSquad.unitArray withDelta:delta];
                
                NBCharacter* tempCharacter1 = (NBCharacter*)tempUnit1;
                
                if (tempCharacter.position.y > tempCharacter1.position.y)
                {
                    [tempCharacter setZOrder:(tempCharacter.zOrder - 1)];
                    [tempCharacter1 setZOrder:(tempCharacter1.zOrder + 1)];
                }
            }
            
            DLog(@"ZORDER = %i", tempCharacter.zOrder);
        }
    }
}

-(void)startUpdate
{
    for (int i = 0; i < [self.unitArray count]; i++)
    {
        id tempUnit = [self.unitArray objectAtIndex:i];
        [tempUnit startUpdate];
    }
}

@end
