//
//  NBAppStoreProductData.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 23/4/13.
//  
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBUserInterface.h"

@interface NBAppStoreProductData : NSObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, assign) float cost;
@property (nonatomic, assign) int quantityInBundle;
@property (nonatomic, retain) NSString* imageNormal;
@property (nonatomic, retain) NSString* imageSelected;
@property (nonatomic, retain) NSString* imageDisabled;

@end
