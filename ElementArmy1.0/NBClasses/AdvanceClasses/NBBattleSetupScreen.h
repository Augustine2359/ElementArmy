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

@property (nonatomic, retain) NBStaticObject *battleSetupTitle;
@property (nonatomic, retain) NBStaticObject *battleSetupCharacter1;
@property (nonatomic, retain) NBStaticObject *battleSetupCharacter2;
@property (nonatomic, retain) NBStaticObject *battleSetupCharacter3;
@property (nonatomic, retain) NBButton *battleSetupCharacter1Up;
@property (nonatomic, retain) NBButton *battleSetupCharacter1Right;
@property (nonatomic, retain) NBButton *battleSetupCharacter1Down;
@property (nonatomic, retain) NBButton *battleSetupCharacter1Left;

@property (nonatomic, retain) NBButton *battleSetupCharacter2Up;
@property (nonatomic, retain) NBButton *battleSetupCharacter2Right;
@property (nonatomic, retain) NBButton *battleSetupCharacter2Down;
@property (nonatomic, retain) NBButton *battleSetupCharacter2Left;

@property (nonatomic, retain) NBButton *battleSetupCharacter3Up;
@property (nonatomic, retain) NBButton *battleSetupCharacter3Right;
@property (nonatomic, retain) NBButton *battleSetupCharacter3Down;
@property (nonatomic, retain) NBButton *battleSetupCharacter3Left;

@property (nonatomic, retain) NBButton *battleSetupOk;
@property (nonatomic, retain) NBButton *battleSetupCancel;
@property (nonatomic, retain) NBButton *battleSetupItem1;
@property (nonatomic, retain) NBButton *battleSetupItem2;
@property (nonatomic, retain) NBButton *battleSetupItem3;

@end
