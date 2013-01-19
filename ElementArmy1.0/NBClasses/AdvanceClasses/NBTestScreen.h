//
//  NBTestScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 19/1/13.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"

@interface NBTestScreen : NBBasicScreenLayer

-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;

//UI Control
-(void)onTestButtonPressed;
-(void)testButtonOnSubLayer;

@property (nonatomic, retain) NBButton* testButton;
@property (nonatomic, retain) NBStaticObject* sampleStaticObject;
@property (nonatomic, retain) NBButton* wastedMyTimeButton;
@property (nonatomic, retain) CCLayerColor* testSubLayer;

@end