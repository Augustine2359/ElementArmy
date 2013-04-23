//
//  NBHQAppStore.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 23/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "NBHQAppStore.h"


@implementation NBHQAppStore

-(id)initWithLayer:(id)layer
{
    if ((self = [super init]))
    {
//        [self initialiseProductsArray];
        [self initialiseAppStoreUI];
    }
    return self;
}

-(void)initialiseProductsArray{
    self.allProducts = [CCArray new];
    
    NBAppStoreProductData* productData = nil;
    CCARRAY_FOREACH([NBDataManager getListOfEquipments], productData)
    {
        NBAppStoreProduct* product = [NBAppStoreProduct createProduct:productData onLayer:self onSelector:@selector(selectTargetProduct)];
        [self.allProducts addObject:product];
    }
}

-(void)initialiseAppStoreUI{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    /*
    CCArray* allHeldEquipments = [[NBDataManager dataManager] availableEquipments];
    
    for (int x = 0; x < [self.allProducts count]; x++) {
        NBAppStoreProduct* thatProduct = [self.allProducts objectAtIndex:x];
        [thatProduct.equipmentIcon setPosition:ccp(x%4 * 100 + 75, 275 - x/4 * 75)];
        [thatProduct displayEquipmentIcon];
        
        int quantityHeld = 0;
        for (int y = 0; y < [allHeldEquipments count]; y++) {
            NBAppStoreProduct* thisEquipment = [allHeldEquipments objectAtIndex:y];
            if (thisEquipment.equipmentData.equipmentName == thatProduct.equipmentData.equipmentName) {
                quantityHeld = thisEquipment.equipmentData.availableAmount;
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
    }*/
    
    [self setPosition:ccp(0, -320)];
}

-(void)selectTargetProduct{
    //Confirm msg to buy
    //Really purchase from app store
    DLog(@"IAP here..");
}

@end
