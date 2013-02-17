//
//  NBSoldierBoss.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 17/2/13.
//
//

#import "NBSoldierBoss.h"

@implementation NBSoldierBoss

-(void)initialize
{
    [super initialize];
    
    self.basicClassData.enemyType = etBoss;
    self.hitPoint = 1000;
}

-(void)update:(ccTime)delta
{
    //Don't change below
    //******************
    [super update:delta];
}

@end
