//
//  NBMessageBox.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 26/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NBStaticObject.h"
#import "NBButton.h"

#define MESSAGE_BOX_FRAME_NAME @"static_box.png"

@interface NBMessageBox : NBStaticObject

+(void)show:(NSString*)message;

@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NBButton* buttonOK;

@end
