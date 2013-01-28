//
//  NBBattleSetupItems.h
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "NBBasicScreenLayer.h"

@interface NBBattleSetupItems : NBBasicScreenLayer

//@property (nonatomic, retain) NBStaticObject *itemSelectionFrame;

@property (nonatomic, retain) NSMutableArray* itemNames;
@property (nonatomic, retain) NSMutableArray* selectedItemsIndexes;
@property (nonatomic) bool itemSelectionOpen;
@property (nonatomic) int currentSelectedItemIndex;

@property (nonatomic, retain) NBButton* changingTargetItem;

-(void)initialiseItemArray;
-(void)initialiseItemUI;
-(void)toggleItemSelection:(NBButton*)selectedItemButton;
-(void)selectTargetItem:(NBButton*)targetItem;

@end
