//
//  NBSpellProjectile.m
//  ElementArmy1.0
//
//  Created by Augustine on 6/4/13.
//
//

#import "NBSpellProjectile.h"

@interface NBSpellProjectile()

@property (nonatomic, strong) NSMutableArray *damagedCharacters;
@property (nonatomic) CGFloat spellProjectileSpeed;

@end

@implementation NBSpellProjectile

- (id)init {
  self = [super init];
  if (self) {
    self.damagedCharacters = [NSMutableArray array];
    self.spellProjectileSpeed = 10;
    self.isReturningToThrower = NO;
  }
  return self;
}

- (id)initWithSpeed:(CGFloat)speed {
  self = [super init];
  if (self) {
    self.damagedCharacters = [NSMutableArray array];
    self.spellProjectileSpeed = speed;
    self.isReturningToThrower = NO;
  }
  
  return self;
}

- (void)checkShouldDamageCharacter:(NBCharacter *)character {
  
}

- (CGFloat)speed {
  return self.spellProjectileSpeed;
}

@end
