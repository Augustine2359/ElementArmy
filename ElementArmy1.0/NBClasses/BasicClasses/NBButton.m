//
//  NBSimpleButton.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
//

#import "NBButton.h"

@implementation NBButton

+(id)create
{
    return [NBButton createWithSize:CGSizeMake(100, 40)];
}

+(id)createWithSize:(CGSize)size
{
    NBButton* tempButton = [[NBButton alloc] initWithFrameName:DEFAULT_BUTTON_FRAME_NAME andSpriteBatchNode:[NBStaticObject getCurrentSpriteBatchNode] onLayer:[NBStaticObject getCurrentLayer] atPosition:CGPointZero];
    
    [tempButton setToCustomSize:size];
    
    return tempButton;
}

-(id)initWithFrameName:(NSString *)frameName andSpriteBatchNode:(CCSpriteBatchNode *)spriteBatchNode onLayer:(CCLayer *)layer
{
    if ((self = [super initWithFrameName:frameName andSpriteBatchNode:spriteBatchNode onLayer:layer]))
    {
        self.state = Released;
        self.stateArray = [[CCArray alloc] initWithCapacity:Reserved];
        
        for (int i = 0; i < Reserved; i++)
        {
            [self.stateArray addObject:DEFAULT_BUTTON_RELEASED_FRAME_NAME];
        }
    }
    
    return self;
}

-(void)addStateFrame:(EnumButtonState)state usingFrame:(NSString*)frameName
{
    if (!self.stateArray) self.stateArray = [[CCArray alloc] initWithCapacity:Reserved];
    
    [self.stateArray replaceObjectAtIndex:state withObject:frameName];
}

-(void)addHandler:(id)target selector:(SEL)handler
{
    self.owner = target;
    self.handler = handler;
}

-(void)onPressed
{
    self.state = Pressed;
    pressedDuration = DEFAULT_PRESSED_DURATION;
    
    [self.owner performSelector:self.handler];
}

-(void)onReleased
{
    
}

-(void)update:(ccTime)delta
{
    [self setCurrentFrame:[self.stateArray objectAtIndex:self.state]];
    
    if (self.state == Pressed)
    {
        pressedDuration -= (delta * 60);
        if (pressedDuration <= 0)
        {
            self.state = Released;
        }
    }
}

-(void)onTouched
{
    [self onPressed];
}

@end
