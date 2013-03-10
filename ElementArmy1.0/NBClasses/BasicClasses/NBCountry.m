//
//  NBCountry.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 10/3/13.
//
//

#import "NBCountry.h"

static NBCountryData* currentlySelectedCountry = nil;

@implementation NBCountry

+(NBCountryData*)getCurrentSelectedCountry
{
    return currentlySelectedCountry;
}

-(id)initWithCountryData:(NBCountryData*)newCountryData onLayer:(CCLayer*)layer respondToSelector:(SEL)selector
{
    if (self = [super init])
    {
        self.countryData = newCountryData;
        self.currentLayer = layer;
        self.currentSelector = selector;
        self.icon = [NBButton createWithStringHavingNormal:self.countryData.iconSpriteNormal havingSelected:self.countryData.iconSpriteSelected havingDisabled:self.countryData.iconSpriteDisabled onLayer:layer respondTo:self selector:@selector(onIconSelected) withSize:CGSizeZero];
        self.icon.position = newCountryData.positionInWorld;
        [self.icon show];
    }
    
    return self;
}

-(void)onIconSelected
{
    DLog(@"%@ selected", self.countryData.countryName);
    currentlySelectedCountry = self.countryData;
    [self.currentLayer performSelector:self.currentSelector];
}

@end
