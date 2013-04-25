//
//  NBInAppPurchaseManager.m
//  ElementArmy1.0
//
//  Created by Augustine on 23/4/13.
//
//

#import "NBInAppPurchaseManager.h"

@interface NBInAppPurchaseManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) SKProductsRequest *productsRequest;

@end

@implementation NBInAppPurchaseManager

+ (NBInAppPurchaseManager *)sharedInstance {
  static NBInAppPurchaseManager *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[self alloc] init];
  });
  
  return _sharedInstance;  
}

- (id)init {
  self = [super init];
  if (self) {
    NSSet *identifiers = [NSSet setWithObject:[NSString stringWithFormat:@"gem.test.100"]];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //    SKPayment *payment = [SKPayment paymentWithProduct:<#(SKProduct *)#>]
  }
  return self;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  DLog(@"%@", response.products);
  DLog(@"%@", response.invalidProductIdentifiers);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  DLog(@"%@", request);
  DLog(@"%@", error);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
  
}

@end
