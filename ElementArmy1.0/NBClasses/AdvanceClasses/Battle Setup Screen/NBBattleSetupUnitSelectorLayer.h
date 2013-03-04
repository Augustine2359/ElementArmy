//
//  NBBattleSetupUnitSelectorLayer.h
//  ElementArmy1.0
//
//  Created by Augustine on 10/1/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBCharacter.h"

@interface NBBattleSetupUnitSelectorLayer : CCLayerColor

@property (nonatomic) BOOL isLocked;
@property (nonatomic) NSInteger tier; //tier goes from 0 to 2
@property (nonatomic) NSInteger element; //element goes from 0 to 4

- (BOOL)isTouchingMe:(CGPoint)touchLocation;

- (void)decreaseTier;
- (void)decreaseElement;
- (void)increaseElement;
- (void)increaseTier;

- (NBBasicClassData *)basicClassData;

@end
