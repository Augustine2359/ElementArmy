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

@end
