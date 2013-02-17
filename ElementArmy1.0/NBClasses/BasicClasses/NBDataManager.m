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

#define SQUAD_COUNT_ALLOWED 3

static NBDataManager* dataManager = nil;

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
        
        self.selectedItems = [CCArray arrayWithCapacity:3];
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
    self.listOfStages = [CCArray array];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *stages = [dictionary objectForKey:@"Stage data"];
    
    for (NSDictionary *stageDataDictionary in stages)
    {
        NBStageData *stageData = [[NBStageData alloc] init];
        stageData.stageID = [stageDataDictionary objectForKey:@"stageID"];
        stageData.countryID = [stageDataDictionary objectForKey:@"countryID"];
        stageData.availableNormalImageName = [stageDataDictionary objectForKey:@"availableNormalImageName"];
        stageData.availableDisabledImageName = [stageDataDictionary objectForKey:@"availableDisabledImageName"];
        stageData.completedNormalImageName = [stageDataDictionary objectForKey:@"completedNormalImageName"];
        stageData.completedDisabledImageName = [stageDataDictionary objectForKey:@"completedDisabledImageName"];
        CGFloat gridPointX = [[[stageDataDictionary objectForKey:@"gridPoint"] objectForKey:@"x"] floatValue];
        CGFloat gridPointY = [[[stageDataDictionary objectForKey:@"gridPoint"] objectForKey:@"y"] floatValue];
        stageData.gridPoint = CGPointMake(gridPointX, gridPointY);
        stageData.nextStageID = [stageDataDictionary objectForKey:@"nextStageID"];
        stageData.isCompleted = [[stageDataDictionary objectForKey:@"isCompleted"] boolValue];
        stageData.isUnlocked = [[stageDataDictionary objectForKey:@"isUnlocked"] boolValue];
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

@end
