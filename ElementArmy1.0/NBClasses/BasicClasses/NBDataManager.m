//
//  NBDataManager.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/1/13.
//
//

#import "NBDataManager.h"
#import "NBStage.h"
#import "NBItemData.h"
#import "NBEquipmentData.h"
#import "NBProjectileBasicData.h"
#import "NBSkill.h"
//#import "NBCountryData.h"

#define SQUAD_COUNT_ALLOWED 3

static NBDataManager* dataManager = nil;
static CCArray* listOfProjectiles = nil;
static CCArray* listOfCountries = nil;
static CCArray* listOfSkills = nil;
static CCArray* listOfItems = nil;
static CCArray* listOfEquipments = nil;
static CCArray* listOfLevelData = nil;

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
        listOfCountries = [[CCArray alloc] initWithCapacity:10];
        listOfEquipments = [[CCArray alloc] initWithCapacity:100];
        listOfSkills = [[CCArray alloc] initWithCapacity:100];
        listOfItems = [[CCArray alloc] initWithCapacity:100];
        listOfLevelData = [[CCArray alloc] initWithCapacity:100];

        //[self createStages];
        //[self createItems];
        
        self.selectedItems = [CCArray arrayWithCapacity:3];
        self.selectedEquipments = [CCArray arrayWithCapacity:3];
    }

    return self;
}

-(void)dealloc
{
    [listOfSkills release];
    [listOfItems release];
    [listOfEquipments release];
    [super dealloc];
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
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"SaveGame.plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    //temporary
    //dictionary = nil;
    
    //if it doesn't exist yet, use the default one
    if (dictionary == nil) {
      plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
      dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }

    NSArray *countries = [dictionary objectForKey:@"Stage data"];
    
    for (NSDictionary *countryDataDictionary in countries)
    {
        NBCountryData* countryData = [[NBCountryData alloc] init];
        countryData.countryName = [countryDataDictionary objectForKey:@"countryName"];
        countryData.iconSpriteNormal = [countryDataDictionary objectForKey:@"iconSpriteNormal"];
        countryData.iconSpriteSelected = [countryDataDictionary objectForKey:@"iconSpriteSelected"];
        countryData.iconSpriteDisabled = [countryDataDictionary objectForKey:@"iconSpriteDisabled"];
        countryData.gridBackgroundImage = [countryDataDictionary objectForKey:@"gridBackgroundImage"];
        countryData.majorElementID = [[countryDataDictionary objectForKey:@"majorElementID"] intValue];
        int countryHorizontalGridCount = [[[countryDataDictionary objectForKey:@"gridBoardSize"] objectForKey:@"horizontal"] intValue];
        int countryVerticalGridCount = [[[countryDataDictionary objectForKey:@"gridBoardSize"] objectForKey:@"vertical"] intValue];
        countryData.gridBoardSize = CGSizeMake(countryHorizontalGridCount, countryVerticalGridCount);
        CGFloat countryX = [[[countryDataDictionary objectForKey:@"positionInWorld"] objectForKey:@"x"] floatValue];
        CGFloat countryY = [[[countryDataDictionary objectForKey:@"positionInWorld"] objectForKey:@"y"] floatValue];
        countryData.positionInWorld = CGPointMake(countryX, countryY);
        
        NSArray *stages = [countryDataDictionary objectForKey:@"stageList"];
        
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
            NSArray* tempArray = [stageDataDictionary objectForKey:@"nextStageDataList"];
            stageData.nextStageDataList = [CCArray arrayWithNSArray:tempArray];
            tempArray = [stageDataDictionary objectForKey:@"willUnlockStageID"];
            stageData.willUnlockStageID = [CCArray arrayWithNSArray:tempArray];
            stageData.isCompleted = [[stageDataDictionary objectForKey:@"isCompleted"] boolValue];
            stageData.isUnlocked = [[stageDataDictionary objectForKey:@"isUnlocked"] boolValue];
            stageData.battlePointAwarded = [[stageDataDictionary objectForKey:@"battlePointAwarded"] longValue];
            
            NSArray* enemyList = [stageDataDictionary objectForKey:@"Enemy List"];
            
            if (enemyList)
            {
                arrayOfEnemyData = [[CCArray alloc] initWithCapacity:3];
                
                for (NSDictionary* enemy in enemyList)
                {
                    basicClassData = [self getBasicClassDataByClassName:[enemy objectForKey:@"enemyClass"]];
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
                    basicClassData.battlePointsAward = [[[enemy objectForKey:@"attributes"] objectForKey:@"battlePointsAward"] longValue];
                    
                    [arrayOfEnemyData addObject:basicClassData];
                }
            }
            
            stageData.enemyList = arrayOfEnemyData;
            
            NBStage *stage = [NBStage createStageWithStageData:stageData];
            [self.listOfStages addObject:stage];
            [countryData.stageList addObject:stage];
        }
        
        [listOfCountries addObject:countryData];
    }
}

