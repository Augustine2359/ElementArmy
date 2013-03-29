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
    
    self.allItems = [NSMutableArray new];
    NBItemData* itemData = nil;
    CCARRAY_FOREACH([NBDataManager getListOfItems], itemData)
    {
        NBItem* item = [NBItem createItem:itemData onLayer:self onSelector:@selector(selectTargetItem)];
        [self.allItems addObject:item];
    }
}

-(void)initialiseItemUI{
    for (int x = 0; x < [self.allItems count]; x++) {
        NBItem* thatItem = [self.allItems objectAtIndex:x];
        [thatItem.itemIcon setPosition:ccp(x%4 * 100 + 100, 250 - x/4 * 75)];
        [thatItem displayItemIcon];
        
        if (x == 11) {
            //Do something to show the remainder on next page
            break;
        }
    }
    
    self.descriptionString = @"No item selected";
    self.descriptionLabel = [CCLabelTTF labelWithString:self.descriptionString fontName:@"Marker Felt" fontSize:20];
    self.descriptionLabel.position = ccp(240, 75);
    [self addChild:self.descriptionLabel];
    
    self.confirmButton = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(confirmAndCloseMenu) withSize:CGSizeZero];
    [self.confirmButton setPosition:CGPointMake(450, 50)];
    [self.confirmButton show];
    
    self.cancelButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(cancelAndCloseMenu) withSize:CGSizeZero];
    [self.cancelButton setPosition:CGPointMake(30, 50)];
    [self.cancelButton show];
    
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
        
        if (selectedItemButton != nil) {
            SEL thatSelector = self.changingTargetItem.currentSelector;
            NBItem* newItem = [NBItem createItem:selectedItemButton.itemData onLayer:self.mainLayer onSelector:thatSelector];
            [newItem.itemIcon setPosition:ccp([self.changingTargetItem.itemIcon getPosition].x, [self.changingTargetItem.itemIcon getPosition].y)];
            [newItem displayItemIcon];
        
            [self.changingTargetItem hideItemIcon];
        }
    }
}

-(void)selectTargetItem{
    NBItem* item = [NBItem getCurrentlySelectedItem];
    self.descriptionString = item.itemData.description;
    self.descriptionLabel.string = self.descriptionString;
}

-(void)confirmAndCloseMenu{
    NBItem *item = [NBItem getCurrentlySelectedItem];
    [self toggleItemSelection:item];
}

-(void)cancelAndCloseMenu{
    [self toggleItemSelection:nil];
}
@end
