//
//  NBBattleSetupItems.m
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "NBBattleSetupItems.h"

@implementation NBBattleSetupItems

float slideDuration = 0.5f;


-(id)initWithLayer:(id)layer
{
    if ((self = [super init]))
    {
        self.mainLayer = layer;
        [self initialiseItemArray];
        [self initialiseItemUI];
    }
    return self;
}

- (void)onEnter {
    [super onEnter];
}

- (id)init {
    self = [super init];
    
    if (self) {
    }
    return self;
}

-(void)initialiseItemArray{
//    self.itemNames = [NSMutableArray new];
//    self.itemNames = [NSMutableArray arrayWithObjects:@"Potion.png", @"Fury_pill.png", @"Winged_boots.png", @"Fury_pill.png", @"Potion.png", nil];
//    
//    self.selectedItemsIndexes = [NSMutableArray new];
//    self.selectedItemsIndexes = [NSMutableArray arrayWithObjects:0, 1, 2, nil];
//    [self.selectedItemsIndexes addObjectsFromNSArray:[self.itemNames objectAtIndex:0]];
//    [self.selectedItemsIndexes addObjectsFromNSArray:[self.itemNames objectAtIndex:1]];
//    [self.selectedItemsIndexes addObjectsFromNSArray:[self.itemNames objectAtIndex:2]];
    
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    
    NBItem* item1 = [NBItem createItem:@"Potion" onLayer:self onSelector:@selector(selectTargetItem)];
    [item1 setItemIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self respondTo:nil selector:@selector(selectTargetItem:)];
    NBItem* item2 = [NBItem createItem:@"FuryPill" onLayer:self onSelector:@selector(selectTargetItem)];
    [item2 setItemIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self respondTo:item2 selector:@selector(onItemSelected)];
    NBItem* item3 = [NBItem createItem:@"WingedBoots" onLayer:self onSelector:@selector(selectTargetItem)];
    [item3 setItemIconWithNormalImage:@"Winged_boots.png" selectedImage:@"Winged_boots.png" disabledImage:@"Winged_boots.png" onLayer:self respondTo:nil selector:@selector(selectTargetItem:)];
    NBItem* item4 = [NBItem createItem:@"FuryPill" onLayer:self onSelector:@selector(selectTargetItem)];
    [item4 setItemIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self respondTo:nil selector:@selector(selectTargetItem:)];
    NBItem* item5 = [NBItem createItem:@"Potion" onLayer:self onSelector:@selector(selectTargetItem)];
    [item5 setItemIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self respondTo:nil selector:@selector(selectTargetItem:)];
    
    self.allItems = [NSMutableArray new];
    self.allItems = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, item5, nil];
}

-(void)initialiseItemUI{
//    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    //        self.itemSelectionFrame = [NBStaticObject createWithSize:CGSizeMake(400, 300) usingFrame:@"frame_item.png" atPosition:CGPointMake(240, -300)];
    
//    for (int x = 0; x < [self.itemNames count]; x++) {
//        NBButton* itemButton;
//        itemButton = [NBButton createWithStringHavingNormal:[self.itemNames objectAtIndex:x] havingSelected:[self.itemNames objectAtIndex:x] havingDisabled:[self.itemNames objectAtIndex:x] onLayer:self respondTo:nil selector:@selector(selectTargetItem:) withSize:CGSizeZero intArgument:x];
//        itemButton.tag = x;
//        [itemButton setPosition:ccp(x%4 * 100 + 100, 250 - x/4 * 75)];
//        [itemButton show];
//    }
//    
//    NBButton* okBtn = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero intArgument:0];
//    [okBtn setPosition:ccp(400, 50)];
//    [okBtn show];
    
    
    for (int x = 0; x < [self.allItems count]; x++) {
        NBItem* thatItem = [self.allItems objectAtIndex:x];
        [thatItem.itemIcon setPosition:ccp(x%4 * 100 + 100, 250 - x/4 * 75)];
        [thatItem displayItemIcon];
    }
    
    [self setPosition:ccp(0, -320)];
}

-(void)toggleItemSelection:(NBItem*)selectedItemButton{
    //Is already closed
    if (!self.itemSelectionOpen) {
        id open = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(0, 0)];
        [self runAction:open];
        self.itemSelectionOpen = YES;
        
        self.changingTargetItem = selectedItemButton;
        DLog(@"yeah = %@", self.mainLayer);
    }
    
    //Is already opened
    else{
        id close = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(0, -320)];
        [self runAction:close];
        self.itemSelectionOpen = NO;
        
        DLog(@"%@", selectedItemButton.itemData.itemID);
        NBItem* newItem = [NBItem createItem:selectedItemButton.itemData.itemID onLayer:self.mainLayer onSelector:@selector(toggleItemSelection)];
        [newItem setItemIconWithNormalImage:selectedItemButton.image selectedImage:selectedItemButton.image disabledImage:selectedItemButton.image onLayer:self.mainLayer respondTo:nil selector:@selector(toggleItemSelection:)];
        [newItem.itemIcon setPosition:ccp(self.changingTargetItem.itemIcon.position.x, self.changingTargetItem.itemIcon.position.y)];
                [newItem displayItemIcon];
//        NBItem* newItem = [NBItem createItem:@"WingedBoots"];
//        [newItem setItemIconWithNormalImage:@"Winged_boots.png" selectedImage:@"Winged_boots.png" disabledImage:@"Winged_boots.png" onLayer:self.mainLayer respondTo:nil selector:@selector(toggleItemSelection:)];
//        [newItem.itemIcon setPosition:ccp(160, 50)];
//        [newItem displayItemIcon];
        
//        [self.changingTargetItem hideItemIcon];
    }
}

-(void)selectTargetItem{
    NBItem *item = [NBItem getCurrentlySelectedItem];
    [self toggleItemSelection:item];
}

-(void)test{
    DLog(@"HAHA");
}

@end
