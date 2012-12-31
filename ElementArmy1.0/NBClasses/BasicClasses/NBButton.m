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

+(id)createOnLayer:(CCLayer*)layer selector:(SEL)selector
{
    return [NBButton createWithSize:CGSizeZero onLayer:layer selector:selector];
}

+(id)createWithSize:(CGSize)size onLayer:(CCLayer*)layer selector:(SEL)selector
{
    CCSprite* normalSprite = [CCSprite spriteWithSpriteFrameName:DEFAULT_BUTTON_NORMAL_FRAME_NAME];
    CCSprite* selectedSprite = [CCSprite spriteWithSpriteFrameName:DEFAULT_BUTTON_SELECTED_FRAME_NAME];
    CCSprite* disabledSprite = [CCSprite spriteWithSpriteFrameName:DEFAULT_BUTTON_DISABLED_FRAME_NAME];
    
    NBButton* tempButton = [[NBButton alloc] initOnLayer:layer selector:selector havingNormal:normalSprite havingSelected:selectedSprite havingDisabled:disabledSprite];
    
    if (!CGSizeEqualToSize(size, CGSizeZero))
    {
        [tempButton.buttonObject setScaleX:(size.width / tempButton.buttonObject.contentSize.width)];
        [tempButton.buttonObject setScaleY:(size.height / tempButton.buttonObject.contentSize.height)];
    }
    
    return tempButton;
}

+(id)createWithCustomImageHavingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite onLayer:(CCLayer*)layer selector:(SEL)selector
{
    return [[NBButton alloc] initOnLayer:layer selector:selector havingNormal:normalSprite havingSelected:selectedSprite havingDisabled:disabledSprite];
}

-(id)initOnLayer:(CCLayer*)layer selector:(SEL)selector havingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite
{
    if (!buttonList)
    {
        buttonList = [[CCArray alloc] initWithCapacity:50];
    }
    
    self.normalSprite = normalSprite;
    self.selectedSprite = selectedSprite;
    self.disabledSprite = disabledSprite;
    
    self.buttonObject = [CCMenuItemSprite itemWithNormalSprite:self.normalSprite selectedSprite:self.selectedSprite disabledSprite:self.disabledSprite target:layer selector:selector];
    self.menu = [CCMenu menuWithItems:self.buttonObject, nil];
    [self hide];
    self.name = [NSString stringWithFormat:@"Button%i", [buttonList count]];
    
    [layer addChild:self.menu];
    
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

-(void)show
{
    self.menu.visible = YES;
}

-(void)hide
{
    self.menu.visible = NO;
}

@end
