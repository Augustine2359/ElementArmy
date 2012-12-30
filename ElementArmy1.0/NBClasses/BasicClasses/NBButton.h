//
//  NBSimpleButton.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NBStaticObject.h"

#define DEFAULT_BUTTON_FRAME_NAME @"staticbox_blue.png"
#define DEFAULT_BUTTON_RELEASED_FRAME_NAME @"staticbox_blue.png"
#define DEFAULT_BUTTON_PRESSED_FRAME_NAME @"staticbox_red.png"
#define DEFAULT_BUTTON_DISABLED_FRAME_NAME @"staticbox_blue.png"
#define DEFAULT_PRESSED_DURATION 250

typedef enum
{
    Released = 0,
    Pressed = 1,
    Disabled = 2,
    Reserved = 3
} EnumButtonState;

@interface NBButton : NBStaticObject
{
    int pressedDuration;
}

+(id)create;
+(id)createWithSize:(CGSize)size;
-(void)addStateFrame:(EnumButtonState)state usingFrame:(NSString*)frameName;
-(void)addHandler:(id)target selector:(SEL)handler;
-(void)onPressed;
-(void)onReleased;

@property (nonatomic, retain) NSString* text;
@property (nonatomic, assign) EnumButtonState state;
@property (nonatomic, retain) CCArray* stateArray;
@property (nonatomic, retain) id owner;
@property (nonatomic, assign) SEL handler;

@end
