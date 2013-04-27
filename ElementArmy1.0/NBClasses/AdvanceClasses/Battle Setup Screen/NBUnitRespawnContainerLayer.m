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

-(id)initWithRect:(CGRect)rect{
    self = [super init];
    
    if (self) {
        self.position = ccp(rect.origin.x, rect.origin.y);
        self.maxUnits = 10;
        self.unitCounter = 10;
        self.respawnTimePerUnit = 10;
        
        self.attributesBackground = [NBStaticObject createStaticObject:@"troopSelectionScreen_box_large.png" atPosition:CGPointMake(375, 175)];
        [self.attributesBackground setScale:1.25];
        
        self.portraitImage = [NBStaticObject createStaticObject:@"troopSelectionScreen_portrait.png" atPosition:CGPointMake(425, 175)];
        
//        NBButton *killUnitButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(killUnit) withSize:CGSizeZero];
//        killUnitButton.position = CGPointMake(150, rect.size.height*0.25);
//        [killUnitButton show];
//        
//        NBButton *respawnUnitsButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(respawnUnits) withSize:CGSizeZero];
//        respawnUnitsButton.position = CGPointMake(rect.size.width/2 + 50, rect.size.height*0.75);
//        [respawnUnitsButton show];
//        
//        NSNumber *numberOfLiveUnits = [[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfLiveUnits"];
//        if (numberOfLiveUnits == nil)
//            self.unitCounter = 10;
        
        
        NBBasicClassData* statsList = [[[NBDataManager dataManager] listOfCharacters] objectAtIndex:0];
        self.labelHPStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP: %i x ", statsList.currentHP] dimensions:CGSizeMake(rect.size.width*0.5, rect.size.height*0.15) hAlignment:kCCTextAlignmentRight fontName:@"Marker Felt" fontSize:15];
        self.labelHPStat.position = ccp(rect.size.width*0.15, rect.size.height*0.8);
        self.labelHPStat.color = ccc3(100, 100, 100);
        [self addChild:self.labelHPStat];
        
        self.labelSPStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"SP: %i x ", statsList.currentSP] dimensions:CGSizeMake(rect.size.width*0.5, rect.size.height*0.15) hAlignment:kCCTextAlignmentRight fontName:@"Marker Felt" fontSize:15];
        self.labelSPStat.position = ccp(rect.size.width*0.15, rect.size.height*0.7);
        self.labelSPStat.color = ccc3(100, 100, 100);
        [self addChild:self.labelSPStat];
        
        self.labelSPStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"STR: %i x ", statsList.currentSTR] dimensions:CGSizeMake(rect.size.width*0.5, rect.size.height*0.15) hAlignment:kCCTextAlignmentRight fontName:@"Marker Felt" fontSize:15];
        self.labelSPStat.position = ccp(rect.size.width*0.15, rect.size.height*0.6);
        self.labelSPStat.color = ccc3(100, 100, 100);
        [self addChild:self.labelSPStat];
        
        self.labelDEFStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"DEF: %i x ", statsList.currentDEF] dimensions:CGSizeMake(rect.size.width*0.5, rect.size.height*0.15) hAlignment:kCCTextAlignmentRight fontName:@"Marker Felt" fontSize:15];
        self.labelDEFStat.position = ccp(rect.size.width*0.15, rect.size.height*0.5);
        self.labelDEFStat.color = ccc3(100, 100, 100);
        [self addChild:self.labelDEFStat];
        
        self.labelINTStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"INT: %i x ", statsList.currentINT] dimensions:CGSizeMake(rect.size.width*0.5, rect.size.height*0.15) hAlignment:kCCTextAlignmentRight fontName:@"Marker Felt" fontSize:15];
        self.labelINTStat.position = ccp(rect.size.width*0.15, rect.size.height*0.4);
        self.labelINTStat.color = ccc3(100, 100, 100);
        [self addChild:self.labelINTStat];
        
        self.labelDEXStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"DEX: %i x ", statsList.currentDEX] dimensions:CGSizeMake(rect.size.width*0.5, rect.size.height*0.15) hAlignment:kCCTextAlignmentRight fontName:@"Marker Felt" fontSize:15];
        self.labelDEXStat.position = ccp(rect.size.width*0.15, rect.size.height*0.3);
        self.labelDEXStat.color = ccc3(100, 100, 100);
        [self addChild:self.labelDEXStat];
        
        self.labelEVAStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"EVA: %i x ", statsList.currentEVA] dimensions:CGSizeMake(rect.size.width*0.5, rect.size.height*0.15) hAlignment:kCCTextAlignmentRight fontName:@"Marker Felt" fontSize:15];
        self.labelEVAStat.position = ccp(rect.size.width*0.15, rect.size.height*0.2);
        self.labelEVAStat.color = ccc3(100, 100, 100);
        [self addChild:self.labelEVAStat];
        
