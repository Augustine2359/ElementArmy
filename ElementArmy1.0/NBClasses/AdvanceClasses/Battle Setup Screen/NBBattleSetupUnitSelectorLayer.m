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

enum UnitChangeType {
  UnitChangeDecreaseTier = 0,
  UnitChangeDecreaseElement,
  UnitChangeIncreaseTier,
  UnitChangeIncreaseElement
  };

@interface NBBattleSetupUnitSelectorLayer()

@property (nonatomic, strong) NBBasicClassData *previousBasicClassData;
@property (nonatomic, strong) NBBasicClassData *currentBasicClassData;
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

    self.currentBasicClassData = [[self.elementsArray objectAtIndex:self.element] objectAtIndex:self.tier];
    self.currentUnitSprite = [self generateSpriteFromBasicClassData:self.currentBasicClassData];
    [self addChild:self.currentUnitSprite];
  }
  return self;
}

- (void)visit {

  CGPoint origin = [self convertToWorldSpace:CGPointZero];

  //increase the dimensions for retina
  CGRect rectToClipTo = CGRectMake(origin.x, origin.y, self.contentSize.width, self.contentSize.height);
  if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
    rectToClipTo.origin.x *= 2;
    rectToClipTo.origin.y *= 2;
    rectToClipTo.size.width *= 2;
    rectToClipTo.size.height *= 2;
  }

  //clips the layer so that the sprites inside don't appear outside of the layer
	glEnable(GL_SCISSOR_TEST);
  glScissor(rectToClipTo.origin.x, rectToClipTo.origin.y, rectToClipTo.size.width, rectToClipTo.size.height);
	[super visit];
	glDisable(GL_SCISSOR_TEST);
}

- (void)prepareElementsArray {
  self.elementsArray = [CCArray array];
  CCArray *elementArray = [CCArray array];

  NBBasicClassData *metalSoldierClassData = [[NBDataManager dataManager] getBasicClassDataByClassName:@"metalsoldier"];

  [elementArray addObject:metalSoldierClassData];
  [elementArray addObject:metalSoldierClassData];
  [self.elementsArray addObject:elementArray];

  elementArray = [CCArray array];
  [elementArray addObject:metalSoldierClassData];
  [elementArray addObject:metalSoldierClassData];
  [self.elementsArray addObject:elementArray];
}

- (NBBasicClassData *)basicClassData {
  return self.currentBasicClassData;
}

- (CCSprite *)generateSpriteFromBasicClassData:(NBBasicClassData *)basicClassData {
  CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:basicClassData.idleFrame];
  sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  return sprite;
}

-(BOOL)isTouchingMe:(CGPoint)touchLocation
{
  CGRect rectToTest = CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
  return CGRectContainsPoint(rectToTest, touchLocation);
}

- (void)animateUnitChange:(enum UnitChangeType)unitChangeType {
  [self.previousUnitSprite removeFromParentAndCleanup:YES];
  self.previousUnitSprite = self.currentUnitSprite;
  self.previousBasicClassData = self.currentBasicClassData;
  self.currentBasicClassData = [[self.elementsArray objectAtIndex:self.element] objectAtIndex:self.tier];
  self.currentUnitSprite = [self generateSpriteFromBasicClassData:self.currentBasicClassData];
  if ([self.children containsObject:self.currentUnitSprite] == NO)
    [self addChild:self.currentUnitSprite];
  CGPoint position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  switch (unitChangeType) {
    case UnitChangeDecreaseTier:
      position.y += self.contentSize.height;
      break;
    case UnitChangeDecreaseElement:
      position.x += self.contentSize.width;
      break;
    case UnitChangeIncreaseElement:
      position.x -= self.contentSize.width;
      break;
    case UnitChangeIncreaseTier:
      position.y -= self.contentSize.height;
      break;
    default:
      break;
  }
  self.currentUnitSprite.position = position;

  position = self.previousUnitSprite.position;
  id move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
  [self.currentUnitSprite runAction:move];

  switch (unitChangeType) {
    case UnitChangeDecreaseTier:
      position.y -= self.contentSize.height;
      break;
    case UnitChangeDecreaseElement:
      position.x -= self.contentSize.width;
      break;
    case UnitChangeIncreaseElement:
      position.x += self.contentSize.width;
      break;
    case UnitChangeIncreaseTier:
      position.y += self.contentSize.height;
      break;
    default:
      break;
  }

  move = [CCMoveTo actionWithDuration:SPRITE_SLIDE_DURATON position:position];
  [self.previousUnitSprite runAction:move];
}

- (void)decreaseTier {
  NSInteger previousTier = self.tier;
  self.tier--;
  if (self.tier < MINIMUM_TIER)
    self.tier = MINIMUM_TIER;

  if (previousTier != self.tier)
    [self animateUnitChange:UnitChangeDecreaseTier];
}

- (void)decreaseElement {
  NSInteger previousElement = self.element;
  self.element--;
  if (self.element < MINIMUM_ELEMENT)
    self.element = MINIMUM_ELEMENT;

  if (previousElement != self.element)
    [self animateUnitChange:UnitChangeDecreaseElement];
}

- (void)increaseElement {
  NSInteger previousElement = self.element;
  self.element++;
  if (self.element > MAXIMUM_ELEMENT)
    self.element = MAXIMUM_ELEMENT;

  if (previousElement != self.element)
    [self animateUnitChange:UnitChangeIncreaseElement];
}

- (void)increaseTier {
  NSInteger previousTier = self.tier;
  self.tier++;
  if (self.tier > MAXIMUM_TIER)
    self.tier = MAXIMUM_TIER;

  if (previousTier != self.tier)
    [self animateUnitChange:UnitChangeIncreaseTier];
}

@end
