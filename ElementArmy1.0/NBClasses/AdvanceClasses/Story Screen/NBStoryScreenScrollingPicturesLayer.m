//
//  NBStoryScreenScrollingPicturesLayer.m
//  ElementArmy1.0
//
//  Created by Augustine on 17/1/13.
//
//

#import "NBStoryScreenScrollingPicturesLayer.h"
#import "CCSprite.h"
#import "CCActionInterval.h"

#define PICTURE_SLIDE_DURATION 5

@implementation NBStoryScreenScrollingPicturesLayer

- (id)init {
  self = [super init];
  if (self) {
    CCSprite *picture0 = [CCSprite spriteWithSpriteFrameName:@"NB_worldMap_960x480.png"];
    [self addChild:picture0];

    CGPoint position = picture0.position;
    position.x -= self.contentSize.width;
    id move = [CCMoveTo actionWithDuration:PICTURE_SLIDE_DURATION position:position];
    [picture0 runAction:move];

    CCSprite *picture1 = [CCSprite spriteWithSpriteFrameName:@"NB_worldMap_960x480.png"];
    position = picture1.position;
    position.x += self.contentSize.width;
    picture1.position = position;
    [self addChild:picture1];

    position.x -= self.contentSize.width;
    move = [CCMoveTo actionWithDuration:PICTURE_SLIDE_DURATION position:position];
    [picture1 runAction:move];
  }
  return self;
}

@end
