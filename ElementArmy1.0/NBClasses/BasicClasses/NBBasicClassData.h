//
//  NBBasicClassData.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBBasicClassData : NSObject

@property (nonatomic, retain) NSString* className;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int availableUnit;
@property (nonatomic, assign) int totalUnit;
@property (nonatomic, assign) NSDate* timeLastBattleCompleted;

@end
