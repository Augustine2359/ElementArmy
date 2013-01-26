//
//  BattleSetupItems.h
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "NBBasicScreenLayer.h"

@interface BattleSetupItems : NBBasicScreenLayer

@property (nonatomic, retain) NBStaticObject *itemSelectionFrame;
@property (nonatomic, retain) NBButton *item01;
@property (nonatomic, retain) NBButton *item02;
@property (nonatomic, retain) NBButton *item03;
@property (nonatomic, retain) NBButton *item04;
@property (nonatomic, retain) NBButton *item05;

@property (nonatomic, retain) NSArray* itemNames;
@property (nonatomic) bool itemSelectionOpen;

-(void)toggleItemSelection;
-(void)initialiseItemArray;

@end
