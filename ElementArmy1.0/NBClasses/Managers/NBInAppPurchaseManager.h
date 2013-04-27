//
//  NBInAppPurchaseManager.h
//  ElementArmy1.0
//
//  Created by Augustine on 23/4/13.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface NBInAppPurchaseManager : NSObject

+(NBInAppPurchaseManager*)sharedInstance;
-(void)makePurchase:(NSString*)productID;

@property (nonatomic, retain) NSArray* productList;

@end
