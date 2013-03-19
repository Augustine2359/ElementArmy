//
//  NBSingleAnimatedObject.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 17/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBSingleAnimatedObject : CCSprite

-(void)addAnimationFrameName:(NSString*)animationFrameName withAnimationCount:(int)animationCount fileExtension:(NSString*)fileExtension;
-(void)playAnimationWithDelay:(ccTime)delayTime informToObject:(id)object onSelector:(SEL)selector;
-(void)playAnimation:(bool)forever withDelay:(ccTime)delayTime;
-(void)stopAnimation;

@property (nonatomic, retain) NSMutableArray* frames;

@end
