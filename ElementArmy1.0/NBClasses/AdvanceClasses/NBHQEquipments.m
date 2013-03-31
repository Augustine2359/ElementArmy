//
//  NBHQEquipments.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 31/3/13.
//
//

#import "NBHQEquipments.h"

NBEquipment* currSelectedEquipment = nil;


@implementation NBHQEquipments

-(id)initWithLayer:(id)layer
{
    if ((self = [super init]))
    {
        [self initialiseEquipmentArray];
        [self initialiseEquipmentUI];
    }
    return self;
}

-(void)initialiseEquipmentArray{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    
    self.allEquipments = [CCArray new];
    NBEquipmentData* equipmentData = nil;
    CCARRAY_FOREACH([NBDataManager getListOfEquipments], equipmentData)
    {
        NBEquipment* equipment = [NBEquipment createEquipment:equipmentData onLayer:self onSelector:@selector(selectTargetEquipment)];
        [self.allEquipments addObject:equipment];
    }
}

-(void)initialiseEquipmentUI{
    for (int x = 0; x < [self.allEquipments count]; x++) {
        NBEquipment* thatEquipment = [self.allEquipments objectAtIndex:x];
        [thatEquipment.equipmentIcon setPosition:ccp(x%4 * 100 + 75, 275 - x/4 * 75)];
        [thatEquipment displayEquipmentIcon];
        
        if (x == 11) {
            //Do something to show the remainder on next page
            break;
        }
    }
    
    self.descriptionString = @"No equipment selected";
    self.descriptionLabel = [CCLabelTTF labelWithString:self.descriptionString fontName:@"Marker Felt" fontSize:20];
    self.descriptionLabel.position = ccp(240, 150);
    [self addChild:self.descriptionLabel];
    
    [self setPosition:ccp(0, -320)];
}

-(void)selectTargetEquipment{
    NBEquipment *thatEquipment = [NBEquipment getCurrentlySelectedEquipment];
    
    if (currSelectedEquipment == thatEquipment) {
        self.tapCount++;
    }
    else{
        currSelectedEquipment = thatEquipment;
        self.tapCount = 1;
    }
    
    switch (self.tapCount) {
        case 1:{
            self.descriptionString = thatEquipment.equipmentData.description;
            self.descriptionLabel.string = self.descriptionString;
        }
        break;
            
        default:{
            //Quantity + 1
        }
        break;
    }
}

@end
