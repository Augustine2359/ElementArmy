//
//  NBMagic.m
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 19/9/12.
//
//

#import "NBMagic.h"

@implementation NBMagic

static int objectCount = 0;

@synthesize name;

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer
{
    if (self == [super initWithFrameName:frameName andSpriteBatchNode:spriteBatchNode onLayer:layer])
    {
        self.currentLayer = layer;
        self.objectIndex = [layer.children count];
        
        objectCount++;
    }
    
    return self;
}

//Events
-(void)onTouched
{
    DLog(@"%@ is touched", self.name);
}

@end
