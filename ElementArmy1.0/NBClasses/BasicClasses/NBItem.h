//
//  NBItem.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import <Foundation/Foundation.h>
#import "NBItemData.h"

@interface NBItem : NSObject

+(id)createItem:(NSString*)itemID;
-(id)setItemIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer respondTo:(id)object selector:(SEL)selector;
-(void)displayItemIcon;
-(void)hideItemIcon;

@property (nonatomic, retain) NBItemData* itemData;
@property (nonatomic, retain) NBButton* itemIcon;

@property (nonatomic, retain) NSString* image;

@end
