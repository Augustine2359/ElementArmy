//
//  NBDamageLabel.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 4/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBDamageLabel : CCLabelAtlas
{
    CGFloat damageCounterLabelRemainingTime;
    int currentDamageLabelIndex;
}

+(void)setCurrentLayerForDamageLabel:(CCLayer*)layer;
+(void)registerDamage:(CGPoint)position withDamageAmount:(long)damage;
-(void)animate;

@end
