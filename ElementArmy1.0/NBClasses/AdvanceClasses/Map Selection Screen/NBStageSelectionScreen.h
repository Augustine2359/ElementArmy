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
#import "NBSingleAnimatedObject.h"

@interface NBStageSelectionScreen : NBBasicScreenLayer

-(void)readFromDataManager;
-(void)readStagesFromFile;
-(void)onStageSelected;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;
-(void)gotoMapSelectionScreen;
-(void)onStageGridEnteringAnimationCompleted;

@property (nonatomic, retain) NBCountryData* currentCountryData;
@property (nonatomic, retain) NBCountryStageGrid* currentCountryStage;
@property (nonatomic, assign) int horizontalGridCount;
@property (nonatomic, assign) int verticalGridCount;
@property (nonatomic, retain) NBButton* gotoBattleButton;
@property (nonatomic, retain) NBButton* backToWorldSelectionButton;
@property (nonatomic, assign) bool stageCreated;
@property (nonatomic, retain) NBSingleAnimatedObject* flagCursor;

@end
