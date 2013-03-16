//
//  NBMessageBox.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NBStaticObject.h"
#import "NBButton.h"

#define MESSAGE_BOX_FRAME_NAME @"static_box.png"

enum MessageBoxStartingPosition {
  MessageBoxStartingPositionCentre = 0,
  MessageBoxStartingPositionTop,
  MessageBoxStartingPositionBottom,
  MessageBoxStartingPositionRight,
  MessageBoxStartingPositionLeft,
  MessageBoxStartingPositionTopRight,
  MessageBoxStartingPositionTopLeft,
  MessageBoxStartingPositionBottomRight,
  MessageBoxStartingPositionBottomLeft
  };

@interface NBMessageBox : NBStaticObject

- (id)initWithFrameName:(NSString *)frameName andSpriteBatchNode:(CCSpriteBatchNode *)spriteBatchNode onLayer:(CCLayer *)layer respondTo:(id)theTarget selector:(SEL)theSelector atMessageBoxStartingPosition:(enum MessageBoxStartingPosition)messageBoxStartingPosition;
- (void)scaleFrom:(CGFloat)fromScale toScale:(CGFloat)toScale inDuration:(CGFloat)duration;

@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NBButton* buttonOK;

@end
