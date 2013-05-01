//
//  NBHQAppStore.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 23/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "NBHQAppStore.h"
#import "NBInAppPurchaseManager.h"

@interface NBHQAppStore() <NBInAppPurchaseManagerDelegate>
@end

@implementation NBHQAppStore

-(id)initWithLayer:(id)layer
{
    if ((self = [super init]))
    {
        [self initialiseProductsArray];
        [self initialiseAppStoreUI];
        self.IAPManager = [NBInAppPurchaseManager sharedInstance];
        self.IAPManager.delegate = self;
    }
    return self;
}

-(void)initialiseProductsArray{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    self.allProducts = [CCArray new];
    
    NBAppStoreProductData* productData = nil;
    CCARRAY_FOREACH([NBDataManager getListOfAppStoreProducts], productData)
    {
        NBAppStoreProduct* product = [NBAppStoreProduct createProduct:productData onLayer:self onSelector:@selector(selectTargetProduct)];
        [self.allProducts addObject:product];
    }
}

-(void)initialiseAppStoreUI{
    [self setPosition:ccp(0, -320)];
    
    for (int x = 0; x < [self.allProducts count]; x++) {
        NBAppStoreProduct* thatProduct = [self.allProducts objectAtIndex:x];
        [thatProduct.productIcon setPosition:ccp(x%4 * 100 + 75, 275 - x/4 * 75)];
        
        CCLabelTTF* costLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%.2f", thatProduct.productData.cost] fontName:@"PF Ronda Seven" fontSize:15];
        costLabel.position = ccp(thatProduct.productIcon.getPosition.x, thatProduct.productIcon.getPosition.y - 35);
        
        [self addChild:costLabel];
        
        if (x == 11) {
            //Do something to show the remainder on next page
            break;
        }
    }
}

-(void)selectTargetProduct{
    [self.IAPManager makePurchase:@"gem.test.100"];
}

- (void)finishPurchaseForProductWithProductIdentifier:(NSString *)productIdentifier {
  if ([productIdentifier isEqualToString:GEMS_TEST_100]) {
    DLog(@"YOU GOT 100 GEMS");
  }
}

@end
