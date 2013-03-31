//
//  GameInterfaceLayer.h
//  Gaston
//
//  Created by Juan Jacobo Montero Muñoz on 03/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NJPolvisi.h"
#import "CCTool.h"
#import "PRFilledPolygon.h"
#import "GameLayer.h"
#import "NJSettings.h"
#import "PauseMenuLayer.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>

NSMutableArray *tools;
NSMutableArray *usedTools;
NSMutableDictionary *polvisacos;
NSMutableArray *polyg;
NSMutableArray *polyg2;
int maxBulbs;
int plus;
RevMobFullscreen *fullscreenAd;
@class GameLayer;
@class PauseMenuLayer;

@interface GameInterfaceLayer : CCLayer <SKPaymentTransactionObserver>
{
    SKProductsRequest *productRequest;
    int boughtKeys;
    CCSprite *bottomBg;
    CCTool *tocado;
    NSMutableArray *polygon;
    GameLayer *gameLayer;
    BOOL switchPosition;
    BOOL mov;
    NSMutableArray *dondeHasTocado;
    PauseMenuLayer *pauseMenuLayer;
    CCLabelTTF *largeBulbNumb;
    CCMenuItemToggle* ccSwitch;
    SKProduct *unlockLevels;
}
+(CCScene*)sceneWithLevel:(int)lvl;
-(void) setGameLayer:(GameLayer*)gameL;
-(void) pauseMenu:(int)menu porcentaje:(float)percent;
-(void)luces;

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
@end
