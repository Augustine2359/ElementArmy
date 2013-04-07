//
//  NBHUDLayer.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 31/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBFancySlidingMenuLayer.h"
#import "NBUserInterface.h"
#import "NBAreaEffect.h"

@interface NBHUDLayer : NBBasicScreenLayer
{
    CGFloat targetScaleXForHPBar;
    CGFloat targetScaleYForHPBar;
}

-(void)prepareUI:(id)battleLayer;
-(void)entranceAnimationStep2:(id)objectToRespond withSelector:(SEL)selector;
-(void)entranceAnimationStep3:(id)objectToRespond withSelector:(SEL)selector;
-(void)entranceAnimationStep4;
-(void)updateAllyHPScale:(long)scaleAmount;
-(void)updateEnemyHPScale:(long)scaleAmount;

@property (nonatomic, retain) id battlefieldLayer;
@property (nonatomic, retain) NBFancySlidingMenuLayer *itemMenuLayer;
@property (nonatomic, retain) CCSprite* allyFlagLogo;
@property (nonatomic, retain) CCSprite* enemyFlagLogo;
@property (nonatomic, retain) CCSprite* HPBarPlaceholder;
@property (nonatomic, retain) CCSprite* allyHPBar;
@property (nonatomic, retain) CCSprite* enemyHPBar;
@property (nonatomic, retain) NBButton* startBattleButton;

@property (nonatomic, retain) NBAreaEffect* itemAreaEffect;
@property (nonatomic, retain) NBItem* item1;
@property (nonatomic, retain) NBItem* item2;
@property (nonatomic, retain) NBItem* item3;

@end
