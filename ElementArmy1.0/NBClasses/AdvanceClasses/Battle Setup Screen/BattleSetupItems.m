//
//  BattleSetupItems.m
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "BattleSetupItems.h"

@implementation BattleSetupItems

- (void)onEnter {
    [super onEnter];
}

- (id)init {
    self = [super init];
    
    if (self) {
        
        self.itemSelectionFrame = [NBStaticObject createWithSize:CGSizeMake(400, 300) usingFrame:@"frame_item.png" atPosition:CGPointMake(240, -300)];
        
        self.item01 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item01 setPosition:CGPointMake(100, -300)];
        [self.item01 show];
        self.item02 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item02 setPosition:CGPointMake(150, -300)];
        [self.item02 show];
        self.item03 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item03 setPosition:CGPointMake(200, -300)];
        [self.item03 show];
        self.item04 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item04 setPosition:CGPointMake(250, -300)];
        [self.item04 show];
        self.item05 = [NBButton createWithStringHavingNormal:@"Potion.png" havingSelected:@"Potion.png" havingDisabled:@"Potion.png" onLayer:self selector:@selector(toggleItemSelection) withSize:CGSizeZero];
        [self.item05 setPosition:CGPointMake(300, -300)];
        [self.item05 show];
        
    }
    return self;
}
@end
