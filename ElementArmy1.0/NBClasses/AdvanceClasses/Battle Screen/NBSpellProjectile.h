//
//  NBSpellProjectile
//  ElementArmy1.0
//
//  Created by Augustine on 6/4/13.
//
//

#import <Foundation/Foundation.h>
#import "NBCharacter.h"

@interface NBSpellProjectile : NSObject

@property (nonatomic, strong) NBCharacter *thrower;
@property (nonatomic, strong) NBCharacter *target;
@property (nonatomic) BOOL isBoomerang;
@property (nonatomic) BOOL isReturningToThrower;

- (id)initWithSpeed:(CGFloat)speed;
- (void)checkShouldDamageCharacter:(NBCharacter *)character;

- (CGFloat)speed;

@end
