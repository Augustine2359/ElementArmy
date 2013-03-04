//
//  NBHQSetupScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/2/13.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"

@interface NBHQSetupScreen : NBBasicScreenLayer

-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;
-(void)gotoTestScreen;

//UI Control
-(void)onTestButtonPressed;

@property (nonatomic, retain) NBButton* testButton;
@property (nonatomic, retain) NBStaticObject* titleBanner;

@end
