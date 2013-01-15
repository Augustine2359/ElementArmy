//
//  NBStage.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 13/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBStage : NSObject

@property (nonatomic, retain) NSString* stageID;

@property (nonatomic, retain) CCSprite* worldIconAvailable;
@property (nonatomic, retain) CCSprite* worldIconCompleted;
@property (nonatomic, assign) CGPoint positionInWorldGrid;

@property (nonatomic, retain) CCArray* enemyList;

@end
