//
//  NBAppStoreProduct.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 23/4/13.
//
//

#import "cocos2d.h"
#import "NBAppStoreProduct.h"


@implementation NBAppStoreProduct

+(id)createProduct:(NBAppStoreProductData*)newProductData onLayer:(id)layer onSelector:(SEL)selector{
    
    NBAppStoreProduct* appStoreProduct = [NBAppStoreProduct new];
    appStoreProduct.productData = newProductData;
    appStoreProduct.currentLayer = layer;
    appStoreProduct.onPressedSelector = selector;
    
    [appStoreProduct setProductIconWithNormalImage:appStoreProduct.productData.imageNormal selectedImage:appStoreProduct.productData.imageSelected disabledImage:appStoreProduct.productData.imageDisabled onLayer:layer];
    
    return appStoreProduct;
}

-(id)setProductIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer
{
    self.productIcon = [NBButton createWithStringHavingNormal:normalImage havingSelected:selectedImage havingDisabled:disabledImage onLayer:layer respondTo:self selector:@selector(onProductSelected) withSize:CGSizeZero];
    [self.productIcon show];
    
    return self;
}

-(void)onProductSelected{
    [self.currentLayer performSelector:self.onPressedSelector];
}

@end
