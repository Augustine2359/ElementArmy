//
//  NBMessageBox.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
//

#import "NBMessageBox.h"

static NBMessageBox* currentMessageBox = nil;

@implementation NBMessageBox

+(void)show:(NSString*)message
{
    currentMessageBox = [[NBMessageBox alloc] initWithFrameName:MESSAGE_BOX_FRAME_NAME andSpriteBatchNode:[NBStaticObject getCurrentSpriteBatchNode] onLayer:[NBStaticObject getCurrentLayer] atPosition:CGPointMake([NBStaticObject getWinSize].width / 2, [NBStaticObject getWinSize].height / 2)];
}

-(id)initWithFrameName:(NSString *)frameName andSpriteBatchNode:(CCSpriteBatchNode *)spriteBatchNode onLayer:(CCLayer *)layer atPosition:(CGPoint)position
{
    self = [super initWithFrameName:frameName andSpriteBatchNode:spriteBatchNode onLayer:layer atPosition:position];
    return self;
}

-(void)onTouched
{
    
}

@end
