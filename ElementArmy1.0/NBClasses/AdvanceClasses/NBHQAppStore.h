//
//  NBHQAppStore.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 23/4/13.
//  
//

#import "NBBasicScreenLayer.h"
#import "NBAppStoreProduct.h"


@interface NBHQAppStore : NBBasicScreenLayer

@property (nonatomic, retain) id mainLayer;
@property (nonatomic, retain) CCArray* allProducts;

-(id)initWithLayer:(id)layer;
-(void)initialiseAppStoreUI;
-(void)selectTargetProduct;

@end
