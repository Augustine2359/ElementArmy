//
//  NBBattleSetupScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"
#import "NBBattleSetupItems.h"

@interface NBBattleSetupScreen : NBBasicScreenLayer

-(void)openItemSelection:(NBButton*)selectedItemIndex;
-(void)gotoAppStore;

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleScreen;

@property (nonatomic, retain) NBStaticObject *battleSetupTitle;

@property (nonatomic, retain) NBButton *battleSetupOk;
@property (nonatomic, retain) NBButton *battleSetupCancel;

//Item selection
@property (nonatomic, retain) NBBattleSetupItems* setupItemsFrame;
//Create array of 3 int here to store selected items
@property (nonatomic, retain) NSMutableArray* selectedItemsArrayIndex;
@property (nonatomic) int tempNumberOfUnlockedItemsSlots;

@end
