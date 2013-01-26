//
//  NBBattleSetupScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicScreenLayer.h"
#import "BattleSetupItems.h"

@interface NBBattleSetupScreen : NBBasicScreenLayer

-(void)openItemSelection:(NBButton*)selectedItemIndex;
-(void)updateSelectedItems;
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
@property (nonatomic, retain) BattleSetupItems* setupItemsFrame;
//Create array of 3 int here to store selected items
@property (nonatomic, retain) NSArray* selectedItemsArrayIndex;
@property (nonatomic) int currentSelectedItemIndex;
@property (nonatomic) int tempNumberOfUnlockedItemsSlots;

@end
