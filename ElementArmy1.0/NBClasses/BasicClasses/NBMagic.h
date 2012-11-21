//
//  NBMagic.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 19/9/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBBasicObject.h"

@interface NBMagic : NBBasicObject

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer;

@property (nonatomic, retain) NSString* name;

@end
