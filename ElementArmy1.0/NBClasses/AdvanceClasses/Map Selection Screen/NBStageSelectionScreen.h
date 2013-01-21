//
//  NBStageSelectionScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 20/1/13.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"
#import "NBCountryStageGrid.h"

@interface NBStageSelectionScreen : NBBasicScreenLayer

-(void)readStagesFromFile;
-(void)onStageSelected;
-(void)gotoBattleSetupScreen;

@property (nonatomic, retain) NBCountryStageGrid* currentCountryStage;
@property (nonatomic, assign) int horizontalGridCount;
@property (nonatomic, assign) int verticalGridCount;

@end
