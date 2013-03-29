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

@property (nonatomic, strong) NSArray *gestureRecognizers;

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
  
    CCArray* selectorArray = [CCArray new];
    [selectorArray addObject:self.unitSelectorA];
    [selectorArray addObject:self.unitSelectorB];
    [selectorArray addObject:self.unitSelectorC];

    for (int x = 0; x < [selectorArray count]; x++) {
        NBBattleSetupUnitSelectorLayer* newSelector = (NBBattleSetupUnitSelectorLayer*)[selectorArray objectAtIndex:x];
        newSelector = [[NBBattleSetupUnitSelectorLayer alloc] initWithColor:startColor width:80 height:130];
        newSelector.position = ccp(x*90 + 5, 5);
//        CGPoint backgroundPosition = ccp(newSelector.position.x + 15, 160);
//        NBStaticObject* background = [NBStaticObject createStaticObject:@"troopSelectionScreen_box_large.png" atPosition:backgroundPosition];
//        [background setZOrder:1];
        [self addChild:newSelector];
    }
    
//  self.unitSelectorA = [[NBBattleSetupUnitSelectorLayer alloc] initWithColor:startColor width:80 height:130];
//  self.unitSelectorA.position = CGPointMake(5, 5);
//  self.columnBackground = [NBStaticObject createStaticObject:@"troopSelectionScreen_box_large.png" atPosition:CGPointMake(5, 5)];
//  [self addChild:self.unitSelectorA];
//  
//  self.unitSelectorB = [[NBBattleSetupUnitSelectorLayer alloc] initWithColor:startColor width:80 height:130];
//  self.unitSelectorB.position = CGPointMake(95, 5);
//  [self addChild:self.unitSelectorB];
//  
//  self.unitSelectorC = [[NBBattleSetupUnitSelectorLayer alloc] initWithColor:startColor width:80 height:130];
//  self.unitSelectorC.position = CGPointMake(185, 5);
//  [self addChild:self.unitSelectorC];
}

- (NBBasicClassData *)basicClassDataInUnitSelector:(NSInteger)selector {
  switch (selector) {
    case 0:
      return [self.unitSelectorA basicClassData];
    case 1:
      return [self.unitSelectorB basicClassData];
    case 2:
      return [self.unitSelectorC basicClassData];
    default:
      return [self.unitSelectorA basicClassData];
  }
  return [self.unitSelectorA basicClassData];
}

- (void)addSwipeGestureRecognizers {
  if ((self.gestureRecognizers != nil) || ([self.gestureRecognizers count] > 0))
    return;

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

  self.gestureRecognizers = [NSArray arrayWithObjects:downSwipeGestureRecognizer, leftSwipeGestureRecognizer, rightSwipeGestureRecognizer, upSwipeGestureRecognizer, nil];
}

- (void)onEnter {
  [super onEnter];
  [self addSwipeGestureRecognizers];
}

- (void)onExitTransitionDidStart {
  [super onExitTransitionDidStart];
  [self removeSwipeGestureRecognizersFromDirector];
}

- (void)removeSwipeGestureRecognizersFromDirector {
  for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers)
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:gestureRecognizer];

  self.gestureRecognizers = [NSArray array];
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
