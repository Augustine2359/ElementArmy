//
//  NBAudioManager.h
//  ElementArmy1.0
//
//  Created by Augustine on 25/4/13.
//
//

#import <Foundation/Foundation.h>

@interface NBAudioManager : NSObject

+ (NBAudioManager *)sharedInstance;
- (void)playSoundEffect:(NSString *)soundEffect;

@end
