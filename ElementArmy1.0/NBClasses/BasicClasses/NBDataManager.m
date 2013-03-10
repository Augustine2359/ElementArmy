//
//  NBDataManager.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/1/13.
//
//

#import "NBDataManager.h"
#import "NBStage.h"
#import "NBStageData.h"
#import "NBItemData.h"
#import "NBProjectileBasicData.h"

#define SQUAD_COUNT_ALLOWED 3

static NBDataManager* dataManager = nil;
static CCArray* listOfProjectiles = nil;

@implementation NBDataManager

+(id)dataManager
{
    if (dataManager)
        return dataManager;
    else
    {
        dataManager = [[NBDataManager alloc] init];
        return dataManager;
    }
}

-(id)init
{
    if ((self = [super init]))
    {
        self.arrayOfAllySquad = [CCArray arrayWithCapacity:SQUAD_COUNT_ALLOWED];
        self.arrayOfEnemySquad = [CCArray arrayWithCapacity:SQUAD_COUNT_ALLOWED];
        self.listOfCreatedStagesID = [CCArray arrayWithCapacity:100];
        self.listOfCharacters = [[CCArray alloc] initWithCapacity:100];
        listOfProjectiles = [[CCArray alloc] initWithCapacity:50];

        //[self createStages];
        [self createItems];
        
        self.selectedItems = [CCArray arrayWithCapacity:3];
        self.selectedEquipments = [CCArray arrayWithCapacity:3];
    }

    return self;
}

-(NBStageData*)getStageDataByStageID:(NSString*)stageID
{
    NBStageData* stageData = nil;
    
    CCARRAY_FOREACH(self.listOfCreatedStagesID, stageData)
    {
        if ([stageData.stageID isEqualToString:stageID])
        {
            return stageData;
        }
    }
    
    return nil;
}

-(void)createStages
{
    NBBasicClassData* basicClassData = nil;
    CCArray* arrayOfEnemyData = nil;
    
    self.listOfStages = [CCArray array];

    //read from the app documents directory
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"GameSettings.plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    dictionary = nil;
    
    //if it doesn't exist yet, use the default one
    if (dictionary == nil) {
      plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
      dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }

    NSArray *stages = [dictionary objectForKey:@"Stage data"];
    
    for (NSDictionary *stageDataDictionary in stages)
    {
        NBStageData *stageData = [[NBStageData alloc] init];
        stageData.stageID = [stageDataDictionary objectForKey:@"stageID"];
        stageData.stageName = [stageDataDictionary objectForKey:@"stageName"];
        stageData.countryID = [stageDataDictionary objectForKey:@"countryID"];
        stageData.availableNormalImageName = [stageDataDictionary objectForKey:@"availableNormalImageName"];
        stageData.availableDisabledImageName = [stageDataDictionary objectForKey:@"availableDisabledImageName"];
        stageData.completedNormalImageName = [stageDataDictionary objectForKey:@"completedNormalImageName"];
        stageData.completedDisabledImageName = [stageDataDictionary objectForKey:@"completedDisabledImageName"];
        CGFloat gridPointX = [[[stageDataDictionary objectForKey:@"gridPoint"] objectForKey:@"x"] floatValue];
        CGFloat gridPointY = [[[stageDataDictionary objectForKey:@"gridPoint"] objectForKey:@"y"] floatValue];
        stageData.gridPoint = CGPointMake(gridPointX, gridPointY);
        NSArray* tempArray = [stageDataDictionary objectForKey:@"nextStageID"];
        stageData.nextStageID = [CCArray arrayWithNSArray:tempArray];
        tempArray = [stageDataDictionary objectForKey:@"willUnlockStageID"];
        stageData.willUnlockStageID = [CCArray arrayWithNSArray:tempArray];
        stageData.isCompleted = [[stageDataDictionary objectForKey:@"isCompleted"] boolValue];
        stageData.isUnlocked = [[stageDataDictionary objectForKey:@"isUnlocked"] boolValue];
        
        NSArray* enemyList = [stageDataDictionary objectForKey:@"Enemy List"];
        
        if (enemyList)
        {
            arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
            
            for (NSDictionary* enemy in enemyList)
            {
                basicClassData = [[NBDataManager dataManager] getBasicClassDataByClassName:[enemy objectForKey:@"enemyClass"]];
                basicClassData.level = [[enemy objectForKey:@"level"] integerValue];
                basicClassData.totalUnit = 1;
                basicClassData.availableUnit = 1;
                basicClassData.timeLastBattleCompleted = [NSDate date];
                basicClassData.scale = [[enemy objectForKey:@"scale"] floatValue];
                if (basicClassData.scale == 0) basicClassData.scale = 1;
                basicClassData.currentHP = [[[enemy objectForKey:@"attributes"] objectForKey:@"HP"] intValue];
                basicClassData.currentSP = [[[enemy objectForKey:@"attributes"] objectForKey:@"SP"] intValue];
                basicClassData.currentSTR = [[[enemy objectForKey:@"attributes"] objectForKey:@"STR"] intValue];
                basicClassData.currentDEF = [[[enemy objectForKey:@"attributes"] objectForKey:@"DEF"] intValue];
                basicClassData.currentINT = [[[enemy objectForKey:@"attributes"] objectForKey:@"INT"] intValue];
                basicClassData.currentDEX = [[[enemy objectForKey:@"attributes"] objectForKey:@"DEX"] intValue];
                basicClassData.currentEVA = [[[enemy objectForKey:@"attributes"] objectForKey:@"EVA"] intValue];
                
                [arrayOfEnemyData addObject:basicClassData];
            }
        }
        
        stageData.enemyList = arrayOfEnemyData;
        
        NBStage *stage = [NBStage createStageWithStageData:stageData];
        [self.listOfStages addObject:stage];
    }
}

