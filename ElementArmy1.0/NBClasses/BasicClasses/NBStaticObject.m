//
//  NBStaticObject.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/12/12.
//
//

#import "NBStaticObject.h"

static CCArray* staticObjectList = nil;

@implementation NBStaticObject

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer
{
    if (!staticObjectList)
    {
        staticObjectList = [[CCArray alloc] initWithCapacity:MAXIMUM_STATIC_OBJECT_CAPACITY];
    }
    
    if (self == [super initWithFrameName:frameName andSpriteBatchNode:spriteBatchNode onLayer:layer])
    {
        self.currentLayer = layer;
        self.objectIndex = [layer.children count];
    }
    
    [staticObjectList addObject:self];
    
    [layer addChild:self z:[staticObjectList count]];
    
    return self;
}

@end
