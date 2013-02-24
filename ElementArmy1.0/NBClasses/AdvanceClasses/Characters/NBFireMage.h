//
//  NBFireMage.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 30/9/12.
//
//

#import <Foundation/Foundation.h>
#import "NBCharacter.h"
#import "NBUpdatableCharacter.h"
#import "NBFireball.h"

#define MAXIMUM_FIREMAGE_CAPACITY 50
#define FIRE_MAGE_FILE_IDLE @"fire_mage_IDLEanim"
#define FIRE_MAGE_FILE_ATTACK @"fire_mage_ATTACKanim"
#define FIRE_MAGE_FILE @"fire_mage_IDLEanim_1.png"

@interface NBFireMage : NBCharacter

-(id)initWithSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer onSide:(EnumCharacterSide)side usingBasicClassData:(NBBasicClassData*)basicClassData;
-(void)attack:(NBCharacter*)target;
-(void)attackWithAnimation:(NBCharacter*)target withAnimation:(NSString*)animationName;

-(void)onTouched;
-(void)onAttackCompleted;
-(void)onAttacked:(id)attacker;

@end
