//
//  NBStoryScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"
#import "NBStorySet2.h"

@interface NBStoryScreen : NBBasicScreenLayer

@property (nonatomic, retain) NBStorySet2* storyLayer;

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;

@end
