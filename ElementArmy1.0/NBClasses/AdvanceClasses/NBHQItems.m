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
    self.allCostLabels = [CCArray new];
    self.allQuantityLabels = [CCArray new];
    CCArray* allHeldItems = [[NBDataManager dataManager] availableItems];
    
    for (int x = 0; x < [self.allItems count]; x++) {
        NBItem* thatItem = [self.allItems objectAtIndex:x];
        [thatItem.itemIcon setPosition:ccp(x%4 * 100 + 75, 275 - x/4 * 75)];
        [thatItem displayItemIcon];
        
        int quantityHeld = 0;
        for (int y = 0; y < [allHeldItems count]; y++) {
            NBItem* thisItem = [allHeldItems objectAtIndex:y];
            if (thisItem.itemData.itemName == thatItem.itemData.itemName) {
                quantityHeld = thisItem.itemData.availableAmount;
                break;
            }
        }
        
        CCLabelTTF* costLabel = [CCLabelTTF labelWithString:@"$9999" fontName:@"Marker Felt" fontSize:15];
        CCLabelTTF* quantityLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x %i", quantityHeld] fontName:@"Marker Felt" fontSize:15];
        costLabel.position = ccp(x%4 * 100 + 75, 240 - x/4 * 75);
        quantityLabel.position = ccp(x%4 * 100 + 125, 275 - x/4 * 75);
        
        [self addChild:costLabel];
        [self addChild:quantityLabel];
        [self.allCostLabels addObject:costLabel];
        [self.allQuantityLabels addObject:quantityLabel];

        if (x == 11) {
            //Do something to show the remainder on next page
            break;
        }
    }
    
    self.descriptionString = @"No item selected";
    self.labelBackground = [CCSprite spriteWithSpriteFrameName:@"staticbox_gray.png"];
    self.labelBackground.scaleX = 360 / self.labelBackground.contentSize.width;
    self.labelBackground.scaleY = 50 / self.labelBackground.contentSize.height;
    self.labelBackground.position = ccp(220, 130);
    self.descriptionLabel = [CCLabelTTF labelWithString:self.descriptionString dimensions:CGSizeMake(350, 50) hAlignment:kCCTextAlignmentLeft fontName:@"Marker Felt" fontSize:20];
    self.descriptionLabel.position = ccp(230, 130);
    [self addChild:self.labelBackground];
    [self addChild:self.descriptionLabel];
    
    self.buyButton = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(buyTargetItem) withSize:CGSizeZero];
    [self.buyButton setPosition:CGPointMake(400, 125)];
    [self.buyButton.menu setZOrder:2];
    [self.buyButton show];
    
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
            [self buyTargetItem];
        }
            break;
    }
}

-(void)buyTargetItem{
    NBItem *thatItem = [NBItem getCurrentlySelectedItem];
    int itemIndex = [[NBDataManager getListOfItems] indexOfObject:thatItem.itemData];
    
    if (itemIndex == 0) {
        return;
    }
    
    //Check enough gold
    //Add quantity
    int quantityHeld = ++thatItem.itemData.availableAmount;
    //Update label
    CCLabelTTF* thatLabel = (CCLabelTTF*)[self.allQuantityLabels objectAtIndex:itemIndex];
    [thatLabel setString:[NSString stringWithFormat:@"x %i", quantityHeld]];
}

@end
