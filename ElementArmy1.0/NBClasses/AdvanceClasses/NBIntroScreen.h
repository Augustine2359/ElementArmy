//
//  NBIntroScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"

@interface NBIntroScreen : NBBasicScreenLayer

-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;

//UI Control
-(void)onTestButtonPressed;

@property (nonatomic, retain) NBButton* testButton;
@property (nonatomic, retain) NBStaticObject* sampleStaticObject;
@property (nonatomic, retain) NBButton* wastedMyTimeButton;

@end
