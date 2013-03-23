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
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    
    NBItem* item1 = [NBItem createItem:@"Potion" onLayer:self onSelector:@selector(selectTargetItem)];
    [item1 setItemIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];
    NBItem* item2 = [NBItem createItem:@"FuryPill" onLayer:self onSelector:@selector(selectTargetItem)];
    [item2 setItemIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    NBItem* item3 = [NBItem createItem:@"WingedBoots" onLayer:self onSelector:@selector(selectTargetItem)];
    [item3 setItemIconWithNormalImage:@"Winged_boots.png" selectedImage:@"Winged_boots.png" disabledImage:@"Winged_boots.png" onLayer:self];
    NBItem* item4 = [NBItem createItem:@"FuryPill" onLayer:self onSelector:@selector(selectTargetItem)];
    [item4 setItemIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    NBItem* item5 = [NBItem createItem:@"Potion" onLayer:self onSelector:@selector(selectTargetItem)];
    [item5 setItemIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];
    self.allItems = [NSMutableArray new];
    self.allItems = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, item5, nil];
}

-(void)initialiseItemUI{
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
    }
    
    //Is already opened
    else{
        id close = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(0, -320)];
        [self runAction:close];
        self.itemSelectionOpen = NO;
        
        NBItem* newItem = [NBItem createItem:selectedItemButton.itemData.itemID onLayer:self onSelector:@selector(selectTargetItem)];
        [newItem setItemIconWithNormalImage:selectedItemButton.image selectedImage:selectedItemButton.image disabledImage:selectedItemButton.image onLayer:self.mainLayer];
        [newItem.itemIcon setPosition:ccp([self.changingTargetItem.itemIcon getPosition].x, [self.changingTargetItem.itemIcon getPosition].y)];
        [newItem displayItemIcon];
        
        [self.changingTargetItem hideItemIcon];    }
}

-(void)selectTargetItem{
    NBItem *item = [NBItem getCurrentlySelectedItem];
    [self toggleItemSelection:item];
}

@end
