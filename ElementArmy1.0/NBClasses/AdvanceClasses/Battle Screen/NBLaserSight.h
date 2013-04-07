//
//  NBLaserSight.h
//  ElementArmy1.0
//
//  Created by Augustine on 6/4/13.
//
//

#import "CCNode.h"
#import "NBSpellProjectile.h"

@class NBLaserSight;

@protocol NBLaserSightDelegate <NSObject>

- (void)lockOnFinished:(NBLaserSight *)laserSight;

@end

@interface NBLaserSight : CCNode

@property (nonatomic, strong) NSArray *spellProjectiles;
@property (nonatomic, strong) id <NBLaserSightDelegate> delegate; //inform the delegate when lock-on is complete

- (id)initWithSpellProjectiles:(NSArray *)projectiles lockOnTime:(CGFloat)time;
- (void)startLockOn;

@end
