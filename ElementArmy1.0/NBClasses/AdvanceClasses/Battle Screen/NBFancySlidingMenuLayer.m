//
//  NBFancySlidingMenuLayer.m
//  ElementArmy1.0
//
//  Created by Augustine on 4/1/13.
//
//

#import "NBFancySlidingMenuLayer.h"

#define NORMAL_TAG 1
#define SELECTED_TAG 2
#define DISABLED_TAG 3

#define HORIZONTAL_SPACING_BETWEEN_BUTTONS 10
#define VERTICAL_SPACING_BETWEEN_BUTTONS 10

#define BUTTON_SLIDING_DURATION 0.25

@interface NBFancySlidingMenuLayer()

@property (nonatomic) BOOL onLeftSide;

@property (nonatomic, strong) CCSprite *groupClassButtonNormalSprite;
@property (nonatomic, strong) CCSprite *groupClassButtonSelectedSprite;
@property (nonatomic, strong) CCSprite *groupClassButtonDisabledSprite;

@property (nonatomic, strong) CCSprite *classSkillAButtonNormalSprite;
@property (nonatomic, strong) CCSprite *classSkillAButtonSelectedSprite;
@property (nonatomic, strong) CCSprite *classSkillAButtonDisabledSprite;

@property (nonatomic, strong) CCSprite *classSkillBButtonNormalSprite;
@property (nonatomic, strong) CCSprite *classSkillBButtonSelectedSprite;
@property (nonatomic, strong) CCSprite *classSkillBButtonDisabledSprite;

@property (nonatomic, strong) CCSprite *classSkillCButtonNormalSprite;
@property (nonatomic, strong) CCSprite *classSkillCButtonSelectedSprite;
@property (nonatomic, strong) CCSprite *classSkillCButtonDisabledSprite;

@end

@implementation NBFancySlidingMenuLayer

- (void)onEnter {
  [super onEnter];
}

- (id)init {
  self = [super init];
  if (self) {
    self.onLeftSide = YES;

    self.backgroundSprite = [CCSprite spriteWithSpriteFrameName:@"lifebar.png"];
    self.backgroundSprite.opacity = 0;
    self.backgroundSprite.scaleY = 2;
    self.backgroundSprite.position = CGPointMake(self.backgroundSprite.contentSize.width/2, 60);
    [self addChild:self.backgroundSprite];

    self.groupClassButtonNormalSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    CGPoint position = CGPointMake(20, 20);
    self.groupClassButtonNormalSprite.position = position;
    self.groupClassButtonNormalSprite.tag = NORMAL_TAG;

    self.groupClassButtonSelectedSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_selected.png"];
    self.groupClassButtonSelectedSprite.position = position;
    self.groupClassButtonSelectedSprite.visible = NO;
    
    self.groupClassButtonDisabledSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    self.groupClassButtonDisabledSprite.position = position;
    self.groupClassButtonDisabledSprite.visible = NO;
    [self addChild:self.groupClassButtonDisabledSprite];
    
    self.classSkillAButtonNormalSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    self.classSkillAButtonNormalSprite.position = position;
    self.groupClassButtonNormalSprite.tag = NORMAL_TAG;
    [self addChild:self.classSkillAButtonNormalSprite];

    self.classSkillAButtonSelectedSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_selected.png"];
    self.classSkillAButtonSelectedSprite.position = position;
    self.classSkillAButtonSelectedSprite.tag = NORMAL_TAG;
    self.classSkillAButtonSelectedSprite.visible = NO;
    [self addChild:self.classSkillAButtonSelectedSprite];

    self.classSkillAButtonDisabledSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    self.classSkillAButtonDisabledSprite.position = position;
    self.classSkillAButtonDisabledSprite.tag = NORMAL_TAG;
    self.classSkillAButtonDisabledSprite.visible = NO;
    [self addChild:self.classSkillAButtonDisabledSprite];

    self.classSkillBButtonNormalSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    self.classSkillBButtonNormalSprite.position = position;
    self.groupClassButtonNormalSprite.tag = NORMAL_TAG;
    [self addChild:self.classSkillBButtonNormalSprite];

    self.classSkillBButtonSelectedSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_selected.png"];
    self.classSkillBButtonSelectedSprite.position = position;
    self.classSkillBButtonSelectedSprite.tag = NORMAL_TAG;
    self.classSkillBButtonSelectedSprite.visible = NO;
    [self addChild:self.classSkillBButtonSelectedSprite];

    self.classSkillBButtonDisabledSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    self.classSkillBButtonDisabledSprite.position = position;
    self.classSkillBButtonDisabledSprite.tag = NORMAL_TAG;
    self.classSkillBButtonDisabledSprite.visible = NO;
    [self addChild:self.classSkillBButtonDisabledSprite];

    self.classSkillCButtonNormalSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    self.classSkillCButtonNormalSprite.position = position;
    self.groupClassButtonNormalSprite.tag = NORMAL_TAG;
    [self addChild:self.classSkillCButtonNormalSprite];

    self.classSkillCButtonSelectedSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_selected.png"];
    self.classSkillCButtonSelectedSprite.position = position;
    self.classSkillCButtonSelectedSprite.tag = NORMAL_TAG;
    self.classSkillCButtonSelectedSprite.visible = NO;
    [self addChild:self.classSkillCButtonSelectedSprite];

    self.classSkillCButtonDisabledSprite = [CCSprite spriteWithSpriteFrameName:@"groupskillbutton_normal.png"];
    self.classSkillCButtonDisabledSprite.position = position;
    self.classSkillCButtonDisabledSprite.tag = NORMAL_TAG;
    self.classSkillCButtonDisabledSprite.visible = NO;
    [self addChild:self.classSkillCButtonDisabledSprite];

    [self addChild:self.groupClassButtonNormalSprite];
    [self addChild:self.groupClassButtonSelectedSprite];
  }
  return self;
}

