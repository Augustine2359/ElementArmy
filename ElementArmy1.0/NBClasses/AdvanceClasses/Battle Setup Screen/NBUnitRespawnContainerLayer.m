//
//  NBUnitRespawnContainerLayer.m
//  ElementArmy1.0
//
//  Created by Augustine on 27/2/13.
//
//

#import "NBUnitRespawnContainerLayer.h"
#import "NBButton.h"

@interface NBUnitRespawnContainerLayer()

@property (nonatomic) NSInteger unitCounter;
@property (nonatomic) NSInteger maxUnits;
@property (nonatomic) CGFloat respawnTimePerUnit;
@property (nonatomic, strong) NSDate *firstUnitDeathTime;

@end

@implementation NBUnitRespawnContainerLayer

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h {
  self = [super initWithColor:color width:w height:h];
  if (self) {
    self.maxUnits = 10;
    self.unitCounter = 10;
    self.respawnTimePerUnit = 10;

    NBButton *killUnitButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(killUnit) withSize:CGSizeZero];
    [killUnitButton setIntStorage:0];
    killUnitButton.position = CGPointMake(50, h/2);
    [killUnitButton show];

    NBButton *respawnUnitsButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(respawnUnits) withSize:CGSizeZero];
    [respawnUnitsButton setIntStorage:0];
    respawnUnitsButton.position = CGPointMake(w/2 + 50, h/2);
    [respawnUnitsButton show];

    NSNumber *numberOfLiveUnits = [[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfLiveUnits"];
    if (numberOfLiveUnits == nil)
      self.unitCounter = 10;

    [self schedule:@selector(respawnUnits) interval:1 repeat:INFINITY delay:0];
  }
  return self;
}

- (void)respawnUnits {
  NSDate *firstUnitDeathTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstUnitDeathTime"];
  if (firstUnitDeathTime == nil) {
    DLog(@"no dead units");
    return;
  }
  NSDate *currentDate = [NSDate date];
  CGFloat timeSinceFirstUnitDeath = [currentDate timeIntervalSinceDate:firstUnitDeathTime];
  CGFloat numberOfRespawnedUnits = timeSinceFirstUnitDeath/self.respawnTimePerUnit;
  numberOfRespawnedUnits = floorf(numberOfRespawnedUnits);
  firstUnitDeathTime = [NSDate dateWithTimeInterval:numberOfRespawnedUnits * self.respawnTimePerUnit sinceDate:firstUnitDeathTime];
  [[NSUserDefaults standardUserDefaults] setObject:firstUnitDeathTime forKey:@"firstUnitDeathTime"];
  self.unitCounter += numberOfRespawnedUnits;
  if (self.unitCounter >= self.maxUnits) {
    self.unitCounter = self.maxUnits;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstUnitDeathTime"];
    DLog(@"no dead units");
    return;
  }
  CGFloat currentNumberOfUnits = self.unitCounter + numberOfRespawnedUnits;
  currentNumberOfUnits = floorf(currentNumberOfUnits);
  if (currentNumberOfUnits > self.maxUnits)
    currentNumberOfUnits = self.maxUnits;

  DLog(@"firstUnitDeathTime is %@", firstUnitDeathTime);
  DLog(@"%f respawned", numberOfRespawnedUnits);
  DLog(@"%d remaining", self.unitCounter);
  DLog(@"");
}

- (void)killUnit {
  self.unitCounter--;
  NSDate *firstUnitDeathTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstUnitDeathTime"];
  if (firstUnitDeathTime == nil)
    firstUnitDeathTime = [NSDate date];
  [[NSUserDefaults standardUserDefaults] setObject:firstUnitDeathTime forKey:@"firstUnitDeathTime"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
