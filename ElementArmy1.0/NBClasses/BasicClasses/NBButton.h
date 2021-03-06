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

@interface NBButton : NBStaticObject

+(id)createOnLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector;
+(id)createWithSize:(CGSize)size onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector;
+(id)createWithCustomImageHavingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector withSize:(CGSize)size;
+(id)createWithStringHavingNormal:(NSString*)normalSpriteString havingSelected:(NSString*)selectedSpriteString havingDisabled:(NSString*)disabledSpriteString onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector withSize:(CGSize)size;
+(id)createWithStringHavingNormal:(NSString*)normalSpriteString havingSelected:(NSString*)selectedSpriteString havingDisabled:(NSString*)disabledSpriteString onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector withSize:(CGSize)size onSubLayer:(CCLayer*)subLayer;
-(id)initOnLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector havingNormal:(CCSprite*)normalSprite havingSelected:(CCSprite*)selectedSprite havingDisabled:(CCSprite*)disabledSprite withSize:(CGSize)size;
-(CGPoint)getPosition;
-(void)show;
-(void)hide;
-(void)changeParent:(CCLayer*)layer;
-(void)disable;
-(void)enable;

@property (nonatomic, retain) CCMenu* menu;
@property (nonatomic, retain) CCMenuItemSprite* buttonObject;
@property (nonatomic, retain) CCSprite* normalSprite;
@property (nonatomic, retain) CCSprite* selectedSprite;
@property (nonatomic, retain) CCSprite* disabledSprite;
@property (nonatomic, retain) CCLayer* listenerLayer;
@property (nonatomic, retain) CCLayer* displayLayer;
@property (nonatomic, assign) SEL handlerMethod;
@property (nonatomic, assign) CGSize currentSize;

@end
