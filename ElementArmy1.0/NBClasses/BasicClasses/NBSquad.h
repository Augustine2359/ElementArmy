//
//  NBSquad.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 14/10/12.
//
//

#import <Foundation/Foundation.h>
#import "NBFireExplosion.h"
#import "NBCharacter.h"
#import "NBSkill.h"

#define MAXIMUM_SQUAD_PER_SIDE 4
#define MAGIC_SLOT_CAPACITY 3
#define MAXIMUM_UNIT_COUNT 8
#define FIRST_UNIT_X_BACKLINE_PERCENTAGE 0.10
#define FIRST_UNIT_X_FRONTLINE_PERCENTAGE 0.25
#define FIRST_UNIT_Y_BOTTOM_PERCENTAGE 0.20
#define TOP_BATTLEFIELD_PADDING 40
#define Y_UNIT_PADDING 40

@interface NBSquad : NSObject

+(void)resetSquadPositionIndex;
+(void)setupBatteFieldDimension:(CGSize)size;
//-(id)createSquadOf:(NSString*)unitClassName withUnitCount:(int)count onSide:(EnumCharacterSide)side andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer;
-(id)createSquadUsingBasicClassData:(NBBasicClassData*)basicClassData onSide:(EnumCharacterSide)side andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer;
-(void)updateWithAllyUnits:(CCArray*)allySquads andEnemyUnits:(CCArray*)enemySquads withDelta:(ccTime)delta;
-(void)startUpdate;
-(void)update;

@property (nonatomic, retain) CCArray* skillSlot;
@property (nonatomic, retain) CCArray* unitArray;
@property (nonatomic, assign) Class unitClass;
@property (nonatomic, assign) int squadPositionIndex;
@property (nonatomic, assign) bool allUnitAreDead;
@property (nonatomic, assign) long totalAliveUnitHP;
@property (nonatomic, assign) int totalCurrentAliveUnit;

@end
