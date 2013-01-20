//
//  NBStoryScreenScrollingTextLayer.m
//  ElementArmy1.0
//
//  Created by Augustine on 17/1/13.
//
//

#import "NBStoryScreenScrollingTextLayer.h"
#import "CCLabelTTF.h"
#import "CCActionInterval.h"

#define TEXT_SLIDE_DURATION 5

@implementation NBStoryScreenScrollingTextLayer

- (id)init {
  self = [super init];
  if (self) {
    NSString *text = @"The quick brown fox jumps over the lazy dog";
    CCLabelTTF *label0 = [CCLabelTTF labelWithString:text fontName:@"Zapfino" fontSize:16];
    [self addChild:label0];

    CGPoint position = label0.position;
    position.y -= self.contentSize.height;
    id move = [CCMoveTo actionWithDuration:TEXT_SLIDE_DURATION position:position];
    [label0 runAction:move];

    CCLabelTTF *label1 = [CCLabelTTF labelWithString:text fontName:@"Zapfino" fontSize:16];
    position = label1.position;
    position.y += self.contentSize.height;
    label1.position = position;
    [self addChild:label1];

    position.y -= self.contentSize.height;
    move = [CCMoveTo actionWithDuration:TEXT_SLIDE_DURATION position:position];
    [label1 runAction:move];

  }
  return self;
}

@end
