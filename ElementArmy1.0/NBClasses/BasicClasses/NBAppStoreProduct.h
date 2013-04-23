//
//  NBAppStoreProduct.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 23/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBAppStoreProductData.h"

@interface NBAppStoreProduct : NSObject
    
@property (nonatomic, retain) NBButton* productIcon;
@property (nonatomic, retain) id currentLayer;
@property (nonatomic, assign) SEL onPressedSelector;

+(id)createProduct:(NBAppStoreProductData*)productName onLayer:(id)layer onSelector:(SEL)selector;

@end
