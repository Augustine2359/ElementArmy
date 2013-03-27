//
//  NBBattleSetupUnitSelectorsContainerLayer.h
//  ElementArmy1.0
//
//  Created by Augustine on 11/1/13.
//
//

#import "CCLayer.h"
#import "NBCharacter.h"

@interface NBBattleSetupUnitSelectorsContainerLayer : CCLayerColor

//pass in 0, 1 or 2 and it'll return the character in the appropriate slot
- (NBBasicClassData *)basicClassDataInUnitSelector:(NSInteger)selector;
- (void)addSwipeGestureRecognizers;
- (void)removeSwipeGestureRecognizersFromDirector;

@end
