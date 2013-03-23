//
//  NBCountryData.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 12/2/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "NBUserInterface.h"

#define MAX_NUM_OF_STAGE_PER_WORLD 100

@interface NBCountryData : NSObject

@property (nonatomic, retain) NSString* countryName;
@property (nonatomic, retain) NSString* iconSpriteNormal;
@property (nonatomic, retain) NSString* iconSpriteSelected;
@property (nonatomic, retain) NSString* iconSpriteDisabled;
@property (nonatomic, retain) NSString* gridBackgroundImage;
@property (nonatomic, assign) CGSize gridBoardSize;
@property (nonatomic, assign) CGPoint positionInWorld;
@property (nonatomic, retain) CCArray* stageList;
@property (nonatomic, retain) CCArray* listOfCreatedStagesID;
@property (nonatomic, assign) int majorElementID;

@end
