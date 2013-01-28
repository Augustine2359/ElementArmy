//
//  NBStageData.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 27/1/13.
//
//

#import "NBStageData.h"

@implementation NBStageData

-(id)init
{
    if ((self = [super init]))
    {
        self.gridPoint = CGPointZero;
        self.nextStageID = [[CCArray alloc] initWithCapacity:3];
    }
    
    return self;
}

@end
