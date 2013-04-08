//
//  NBChainLightning.m
//  ElementArmy1.0
//
//  Created by Augustine on 8/4/13.
//
//

#import "NBChainLightning.h"

@interface NBChainLightning()

@property (nonatomic, strong) NSMutableArray *randomlyOrderedTargets;
@property (nonatomic, strong) NBCharacter *thrower;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic) NSInteger numberOfActiveArcs;
@property (nonatomic) CGFloat timePerArc;

@end

@implementation NBChainLightning

- (void)randomnizeTargets:(NSArray *)targets {
  NSMutableArray *randomTargets = [targets mutableCopy];
  while ([randomTargets count] > 0) {
    NSInteger randomIndex = arc4random()%[randomTargets count];
    NBCharacter *target = [randomTargets objectAtIndex:randomIndex];
    [randomTargets removeObjectAtIndex:randomIndex];
    [self.randomlyOrderedTargets addObject:target];
    if ([self.randomlyOrderedTargets count] >= self.numberOfTargets)
      break;
  }
}

- (id)initWithThrower:(NBCharacter *)thrower andTargets:(NSArray *)targets {
  self = [super init];
  if (self) {
    self.thrower = thrower;
    self.numberOfTargets = [targets count];
    self.randomlyOrderedTargets = [NSMutableArray array];
    self.numberOfActiveArcs = 0;
    self.timePerArc = 1;
    [self randomnizeTargets:targets];
  }

  return self;
}

- (void)startChainLightning {
  self.startDate = [NSDate date];
  [NSTimer scheduledTimerWithTimeInterval:self.timePerArc target:self selector:@selector(increaseArc:) userInfo:nil repeats:YES];
//  NSTimer *timer = [NSTimer timerWithTimeInterval:self.timePerArc target:self selector:@selector(increaseArc:) userInfo:nil repeats:YES];
//  [timer fire];
}

- (void)increaseArc:(NSTimer *)timer {
  if (self.numberOfActiveArcs >= [self.randomlyOrderedTargets count]) {
    [timer invalidate];
    [self removeFromParentAndCleanup:YES];
  }
  else {
    [self.delegate chainLightningDamagedCharacter:[self.randomlyOrderedTargets objectAtIndex:self.numberOfActiveArcs]];
    self.numberOfActiveArcs++;
  }
}

- (void)drawFunkyCurveBetweenCharacter:(NBCharacter *)character andCharacter:(NBCharacter *)otherCharacter {
  CGFloat gradient = (otherCharacter.position.y - character.position.y) / (otherCharacter.position.x - character.position.x);
  CGFloat gradientOfBisector = -1.0/gradient;
  CGPoint midPoint = ccpMidpoint(character.position, otherCharacter.position);
  CGFloat distance = ccpDistance(character.position, otherCharacter.position);
  CGPoint controlPoint;
  CGFloat multiplier = 5.0;

  CGPoint controlPointA = ccpAdd(midPoint, CGPointMake(distance/multiplier, distance*gradientOfBisector/multiplier));
  CGPoint controlPointB = ccpAdd(midPoint, CGPointMake(-distance/multiplier, distance*gradientOfBisector/multiplier));

  controlPointA = CGPointMake((character.position.x + otherCharacter.position.x)/3, character.position.y);
  controlPointB = CGPointMake((character.position.x + otherCharacter.position.x)/3*2, otherCharacter.position.y);
  ccDrawCubicBezier(character.position, controlPointA, controlPointB, otherCharacter.position, 30);
//  if (gradientOfBisector >= 0)
//    controlPoint = ccpAdd(midPoint, CGPointMake(distance/multiplier, distance/multiplier*gradientOfBisector));
//  else
//    controlPoint = ccpAdd(midPoint, CGPointMake(-distance/multiplier, distance/multiplier*gradientOfBisector));
//  ccDrawQuadBezier(character.position, controlPoint, otherCharacter.position, 30);
}

- (void)draw {
  glLineWidth(2);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  ccDrawColor4F(1, 1, 1, 1);

  if (self.numberOfActiveArcs < 1)
    return;

  [self drawFunkyCurveBetweenCharacter:self.thrower andCharacter:[self.randomlyOrderedTargets objectAtIndex:0]];
  for (NSInteger index = 1; index < self.numberOfActiveArcs; index++) {
    [self drawFunkyCurveBetweenCharacter:[self.randomlyOrderedTargets objectAtIndex:index-1]
                            andCharacter:[self.randomlyOrderedTargets objectAtIndex:index]];
  }

//  for (NSInteger index = 0; index < [self.spellProjectiles count]; index++) {
//    NBSpellProjectile *spellProjectile = [self.spellProjectiles objectAtIndex:index];
//    ccDrawColor4F(1, 0, 0, 1);
//    ccDrawLine(spellProjectile.thrower.position, spellProjectile.target.position);
//  }
}

@end
