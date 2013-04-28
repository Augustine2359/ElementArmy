//
//  NBInAppPurchaseManager.h
//  ElementArmy1.0
//
//  Created by Augustine on 23/4/13.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define GEMS_TEST_100 @"gem.test.100"

@protocol NBInAppPurchaseManagerDelegate <NSObject>

- (void)finishPurchaseForProductWithProductIdentifier:(NSString *)productIdentifier;

@end

@interface NBInAppPurchaseManager : NSObject

+(NBInAppPurchaseManager*)sharedInstance;

@property (nonatomic, strong) id<NBInAppPurchaseManagerDelegate> delegate;

-(void)makePurchase:(NSString*)productID;

@end
