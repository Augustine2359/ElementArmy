//
//  NBDataManager.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/1/13.
//
//

#import "NBDataManager.h"

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

@end
