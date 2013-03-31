//
//  NBShakeEffect.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 31/3/13.
//
//

#import "NBShakeEffect.h"

@implementation NBShakeEffect

+(id)actionWithDuration:(ccTime)duration withStrength:(float)strength
{
    return [NBShakeEffect actionWithDuration:duration withXStrength:strength withYStrength:strength];
}

+(id)actionWithDuration:(ccTime)duration withXStrength:(float)strength_x withYStrength:(float)strength_y
{
    NBShakeEffect* p_action = [[NBShakeEffect alloc] initWithDuration:duration withXStrength:strength_x withYStrength:strength_y];
    
    return p_action;
}
                                                              
-(id)initWithDuration:(ccTime)duration withXStrength:(float)strength_x withYStrength:(float)strength_y
{
    if (self = [super initWithDuration:duration])
    {
        self._strength_x = strength_x;
        self._strength_y = strength_y;
    }
    
    return self;
}

-(float)fgRangeRand:(float)min :(float)max
{
    float rnd = ((float)rand()/(float)RAND_MAX);
    return rnd*(max-min)+min;
}

-(void)update:(ccTime)time
{
    float randx = [self fgRangeRand:-self._strength_x :self._strength_x];
    float randy = [self fgRangeRand:-self._strength_y :self._strength_y];
    
    // move the target to a shaked position
    CCNode* target = (CCNode*)self.target;
    target.position = ccp(randx, randy);
}

-(void)startWithTarget:(CCNode*)target
{
    [super startWithTarget:target];
    
    // save the initial position
    self._initial_x = target.position.x;
    self._initial_y = target.position.y;
}

-(void)stop
{
    CCNode* target = (CCNode*)self.target;
    target.position = ccp(self._initial_x, self._initial_y);
    
    [super stop];
}
@end
