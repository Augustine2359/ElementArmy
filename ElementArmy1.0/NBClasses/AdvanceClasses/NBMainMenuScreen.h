//
//  NBMainMenuScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"

@interface NBMainMenuScreen : NBBasicScreenLayer

-(void)gotoIntroScreen;
-(void)gotoStoryScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;

@end