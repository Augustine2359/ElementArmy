//
//  NBAreaEffect.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBAreaEffect : CCSprite <CCTargetedTouchDelegate>
{
    bool isFollowing;
}

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName onLayer:(CCLayer*)layer;
-(void)activate;
-(void)deactivate;
-(BOOL)isTouchingMe:(CGPoint)touchLocation;

@property (nonatomic, assign) CGSize areaSize;

@end
