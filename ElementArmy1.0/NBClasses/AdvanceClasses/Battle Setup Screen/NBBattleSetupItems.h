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

@property (nonatomic, retain) id mainLayer;
@property (nonatomic) bool itemSelectionOpen;

@property (nonatomic, retain) NBItem* changingTargetItem;
@property (nonatomic, retain) NSMutableArray* allItems;

@property (nonatomic, retain) CCLabelTTF* descriptionLabel;
@property (nonatomic, assign) NSString* descriptionString;

@property (nonatomic, retain) NBButton* confirmButton;
@property (nonatomic, retain) NBButton* cancelButton;

-(id)initWithLayer:(id)layer;
-(void)initialiseItemArray;
-(void)initialiseItemUI;
-(void)toggleItemSelection:(NBItem*)selectedItemButton;
-(void)selectTargetItem;
-(void)confirmAndCloseMenu;
-(void)cancelAndCloseMenu;

@end
