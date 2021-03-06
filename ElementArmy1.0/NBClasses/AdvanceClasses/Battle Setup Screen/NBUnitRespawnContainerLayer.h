//
//  NBUnitRespawnContainerLayer.h
//  ElementArmy1.0
//
//  Created by Augustine on 27/2/13.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "NBBasicScreenLayer.h"
#import "NBEquipment.h"


@interface NBUnitRespawnContainerLayer : CCLayerColor

//Attributes section
@property(nonatomic, retain) NBStaticObject* attributesBackground;
@property(nonatomic, retain) NBStaticObject* portraitImage;

@property(nonatomic, retain)CCLabelTTF* labelHPStat;
@property(nonatomic, retain)CCLabelTTF* labelSPStat;
@property(nonatomic, retain)CCLabelTTF* labelSTRStat;
@property(nonatomic, retain)CCLabelTTF* labelDEFStat;
@property(nonatomic, retain)CCLabelTTF* labelINTStat;
@property(nonatomic, retain)CCLabelTTF* labelDEXStat;
@property(nonatomic, retain)CCLabelTTF* labelEVAStat;

@property(nonatomic, retain)CCArray* bonusLabels;

-(id)initWithRect:(CGRect)rect;
-(void)updateBonusStats:(NBEquipment*)equipment1 equipment2:(NBEquipment*)equipment2 equipment3:(NBEquipment*)equipment3;

@end
