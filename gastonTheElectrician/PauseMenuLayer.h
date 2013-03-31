//
//  PauseMenuLayer.h
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 31/01/13.
//
//

#import "CCLayer.h"
#import "GameInterfaceLayer.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"
@interface PauseMenuLayer : CCLayerColor <MFMailComposeViewControllerDelegate, SKPaymentTransactionObserver>
{
    int chooseAd;
    CCSprite *pauseMenuBg;
    CCMenu *pauseMenu;
    CCMenu *share2Menu;
    CCMenuItemImage *playButton;
    CCMenuItemImage *exitButton;
    CCMenuItemImage *restartButton;
    CCMenu *adMenu;
    CCLabelTTF *titleWL;
    CCLabelTTF *subtitleWL;
    CCLabelTTF *scoreWL;
    CCSprite *rayo1WL;
    CCSprite *rayo2WL;
    CCSprite *rayo3WL;
    UIViewController* emailController;
    NSString *shareText;
    int whichMenu;
}

-(void)displayMenu:(int)menu; //1 end 0 pausa

@end
