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
#import "NBItem.h"

@interface NBBattleSetupScreen : NBBasicScreenLayer

-(void)gotoAppStore;

-(void)gotoIntroScreen;
-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleScreen;
-(void)itemSelected:(NBItem*)item;

@property (nonatomic, retain) NBStaticObject *battleSetupTitle;

@property (nonatomic, retain) NBButton *battleSetupOk;
@property (nonatomic, retain) NBButton *battleSetupCancel;

//Item selection
@property (nonatomic, retain) NBBattleSetupItems* setupItemsFrame;
//Create array of 3 int here to store selected items
@property (nonatomic, retain) NSMutableArray* selectedItemsArrayIndex;
@property (nonatomic) int tempNumberOfUnlockedItemsSlots;

@property(nonatomic, retain) NBItem* selectedItem1;
@property(nonatomic, retain) NBItem* selectedItem2;
@property(nonatomic, retain) NBItem* selectedItem3;
@property(nonatomic, retain) NSMutableArray* selectedItemsArray;

@end
