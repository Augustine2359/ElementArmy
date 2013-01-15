//
//  NBBattleSetupUnitSelectorsContainerLayer.m
//  ElementArmy1.0
//
//  Created by Augustine on 11/1/13.
//
//

#import "NBBattleSetupUnitSelectorsContainerLayer.h"
#import "NBBattleSetupUnitSelectorLayer.h"

@interface NBBattleSetupUnitSelectorsContainerLayer()

@property (nonatomic, strong) NBBattleSetupUnitSelectorLayer *unitSelectorA;
@property (nonatomic, strong) NBBattleSetupUnitSelectorLayer *unitSelectorB;
@property (nonatomic, strong) NBBattleSetupUnitSelectorLayer *unitSelectorC;

@end

@implementation NBBattleSetupUnitSelectorsContainerLayer

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h {
  self = [super initWithColor:color width:w height:h];
  if (self) {
    [self addUnitSelectors];
    [self addSwipeGestureRecognizers];
  }
  return self;
}

- (void)addUnitSelectors {
  ccColor4B startColor;
  startColor.r = 0;
  startColor.g = 0;
  startColor.b = 0;
  startColor.a = 255;
  
  self.unitSelectorA = [[NBBattleSetupUnitSelectorLayer alloc] initWithColor:startColor width:100 height:200];
  self.unitSelectorA.position = CGPointMake(5, 5);
  [self addChild:self.unitSelectorA];
  
  self.unitSelectorB = [[NBBattleSetupUnitSelectorLayer alloc] initWithColor:startColor width:100 height:200];
  self.unitSelectorB.position = CGPointMake(115, 5);
  [self addChild:self.unitSelectorB];
  
  self.unitSelectorC = [[NBBattleSetupUnitSelectorLayer alloc] initWithColor:startColor width:100 height:200];
  self.unitSelectorC.position = CGPointMake(225, 5);
  [self addChild:self.unitSelectorC];
}

- (void)addSwipeGestureRecognizers {
  UISwipeGestureRecognizer *downSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
  downSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
  [[[CCDirector sharedDirector] view] addGestureRecognizer:downSwipeGestureRecognizer];

  UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
  leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [[[CCDirector sharedDirector] view] addGestureRecognizer:leftSwipeGestureRecognizer];
  
  UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
  rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [[[CCDirector sharedDirector] view] addGestureRecognizer:rightSwipeGestureRecognizer];
  
  UISwipeGestureRecognizer *upSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
  upSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
  [[[CCDirector sharedDirector] view] addGestureRecognizer:upSwipeGestureRecognizer];
}

-(BOOL)isTouchingMe:(CGPoint)touchLocation
{
  CGRect rectToTest = CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
  return CGRectContainsPoint(rectToTest, touchLocation);
}

- (void)onSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
  CGPoint touchLocation = [swipeGestureRecognizer locationInView:[CCDirector sharedDirector].view];
  //need to flip because the coordinate systems are flipped
  touchLocation.y = [[CCDirector sharedDirector] winSize].height - touchLocation.y;
  
  BOOL isTouchingMe = [self isTouchingMe:touchLocation];
  if (isTouchingMe == NO)
    return;

  touchLocation.x -= self.position.x;
  touchLocation.y -= self.position.y;

  for (NBBattleSetupUnitSelectorLayer *unitSelector in self.children) {
    if ([unitSelector isTouchingMe:touchLocation]) {
      if ([unitSelector isLocked] == NO)
        [self sendSwipe:swipeGestureRecognizer toUnitSelector:unitSelector];
      break;
    }
  }
}

- (void)sendSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer toUnitSelector:(NBBattleSetupUnitSelectorLayer *)unitSelector {
  switch (swipeGestureRecognizer.direction) {
      case UISwipeGestureRecognizerDirectionDown:
      [unitSelector decreaseTier];
      break;
    case UISwipeGestureRecognizerDirectionLeft:
      [unitSelector decreaseElement];
      break;
    case UISwipeGestureRecognizerDirectionRight:
      [unitSelector increaseElement];
      break;
    case UISwipeGestureRecognizerDirectionUp:
      [unitSelector increaseTier];
      break;
    default:
      break;
  }

  DLog(@"selector %d tier %d element %d", [self.children indexOfObject:unitSelector], unitSelector.tier, unitSelector.element);
}

@end
