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
//bool itemSelectionOpen = NO;


- (void)onEnter {
    [super onEnter];
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initialiseItemArray];
        [self initialiseItemUI];
    }
    return self;
}

-(void)initialiseItemArray{
    self.itemNames = [NSMutableArray new];
    self.itemNames = [NSMutableArray arrayWithObjects:@"Potion.png", @"Fury_pill.png", @"Winged_boots.png", @"Fury_pill.png", @"Potion.png", nil];
    
    self.selectedItemsIndexes = [NSMutableArray new];
    self.selectedItemsIndexes = [NSMutableArray arrayWithObjects:0, 1, 2, nil];
//    [self.selectedItemsIndexes addObjectsFromNSArray:[self.itemNames objectAtIndex:0]];
//    [self.selectedItemsIndexes addObjectsFromNSArray:[self.itemNames objectAtIndex:1]];
//    [self.selectedItemsIndexes addObjectsFromNSArray:[self.itemNames objectAtIndex:2]];
}

-(void)initialiseItemUI{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    //        self.itemSelectionFrame = [NBStaticObject createWithSize:CGSizeMake(400, 300) usingFrame:@"frame_item.png" atPosition:CGPointMake(240, -300)];
    
    for (int x = 0; x < [self.itemNames count]; x++) {
        NBButton* itemButton;
        itemButton = [NBButton createWithStringHavingNormal:[self.itemNames objectAtIndex:x] havingSelected:[self.itemNames objectAtIndex:x] havingDisabled:[self.itemNames objectAtIndex:x] onLayer:self respondTo:nil selector:@selector(selectTargetItem:) withSize:CGSizeZero intArgument:x];
        itemButton.tag = x;
        [itemButton setPosition:ccp(x%4 * 100 + 100, 250 - x/4 * 75)];
        [itemButton show];
    }
    
    NBButton* okBtn = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero intArgument:0];
    [okBtn setPosition:ccp(400, 50)];
    [okBtn show];
    
    [self setPosition:ccp(0, -320)];
}

-(void)toggleItemSelection:(NBButton*)selectedItemButton{
    //Closed
    if (!self.itemSelectionOpen) {
        id open = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(0, 0)];
        [self runAction:open];
        self.itemSelectionOpen = YES;
        
        self.changingTargetItem = selectedItemButton;
    }
    //Opened
    else{
        id close = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(0, -320)];
        [self runAction:close];
        self.itemSelectionOpen = NO;
    }
}

-(void)selectTargetItem:(NBButton*)targetItem{
    
    //Update by int array indexes
//    DLog(@"AA");
//    NSLog(@"%i", targetItem.tempIntStorage);
    NSLog(@"%i", targetItem.tag);
//    [self.selectedItemsIndexes replaceObjectAtIndex:self.currentSelectedItemIndex withObject:[NSNumber numberWithInt:targetItem.tag]];
//    DLog(@"BB");
//    [self toggleItemSelection];
    
    //Update by retrieving image filename from targetItem
    DLog(@"AA");
//    NBButton* newItem = [NBButton createWithStringHavingNormal:<#(NSString *)#> havingSelected:<#(NSString *)#> havingDisabled:<#(NSString *)#> onLayer:<#(CCLayer *)#> respondTo:<#(id)#> selector:<#(SEL)#> withSize:<#(CGSize)#> intArgument:<#(int)#>]
    [self toggleItemSelection:self.changingTargetItem];
    DLog(@"DD");
}

@end
