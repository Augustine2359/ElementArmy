//
//  NBStageData.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 27/1/13.
//
//

#import "NBStageData.h"

static CCArray* stageDataList = nil;

@implementation NBStageData

+(NBStageData*)getStageDataByID:(NSString*)stageID
{
    if (stageDataList)
    {
        NBStageData* stageData = nil;
        
        CCARRAY_FOREACH(stageDataList, stageData)
        {
            if ([stageData.stageID isEqualToString:stageID])
            {
                return stageData;
            }
        }
    }
    
    return nil;
}

-(id)init
{
    if ((self = [super init]))
    {
        stageDataList = [[CCArray alloc] initWithCapacity:100];
        
        self.gridPoint = CGPointZero;
        self.nextStageDataList = [[CCArray alloc] initWithCapacity:3];
        self.connectedStageID = [[CCArray alloc] initWithCapacity:3];
        self.willUnlockStageID = [[CCArray alloc] initWithCapacity:3];
        self.connectorLines = [[CCArray alloc] initWithCapacity:4];
    }
    
    return self;
}

@end
