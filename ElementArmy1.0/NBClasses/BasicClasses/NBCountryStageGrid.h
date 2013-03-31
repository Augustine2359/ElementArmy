//
//  NBCountryStageGrid.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 15/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBBasicScreenLayer.h"
#import "NBCountry.h"
#import "NBStage.h"
#import "NBConnectorLine.h"

#define GRID_SQUARE_SIZE 10
#define STAGE_HORIZONTAL_CAPACITY 12
#define STAGE_VERTICAL_CAPACITY 18
#define GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET 16

@interface NBCountryStageGrid : CCLayerColor
{
    bool isEntering;
}

-(id)initOnLayer:(NBBasicScreenLayer*)layer withSize:(CGSize)size withCountryData:(NBCountryData*)newCountryData respondToSelector:(SEL)selector;
-(void)displayAllStages;
-(void)addStage:(NBStage*)stage;
-(NBStage*)getStageByID:(NSString*)compareStageID;
-(void)update;
-(void)onEnter:(CCLayer*)mainLayer;
-(void)onEnteringAnimationCompleted;

@property (nonatomic, retain) NBCountryData* countryData;
@property (nonatomic, retain) NSString* countryID;
@property (nonatomic, retain) NSString* countryName;
@property (nonatomic, retain) CCArray* stageGrid;
@property (nonatomic, retain) CCLayerColor* stageGridLayer;
@property (nonatomic, retain) CCArray* stageList;
@property (nonatomic, retain) CCArray* lineList;
@property (nonatomic, retain) CCLayer* currentLayer;
@property (nonatomic, assign) SEL currentSelector;
@property (nonatomic, retain) CCSprite* background;

@end
