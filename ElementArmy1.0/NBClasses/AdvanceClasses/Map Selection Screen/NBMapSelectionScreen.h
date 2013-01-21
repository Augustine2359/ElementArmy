//
//  NBMapSelectionScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"
#import "NBCountryStageGrid.h"

@interface NBMapSelectionScreen : NBBasicScreenLayer

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoStoryScreen;
-(void)gotoStageSelectionScreen;
-(void)gotoBattleScreen;

@end
