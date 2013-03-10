//
//  NBCountryData.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/2/13.
//
//

#import "NBCountryData.h"

static CCArray* worldList = nil;

@implementation NBCountryData

+(CCArray*)getWorldList
{
    return worldList;
}

-(id)init
{
    if (!worldList)
        worldList = [[CCArray alloc] initWithCapacity:10];
    
    if (self = [super init])
    {
        self.countryName = [NSString stringWithFormat:@"country%i", [worldList count]];
        self.stageList = [[CCArray alloc] initWithCapacity:MAX_NUM_OF_STAGE_PER_WORLD];
        
        [worldList addObject:self];
    }
    
    return self;
}

@end
