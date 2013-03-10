//
//  NBBattleSetupEquipments.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 10/3/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBItem.h"


@interface NBBattleSetupEquipments : NBBasicScreenLayer

@property (nonatomic) bool itemSelectionOpen;
@property (nonatomic) int currentSelectedItemIndex;

@property (nonatomic, retain) NBItem* changingTargetItem;

@property(nonatomic, retain) NSMutableArray* allItems;
@property (nonatomic, retain) id mainLayer;

-(id)initWithLayer:(id)layer;
-(void)initialiseItemArray;
-(void)initialiseItemUI;
-(void)toggleItemSelection:(NBItem*)selectedItemButton;
-(void)selectTargetItem;


@end