- (id)initOnLeftSide:(BOOL)onLeftSide {
  self = [self init];
  if (self) {
    self.onLeftSide = onLeftSide;
    if (onLeftSide == NO) {
      self.backgroundSprite.position = CGPointMake(self.contentSize.width - self.backgroundSprite.contentSize.width/2, 60);

      CGPoint position = CGPointMake(self.contentSize.width - 20, 20);
      self.groupClassButtonNormalSprite.position = position;
      self.groupClassButtonSelectedSprite.position = position;
      self.groupClassButtonDisabledSprite.position = position;
      self.classSkillAButtonNormalSprite.position = position;
      self.classSkillAButtonSelectedSprite.position = position;
      self.classSkillAButtonDisabledSprite.position = position;
      self.classSkillBButtonNormalSprite.position = position;
      self.classSkillBButtonSelectedSprite.position = position;
      self.classSkillBButtonDisabledSprite.position = position;
      self.classSkillCButtonNormalSprite.position = position;
      self.classSkillCButtonSelectedSprite.position = position;
      self.classSkillCButtonDisabledSprite.position = position;
    }
  }
  return self;
}

-(void) registerWithTouchDispatcher
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority swallowsTouches:YES];
}

-(BOOL)isTouchingMe:(CGPoint)touchLocation
{
  CGRect rectToTest;
  
  if (self.groupClassButtonNormalSprite.tag == NORMAL_TAG) {
    rectToTest = CGRectMake(self.groupClassButtonNormalSprite.position.x - self.groupClassButtonNormalSprite.contentSize.width/2,
                            self.groupClassButtonNormalSprite.position.y - self.groupClassButtonNormalSprite.contentSize.height/2,
                            self.groupClassButtonNormalSprite.contentSize.width,
                            self.groupClassButtonNormalSprite.contentSize.height);
  }
  else {
    rectToTest = CGRectMake(self.groupClassButtonNormalSprite.position.x - self.groupClassButtonNormalSprite.contentSize.width/2,
                            self.groupClassButtonNormalSprite.position.y - self.groupClassButtonNormalSprite.contentSize.height/2,
                            self.classSkillAButtonNormalSprite.contentSize.width + HORIZONTAL_SPACING_BETWEEN_BUTTONS + self.classSkillBButtonNormalSprite.contentSize.width + HORIZONTAL_SPACING_BETWEEN_BUTTONS + self.classSkillCButtonNormalSprite.contentSize.width,
                            self.groupClassButtonNormalSprite.contentSize.height + VERTICAL_SPACING_BETWEEN_BUTTONS + self.classSkillAButtonNormalSprite.contentSize.height);
  }

  return CGRectContainsPoint(rectToTest, touchLocation);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if (self.groupClassButtonNormalSprite.tag == DISABLED_TAG)
    return NO;
  CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

  BOOL isTouchingMe = [self isTouchingMe:touchLocation];
  if (isTouchingMe) {
    [self.backgroundSprite runAction:[CCFadeIn actionWithDuration:BUTTON_SLIDING_DURATION]];

    self.groupClassButtonNormalSprite.tag = SELECTED_TAG;
    self.groupClassButtonNormalSprite.visible = NO;
    self.groupClassButtonSelectedSprite.visible = YES;

    CGPoint position = self.groupClassButtonNormalSprite.position;
    position.y += self.groupClassButtonNormalSprite.contentSize.height + VERTICAL_SPACING_BETWEEN_BUTTONS;
    id move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillAButtonNormalSprite runAction:move];
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillAButtonSelectedSprite runAction:move];
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillAButtonDisabledSprite runAction:move];
    
    if (self.onLeftSide)
      position.x += self.classSkillAButtonNormalSprite.contentSize.width + HORIZONTAL_SPACING_BETWEEN_BUTTONS;
    else
      position.x -= self.classSkillAButtonNormalSprite.contentSize.width + HORIZONTAL_SPACING_BETWEEN_BUTTONS;
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillBButtonNormalSprite runAction:move];
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillBButtonSelectedSprite runAction:move];
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillBButtonDisabledSprite runAction:move];

    if (self.onLeftSide)
      position.x += self.classSkillBButtonNormalSprite.contentSize.width + HORIZONTAL_SPACING_BETWEEN_BUTTONS;
    else
      position.x -= self.classSkillBButtonNormalSprite.contentSize.width + HORIZONTAL_SPACING_BETWEEN_BUTTONS;
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillCButtonNormalSprite runAction:move];
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillCButtonSelectedSprite runAction:move];
    move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:position];
    [self.classSkillCButtonDisabledSprite runAction:move];
  }
  
  return isTouchingMe;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  [self.backgroundSprite runAction:[CCFadeOut actionWithDuration:BUTTON_SLIDING_DURATION]];

  self.groupClassButtonNormalSprite.tag = NORMAL_TAG;
  self.groupClassButtonNormalSprite.visible = YES;
  self.groupClassButtonSelectedSprite.visible = NO;

  BOOL skillWasUsed = NO;

  if (self.classSkillAButtonSelectedSprite.visible) {
    skillWasUsed = YES;
    DLog(@"Skill A used");
  }
  if (self.classSkillBButtonSelectedSprite.visible) {
    skillWasUsed = YES;
    DLog(@"Skill B used");
  }
  if (self.classSkillCButtonSelectedSprite.visible) {
    skillWasUsed = YES;
    DLog(@"Skill C used");
  }
  if (skillWasUsed == NO)
    DLog(@"No skill used");

  self.classSkillAButtonNormalSprite.visible = YES;
  self.classSkillAButtonSelectedSprite.visible = NO;
  self.classSkillBButtonNormalSprite.visible = YES;
  self.classSkillBButtonSelectedSprite.visible = NO;
  self.classSkillCButtonNormalSprite.visible = YES;
  self.classSkillCButtonSelectedSprite.visible = NO;

  id move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillAButtonNormalSprite runAction:move];
  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillAButtonSelectedSprite runAction:move];
  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillAButtonDisabledSprite runAction:move];

  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillBButtonNormalSprite runAction:move];
  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillBButtonSelectedSprite runAction:move];
  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillBButtonDisabledSprite runAction:move];

  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillCButtonNormalSprite runAction:move];
  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillBButtonSelectedSprite runAction:move];
  move = [CCMoveTo actionWithDuration:BUTTON_SLIDING_DURATION position:self.groupClassButtonNormalSprite.position];
  [self.classSkillCButtonDisabledSprite runAction:move];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
  CGRect rectToTest;
  rectToTest = CGRectMake(self.classSkillAButtonNormalSprite.position.x - self.classSkillAButtonNormalSprite.contentSize.width/2,
                          self.classSkillAButtonNormalSprite.position.y - self.classSkillAButtonNormalSprite.contentSize.height/2,
                          self.classSkillAButtonNormalSprite.contentSize.width,
                          self.classSkillAButtonNormalSprite.contentSize.height);  

  //select Skill A
  if (CGRectContainsPoint(rectToTest, touchLocation)) {
    self.classSkillAButtonNormalSprite.visible = NO;
    self.classSkillAButtonSelectedSprite.visible = YES;
    self.classSkillBButtonNormalSprite.visible = YES;
    self.classSkillBButtonSelectedSprite.visible = NO;
    self.classSkillCButtonNormalSprite.visible = YES;
    self.classSkillCButtonSelectedSprite.visible = NO;
    return;
  }

  rectToTest = CGRectMake(self.classSkillBButtonNormalSprite.position.x - self.classSkillBButtonNormalSprite.contentSize.width/2,
                          self.classSkillBButtonNormalSprite.position.y - self.classSkillBButtonNormalSprite.contentSize.height/2,
                          self.classSkillBButtonNormalSprite.contentSize.width,
                          self.classSkillBButtonNormalSprite.contentSize.height);

  //select Skill B
  if (CGRectContainsPoint(rectToTest, touchLocation)) {
    self.classSkillAButtonNormalSprite.visible = YES;
    self.classSkillAButtonSelectedSprite.visible = NO;
    self.classSkillBButtonNormalSprite.visible = NO;
    self.classSkillBButtonSelectedSprite.visible = YES;
    self.classSkillCButtonNormalSprite.visible = YES;
    self.classSkillCButtonSelectedSprite.visible = NO;
    return;
  }

  //select Skill C
  rectToTest = CGRectMake(self.classSkillCButtonNormalSprite.position.x - self.classSkillCButtonNormalSprite.contentSize.width/2,
                          self.classSkillCButtonNormalSprite.position.y - self.classSkillCButtonNormalSprite.contentSize.height/2,
                          self.classSkillCButtonNormalSprite.contentSize.width,
                          self.classSkillCButtonNormalSprite.contentSize.height);
  if (CGRectContainsPoint(rectToTest, touchLocation)) {
    self.classSkillAButtonNormalSprite.visible = YES;
    self.classSkillAButtonSelectedSprite.visible = NO;
    self.classSkillBButtonNormalSprite.visible = YES;
    self.classSkillBButtonSelectedSprite.visible = NO;
    self.classSkillCButtonNormalSprite.visible = NO;
    self.classSkillCButtonSelectedSprite.visible = YES;
    return;
  }

  //select nothing
  self.classSkillAButtonNormalSprite.visible = YES;
  self.classSkillAButtonSelectedSprite.visible = NO;
  self.classSkillBButtonNormalSprite.visible = YES;
  self.classSkillBButtonSelectedSprite.visible = NO;
  self.classSkillCButtonNormalSprite.visible = YES;
  self.classSkillCButtonSelectedSprite.visible = NO;
}

@end
