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
    killUnitButton.position = CGPointMake(150, h*0.25);
    [killUnitButton show];

    NBButton *respawnUnitsButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(respawnUnits) withSize:CGSizeZero];
    [respawnUnitsButton setIntStorage:0];
    respawnUnitsButton.position = CGPointMake(w/2 + 50, h*0.75);
    [respawnUnitsButton show];

    NSNumber *numberOfLiveUnits = [[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfLiveUnits"];
    if (numberOfLiveUnits == nil)
      self.unitCounter = 10;
      
      
      CCLabelTTF* labelHP = [CCLabelTTF labelWithString:@"HP: " fontName:@"Marker Felt" fontSize:15];
      labelHP.position = ccp(w*0.2, h*0.8);
      labelHP.color = ccc3(100, 100, 100);
      [self addChild:labelHP];
      self.labelHPStat = [CCLabelTTF labelWithString:@"9" fontName:@"Marker Felt" fontSize:15];
      self.labelHPStat.position = ccp(w*0.4, h*0.8);
      self.labelHPStat.color = ccc3(100, 100, 100);
      [self addChild:self.labelHPStat];
      
      CCLabelTTF* labelSP = [CCLabelTTF labelWithString:@"SP: " fontName:@"Marker Felt" fontSize:15];
      labelSP.position = ccp(w*0.2, h*0.7);
      labelSP.color = ccc3(100, 100, 100);
      [self addChild:labelSP];
      self.labelSPStat = [CCLabelTTF labelWithString:@"99" fontName:@"Marker Felt" fontSize:15];
      self.labelSPStat.position = ccp(w*0.4, h*0.7);
      self.labelSPStat.color = ccc3(100, 100, 100);
      [self addChild:self.labelSPStat];
      
      CCLabelTTF* labelSTR = [CCLabelTTF labelWithString:@"STR: " fontName:@"Marker Felt" fontSize:15];
      labelSTR.position = ccp(w*0.2, h*0.6);
      labelSTR.color = ccc3(100, 100, 100);
      [self addChild:labelSTR];
      self.labelSPStat = [CCLabelTTF labelWithString:@"888" fontName:@"Marker Felt" fontSize:15];
      self.labelSPStat.position = ccp(w*0.4, h*0.6);
      self.labelSPStat.color = ccc3(100, 100, 100);
      [self addChild:self.labelSPStat];
      
      CCLabelTTF* labelDEF = [CCLabelTTF labelWithString:@"DEF: " fontName:@"Marker Felt" fontSize:15];
      labelDEF.position = ccp(w*0.2, h*0.5);
      labelDEF.color = ccc3(100, 100, 100);
      [self addChild:labelDEF];
      self.labelDEFStat = [CCLabelTTF labelWithString:@"9999" fontName:@"Marker Felt" fontSize:15];
      self.labelDEFStat.position = ccp(w*0.4, h*0.5);
      self.labelDEFStat.color = ccc3(100, 100, 100);
      [self addChild:self.labelDEFStat];
      
      CCLabelTTF* labelINT = [CCLabelTTF labelWithString:@"INT: " fontName:@"Marker Felt" fontSize:15];
      labelINT.position = ccp(w*0.2, h*0.4);
      labelINT.color = ccc3(100, 100, 100);
      [self addChild:labelINT];
      self.labelINTStat = [CCLabelTTF labelWithString:@"99999" fontName:@"Marker Felt" fontSize:15];
      self.labelINTStat.position = ccp(w*0.4, h*0.4);
      self.labelINTStat.color = ccc3(100, 100, 100);
      [self addChild:self.labelINTStat];
      
      CCLabelTTF* labelDEX = [CCLabelTTF labelWithString:@"DEX: " fontName:@"Marker Felt" fontSize:15];
      labelDEX.position = ccp(w*0.2, h*0.3);
      labelDEX.color = ccc3(100, 100, 100);
      [self addChild:labelDEX];
      self.labelDEXStat = [CCLabelTTF labelWithString:@"999999" fontName:@"Marker Felt" fontSize:15];
      self.labelDEXStat.position = ccp(w*0.4, h*0.3);
      self.labelDEXStat.color = ccc3(100, 100, 100);
      [self addChild:self.labelDEXStat];
      
      CCLabelTTF* labelEVA = [CCLabelTTF labelWithString:@"EVA: " fontName:@"Marker Felt" fontSize:15];
      labelEVA.position = ccp(w*0.2, h*0.2);
      labelEVA.color = ccc3(100, 100, 100);
      [self addChild:labelEVA];
      self.labelEVAStat = [CCLabelTTF labelWithString:@"9999999" fontName:@"Marker Felt" fontSize:15];
      self.labelEVAStat.position = ccp(w*0.4, h*0.2);
      self.labelEVAStat.color = ccc3(100, 100, 100);
      [self addChild:self.labelEVAStat];

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