-(void)createItems
{
    self.listOfItems = [CCArray array];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *items = [dictionary objectForKey:@"Item data"];
    
    for (NSDictionary *itemDataDictionary in items)
    {
        NBItemData *itemData = [[NBItemData alloc] init];
        itemData.itemID = [itemDataDictionary objectForKey:@"itemID"];
        [self.listOfItems addObject:itemData];
    }
}

-(void)createCharacterList
{
    if (!self.listOfCharacters) self.listOfCharacters = [CCArray array];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *characters = [dictionary objectForKey:@"Character data"];
    
    for (NSDictionary *characterDataDictionary in characters)
    {
        NBBasicClassData *characterData = [[NBBasicClassData alloc] init];
        characterData.className = [characterDataDictionary objectForKey:@"className"];
        characterData.classType = [characterDataDictionary objectForKey:@"classType"];
        characterData.startLevel = [[characterDataDictionary objectForKey:@"startLevel"] intValue];
        characterData.basicHP = [[characterDataDictionary objectForKey:@"basicHP"] intValue];
        characterData.basicSP = [[characterDataDictionary objectForKey:@"basicSP"] intValue];
        characterData.basicSTR = [[characterDataDictionary objectForKey:@"basicSTR"] intValue];
        characterData.basicDEF = [[characterDataDictionary objectForKey:@"basicDEF"] intValue];
        characterData.basicINT = [[characterDataDictionary objectForKey:@"basicINT"] intValue];
        characterData.basicDEX = [[characterDataDictionary objectForKey:@"basicDEX"] intValue];
        characterData.basicEVA = [[characterDataDictionary objectForKey:@"basicEVA"] intValue];
        characterData.minHPAdd = [[characterDataDictionary objectForKey:@"minHPAdd"] intValue];
        characterData.maxHPAdd = [[characterDataDictionary objectForKey:@"maxHPAdd"] intValue];
        characterData.minSPAdd = [[characterDataDictionary objectForKey:@"minSPAdd"] intValue];
        characterData.maxSPAdd = [[characterDataDictionary objectForKey:@"maxSPAdd"] intValue];
        characterData.minSTRAdd = [[characterDataDictionary objectForKey:@"minSTRAdd"] intValue];
        characterData.maxSTRAdd = [[characterDataDictionary objectForKey:@"maxSTRAdd"] intValue];
        characterData.minDEFAdd = [[characterDataDictionary objectForKey:@"minDEFAdd"] intValue];
        characterData.maxDEFAdd = [[characterDataDictionary objectForKey:@"maxDEFAdd"] intValue];
        characterData.minINTAdd = [[characterDataDictionary objectForKey:@"minINTAdd"] intValue];
        characterData.maxINTAdd = [[characterDataDictionary objectForKey:@"maxINTAdd"] intValue];
        characterData.minDEXAdd = [[characterDataDictionary objectForKey:@"minDEXAdd"] intValue];
        characterData.maxDEXAdd = [[characterDataDictionary objectForKey:@"maxDEXAdd"] intValue];
        characterData.minEVAAdd = [[characterDataDictionary objectForKey:@"minEVAAdd"] intValue];
        characterData.maxEVAAdd = [[characterDataDictionary objectForKey:@"maxEVAAdd"] intValue];
        characterData.attackType = [[characterDataDictionary objectForKey:@"attackType"] intValue];
        characterData.maximumAttackedStack = [[characterDataDictionary objectForKey:@"maximumAttackedStack"] intValue];
        characterData.idleFrame = [[characterDataDictionary objectForKey:@"frames"] objectForKey:@"idleFrame"];
        characterData.idleAnimFrame = [[characterDataDictionary objectForKey:@"frames"] objectForKey:@"idleAnimFrame"];
        characterData.idleAnimFrameCount = [[[characterDataDictionary objectForKey:@"frames"] objectForKey:@"idleAnimFrameCount"] shortValue];
        characterData.attackAnimFrame = [[characterDataDictionary objectForKey:@"frames"] objectForKey:@"attackAnimFrame"];
        characterData.attackAnimFrameCount = [[[characterDataDictionary objectForKey:@"frames"] objectForKey:@"attackAnimFrameCount"] shortValue];
        characterData.shootAnimFrame = [[characterDataDictionary objectForKey:@"frames"] objectForKey:@"shootAnimFrame"];
        characterData.shootAnimFrameCount = [[[characterDataDictionary objectForKey:@"frames"] objectForKey:@"shootAnimFrameCount"] shortValue];
        
        characterData.currentHP = characterData.basicHP;
        characterData.currentSP = characterData.basicSP;
        characterData.currentSTR = characterData.basicSTR;
        characterData.currentDEF = characterData.basicDEF;
        characterData.currentINT = characterData.basicINT;
        characterData.currentDEX = characterData.basicDEX;
        characterData.currentEVA = characterData.basicEVA;
        
        characterData.useProjectileName = [characterDataDictionary objectForKey:@"useProjectileName"];
        
        [self.listOfCharacters addObject:characterData];
    }
}

