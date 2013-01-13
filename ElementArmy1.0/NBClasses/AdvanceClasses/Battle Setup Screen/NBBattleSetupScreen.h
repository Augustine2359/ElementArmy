//
//  NBBattleSetupScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"

@interface NBBattleSetupScreen : NBBasicScreenLayer

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleScreen;

@property (nonatomic, retain) NBButton *battleSetupTitle;
@property (nonatomic, retain) NBButton *battleSetupOk;
@property (nonatomic, retain) NBButton *battleSetupCancel;
@property (nonatomic, retain) NBButton *battleSetupItem1;
@property (nonatomic, retain) NBButton *battleSetupItem2;
@property (nonatomic, retain) NBButton *battleSetupItem3;

@property (nonatomic, retain) NBButton* battleSetupItemSample;

@end
