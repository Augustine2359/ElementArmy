//
//  NBGameLoadingScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 1/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"

@interface NBGameLoadingScreen : NBBasicScreenLayer

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoStoryScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;

@end
