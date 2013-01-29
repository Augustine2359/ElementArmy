//
//  NBItem.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import "NBItem.h"

@implementation NBItem

+(id)createItem:(NSString*)itemID
{
    NBItem* item = [[NBItem alloc] init];
    item.itemData = [[NBItemData alloc] init];
    item.itemData.itemID = itemID;
    
    return item;
}

-(id)setItemIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector
{
    self.itemIcon = [NBButton createWithStringHavingNormal:normalImage havingSelected:selectedImage havingDisabled:disabledImage onLayer:layer respondTo:object selector:selector withSize:CGSizeZero intArgument:0];
    return self;
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