-(void)loadItemList
{
    listOfItems = [CCArray array];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *items = [dictionary objectForKey:@"Item data"];
    
    for (NSDictionary *itemDataDictionary in items)
    {
        NBItemData *itemData = [[NBItemData alloc] init];
        itemData.itemName = [itemDataDictionary objectForKey:@"itemName"];
        itemData.description = [itemDataDictionary objectForKey:@"description"];
        itemData.impactedStatus = [itemDataDictionary objectForKey:@"impactedStatus"];
        itemData.effectToUnitSide = [[itemDataDictionary objectForKey:@"effectToUnitSide"] integerValue];
        itemData.usageType = [[itemDataDictionary objectForKey:@"usageType"] integerValue];
        itemData.impactAreaType = [[itemDataDictionary objectForKey:@"impactAreaType"] integerValue];
        itemData.impactType = [[itemDataDictionary objectForKey:@"impactType"] integerValue];
        itemData.impactValue = [itemDataDictionary objectForKey:@"impactValue"];
        itemData.specialEffect = [itemDataDictionary objectForKey:@"specialEffect"];
        itemData.allowBeyondMaximumValue = [[itemDataDictionary objectForKey:@"allowBeyondMaximumValue"] boolValue];
        itemData.maximumAllowable = [[itemDataDictionary objectForKey:@"maximumAllowable"] integerValue];
        itemData.imageNormal = [itemDataDictionary objectForKey:@"imageNormal"];
        itemData.imageSelected = [itemDataDictionary objectForKey:@"imageSelected"];
        itemData.imageDisabled = [itemDataDictionary objectForKey:@"imageDisabled"];
        [listOfItems addObject:itemData];
    }
    
    [listOfItems retain];
}

-(void)loadEquipmentList
{
    listOfEquipments = [CCArray array];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *equipments = [dictionary objectForKey:@"Equipment data"];
    
    for (NSDictionary *equipmentDataDictionary in equipments)
    {
        NBEquipmentData *equipmentData = [[NBEquipmentData alloc] init];
        equipmentData.equipmentName = [equipmentDataDictionary objectForKey:@"equipmentName"];
        equipmentData.description = [equipmentDataDictionary objectForKey:@"description"];
        equipmentData.statusImpacted = [equipmentDataDictionary objectForKey:@"statusImpacted"];
        equipmentData.impactType = [equipmentDataDictionary objectForKey:@"impactType"];
        equipmentData.impactValue = [equipmentDataDictionary objectForKey:@"impactValue"];
        equipmentData.requiredLevel = [[equipmentDataDictionary objectForKey:@"requiredLevel"] integerValue];
        equipmentData.imageNormal = [equipmentDataDictionary objectForKey:@"imageNormal"];
        equipmentData.imageSelected = [equipmentDataDictionary objectForKey:@"imageSelected"];
        equipmentData.imageDisabled = [equipmentDataDictionary objectForKey:@"imageDisabled"];
        [listOfEquipments addObject:equipmentData];
    }
    
    [listOfEquipments retain];
}

-(void)loadSkillList
{
    listOfSkills = [CCArray array];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *skills = [dictionary objectForKey:@"Skill data"];
    
    for (NSDictionary *skillDataDictionary in skills)
    {
        NBSkill *skillData = [[NBSkill alloc] init];
        skillData.skillName = [skillDataDictionary objectForKey:@"skillName"];
        skillData.skillInGameName = [skillDataDictionary objectForKey:@"skillInGameName"];
        skillData.skillType = [[skillDataDictionary objectForKey:@"skillType"] integerValue];
        skillData.statusImpacted = [skillDataDictionary objectForKey:@"statusImpacted"];
        skillData.impactType = [[skillDataDictionary objectForKey:@"impactType"] integerValue];
        skillData.impactValue = [[skillDataDictionary objectForKey:@"impactValue"] floatValue];
        skillData.frequency = [[skillDataDictionary objectForKey:@"frequency"] floatValue];
        skillData.canExceedMaxValue = [[skillDataDictionary objectForKey:@"canExceedMaxValue"] boolValue];
        
        [listOfSkills addObject:skillData];
    }
    
    [listOfSkills retain];
}

-(void)loadPlayerData{
    //Load all saved variables from plist
}

