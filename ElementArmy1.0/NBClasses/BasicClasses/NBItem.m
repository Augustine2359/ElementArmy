//
//  NBItem.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import "NBItem.h"

static NBItem* currentlySelectedItemInBattleSetup = nil;

@implementation NBItem

+(NBItem*)getCurrentlySelectedItem
{
    return currentlySelectedItemInBattleSetup;
}

+(id)createItem:(NBItemData*)newItemData onLayer:(id)layer onSelector:(SEL)selector
{
    NBItem* item = [[NBItem alloc] init];
    item.itemData = newItemData;
    item.currentLayer = layer;
    item.currentSelector = selector;
    
    return item;
}

-(id)setItemIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer
{
    self.itemIcon = [NBButton createWithStringHavingNormal:normalImage havingSelected:selectedImage havingDisabled:disabledImage onLayer:layer respondTo:self selector:@selector(onItemSelected) withSize:CGSizeZero];
    self.image = normalImage;
    return self;
}

-(void)onItemSelected
{
    currentlySelectedItemInBattleSetup = self;
    [self.currentLayer performSelector:self.currentSelector];
}

-(void)displayItemIcon
{
    if (self.itemIcon)
        [self.itemIcon show];
}

-(void)hideItemIcon
{
    if (self.itemIcon)
        [self.itemIcon hide];
}

@end
