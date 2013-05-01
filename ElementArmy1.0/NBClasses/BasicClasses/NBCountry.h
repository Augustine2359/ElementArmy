//
//  NBCountry.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 10/3/13.
//
//

#import <Foundation/Foundation.h>
#import "NBCountryData.h"
#import "NBUserInterface.h"

@interface NBCountry : NSObject

+(NBCountryData*)getCurrentSelectedCountry;
-(id)initWithCountryData:(NBCountryData*)newCountryData onLayer:(CCLayer*)layer respondToSelector:(SEL)selector;
-(void)onIconSelected;
-(void)update;

@property (nonatomic, retain) NBCountryData* countryData;
@property (nonatomic, retain) NBButton* icon;
@property (nonatomic, retain) CCLayer* currentLayer;
@property (nonatomic, assign) SEL currentSelector;

@end
