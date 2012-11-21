//
//  NBFireExplosion.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 14/10/12.
//
//

#import <Foundation/Foundation.h>
#import "NBSkill.h"

#define FIRE_EXPLOSION_MAGIC_FILE @"skill_fire_mage_skill1.png"

@interface NBFireExplosion : NBSkill

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer;

@end
