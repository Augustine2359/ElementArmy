//
//  NBBattleSetupUnitSelectorLayer.m
//  ElementArmy1.0
//
//  Created by Augustine on 10/1/13.
//
//

#import "NBBattleSetupUnitSelectorLayer.h"
#import "NBSoldier.h"
#import "NBFireMage.h"

#define MINIMUM_TIER 0
#define MINIMUM_ELEMENT 0
#define MAXIMUM_TIER 1
#define MAXIMUM_ELEMENT 1

#define SPRITE_SLIDE_DURATON 0.25

@interface NBBattleSetupUnitSelectorLayer()

@property (nonatomic, strong) CCSprite *previousUnitSprite;
@property (nonatomic, strong) CCSprite *currentUnitSprite;
@property (nonatomic, strong) CCArray *elementsArray;
//element array contains one array for every element
//each of those arrays contains multiple tiers
//for testing purposes, make a 2-by-2 array

@property (nonatomic, strong) CCSpriteBatchNode *characterSpritesBatchNode;

@end

@implementation NBBattleSetupUnitSelectorLayer

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h {
  self = [super initWithColor:color width:w height:h];
  if (self) {
    self.tier = 0;
    self.element = 0;
    self.isLocked = NO;

    [self prepareElementsArray];
    self.currentUnitSprite = [[self.elementsArray objectAtIndex:self.element] objectAtIndex:self.tier];
    [self addChild:self.currentUnitSprite];
  }
  return self;
}

- (void)prepareElementsArray {
  self.elementsArray = [CCArray array];
  CCArray *elementArray = [CCArray array];
  CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"skillAbutton_normal.png"];
  sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  [elementArray addObject:sprite];
  sprite = [CCSprite spriteWithSpriteFrameName:@"skillBbutton_normal.png"];
  sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  [elementArray addObject:sprite];

  [self.elementsArray addObject:elementArray];

  elementArray = [CCArray array];
  sprite = [CCSprite spriteWithSpriteFrameName:METAL_SOLDIER_FILE];
  sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  [elementArray addObject:sprite];
  sprite = [CCSprite spriteWithSpriteFrameName:FIRE_MAGE_FILE];
  sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  [elementArray addObject:sprite];

  [self.elementsArray addObject:elementArray];
}

-(BOOL)isTouchingMe:(CGPoint)touchLocation
{
  CGRect rectToTest = CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
  return CGRectContainsPoint(rectToTest, touchLocation);
}

- (void)decreaseTier {
  NSInteger previousTier = self.tier;
  self.tier--;
  if (self.tier < MINIMUM_TIER)
    self.tier = MINIMUM_TIER;

  if (previousTier != self.tier) {
    [self.previousUnitSprite removeFromParentAndCleanup:YES];
    self.previousUnitSprite = self.currentUnitSprite;

    self.currentUnitSprite = [[self.elementsArray objectAtIndex:self.element] objectAtIndex:self.tier];
    if ([self.children containsObject:self.currentUnitSprite] == NO)
    [self addChild:self.currentUnitSprite];
    CGPoint position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    position.y += self.contentSize.height/2;
    self.currentUnitSprite.position = position;

    position = self.previousUnitSprite.position;
    id move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.currentUnitSprite runAction:move];
    position.y -= self.contentSize.height/2;
    move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.previousUnitSprite runAction:move];
  }
}

- (void)decreaseElement {
  NSInteger previousElement = self.element;
  self.element--;
  if (self.element < MINIMUM_ELEMENT)
    self.element = MINIMUM_ELEMENT;

  if (previousElement != self.element) {
    [self.previousUnitSprite removeFromParentAndCleanup:YES];
    self.previousUnitSprite = self.currentUnitSprite;

    self.currentUnitSprite = [[self.elementsArray objectAtIndex:self.element] objectAtIndex:self.tier];
    if ([self.children containsObject:self.currentUnitSprite] == NO)
      [self addChild:self.currentUnitSprite];
    CGPoint position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    position.x += self.contentSize.width/2;
    self.currentUnitSprite.position = position;

    position = self.previousUnitSprite.position;
    id move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.currentUnitSprite runAction:move];
    position.x -= self.contentSize.width/2;
    move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.previousUnitSprite runAction:move];
  }
}

- (void)increaseElement {
  NSInteger previousElement = self.element;
  self.element++;
  if (self.element > MAXIMUM_ELEMENT)
    self.element = MAXIMUM_ELEMENT;

  if (previousElement != self.element) {
    [self.previousUnitSprite removeFromParentAndCleanup:YES];
    self.previousUnitSprite = self.currentUnitSprite;

    self.currentUnitSprite = [[self.elementsArray objectAtIndex:self.element] objectAtIndex:self.tier];
    if ([self.children containsObject:self.currentUnitSprite] == NO)
      [self addChild:self.currentUnitSprite];
    CGPoint position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    position.x -= self.contentSize.width/2;
    self.currentUnitSprite.position = position;

    position = self.previousUnitSprite.position;
    id move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.currentUnitSprite runAction:move];
    position.x += self.contentSize.width/2;
    move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.previousUnitSprite runAction:move];
  }
}

- (void)increaseTier {
  NSInteger previousTier = self.tier;
  self.tier++;
  if (self.tier > MAXIMUM_TIER)
    self.tier = MAXIMUM_TIER;

  if (previousTier != self.tier) {
    [self.previousUnitSprite removeFromParentAndCleanup:YES];
    self.previousUnitSprite = self.currentUnitSprite;

    self.currentUnitSprite = [[self.elementsArray objectAtIndex:self.element] objectAtIndex:self.tier];
    if ([self.children containsObject:self.currentUnitSprite] == NO)
    [self addChild:self.currentUnitSprite];
    CGPoint position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    position.y -= self.contentSize.height/2;
    self.currentUnitSprite.position = position;

    position = self.previousUnitSprite.position;
    id move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.currentUnitSprite runAction:move];
    position.y += self.contentSize.height/2;
    move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
    [self.previousUnitSprite runAction:move];
  }
}

@end
