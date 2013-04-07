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
#import "NBCountryData.h"
#import "NBStageData.h"

@interface NBDataManager : NSObject

+(id)dataManager;
-(NBStageData*)getStageDataByStageID:(NSString*)stageID;
-(void)createStages;
-(void)loadItemList;
-(void)saveStages;
-(void)saveItems;
-(void)createCharacterList;
-(void)createProjectileList;
-(void)loadEquipmentList;
-(void)loadSkillList;
-(void)loadPlayerData;
-(void)loadGameSettingData;

-(NBBasicClassData*)getBasicClassDataByClassName:(NSString*)className;

+(id)getSkillBySkillName:(NSString*)lookupName;
+(id)getItemDataByItemName:(NSString*)lookupName;
+(id)getEquipmentDataByEquipmentName:(NSString*)lookupName;
+(CCArray*)getListOfProjectiles;
+(CCArray*)getListOfCountries;
+(CCArray*)getListOfItems;
+(CCArray*)getListOfEquipments;

@property (nonatomic, retain) NSString* userID;
@property (nonatomic, retain) NSMutableDictionary* saveGameDictionary;

@property (nonatomic, retain) CCArray* listOfCreatedStagesID;
@property (nonatomic, retain) CCArray* listOfCompletedStageID;
@property (nonatomic, retain) CCArray* listOfUnlockedSkillID;
@property (nonatomic, retain) CCArray* listOfUnlockedItemID;
@property (nonatomic, retain) CCArray* listOfUnlockedWeaponID;

@property (nonatomic, retain) CCArray* listOfStages;
@property (nonatomic, retain) CCArray* listOfCharacters;
@property (nonatomic, retain) CCArray* listOfProjectiles;

@property (nonatomic, retain) NSString* currentStageID;
@property (nonatomic, retain) NBStageData* selectedStageData;
@property (nonatomic, retain) NBCountryData* selectedCountryData;
@property (nonatomic, retain) NSString* selectedItemID;
@property (nonatomic, assign) int numberOfItem;
@property (nonatomic, retain) NSString* selectedWeaponID;

@property (nonatomic, assign) long availableBattlePoint;
@property (nonatomic, assign) long availableGold;
@property (nonatomic, assign) long availableElementalGem;

@property (nonatomic, retain) CCArray* arrayOfAllySquad;
@property (nonatomic, retain) CCArray* arrayOfEnemySquad;
@property (nonatomic, retain) CCArray* selectedItems;

@property (nonatomic, retain) CCArray* selectedEquipments;

@property (nonatomic, assign) bool battleWon;

@end
