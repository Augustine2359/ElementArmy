//
//  NBShakeEffect.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 31/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBShakeEffect : CCActionInterval

+(id)actionWithDuration:(ccTime)duration withStrength:(float)strength;
-(id)initWithDuration:(ccTime)duration withXStrength:(float)strength_x withYStrength:(float)strength_y;
-(float)fgRangeRand:(float)min :(float)max;
-(void)update:(ccTime)time;
-(void)startWithTarget:(CCNode*)target;

@property (nonatomic, assign) float _strength_x;
@property (nonatomic, assign) float _strength_y;
@property (nonatomic, assign) float _initial_x;
@property (nonatomic, assign) float _initial_y;

@end
