//
//  IntroLayer.h
//  gastonTheElectrician
//
//  Created by Juan Jacobo Montero Muñoz on 31/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NJPgeScrollLayer.h"
#import "NJHowToPlayScroll.h"
#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <GameKit/GameKit.h>
#import <Parse/Parse.h>
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
//#import "NJLevelCreator.h"
//#import "NJLevelReader.h"
#import <RevMobAds/RevMobAds.h>

@interface IntroLayer : CCLayer <MFMailComposeViewControllerDelegate, GKAchievementViewControllerDelegate, RevMobAdsDelegate >{CCMenu *menu;
    CCMenu *shareMenu;
    CCMenu* settingsMenu;
    CCSprite *tapadera;
    pgeScrollLayer* scroll;
    howToPlayScrollLayer* HTPscroll;
    UIViewController* emailController;
}
+(CCScene *) scene;
-(void)facebook;
@end
