//
//  NBLaserSight.m
//  ElementArmy1.0
//
//  Created by Augustine on 6/4/13.
//
//

#import "NBLaserSight.h"

@interface NBLaserSight()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic) CGFloat lockOnTime;

@end

@implementation NBLaserSight

- (id)initWithSpellProjectiles:(NSArray *)projectiles lockOnTime:(CGFloat)time {
  self = [super init];
  if (self) {
    self.spellProjectiles = projectiles;
    self.lockOnTime = time;
  }

  return self;
}

- (void)startLockOn {
  self.startDate = [NSDate date];
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self forKey:@"laserSight"];
  NSTimer *timer = [NSTimer timerWithTimeInterval:self.lockOnTime target:self.delegate selector:@selector(lockOnFinished:) userInfo:userInfo repeats:NO];
  timer.fireDate = [self.startDate dateByAddingTimeInterval:self.lockOnTime];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)draw {
  glLineWidth(2);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  for (NSInteger index = 0; index < [self.spellProjectiles count]; index++) {
    NBSpellProjectile *spellProjectile = [self.spellProjectiles objectAtIndex:index];
    ccDrawColor4F(1, 0, 0, 1);
    ccDrawLine(spellProjectile.thrower.position, spellProjectile.target.position);
  }
}

@end
