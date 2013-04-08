//
//  NBHQItems.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 31/3/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBItem.h"

@interface NBHQItems : NBBasicScreenLayer

@property (nonatomic, retain) id mainLayer;
@property (nonatomic, retain) CCArray* allItems;
@property (nonatomic, retain) CCArray* allCostLabels;
@property (nonatomic, retain) CCArray* allQuantityLabels;

@property (nonatomic, retain) CCSprite* labelBackground;
@property (nonatomic, retain) CCLabelTTF* descriptionLabel;
@property (nonatomic, assign) NSString* descriptionString;

@property (nonatomic, assign) int tapCount;
@property (nonatomic, retain) NBButton* buyButton;

-(id)initWithLayer:(id)layer;
-(void)initialiseItemArray;
-(void)initialiseItemUI;
-(void)selectTargetItem;

@end
