//
//  NBStageData.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 27/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBStageData : NSObject

+(NBStageData*)getStageDataByID:(NSString*)stageID;

@property (nonatomic, retain) NSString* stageID;
@property (nonatomic, retain) NSString* countryID;
@property (nonatomic, retain) NSString* availableNormalImageName;
@property (nonatomic, retain) NSString* availableDisabledImageName;
@property (nonatomic, retain) NSString* completedNormalImageName;
@property (nonatomic, retain) NSString* completedDisabledImageName;
@property (nonatomic, assign) CGPoint gridPoint;
@property (nonatomic, retain) CCArray* nextStageID;
@property (nonatomic, retain) CCArray* willUnlockStageID;
@property (nonatomic, retain) CCArray* connectedStageID;
@property (nonatomic, assign) bool isCompleted;
@property (nonatomic, assign) bool isUnlocked;
@property (nonatomic, assign) int winCount;
@property (nonatomic, assign) int loseCount;
@property (nonatomic, retain) CCArray* enemyList;

@end