//
//  NBSoldier.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 30/9/12.
//
//

#import <Foundation/Foundation.h>
#import "NBCharacter.h"
#import "NBUpdatableCharacter.h"

#define MAXIMUM_SOLDIER_CAPACITY 50
#define METAL_SOLDIER_FILE @"metal_soldier_IDLEanim_1.png"
#define METAL_SOLDIER_FILE_IDLE @"metal_soldier_IDLEanim"
#define METAL_SOLDIER_FILE_ATTACK @"metal_soldier_ATTACKanim"
#define FIRE_MAGE_FILE_IDLE @"fire_mage_IDLEanim"
#define FIRE_MAGE_FILE_ATTACK @"fire_mage_ATTACKanim"
#define FIRE_MAGE_FILE @"fire_mage_IDLEanim_1.png"

@interface NBSoldier : NBCharacter

-(void)initialize;
-(void)attack:(NBCharacter*)target;
-(void)attackWithAnimation:(NBCharacter*)target withAnimation:(NSString*)animationName;

-(void)onTouched;
-(void)onAttackCompleted;
-(void)onAttacked:(id)attacker;

@end
