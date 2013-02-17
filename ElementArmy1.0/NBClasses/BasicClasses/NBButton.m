//
//  NBSimpleButton.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
// Features:
// 1. Use CCMenuItemSprite component
// 2. Need all 3 state sprite frame: normal, selected, and disabled

// How to use: see sample on NBIntroScreen, button called wastedMyTimeButton :)

#import "NBButton.h"

static CCArray* buttonList = nil;

@implementation NBButton

+(id)createOnLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector intArgument:(int)intArgument
{
    return [NBButton createWithSize:CGSizeZero onLayer:layer respondTo:object selector:selector intArgument:(int)intArgument];
}

+(id)createWithSize:(CGSize)size onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector intArgument:(int)intArgument
{
    CCSprite* normalSprite = [CCSprite spriteWithSpriteFrameName:DEFAULT_BUTTON_NORMAL_FRAME_NAME];
    CCSprite* selectedSprite = [CCSprite spriteWithSpriteFrameName:DEFAULT_BUTTON_SELECTED_FRAME_NAME];
    CCSprite* disabledSprite = [CCSprite spriteWithSpriteFrameName:DEFAULT_BUTTON_DISABLED_FRAME_NAME];
    
    return [[NBButton alloc] initOnLayer:layer respondTo:object selector:selector havingNormal:normalSprite havingSelected:selectedSprite havingDisabled:disabledSprite withSize:size intArgument:(int)intArgument];
}

+(id)createWithCustomImageHavingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector withSize:(CGSize)size intArgument:(int)intArgument
{
    return [[NBButton alloc] initOnLayer:layer respondTo:object selector:selector havingNormal:normalSprite havingSelected:selectedSprite havingDisabled:disabledSprite withSize:size intArgument:(int)intArgument];
}

+(id)createWithStringHavingNormal:(NSString*)normalSpriteString havingSelected:(NSString*)selectedSpriteString havingDisabled:(NSString*)disabledSpriteString onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector withSize:(CGSize)size intArgument:(int)intArgument
{
    CCSprite* normalSprite = [CCSprite spriteWithSpriteFrameName:normalSpriteString];
    CCSprite* selectedSprite = [CCSprite spriteWithSpriteFrameName:selectedSpriteString];
    CCSprite* disabledSprite = [CCSprite spriteWithSpriteFrameName:disabledSpriteString];
    
    return [[NBButton alloc] initOnLayer:layer respondTo:object selector:selector havingNormal:normalSprite havingSelected:selectedSprite havingDisabled:disabledSprite withSize:size intArgument:(int)intArgument];
}

+(id)createWithStringHavingNormal:(NSString*)normalSpriteString havingSelected:(NSString*)selectedSpriteString havingDisabled:(NSString*)disabledSpriteString onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector withSize:(CGSize)size onSubLayer:(CCLayer*)subLayer intArgument:(int)intArgument
{
    NBButton* tempButton = [NBButton createWithStringHavingNormal:normalSpriteString havingSelected:selectedSpriteString havingDisabled:disabledSpriteString onLayer:layer respondTo:object selector:selector withSize:size intArgument:(int)intArgument];
    [tempButton changeParent:subLayer];
    
    return tempButton;
}

-(id)initOnLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector havingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite withSize:(CGSize)size intArgument:(int)intArgument
{
    if (!buttonList)
    {
        buttonList = [[CCArray alloc] initWithCapacity:50];
    }
    
    self.normalSprite = normalSprite;
    self.selectedSprite = selectedSprite;
    self.disabledSprite = disabledSprite;
    self.displayLayer = layer;
    
    if (object)
    {
        self.buttonObject = [CCMenuItemSprite itemWithNormalSprite:self.normalSprite selectedSprite:self.selectedSprite disabledSprite:self.disabledSprite target:object selector:selector];
    }
    else
    {
        self.buttonObject = [CCMenuItemSprite itemWithNormalSprite:self.normalSprite selectedSprite:self.selectedSprite disabledSprite:self.disabledSprite target:layer selector:selector];
    }
    
    self.menu = [CCMenu menuWithItems:self.buttonObject, nil];
    [self hide];
    self.name = [NSString stringWithFormat:@"Button%i", [buttonList count]];
    
    if (!CGSizeEqualToSize(size, CGSizeZero))
    {
        self.currentSize = size;
        [self.buttonObject setScaleX:(size.width / self.buttonObject.contentSize.width)];
        [self.buttonObject setScaleY:(size.height / self.buttonObject.contentSize.height)];    }
    else
    {
        self.currentSize = CGSizeMake(self.normalSprite.contentSize.width, self.normalSprite.contentSize.height);
    }
    
    [self.displayLayer addChild:self.menu];
    
    self.tempIntStorage = intArgument;
    
    return self;
}

-(void)setPosition:(CGPoint)position
{
    self.menu.position = position;
}

-(CGPoint)getPosition
{
    return self.menu.position;
}

-(void)moveToPosition:(CGPoint)newPosition withDuration:(ccTime)milliseconds
{
    CCMoveTo* move = [CCMoveTo actionWithDuration:milliseconds position:newPosition];
    CCEaseIn* easeIn = [CCEaseIn actionWithAction:move rate:0.5];
    [self.menu runAction:easeIn];
}

-(void)show
{
    self.menu.visible = YES;
}

-(void)hide
{
    self.menu.visible = NO;
}

-(void)changeParent:(CCLayer*)layer
{
    [self.menu removeFromParentAndCleanup:NO];
    self.displayLayer = layer;
    
    [layer addChild:self.menu];
}

-(void)disable
{
    [self.menu setEnabled:NO];
}

-(void)enable
{
    [self.menu setEnabled:YES];
}
@end
