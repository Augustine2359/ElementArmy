//
//  NBStaticObject.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 23/12/12.
//
//
// How to use:
// - On your layer, during the method "OnEnter", call the static method "initializeWithSpriteBatchNode: andLayer: andWindowsSize:" and feed the required variable.
// - The first step is one time, but if you leave your layer and later come back again, the method must be called again.
// - Simply create a property of type of NBStaticObject on your layer.
// - Initialize it by calling static method: "createStaticObject:(NSString*)frameName" or
// - if you know the initial position call the method: "createStaticObject:(NSString*)frameName atPosition:(CGPoint)newPosition;"
// - Being derived from NBBasicObject, you can define your own custom size by calling method: "setCustomSize:(CGSize)newSize".
// - Being derived from CCNodes at the lowest level, you can call its "visible" method to decide whether to show or hide the object.
// - See sample on NBIntroScreen.h


#import "NBStaticObject.h"

static CCArray* staticObjectList = nil;
static CCSpriteBatchNode* currentSpriteBatchNode = nil;
static CCLayer* currentLayer = nil;
static CGSize winSize = {0, 0};

@implementation NBStaticObject

+(void)initializeWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode andLayer:(CCLayer*)layer andWindowsSize:(CGSize)size
{
    [NBStaticObject setCurrentSpriteBatchNode:spriteBatchNode];
    [NBStaticObject setCurrentLayer:layer];
    [NBStaticObject setWinSize:size];
}

+(void)setCurrentSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode
{
    currentSpriteBatchNode = spriteBatchNode;
}

+(CCSpriteBatchNode*)getCurrentSpriteBatchNode
{
    return currentSpriteBatchNode;
}

+(void)setCurrentLayer:(CCLayer*)layer
{
    currentLayer = layer;
}

+(CCLayer*)getCurrentLayer
{
    return currentLayer;
}

+(void)setWinSize:(CGSize)size
{
    winSize = size;
}

+(CGSize)getWinSize
{
    return winSize;
}

+(id)createStaticObject:(NSString*)frameName
{
    return [[NBStaticObject alloc] initWithFrameName:frameName andSpriteBatchNode:currentSpriteBatchNode onLayer:currentLayer atPosition:CGPointZero];
}

+(id)createStaticObject:(NSString*)frameName atPosition:(CGPoint)newPosition
{
    return [[NBStaticObject alloc] initWithFrameName:frameName andSpriteBatchNode:currentSpriteBatchNode onLayer:currentLayer atPosition:newPosition];
}

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer atPosition:(CGPoint)position
{
    if (!staticObjectList)
    {
        staticObjectList = [[CCArray alloc] initWithCapacity:MAXIMUM_STATIC_OBJECT_CAPACITY];
    }
    
    if (self == [super initWithFrameName:frameName andSpriteBatchNode:spriteBatchNode onLayer:layer])
    {
        self.currentLayer = layer;
        self.objectIndex = [layer.children count];
        self.position = position;
    }
    
    [staticObjectList addObject:self];
    
    //[layer addChild:self z:[staticObjectList count]];
    
    return self;
}

@end