-(void)loadGameSettingData
{
    //Load all game setting or game rules data here
    
    //Load levelling table
    //*********************************************
    listOfLevelData = [CCArray array];
    //insert 0 for index 0
    [listOfLevelData addObject:[NSNumber numberWithInt:0]];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *generalDataDictionary = [dictionary objectForKey:@"General data"];
    NSString* generalDataName = nil;
    
    for (NSDictionary *generalData in generalDataDictionary)
    {
        generalDataName = [generalData objectForKey:@"gameSettingName"];
        
        if ([generalDataName isEqualToString:@"levelling table"])
        {
            NSArray* levellingTableArray = [generalData objectForKey:@"levelData"];
            
            for (NSNumber* amount in levellingTableArray)
            {
                [listOfLevelData addObject:amount];
            }
        }
        else if ([generalDataName isEqualToString:@"player game state"])
        {
            self.availableBattlePoint = [[generalData objectForKey:@"availableBattlePoint"] longValue];
            self.availableGold = [[generalData objectForKey:@"availableGold"] longValue];
            self.availableElementalGem = [[generalData objectForKey:@"availableElementalGem"] longValue];
        }
    }
    //*********************************************
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
        characterData.isBoss = [[characterDataDictionary objectForKey:@"isBoss"] boolValue];
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
        characterData.walkAnimFrame = [[characterDataDictionary objectForKey:@"frames"] objectForKey:@"walkAnimFrame"];
        characterData.walkAnimFrameCount = [[[characterDataDictionary objectForKey:@"frames"] objectForKey:@"walkAnimFrameCount"] shortValue];
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
        characterData.activeSkillName = [characterDataDictionary objectForKey:@"activeSkillName"];
        characterData.passiveSkillName = [characterDataDictionary objectForKey:@"passiveSkillName"];
        
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
    
    //load self.saveGameDictionary once
    if (!self.saveGameDictionary)
    {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
        self.saveGameDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    }
    
    //The following is specific for save stage related
    //Grab the default stage data
    NSArray *stages = [self.saveGameDictionary objectForKey:@"Stage data"];

    NSInteger index = 0;
    for (NSMutableDictionary *stageDataDictionary in stages)
    {
        NBStage *stage = [self.listOfStages objectAtIndex:index];
        index++;

        //update the default stage data with any changes to the game state
        NBStageData *stageData = stage.stageData;
        [stageDataDictionary setObject:[NSNumber numberWithBool:stageData.isCompleted] forKey:@"isCompleted"];
        [stageDataDictionary setObject:[NSNumber numberWithBool:stageData.isUnlocked] forKey:@"isUnlocked"];
    }

    [self.saveGameDictionary setObject:stages forKey:@"Stage data"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:self.saveGameDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];

    //save the changes to the app documents directory
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [rootPath stringByAppendingPathComponent:@"SaveGame.plist"];

    if (plistData)
        [plistData writeToFile:path atomically:YES];
}

-(void)saveItems
{
    
}

-(void)saveGameData
{
    //load self.saveGameDictionary once
    if (!self.saveGameDictionary)
    {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
        self.saveGameDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    }
    
    NSArray* generalDataDictionary = [self.saveGameDictionary objectForKey:@"General data"];
    NSString* generalDataName = nil;
    
    for (NSMutableDictionary* generalData in generalDataDictionary)
    {
        generalDataName = [generalData objectForKey:@"gameSettingName"];
        
        //Save available battle points, gold, and elemental gem
        if ([generalDataName isEqualToString:@"player game state"])
        {
            [generalData setObject:[NSNumber numberWithLong:self.availableBattlePoint] forKey:@"availableBattlePoint"];
            [generalData setObject:[NSNumber numberWithLong:self.availableGold] forKey:@"availableGold"];
            [generalData setObject:[NSNumber numberWithLong:self.availableElementalGem] forKey:@"availableElementalGem"];
        }
    }
    
    [self.saveGameDictionary setObject:generalDataDictionary forKey:@"General data"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:self.saveGameDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
    //save the changes to the app documents directory
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [rootPath stringByAppendingPathComponent:@"SaveGame.plist"];
    
    if (plistData)
        [plistData writeToFile:path atomically:YES];
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

+(id)getSkillBySkillName:(NSString*)lookupName
{
    NBSkill* skill = nil;
    
    CCARRAY_FOREACH(listOfSkills, skill)
    {
        if ([skill.skillName isEqualToString:lookupName])
        {
            return skill;
        }
    }
    
    return nil;
}

+(id)getItemDataByItemName:(NSString*)lookupName
{
    NBItemData* itemData = nil;
    
    CCARRAY_FOREACH(listOfItems, itemData)
    {
        if ([itemData.itemName isEqualToString:lookupName])
        {
            return itemData;
        }
    }
    
    return nil;
}

+(id)getEquipmentDataByEquipmentName:(NSString *)lookupName
{
    NBEquipmentData* equipmentData = nil;
    
    CCARRAY_FOREACH(listOfEquipments, equipmentData)
    {
        if ([equipmentData.equipmentName isEqualToString:lookupName])
        {
            return equipmentData;
        }
    }
    
    return nil;
}

+(CCArray*)getListOfProjectiles
{
    return listOfProjectiles;
}

+(CCArray*)getListOfCountries
{
    return listOfCountries;
}

+(CCArray*)getListOfItems
{
    return listOfItems;
}

+(CCArray*)getListOfEquipments
{
    return listOfEquipments;
}
@end
