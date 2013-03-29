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
- (void)setupSelectorsForItem1:(SEL)selectorForItem1 forItem2:(SEL)selectorForItem2 forItem3:(SEL)selectorForItem3 onBattleLayer:(id)layer;
-(void)addItemFrameName:(NSString*)itemFrame;

@property (nonatomic, strong) CCSprite *backgroundSprite;

@property (nonatomic, retain) id battleLayer;
@property (nonatomic, assign) SEL item1Selector;
@property (nonatomic, assign) SEL item2Selector;
@property (nonatomic, assign) SEL item3Selector;

@end