//        [self schedule:@selector(respawnUnits) interval:1 repeat:INFINITY delay:0];
        
        self.bonusLabels = [[CCArray alloc] initWithCapacity:7];
        for (int x = 0; x < [self.bonusLabels capacity]; x++) {
            CCLabelTTF* thatLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1.0"] dimensions:CGSizeMake(rect.size.width*0.25, rect.size.height*0.15) hAlignment:kCCTextAlignmentLeft fontName:@"Marker Felt" fontSize:15];
            thatLabel.position = ccp(rect.size.width*0.55, rect.size.height*0.8 - x*rect.size.height*0.1);
            thatLabel.color = ccc3(0, 0, 255);
            [self.bonusLabels addObject:thatLabel];
            [self addChild:thatLabel];
        }
    }
    return self;
}

//- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h {
//  self = [super initWithColor:color width:w height:h];
//  if (self) {
//    self.maxUnits = 10;
//    self.unitCounter = 10;
//    self.respawnTimePerUnit = 10;
//      
//    self.attributesBackground = [NBStaticObject createStaticObject:@"troopSelectionScreen_portrait.png" atPosition:CGPointMake(500, 100)];
//
//    NBButton *killUnitButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(killUnit) withSize:CGSizeZero];
//    killUnitButton.position = CGPointMake(150, h*0.25);
//    [killUnitButton show];
//
//    NBButton *respawnUnitsButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(respawnUnits) withSize:CGSizeZero];
//    respawnUnitsButton.position = CGPointMake(w/2 + 50, h*0.75);
//    [respawnUnitsButton show];
//
//    NSNumber *numberOfLiveUnits = [[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfLiveUnits"];
//    if (numberOfLiveUnits == nil)
//      self.unitCounter = 10;
//
//      NBBasicClassData* statsList = [[[NBDataManager dataManager] listOfCharacters] objectAtIndex:0];
//      CCLabelTTF* labelHP = [CCLabelTTF labelWithString:@"HP: " fontName:@"Marker Felt" fontSize:15];
//      labelHP.position = ccp(w*0.2, h*0.8);
//      labelHP.color = ccc3(100, 100, 100);
//      [self addChild:labelHP];
//      self.labelHPStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", statsList.currentHP] fontName:@"Marker Felt" fontSize:15];
//      self.labelHPStat.position = ccp(w*0.4, h*0.8);
//      self.labelHPStat.color = ccc3(100, 100, 100);
//      [self addChild:self.labelHPStat];
//      
//      CCLabelTTF* labelSP = [CCLabelTTF labelWithString:@"SP: " fontName:@"Marker Felt" fontSize:15];
//      labelSP.position = ccp(w*0.2, h*0.7);
//      labelSP.color = ccc3(100, 100, 100);
//      [self addChild:labelSP];
//      self.labelSPStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", statsList.currentSP] fontName:@"Marker Felt" fontSize:15];
//      self.labelSPStat.position = ccp(w*0.4, h*0.7);
//      self.labelSPStat.color = ccc3(100, 100, 100);
//      [self addChild:self.labelSPStat];
//      
//      CCLabelTTF* labelSTR = [CCLabelTTF labelWithString:@"STR: " fontName:@"Marker Felt" fontSize:15];
//      labelSTR.position = ccp(w*0.2, h*0.6);
//      labelSTR.color = ccc3(100, 100, 100);
//      [self addChild:labelSTR];
//      self.labelSPStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", statsList.currentSTR] fontName:@"Marker Felt" fontSize:15];
//      self.labelSPStat.position = ccp(w*0.4, h*0.6);
//      self.labelSPStat.color = ccc3(100, 100, 100);
//      [self addChild:self.labelSPStat];
//      
//      CCLabelTTF* labelDEF = [CCLabelTTF labelWithString:@"DEF: " fontName:@"Marker Felt" fontSize:15];
//      labelDEF.position = ccp(w*0.2, h*0.5);
//      labelDEF.color = ccc3(100, 100, 100);
//      [self addChild:labelDEF];
//      self.labelDEFStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", statsList.currentDEF] fontName:@"Marker Felt" fontSize:15];
//      self.labelDEFStat.position = ccp(w*0.4, h*0.5);
//      self.labelDEFStat.color = ccc3(100, 100, 100);
//      [self addChild:self.labelDEFStat];
//      
//      CCLabelTTF* labelINT = [CCLabelTTF labelWithString:@"INT: " fontName:@"Marker Felt" fontSize:15];
//      labelINT.position = ccp(w*0.2, h*0.4);
//      labelINT.color = ccc3(100, 100, 100);
//      [self addChild:labelINT];
//      self.labelINTStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", statsList.currentINT] fontName:@"Marker Felt" fontSize:15];
//      self.labelINTStat.position = ccp(w*0.4, h*0.4);
//      self.labelINTStat.color = ccc3(100, 100, 100);
//      [self addChild:self.labelINTStat];
//      
//      CCLabelTTF* labelDEX = [CCLabelTTF labelWithString:@"DEX: " fontName:@"Marker Felt" fontSize:15];
//      labelDEX.position = ccp(w*0.2, h*0.3);
//      labelDEX.color = ccc3(100, 100, 100);
//      [self addChild:labelDEX];
//      self.labelDEXStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", statsList.currentDEX] fontName:@"Marker Felt" fontSize:15];
//      self.labelDEXStat.position = ccp(w*0.4, h*0.3);
//      self.labelDEXStat.color = ccc3(100, 100, 100);
//      [self addChild:self.labelDEXStat];
//      
//      CCLabelTTF* labelEVA = [CCLabelTTF labelWithString:@"EVA: " fontName:@"Marker Felt" fontSize:15];
//      labelEVA.position = ccp(w*0.2, h*0.2);
//      labelEVA.color = ccc3(100, 100, 100);
//      [self addChild:labelEVA];
//      self.labelEVAStat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", statsList.currentEVA] fontName:@"Marker Felt" fontSize:15];
//      self.labelEVAStat.position = ccp(w*0.4, h*0.2);
//      self.labelEVAStat.color = ccc3(100, 100, 100);
//      [self addChild:self.labelEVAStat];
//
//    [self schedule:@selector(respawnUnits) interval:1 repeat:INFINITY delay:0];
//  }
//  return self;
//}

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

