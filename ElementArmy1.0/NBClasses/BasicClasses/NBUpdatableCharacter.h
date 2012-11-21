//
//  NBUpdatableCharacter.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 21/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol NBUpdatableCharacter <NSObject>

-(void)updateWithAllyUnits:(CCArray*)allyUnits andEnemyUnits:(CCArray*)enemyUnits withDelta:(ccTime)delta;
-(void)onGetMessage;
-(void)onBeforeDeath;

@end
