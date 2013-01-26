//
//  BattleSetupItems.m
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "BattleSetupItems.h"

@implementation BattleSetupItems

float slideDuration = 0.5f;
//bool itemSelectionOpen = NO;


- (void)onEnter {
    [super onEnter];
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initialiseItemArray];
        
        [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
//        self.itemSelectionFrame = [NBStaticObject createWithSize:CGSizeMake(400, 300) usingFrame:@"frame_item.png" atPosition:CGPointMake(240, -300)];
        
        self.item01 = [NBButton createWithStringHavingNormal:[self.itemNames objectAtIndex:0] havingSelected:[self.itemNames objectAtIndex:0] havingDisabled:[self.itemNames objectAtIndex:0] onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item01 setPosition:CGPointMake(100, 250)];
        [self.item01 show];
        self.item02 = [NBButton createWithStringHavingNormal:@"Fury_pill.png" havingSelected:@"Fury_pill.png" havingDisabled:@"Fury_pill.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item02 setPosition:CGPointMake(200, 250)];
        [self.item02 show];
        self.item03 = [NBButton createWithStringHavingNormal:@"Winged_boots.png" havingSelected:@"Winged_boots.png" havingDisabled:@"Winged_boots.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item03 setPosition:CGPointMake(300, 250)];
        [self.item03 show];
        self.item04 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item04 setPosition:CGPointMake(400, 250)];
        [self.item04 show];
        
        self.item05 = [NBButton createWithStringHavingNormal:@"Fury_pill.png" havingSelected:@"Fury_pill.png" havingDisabled:@"Fury_pill.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item05 setPosition:CGPointMake(100, 175)];
        [self.item05 show];
        
        NBButton* okBtn = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [okBtn setPosition:ccp(400, 50)];
        [okBtn show];
        
        [self setPosition:ccp(0, -320)];
    }
    return self;
}

-(void)initialiseItemArray{
    self.itemNames = [NSArray new];
    self.itemNames = [NSArray arrayWithObjects:@"Potion.png", @"Fury_pill.png", @"Winged_boots.png", @"Fury_pill.png", @"Potion.png", nil];
}

-(void)toggleItemSelection{
    //Closed
    if (!self.itemSelectionOpen) {
        id open = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(0, 0)];
        [self runAction:open];
        self.itemSelectionOpen = YES;
    }
    //Opened
    else{
        id close = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(0, -320)];
        [self runAction:close];
        self.itemSelectionOpen = NO;
    }
}

@end
