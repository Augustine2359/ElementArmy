//
//  NBSimpleButton.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NBStaticObject.h"

#define DEFAULT_BUTTON_NORMAL_FRAME_NAME @"staticbox_blue.png"
#define DEFAULT_BUTTON_SELECTED_FRAME_NAME @"staticbox_red.png"
#define DEFAULT_BUTTON_DISABLED_FRAME_NAME @"staticbox_gray.png"
#define DEFAULT_PRESSED_DURATION 250

typedef enum
{
    Released = 0,
    Pressed = 1,
    Disabled = 2,
    Reserved
} EnumButtonState;

@interface NBButton : NBBasicObject

+(id)createOnLayer:(CCLayer*)layer selector:(SEL)selector;
+(id)createWithSize:(CGSize)size onLayer:(CCLayer*)layer selector:(SEL)selector;
+(id)createWithCustomImageHavingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite onLayer:(CCLayer*)layer selector:(SEL)selector;
-(id)initOnLayer:(CCLayer*)layer selector:(SEL)selector havingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite;
-(CGPoint)getPosition;
-(void)show;
-(void)hide;

@property (nonatomic, retain) CCMenu* menu;
@property (nonatomic, retain) CCMenuItemSprite* buttonObject;
@property (nonatomic, retain) CCSprite* normalSprite;
@property (nonatomic, retain) CCSprite* selectedSprite;
@property (nonatomic, retain) CCSprite* disabledSprite;

@end