//
//  NBDataManager.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBBasicClassData.h"

@interface NBDataManager : NSObject

+(id)dataManager;

@property (nonatomic, retain) NSString* userID;

@property (nonatomic, retain) CCArray* listOfCreatedStagesID;
@property (nonatomic, retain) CCArray* listOfCompletedStageID;
@property (nonatomic, retain) CCArray* listOfUnlockedSkillID;
@property (nonatomic, retain) CCArray* listOfUnlockedItemID;
@property (nonatomic, retain) CCArray* listOfUnlockedWeaponID;

@property (nonatomic, retain) NSString* currentStageID;
@property (nonatomic, retain) NSString* selectedStageID;
@property (nonatomic, retain) NSString* selectedItemID;
@property (nonatomic, assign) int numberOfItem;
@property (nonatomic, retain) NSString* selectedWeaponID;

@property (nonatomic, assign) long availableBattlePoint;
@property (nonatomic, assign) long availableGold;
@property (nonatomic, assign) long availableElementalGem;

@property (nonatomic, retain) CCArray* arrayOfAllySquad;
@property (nonatomic, retain) CCArray* arrayOfEnemySquad;

@end
