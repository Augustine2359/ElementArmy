//
//  NBCountryStageGrid.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 15/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define STAGE_HORIZONTAL_CAPACITY 12
#define STAGE_VERTICAL_CAPACITY 18

@interface NBCountryStageGrid : CCLayer

@property (nonatomic, retain) NSString* countryID;
@property (nonatomic, retain) NSString* countryName;
@property (nonatomic, retain) CCArray* stageGrid;

-(void)displayAllStages;

@end
