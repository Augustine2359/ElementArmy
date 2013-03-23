//
//  NBItemData.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBUserInterface.h"

@interface NBItemData : NSObject

@property (nonatomic, retain) NSString* itemID;
@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* impactedStatus;
@property (nonatomic, retain) NSString* impactType;
@property (nonatomic, retain) NSString* impactValue;
@property (nonatomic, retain) NSString* specialEffect;
@property (nonatomic, retain) NSString* frame;
@property (nonatomic, assign) int maximumAllowable;

@property (nonatomic, assign) int availableAmount;

@end
