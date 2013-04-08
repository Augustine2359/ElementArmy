//
//  NBRipples.h
//  ElementArmy1.0
//
//  Created by Augustine on 20/3/13.
//
//

#import "CCNode.h"
#import "NBSpell.h"

@protocol NBRipplesDelegate <NBSpellDelegate>

@optional
- (void)rippleFinished:(CGPoint)rippleOrigin rippleAmplitude:(CGFloat)rippleAmplitude;

@end

@interface NBRipples : CCNode

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat amplitude;
@property (nonatomic) NSInteger numberOfRipples;
@property (nonatomic) CGFloat rippleInterval;
@property (nonatomic) CGFloat rippleDuration;

@property (nonatomic, strong) id <NBSpellDelegate> delegate; //inform the delegate every time a ripple fades out

- (id)initWithPosition:(CGPoint)theOrigin amplitude:(CGFloat)theAmplitude numberOfRipples:(NSInteger)theNumberOfRipples rippleInterval:(CGFloat)theRippleInterval rippleDuration:(CGFloat)theRippleDuration;
- (void)startRipples;

@end
