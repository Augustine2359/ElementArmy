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

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if ([response.products count] > 0)
    {
        self.productList = response.products;
        
        for (SKProduct* product in self.productList)
        {
            DLog(@"%@ success", product.productIdentifier);
        }
    }
    else
    {
        for (NSString* product in response.invalidProductIdentifiers)
        {
            DLog(@"%@ failed", product);
        }
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  DLog(@"%@", request);
  DLog(@"%@", error);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
  
}

-(void)completeTransaction:(SKPaymentTransaction*)transaction
{
    // Your application should implement these two methods.
    //[self recordTransaction:transaction];
    //[self provideContent:transaction.payment.productIdentifier];
    DLog(@"Transaction %@ Completed", transaction.payment.productIdentifier);
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)restoreTransaction:(SKPaymentTransaction*)transaction
{
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    DLog(@"Transaction %@ Restored", transaction.originalTransaction.payment.productIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)failedTransaction:(SKPaymentTransaction*)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        DLog(@"Transaction %@ cancelled", transaction.originalTransaction.payment.productIdentifier);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)makePurchase:(NSString*)productID
{
    for (SKProduct* product in self.productList)
    {
        if ([product.productIdentifier isEqualToString:productID])
        {
            SKPayment* payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
}

@end
