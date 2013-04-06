//
//  NBHQUnits.h
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 31/3/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBButton.h"


@interface NBHQUnits : NBBasicScreenLayer

@property (nonatomic, retain) id mainLayer;
@property (nonatomic, retain) NBButton* fireButton;
@property (nonatomic, retain) NBButton* waterButton;
@property (nonatomic, retain) NBButton* earthButton;
@property (nonatomic, retain) NBButton* metalButton;
@property (nonatomic, retain) NBButton* woodButton;
@property (nonatomic, retain) CCArray* fourUnits;

-(id)initWithLayer:(id)layer;
-(void)initialise;
-(void)onFireButton:(id)sender;
-(void)onWaterButton;
-(void)onEarthButton;
-(void)onMetalButton;
-(void)onWoodButton;

@end
