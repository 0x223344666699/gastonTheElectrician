//
//  NJOptions.h
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 05/12/12.
//
//

#import <Foundation/Foundation.h>
#import <RevMobAds/RevMobAds.h>
#import <FacebookSDK/FacebookSDK.h>
#import <StoreKit/StoreKit.h>
#import <Parse/Parse.h>
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
@interface NJSettings : NSObject
{
    NSUserDefaults *settings;
    SKProductsRequest* skProductsRequest;
    SKProduct* skProductLevels5;
    SKProduct* skProductLevels12;
    SKProduct* skProductLevelsINF;
    SKProduct* skProductNoAds;
}

@property (strong, nonatomic) NSUserDefaults *settings;
@property (strong, nonatomic) SKProduct* skProductLevels5;
@property (strong, nonatomic) SKProduct* skProductLevels12;
@property (strong, nonatomic) SKProduct* skProductLevelsINF;
@property (strong, nonatomic) SKProduct* skProductNoAds;

+(NJSettings*)sharedSettings;
-(void)resetSettings;

-(void)saveAds:(BOOL)ads;
-(void)saveUsername:(NSString*)username;
-(void)saveFirstTime:(BOOL)firstTime;
-(void)save4Inch:(BOOL)iphone;
-(void)saveAudioSFX:(BOOL)audio;
-(void)saveAudioMusic:(BOOL)audio;
-(void)saveFBAds:(BOOL)ads;
-(void)saveTwitterAds:(BOOL)ads;
-(void)updateKeys:(signed int)delta;

-(BOOL)ads;
-(NSString*)username;
-(BOOL)firstTime;
-(BOOL)is4Inch;
+(BOOL)isIphone5;
-(BOOL)audioSFX;
-(BOOL)audioMusic;
-(int)doIHaveKeys;

@end
