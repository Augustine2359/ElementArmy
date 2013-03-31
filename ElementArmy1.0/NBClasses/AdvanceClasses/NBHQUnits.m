//
//  NBHQUnits.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 31/3/13.
//
//

#import "NBHQUnits.h"

@implementation NBHQUnits

-(id)initWithLayer:(id)layer
{
    if ((self = [super init]))
    {
        [self initialise];
    }
    return self;
}

-(void)initialise{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    
    self.fireButton = [NBButton createWithStringHavingNormal:@"fire_country.png" havingSelected:@"fire_country.png" havingDisabled:@"fire_country.png" onLayer:self respondTo:nil selector:@selector(onFireButton:) withSize:CGSizeZero];
    [self.fireButton setPosition:CGPointMake(80, 125)];
    [self.fireButton show];
    
    self.waterButton = [NBButton createWithStringHavingNormal:@"water_country.png" havingSelected:@"water_country.png" havingDisabled:@"water_country.png" onLayer:self respondTo:nil selector:@selector(onWaterButton) withSize:CGSizeZero];
    [self.waterButton setPosition:CGPointMake(160, 125)];
    [self.waterButton show];
    
    self.earthButton = [NBButton createWithStringHavingNormal:@"earth_country.png" havingSelected:@"earth_country.png" havingDisabled:@"earth_country.png" onLayer:self respondTo:nil selector:@selector(onEarthButton) withSize:CGSizeZero];
    [self.earthButton setPosition:CGPointMake(240, 125)];
    [self.earthButton show];
    
    self.metalButton = [NBButton createWithStringHavingNormal:@"metal_country.png" havingSelected:@"metal_country.png" havingDisabled:@"metal_country.png" onLayer:self respondTo:nil selector:@selector(onMetalButton) withSize:CGSizeZero];
    [self.metalButton setPosition:CGPointMake(320, 125)];
    [self.metalButton show];
    
    self.woodButton = [NBButton createWithStringHavingNormal:@"wood_country.png" havingSelected:@"wood_country.png" havingDisabled:@"wood_country.png" onLayer:self respondTo:nil selector:@selector(onWoodButton) withSize:CGSizeZero];
    [self.woodButton setPosition:CGPointMake(400, 125)];
    [self.woodButton show];
    
    NBBasicClassData *test1 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"metalsoldier"];
    NBBasicClassData *test2 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"woodarcher"];
    NBBasicClassData *test3 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"firemage"];
    NBBasicClassData *test4 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"berserker"];
    
    CCSprite *sprite1 = [CCSprite spriteWithSpriteFrameName:test1.idleFrame];
    CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:test2.idleFrame];
    CCSprite *sprite3 = [CCSprite spriteWithSpriteFrameName:test3.idleFrame];
    CCSprite *sprite4 = [CCSprite spriteWithSpriteFrameName:test4.idleFrame];
    
    [sprite1 setScale:3];
    [sprite2 setScale:3];
    [sprite3 setScale:3];
    [sprite4 setScale:3];
    
    [sprite1 setPosition:ccp(60, 250)];
    [sprite2 setPosition:ccp(180, 250)];
    [sprite3 setPosition:ccp(300, 250)];
    [sprite4 setPosition:ccp(420, 250)];
    
    self.fourUnits = [[CCArray alloc] initWithCapacity:4];
    [self.fourUnits addObject:sprite1];
    [self.fourUnits addObject:sprite2];
    [self.fourUnits addObject:sprite3];
    [self.fourUnits addObject:sprite4];
    [self.fourUnits retain];
    
    [self addChild:sprite1];
    [self addChild:sprite2];
    [self addChild:sprite3];
    [self addChild:sprite4];
    
    [self setPosition:ccp(0, -320)];
}

-(void)onFireButton:(id)sender{
//    DLog(@"%@", sender);
//    if ([sender isKindOfClass:[NBButton class]]) {
//        DLog(@"YOLO");
//    }
    
    NBBasicClassData *basic1 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"metalsoldier"];
    NBBasicClassData *basic2 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"woodarcher"];
    NBBasicClassData *advanced1 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"firemage"];
    NBBasicClassData *advanced2 = [[NBDataManager dataManager] getBasicClassDataByClassName:@"berserker"];
    
    CCSprite *sprite1 = [CCSprite spriteWithSpriteFrameName:basic1.idleFrame];
    CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:basic2.idleFrame];
    CCSprite *sprite3 = [CCSprite spriteWithSpriteFrameName:advanced1.idleFrame];
    CCSprite *sprite4 = [CCSprite spriteWithSpriteFrameName:advanced2.idleFrame];
    
//    CCSprite* thatSprite = [CCSprite new];
//    CCARRAY_FOREACH(self.fourUnits, thatSprite){
//        DLog(@"%@", thatSprite);
//    }
    
    [self.fourUnits removeAllObjects];
//    [self.fourUnits addObject:sprite1];
//    [self.fourUnits addObject:sprite2];
//    [self.fourUnits addObject:sprite3];
//    [self.fourUnits addObject:sprite4];
}

-(void)onWaterButton{
    
}

-(void)onEarthButton{
    
}

-(void)onMetalButton{
    
}

-(void)onWoodButton{
    
}

@end