-(void)createProjectileList
{
    if (!listOfProjectiles) listOfProjectiles = [CCArray array];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *projectiles = [dictionary objectForKey:@"Projectile data"];
    
    for (NSDictionary *projectileDataDictionary in projectiles)
    {
        NBProjectileBasicData* projectileData = [[NBProjectileBasicData alloc] init];
        projectileData.projectileName = [projectileDataDictionary objectForKey:@"projectileName"];
        projectileData.idleFrame = [projectileDataDictionary objectForKey:@"idleFrame"];
        projectileData.defaultPower = [[projectileDataDictionary objectForKey:@"defaultPower"] intValue];
        projectileData.defaultSpeed = [[projectileDataDictionary objectForKey:@"defaultSpeed"] intValue];
        projectileData.shootType = [[projectileDataDictionary objectForKey:@"projectileShootType"] intValue];
        
        [listOfProjectiles addObject:projectileData];
    }
}

- (void)saveStages
{
    if (self.listOfStages == nil)
        return;
    
  //Grab the default stage data
  NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
  NSArray *stages = [dictionary objectForKey:@"Stage data"];

  NSInteger index = 0;
  for (NSMutableDictionary *stageDataDictionary in stages) {
    NBStage *stage = [self.listOfStages objectAtIndex:index];
    index++;

    //update the default stage data with any changes to the game state
    NBStageData *stageData = stage.stageData;
    [stageDataDictionary setObject:[NSNumber numberWithBool:stageData.isCompleted] forKey:@"isCompleted"];
    [stageDataDictionary setObject:[NSNumber numberWithBool:stageData.isUnlocked] forKey:@"isUnlocked"];
  }

  [dictionary setObject:stages forKey:@"Stage data"];
  NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];

  //save the changes to the app documents directory
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSString *path = [rootPath stringByAppendingPathComponent:@"GameSettings.plist"];

  if (plistData)
    [plistData writeToFile:path atomically:YES];
}

-(void)saveItems{
    
}

-(NBBasicClassData*)getBasicClassDataByClassName:(NSString*)className
{
    if (self.listOfCharacters && [self.listOfCharacters count] > 0)
    {
        NBBasicClassData* tempClassData = [[NBBasicClassData alloc] init];
        
        CCARRAY_FOREACH(self.listOfCharacters, tempClassData)
        {
            if ([tempClassData.className isEqualToString:className])
            {
                NBBasicClassData* returnClassData = [[NBBasicClassData alloc] init];
                returnClassData = [tempClassData copy];
                return returnClassData;
            }
        }
    }
    
    return nil;
}

+(CCArray*)getListOfProjectiles
{
    return listOfProjectiles;
}

@end
