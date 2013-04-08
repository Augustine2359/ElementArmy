//
//  NBBasicClassData.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/1/13.
//
//

#import "NBBasicClassData.h"

@implementation NBBasicClassData

-(id)init
{
    if (self = [super init])
    {
        self.className = @"empty";
        self.level = 1;
        self.availableUnit = 0;
        self.totalUnit = 0;
        self.timeLastBattleCompleted = [NSDate date];
        self.maximumAttackedStack = 1;
        self.attackType = atMelee;
        self.enemyType = etCommonEnemy;
        self.scale = 1;
    }
    
    return self;
}

-(NBBasicClassData*)copy
{
    NBBasicClassData* tempBasicData = [[NBBasicClassData alloc] init];
    
    NSData* tempData = [NSKeyedArchiver archivedDataWithRootObject:self.className];
    tempBasicData.className = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.classType];
    tempBasicData.classType = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.idleFrame];
    tempBasicData.idleFrame = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.idleAnimFrame];
    tempBasicData.idleAnimFrame = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.attackAnimFrame];
    tempBasicData.attackAnimFrame = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.walkAnimFrame];
    tempBasicData.walkAnimFrame = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.useProjectileName];
    tempBasicData.useProjectileName = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];

    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.activeSkillName];
    tempBasicData.activeSkillName = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempData = [NSKeyedArchiver archivedDataWithRootObject:self.passiveSkillName];
    tempBasicData.passiveSkillName = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    
    tempBasicData.startLevel = self.startLevel;
    tempBasicData.basicHP = self.basicHP;
    tempBasicData.basicSP = self.basicSP;
    tempBasicData.basicSTR = self.basicSTR;
    tempBasicData.basicDEF = self.basicDEF;
    tempBasicData.basicINT = self.basicINT;
    tempBasicData.basicDEX = self.basicDEX;
    tempBasicData.basicEVA = self.basicEVA;
    tempBasicData.minHPAdd = self.minHPAdd;
    tempBasicData.maxHPAdd = self.maxHPAdd;
    tempBasicData.minSPAdd = self.minSPAdd;
    tempBasicData.maxSPAdd = self.maxSPAdd;
    tempBasicData.minSTRAdd = self.minSTRAdd;
    tempBasicData.maxSTRAdd = self.maxSTRAdd;
    tempBasicData.minDEFAdd = self.minDEFAdd;
    tempBasicData.maxDEFAdd = self.maxDEFAdd;
    tempBasicData.minINTAdd = self.minINTAdd;
    tempBasicData.maxINTAdd = self.maxINTAdd;
    tempBasicData.minDEXAdd = self.minDEXAdd;
    tempBasicData.maxDEXAdd = self.maxDEXAdd;
    tempBasicData.minEVAAdd = self.minEVAAdd;
    tempBasicData.maxEVAAdd = self.maxEVAAdd;
    tempBasicData.maximumAttackedStack = self.maximumAttackedStack;
    tempBasicData.attackType = self.attackType;
    tempBasicData.isEnemy = self.isEnemy;
    tempBasicData.idleAnimFrameCount = self.idleAnimFrameCount;
    tempBasicData.attackAnimFrameCount = self.attackAnimFrameCount;
    tempBasicData.walkAnimFrameCount = self.walkAnimFrameCount;
    tempBasicData.shootAnimFrameCount = self.shootAnimFrameCount;
    
    tempBasicData.level = self.level;
    tempBasicData.currentHP = self.currentHP;
    tempBasicData.currentSP = self.currentSP;
    tempBasicData.currentSTR = self.currentSTR;
    tempBasicData.currentDEF = self.currentDEF;
    tempBasicData.currentINT = self.currentINT;
    tempBasicData.currentDEX = self.currentDEX;
    tempBasicData.currentEVA = self.currentEVA;
    tempBasicData.availableUnit = self.availableUnit;
    tempBasicData.totalUnit = self.totalUnit;
    tempBasicData.timeLastBattleCompleted = self.timeLastBattleCompleted;
    tempBasicData.enemyType = self.enemyType;
    tempBasicData.scale = self.scale;
    tempBasicData.battlePointsAward = self.battlePointsAward;
    
    return tempBasicData;
}

@end