-(void)updateBonusStats:(NBEquipment *)equipment1 equipment2:(NBEquipment *)equipment2 equipment3:(NBEquipment *)equipment3{
    CCArray* equipmentsStatsArray = [[CCArray alloc] initWithCapacity:3];
    CCArray* equip1Stats = [equipment1 statsEffectOfEquipment];
    CCArray* equip2Stats = [equipment2 statsEffectOfEquipment];
    CCArray* equip3Stats = [equipment3 statsEffectOfEquipment];
    [equipmentsStatsArray addObject:equip1Stats];
    [equipmentsStatsArray addObject:equip2Stats];
    [equipmentsStatsArray addObject:equip3Stats];
    DLog(@"EQ 1 = %@", equipment1.equipmentData.equipmentName);
    DLog(@"EQ 2 = %@", equipment2.equipmentData.equipmentName);
    DLog(@"EQ 3 = %@", equipment3.equipmentData.equipmentName);
    //Initialise the 7 stats as array
    CCArray* combinedBonusStats = [[CCArray alloc] initWithCapacity:7];
    for (int x = 0; x < [combinedBonusStats capacity]; x++) {
        [combinedBonusStats addObject:@"1.00"];
    }
    
    //Tally all 7 stats for all 3 equipments
    for (int x = 0; x < [equipmentsStatsArray count]; x++) {
        CCArray* thatEquipmentStats = (CCArray*)[equipmentsStatsArray objectAtIndex:x];
        for (int y = 0; y < [thatEquipmentStats count]; y++) {
//            DLog(@"HAYO = %@", [thatEquipmentStats objectAtIndex:y]);
            float value = [[thatEquipmentStats objectAtIndex:y] floatValue];
            if (value == 1.00) {
                continue;
            }
            
            float combinedValue = [[combinedBonusStats objectAtIndex:y] floatValue];
            if (combinedValue == 1.00) {
                combinedValue = value;
            }
            else{
                combinedValue += value;
            }
            
            [combinedBonusStats replaceObjectAtIndex:y withObject:[NSNumber numberWithFloat:combinedValue]];
//            DLog(@"combined value = %f", combinedValue);
        }
    }
    
    //Add resulting bonus stats to labels
    for (int x = 0; x < [self.bonusLabels count]; x++) {
        CCLabelTTF* thatLabel = (CCLabelTTF*)[self.bonusLabels objectAtIndex:x];
        float thatValue = [[combinedBonusStats objectAtIndex:x] floatValue];
        [thatLabel setString:[NSString stringWithFormat:@"%.2f", thatValue]];
    }
}

@end
