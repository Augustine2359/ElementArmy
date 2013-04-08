//
//  NBChainLightning.h
//  ElementArmy1.0
//
//  Created by Augustine on 8/4/13.
//
//

#import "CCNode.h"
#import "NBCharacter.h"

@class NBChainLightning;

@protocol NBChainLightningDelegate <NSObject>

- (void)chainLightningDamagedCharacter:(NBCharacter *)character;

@end

@interface NBChainLightning : CCNode

@property (nonatomic) NSInteger numberOfTargets;
@property (nonatomic, strong) id<NBChainLightningDelegate> delegate;

- (id)initWithThrower:(NBCharacter *)thrower andTargets:(NSArray *)targets;
- (void)startChainLightning;

@end
