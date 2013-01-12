//
//  NBStaticObject.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NBBasicObject.h"

#define MAXIMUM_STATIC_OBJECT_CAPACITY 50
//#define ENABLE_DEBUG

@interface NBStaticObject : NBBasicObject

+(void)initializeWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode andLayer:(CCLayer*)layer andWindowsSize:(CGSize)size;
+(void)setCurrentSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode;
+(CCSpriteBatchNode*)getCurrentSpriteBatchNode;
+(void)setCurrentLayer:(CCLayer*)layer;
+(CCLayer*)getCurrentLayer;
+(void)setWinSize:(CGSize)size;
+(CGSize)getWinSize;
+(id)createStaticObject:(NSString*)frameName;
+(id)createStaticObject:(NSString*)frameName atPosition:(CGPoint)newPosition;
+(id)createWithSize:(CGSize)size usingFrame:(NSString*)frameName atPosition:(CGPoint)newPosition;

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer atPosition:(CGPoint)position;

@end
