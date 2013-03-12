//
//  NBMessageBox.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
//

#import "NBMessageBox.h"

@interface NBMessageBox()

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) CCLabelBMFont *label;

@end

static NBMessageBox* currentMessageBox = nil;

@implementation NBMessageBox

- (id)initWithFrameName:(NSString *)frameName andSpriteBatchNode:(CCSpriteBatchNode *)spriteBatchNode onLayer:(CCLayer *)layer atMessageBoxStartingPosition:(enum MessageBoxStartingPosition)messageBoxStartingPosition {
  self = [super initWithFrameName:frameName andSpriteBatchNode:nil onLayer:layer];
  if (self) {
    self.text = @"testtesttest";
    self.label = [CCLabelBMFont labelWithString:self.text fntFile:[[NSBundle mainBundle] pathForResource:@"sampleFont" ofType:@"fnt"]];

    CGPoint position = CGPointMake(0, 0);

    switch (messageBoxStartingPosition) {
      case MessageBoxStartingPositionBottomLeft:
        position.x += self.label.contentSize.width/2;
        position.y += self.label.contentSize.height/2;
        break;
      case MessageBoxStartingPositionBottom:
        position.x += layer.contentSize.width/2;
        position.y += self.label.contentSize.height/2;
        break;
      case MessageBoxStartingPositionBottomRight:
        position.x += layer.contentSize.width - self.label.contentSize.width/2;
        position.y += self.label.contentSize.height/2;
        break;
      case MessageBoxStartingPositionLeft:
        position.x += self.label.contentSize.width/2;
        position.y += layer.contentSize.height/2;
        break;
      case MessageBoxStartingPositionCentre:
        position.x += layer.contentSize.width/2;
        position.y += layer.contentSize.height/2;
        break;
      case MessageBoxStartingPositionRight:
        position.x += layer.contentSize.width - self.label.contentSize.width/2;
        position.y += layer.contentSize.height/2;
        break;
      case MessageBoxStartingPositionTopLeft:
        position.x += self.label.contentSize.width/2;
        position.y += layer.contentSize.height - self.label.contentSize.height/2;
        break;
      case MessageBoxStartingPositionTop:
        position.x += layer.contentSize.width/2;
        position.y += layer.contentSize.height - self.label.contentSize.height/2;
        break;
      case MessageBoxStartingPositionTopRight:
        position.x += layer.contentSize.width - self.label.contentSize.width/2;
        position.y += layer.contentSize.height - self.label.contentSize.height/2;
        break;
      default:
        break;
    }
    self.label.position = position;
    [self addChild:self.label];

    self.buttonOK = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:layer respondTo:self selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    self.buttonOK.position = position;
    [self.buttonOK show];

    [self scaleFrom:0 toScale:1 inDuration:2];
  }
  return self;
}

- (void)scaleFrom:(CGFloat)fromScale toScale:(CGFloat)toScale inDuration:(CGFloat)duration {
  self.label.scale = fromScale;
  self.buttonOK.buttonObject.scale = fromScale;
  id scaleAction = [CCScaleTo actionWithDuration:duration scale:toScale];
  [self.label runAction:scaleAction];
  scaleAction = [CCScaleTo actionWithDuration:duration scale:toScale];
  [self.buttonOK.buttonObject runAction:scaleAction];
}

- (void)gotoBattleScreen {
  [self scaleFrom:1 toScale:0 inDuration:2];
}

@end
