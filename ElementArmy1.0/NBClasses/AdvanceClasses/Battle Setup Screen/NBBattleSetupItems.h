//
//  NBBattleSetupItems.h
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBItem.h"

@interface NBBattleSetupItems : NBBasicScreenLayer

//@property (nonatomic, retain) NBStaticObject *itemSelectionFrame;

//@property (nonatomic, retain) NSMutableArray* itemNames;
//@property (nonatomic, retain) NSMutableArray* selectedItemsIndexes;
@property (nonatomic) bool itemSelectionOpen;
@property (nonatomic) int currentSelectedItemIndex;

@property (nonatomic, retain) NBItem* changingTargetItem;

@property(nonatomic, retain) NSMutableArray* allItems;
@property (nonatomic, retain) id mainLayer;

-(id)initWithLayer:(id)layer;
-(void)initialiseItemArray;
-(void)initialiseItemUI;
-(void)toggleItemSelection:(NBItem*)selectedItemButton;
-(void)selectTargetItem:(NBItem*)targetItem;
-(void)test;

@end
