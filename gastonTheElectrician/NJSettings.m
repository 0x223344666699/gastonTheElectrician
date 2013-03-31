//
//  NJOptions.m
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 05/12/12.
//
//

#import "NJSettings.h"

/* NSMutableDictionary optionsDictionary
 // ads
 //
 //
 //                               */


@implementation NJSettings
@synthesize settings;
@synthesize skProductLevels5, skProductLevels12, skProductLevelsINF ,skProductNoAds;
+(NJSettings*)sharedSettings
{
    static NJSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });
    return sharedSettings;
}

- (id)init
{
    if (self = [super init]) {
        settings = [NSUserDefaults standardUserDefaults];
        
        if([[settings objectForKey:@"firstTime"] intValue] != 1)
        {
            [self resetSettings];
            
            settings = [NSUserDefaults standardUserDefaults];
        }
    }
    return self;
}

-(void)saveAds:(BOOL)ads
{
    NSLog(@"ADS: %d",ads);
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSNumber numberWithBool:ads] forKey:@"ads"];
    [settings synchronize];
    
    //Parse
    PFQuery *query = [PFQuery queryWithClassName:@"visitas"];
    [query whereKey:@"ID" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count != 0)
        {
            PFObject *user = objects[0];
            [user setObject:[NSNumber numberWithBool:YES] forKey:@"twitFBAds"];
            [user saveInBackground];
        }
    }];
}

-(void)saveFBAds:(BOOL)ads
{
    NSLog(@"FBADS: %d",ads);
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSNumber numberWithBool:ads] forKey:@"FBads"];
    [settings synchronize];
    [self comprobarFBandTWAds];
}

-(void)saveTwitterAds:(BOOL)ads
{
    NSLog(@"TWADS: %d",ads);
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSNumber numberWithBool:ads] forKey:@"TWads"];
    [settings synchronize];
    [self comprobarFBandTWAds];
    
}

-(void)comprobarFBandTWAds
{
    if( ![self FBads] && ![self TWads] && [self ads])
    {
        [self saveAds:NO];
    }
    else if( [self ads] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did you know that...?" message:@"If you share in both twitter and facebook you obtain the No Ads inApp purchase FREE?" delegate:self cancelButtonTitle:@"Thank you" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)saveFirstTime:(BOOL)firstTime
{
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSNumber numberWithBool:firstTime] forKey:@"firstTime"];
    [settings synchronize];
}

-(void)saveUsername:(NSString*)username
{
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:username forKey:@"username"];
    [settings synchronize];
}

-(void)save4Inch:(BOOL)iphone
{
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSNumber numberWithBool:iphone] forKey:@"4Inch"];
    [settings synchronize];
}

-(void)saveAudioSFX:(BOOL)audio
{
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSNumber numberWithBool:audio] forKey:@"audioSFX"];
    [settings synchronize];
}

-(void)saveAudioMusic:(BOOL)audio
{
    settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSNumber numberWithBool:audio] forKey:@"audioMusic"];
    if(audio)
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"lullaby.mp3" loop:YES];
else
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    [settings synchronize];
}

-(int)doIHaveKeys
{
    settings = [NSUserDefaults standardUserDefaults];
    return [[settings objectForKey:@"keys"] intValue];
}

-(void)updateKeys:(signed int)delta
{
    settings = [NSUserDefaults standardUserDefaults];
    if([self doIHaveKeys])
        [settings setObject:[NSNumber numberWithInt:[self doIHaveKeys]+delta] forKey:@"keys"];
    else
        [settings setObject:[NSNumber numberWithInt:delta] forKey:@"keys"];
    
    [settings synchronize];
}

-(BOOL)is4Inch
{
    return [[[NJSettings sharedSettings].settings objectForKey:@"4Inch"] boolValue];
}

-(BOOL)ads
{
    return [[[NJSettings sharedSettings].settings objectForKey:@"ads"] boolValue];
}

-(BOOL)FBads
{
    return [[[NJSettings sharedSettings].settings objectForKey:@"FBads"] boolValue];
}

-(BOOL)TWads
{
    return [[[NJSettings sharedSettings].settings objectForKey:@"TWads"] boolValue];
}

-(BOOL)firstTime
{
    return [[[NJSettings sharedSettings].settings objectForKey:@"firstTime"] boolValue];
}

-(NSString*)username
{
    return [[NJSettings sharedSettings].settings objectForKey:@"username"];
}

+(BOOL)isIphone5
{
    return 500 < [[UIScreen mainScreen] bounds].size.height;
}

-(void)resetSettings
{
    settings = [NSUserDefaults standardUserDefaults];
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         if (!error) {
             [[NJSettings sharedSettings] saveUsername:user.name];
         }
     }];
    
    [settings setObject:[NSNumber numberWithBool:YES] forKey:@"firstTime"];
    [settings setObject:[NSNumber numberWithBool:YES] forKey:@"ads"];
    [settings setObject:[NSNumber numberWithBool:YES] forKey:@"FBads"];
    [settings setObject:[NSNumber numberWithBool:YES] forKey:@"TWads"];
    [settings setObject:[NSNumber numberWithBool:[NJSettings isIphone5]] forKey:@"4Inch"];
    [settings setObject:[NSNumber numberWithBool:YES] forKey:@"audioSFX"];
    [settings synchronize];
}

-(BOOL)audioSFX
{
    return [[[NJSettings sharedSettings].settings objectForKey:@"audioSFX"] boolValue];
}

-(BOOL)audioMusic
{
    return [[[NJSettings sharedSettings].settings objectForKey:@"audioMusic"] boolValue];
}

@end