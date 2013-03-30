//
//  NBRipples
//  ElementArmy1.0
//
//  Created by Augustine on 20/3/13.
//
//

#import "NBRipples.h"
#import "CCDrawingPrimitives.h"

@interface NBRipples()

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation NBRipples

- (id)initWithPosition:(CGPoint)theOrigin amplitude:(CGFloat)theAmplitude numberOfRipples:(NSInteger)theNumberOfRipples rippleInterval:(CGFloat)theRippleInterval rippleDuration:(CGFloat)theRippleDuration{
  self = [self init];
  if (self) {
    self.origin = theOrigin;
    self.amplitude = theAmplitude;
    self.numberOfRipples = theNumberOfRipples;
    self.rippleInterval = theRippleInterval;
    self.rippleDuration = theRippleDuration;
  }
  return self;
}

- (id)init {
  self = [super init];
  if (self) {
    self.origin = CGPointMake(100, 100);
    self.amplitude = 50;
    self.numberOfRipples = 10;
    self.startDate = [NSDate date];
    self.rippleInterval = 0.25;
    self.rippleDuration = 1;
  }
  return self;
}

- (void)setDelegate:(id <NBRipplesDelegate>)delegate {
  _delegate = delegate;
  NSTimer *timer = [NSTimer timerWithTimeInterval:self.rippleInterval target:self selector:@selector(rippleFinished:) userInfo:nil repeats:YES];
  timer.fireDate = [self.startDate dateByAddingTimeInterval:self.rippleDuration];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)rippleFinished:(NSTimer *)timer {
  static NSInteger numberOfFinishedRipples = 0;
  numberOfFinishedRipples++;
  [self.delegate rippleFinished:self.origin rippleAmplitude:self.amplitude];

  if (numberOfFinishedRipples >= self.numberOfRipples)
    [timer invalidate];
}

- (void)draw {
  glLineWidth(2);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  for (NSInteger index = 0; index < self.numberOfRipples; index++) {
    NSDate *rippleStartTime = [self.startDate dateByAddingTimeInterval:index * self.rippleInterval];
    CGFloat timeSinceRippleStart = [[NSDate date] timeIntervalSinceDate:rippleStartTime];
    if ((timeSinceRippleStart < 0) || (timeSinceRippleStart > self.rippleDuration))
      continue;

    ccDrawColor4F(0, 0, 0, (self.rippleDuration - timeSinceRippleStart) / self.rippleDuration);
    ccDrawEllipse(self.origin, self.amplitude * timeSinceRippleStart / self.rippleDuration, 0, 60, NO);
  }
}

@end
