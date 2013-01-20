//
//  NBCountryStageGrid.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 15/1/13.
//
//

#import "NBCountryStageGrid.h"

@implementation NBCountryStageGrid

-(id)init
{
    if (self = [super init])
    {
        self.stageGrid = [CCArray arrayWithCapacity:STAGE_VERTICAL_CAPACITY];
        
        for (int i = 0; i < STAGE_VERTICAL_CAPACITY; i++)
        {
            CCArray* stageHorizontalGrid = [CCArray arrayWithCapacity:STAGE_HORIZONTAL_CAPACITY];
            [self.stageGrid addObject:stageHorizontalGrid];
        }
    }
    
    return self;
}

-(void)displayAllStages
{
    
}

@end
