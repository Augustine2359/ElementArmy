//
//  NBHQSettings.m
//  ElementArmy1.0
//
//  Created by NebulaMac1 on 25/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "NBHQSettings.h"
#import "NBAudioManager.h"

@interface NBHQSettings()

@property (nonatomic, strong) CCLabelTTF *bgmVolumeNumberButton;

@end

@implementation NBHQSettings

-(id)initWithLayer:(id)layer{
    if (self = [super init]) {
        [self initialise];
      [self updateInformation];
    }
    
    return self;

}

-(void)initialise{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    [self setPosition:ccp(0, -320)];
  
  CCLabelTTF *bgmVolumeLabel = [CCLabelTTF labelWithString:@"BGM Volume" fontName:@"PF Ronda Seven" fontSize:15];
  bgmVolumeLabel.position = CGPointMake(100, 250);
  [self addChild:bgmVolumeLabel];

  self.bgmVolumeNumberButton = [CCLabelTTF labelWithString:@"1" fontName:@"PF Ronda Seven" fontSize:15];
  self.bgmVolumeNumberButton.position = CGPointMake(300, 250);
  [self addChild:self.bgmVolumeNumberButton];

  NBButton *decreaseBGMVolumeButton = [NBButton createWithStringHavingNormal:@"NB_chargeIcon1_400x200.png" havingSelected:@"NB_chargeIcon1_400x200.png" havingDisabled:@"NB_chargeIcon1_400x200.png" onLayer:self respondTo:nil selector:@selector(decreaseBGMVolume:) withSize:CGSizeZero];
  decreaseBGMVolumeButton.position = CGPointMake(250, 250);
  [decreaseBGMVolumeButton show];
  
  NBButton *increaseBGMVolumeButton = [NBButton createWithStringHavingNormal:@"NB_chargeIcon1_400x200.png" havingSelected:@"NB_chargeIcon1_400x200.png" havingDisabled:@"NB_chargeIcon1_400x200.png" onLayer:self respondTo:nil selector:@selector(increaseBGMVolume:) withSize:CGSizeZero];
  increaseBGMVolumeButton.position = CGPointMake(350, 250);
  [increaseBGMVolumeButton show];
  
  CCLabelTTF *muteSoundLabel = [CCLabelTTF labelWithString:@"Mute" fontName:@"PF Ronda Seven" fontSize:15];
  muteSoundLabel.position = CGPointMake(100, 200);
  [self addChild:muteSoundLabel];

  NBButton *toggleMuteButton = [NBButton createWithStringHavingNormal:@"NB_chargeIcon1_400x200.png" havingSelected:@"NB_chargeIcon1_400x200.png" havingDisabled:@"NB_chargeIcon1_400x200.png" onLayer:self respondTo:nil selector:@selector(toggleMute:) withSize:CGSizeZero];
  toggleMuteButton.position = CGPointMake(250, 200);
  [toggleMuteButton show];
}

- (void)updateInformation {
  self.bgmVolumeNumberButton.string = [NSString stringWithFormat:@"%d", [[NBAudioManager sharedInstance] bgmVolume]];
  if ([[NBAudioManager sharedInstance] isMute])
    DLog(@"Sound is muted");
  else
    DLog(@"Sound is audible");
}

- (void)decreaseBGMVolume:(id)sender {
  [[NBAudioManager sharedInstance] decreaseBGMVolume];
  [self updateInformation];
}

- (void)increaseBGMVolume:(id)sender {
  [[NBAudioManager sharedInstance] increaseBGMVolume];
  [self updateInformation];
}

- (void)toggleMute:(id)sender {
  [[NBAudioManager sharedInstance] toggleMute];
  [self updateInformation];
}

@end
