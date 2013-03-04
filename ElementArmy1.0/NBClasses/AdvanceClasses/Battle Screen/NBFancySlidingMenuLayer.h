//
//  NBFancySlidingMenuLayer.h
//  ElementArmy1.0
//
//  Created by Augustine on 4/1/13.
//
//

#import "NBBasicScreenLayer.h"

@interface NBFancySlidingMenuLayer : NBBasicScreenLayer

- (id)initOnLeftSide:(BOOL)onLeftSide;

@property (nonatomic, strong) CCSprite *backgroundSprite;

@end
