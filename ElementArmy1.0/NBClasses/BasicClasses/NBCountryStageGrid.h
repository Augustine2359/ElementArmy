//
//  NBCountryStageGrid.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 15/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBStage.h"

#define STAGE_HORIZONTAL_CAPACITY 12
#define STAGE_VERTICAL_CAPACITY 18
#define GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET 16

@interface NBCountryStageGrid : CCLayerColor

-(id)initOnLayer:(NBBasicScreenLayer*)layer withSize:(CGSize)size;
-(void)displayAllStages;
-(void)addStage:(NBStage*)stage;
-(NBStage*)getStageByID:(NSString*)compareStageID;
-(void)update;
-(void)onEnter:(CCLayer*)mainLayer;

@property (nonatomic, retain) NSString* countryID;
@property (nonatomic, retain) NSString* countryName;
@property (nonatomic, retain) CCArray* stageGrid;
@property (nonatomic, retain) CCLayerColor* stageGridLayer;
@property (nonatomic, retain) CCArray* stageList;
@property (nonatomic, retain) CCArray* lineList;
@property (nonatomic, retain) CCLayer* currentLayer;

@end
