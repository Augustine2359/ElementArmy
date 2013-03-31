//
//  NBHQItems.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 31/3/13.
//
//

#import "NBHQItems.h"

NBItem* currSelectedItem = nil;


@implementation NBHQItems

-(id)initWithLayer:(id)layer
{
    if ((self = [super init]))
    {
        [self initialiseItemArray];
        [self initialiseItemUI];
    }
    return self;
}

-(void)initialiseItemArray{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    
    self.allItems = [CCArray new];
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
        [thatItem.itemIcon setPosition:ccp(x%4 * 100 + 75, 275 - x/4 * 75)];
        [thatItem displayItemIcon];
        
        if (x == 11) {
            //Do something to show the remainder on next page
            break;
        }
    }
    
    self.descriptionString = @"No item selected";
    self.descriptionLabel = [CCLabelTTF labelWithString:self.descriptionString fontName:@"Marker Felt" fontSize:20];
    self.descriptionLabel.position = ccp(240, 150);
    [self addChild:self.descriptionLabel];
    
    [self setPosition:ccp(0, -320)];
}

-(void)selectTargetItem{
    NBItem *thatItem = [NBItem getCurrentlySelectedItem];
    
    if (currSelectedItem == thatItem) {
        self.tapCount++;
    }
    else{
        currSelectedItem = thatItem;
        self.tapCount = 1;
    }
    
    switch (self.tapCount) {
        case 1:{
            self.descriptionString = thatItem.itemData.description;
            self.descriptionLabel.string = self.descriptionString;
        }
            break;
            
        default:{
            //Quantity + 1
        }
            break;
    }
}

@end
