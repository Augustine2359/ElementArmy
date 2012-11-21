//
//  NBFireball.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/10/12.
//
//

#import <Foundation/Foundation.h>
#import "NBProjectile.h"

#define NORMAL_FIREBALL_FILE @"fireball_anim_1.png"
#define FIREBALL_TRAVELLING_SPEED 2
#define FIREBALL_MINIMUM_POWER 10

@interface NBFireball : NBProjectile

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setOwner:(NBCharacter*)owner;

@end
