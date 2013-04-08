//
//  NBChainLightning.h
//  ElementArmy1.0
//
//  Created by Augustine on 8/4/13.
//
//

#import "CCNode.h"
#import "NBCharacter.h"
#import "NBSpell.h"

@class NBChainLightning;

@protocol NBChainLightningDelegate <NBSpellDelegate>

@optional
- (void)chainLightningDamagedCharacter:(NBCharacter *)character;

@end

@interface NBChainLightning : NBSpell

@property (nonatomic) NSInteger numberOfTargets;

- (id)initWithThrower:(NBCharacter *)thrower andTargets:(NSArray *)targets;
- (void)startChainLightning;

@end
