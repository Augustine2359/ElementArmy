//
//  NBFireExplosion.m
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 14/10/12.
//
//

#import "NBFireExplosion.h"

@implementation NBFireExplosion

static int objectCount = 0;

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer
{
    //Implement below, but mostly you would be only changing the sprite name
    objectCount++;
    self = [super initWithFrameName:FIRE_EXPLOSION_MAGIC_FILE andSpriteBatchNode:spriteBatchNode onLayer:layer];
    self.name = @"FireExplosionMagic";
    
    self.position = CGPointMake(300, 200);
    
    return self;
}

@end
