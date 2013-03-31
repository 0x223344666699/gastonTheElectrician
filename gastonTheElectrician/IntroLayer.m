//
//  IntroLayer.m
//  Gaston
//
//  Created by Juan Jacobo Montero Muñoz on 02/11/12.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameLayer.h"
#import "ChooseGameModeLayer.h"
#define NJTraduccion(key) \
NSLocalizedString( (key), nil)
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    plus = 0;
    if ( size.height > 480) plus = 44;
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
    layer.position = ccp( 0, plus);
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init
{
    if(self = [super init])
    {
        if([[NJSettings sharedSettings] ads] && plus == 44)
        {
            [[RevMobAds session] showBanner];
            
            CCLabelTTF*label = [CCLabelTTF labelWithString:@"Get more games!" fontName:@"Helvetica-Bold" fontSize:30];
            label.color = ccc3(255, 196, 31);
            CCMenu* adMenu = [CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
                [[RevMobAds session] openAdLinkWithDelegate:self];
            }], nil];
            
            adMenu.position = ccp(160,546);
            [self addChild:adMenu];
        }
        //ParseTest
        NSString *countryCode = [(NSDictionary*)[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];//countryCode
        NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
        NSString *device = [[UIDevice currentDevice] systemName];
        NSString *name = [[UIDevice currentDevice] name];
        NSString *ID;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"ID"])
        {
            ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
            PFQuery *usersQuery = [PFQuery queryWithClassName:@"visitas"];
            [usersQuery whereKey:@"ID" equalTo:ID];
            [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if([objects count])
                {
                    PFObject *object = objects[0];
                    [object incrementKey:@"visitas"];
                    [object saveInBackground];
                    if ( ![object objectForKey:@"rated"] && [[object objectForKey:@"visitas"] intValue] % 15 == 0 )
                    {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NJTraduccion(@"RATEALERTTITLE") message:NJTraduccion(@"RATEALERTMESSAGE") delegate:self cancelButtonTitle:NJTraduccion(@"NO") otherButtonTitles:NJTraduccion(@"YES"), nil];
                        alert.tag = 123;
                        [alert show];
                    }
                }
                
            }];
        }
        else
        {
            PFObject *visitasObject = [PFObject objectWithClassName:@"visitas"];
            PFQuery *usersQuery = [PFQuery queryWithClassName:@"visitas"];
            [visitasObject setObject:[NSNumber numberWithInt:[usersQuery countObjects]] forKey:@"ID"];
            [visitasObject setObject:countryCode forKey:@"country"];
            [visitasObject setObject:iosVersion forKey:@"iosVersion"];
            [visitasObject setObject:device forKey:@"device"];
            [visitasObject setObject:name forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[usersQuery countObjects]] forKey:@"ID"];
            [visitasObject incrementKey:@"visitas"];
            [visitasObject saveInBackground];
            
        }
        
        //mailIniti
        emailController = [[UIViewController alloc] init];
        [[[CCDirector sharedDirector] view] addSubview:emailController.view];
        
        //size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //background
        CCSprite *bg = [CCSprite spriteWithFile:NJTraduccion(@"BGWITHLOGOANDCHAR") rect:CGRectMake(0, 0, 320, 480)];
        bg.position = ccp(160, 240);
        [self addChild:bg z:0 tag:0];
        
        //playButton
        CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"PLAYBUTTON") selectedImage:NJTraduccion(@"PLAYBUTTON") block:^(id sender) {
            [self makeTransition:(ccTime)0];
        }];
        playButton.position = ccp(0, -42);
        playButton.tag = 0;
        
        //shareButton
        CCMenuItemImage *shareButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"SHAREBUTTON") selectedImage:NJTraduccion(@"SHAREBUTTON") block:^(id sender) {
            [self makeTransition:(ccTime)2];
        }];
        shareButton.position = ccp(size.width/4, -150);
        shareButton.tag = 2;
        
        //aboutButton
        CCMenuItemImage *aboutButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"ABOUTBUTTON") selectedImage:NJTraduccion(@"ABOUTBUTTON") block:^(id sender) {
            [self makeTransition:(ccTime)3];
        }];
        aboutButton.position = ccp(size.width/4, -195);
        aboutButton.tag = 3;
        
        //settingsButton
        CCMenuItemImage *settingsButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"SETTINGSBUTTON")selectedImage:NJTraduccion(@"SETTINGSBUTTON") block:^(id sender) {
            [self makeTransition:(ccTime)1];
        }];
        settingsButton.position = ccp(-size.width/4, -195);
        settingsButton.tag = 1;
        
        //howToPlayButton
        CCMenuItemImage *howToPlayButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"HTPLAYBUTTON") selectedImage:NJTraduccion(@"HTPLAYBUTTON") block:^(id sender) {
            [self makeTransition:(ccTime)4];
        }];
        howToPlayButton.position = ccp(-size.width/4, -150);
        howToPlayButton.tag = 4;
        
        menu = [CCMenu menuWithItems:playButton, settingsButton, shareButton, aboutButton, howToPlayButton, nil];
        menu.position = ccp(160,240 );
        
        playButton.position = ccp(0, -42);
        
        [self addChild:menu z:2];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"tapOnButton.wav"];
        if ( [[NJSettings sharedSettings] audioSFX] == NO)
        {
            [[SimpleAudioEngine sharedEngine] setEffectsVolume:0];
        }
        if( [[NJSettings sharedSettings] audioMusic])
        {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"lullaby.mp3" loop:YES];
        }
        
    }
    return self;
}

-(void) makeTransition:(ccTime)dt
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    int tag = (int)dt;
    int i = 0;
    CCMenuItemImage* item;
    
    for(CCMenuItemImage* menuItem in [menu children]) //Ocultar el resto de botones
    {
        if(i != tag)
        {
            if([menuItem opacity] == 255)
            {
                [menuItem  runAction: [CCFadeTo actionWithDuration:0.15 opacity:0]];
                [menuItem setIsEnabled:NO];
            }
            else
            {
                [menuItem  runAction: [CCFadeTo actionWithDuration:0.15 opacity:255]];
                [menuItem setIsEnabled:YES];
            }
        }
        else
        {
            item = menuItem;
        }
        i++;
        
    }
    
    switch (tag)
    {
        case 0: //PlayButton
        {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[ChooseGameModeLayer scene] withColor:ccBLACK]];
        }
            break;
        case 1: //Settings
        {
            if(item.position.y == 10)
            {
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, -205)]];
                [settingsMenu runAction:[CCFadeTo actionWithDuration:0.10 opacity:0]];
                [settingsMenu setIsTouchEnabled:NO];
            }
            else
            {
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, 205)]];
                if(settingsMenu != nil)
                {
                    [settingsMenu runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.20],[CCFadeTo actionWithDuration:0.30 opacity:255], nil] ];
                    [settingsMenu setIsTouchEnabled:YES];
                }
                else
                {
                    CCMenuItemImage *gameCenter = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"GAMECENTERBUTTON") selectedImage:NJTraduccion(@"GAMECENTERBUTTON") block:^(id sender) {
                        [self gameCenter];
                    }];
                    gameCenter.position = ccp(-size.width/4+20, -50);
                    
                    //SFX
                    CCMenuItem* SFXON = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"SFXButton.png")selectedImage:NJTraduccion(@"SFXButton.png") block:nil];
                    
                    CCMenuItem* SFXOFF = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"SFXOFFButton.png")selectedImage:NJTraduccion(@"SFXOFFButton.png") block:nil];
                    
                    NSArray *items;
                    if([[NJSettings sharedSettings] audioSFX])
                    {
                        items = [NSArray arrayWithObjects:SFXON, SFXOFF, nil];
                    }
                    else
                    {
                        items = [NSArray arrayWithObjects:SFXOFF, SFXON, nil];
                    }
                    
                    CCMenuItemToggle *SFX = [CCMenuItemToggle itemWithItems:items block:^(id sender){
                        if([[NJSettings sharedSettings] audioSFX])
                        {
                            [[NJSettings sharedSettings] saveAudioSFX:NO];
                        }
                        else
                        {
                            [[NJSettings sharedSettings] saveAudioSFX:YES];
                            
                        }
                    }];
                    
                    SFX.position = ccp(-size.width/4+20, -100);
                    
                    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"ID: %d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"] intValue] ]fontName:@"Helvetica-Bold" fontSize:40];
                    label.color = ccc3(201, 128, 57);
                    label.position = ccp(0, -210);
                    
                    CCMenuItemLabel *labelMenu = [CCMenuItemLabel itemWithLabel:label];
                    CCLabelTTF *labelShade = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"ID: %d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"] intValue] ]fontName:@"Helvetica-Bold" fontSize:40];;
                    labelShade.color = ccc3(10, 10, 10);
                    labelShade.position = ccp(2, -212);
                    CCMenuItemLabel *labelMenuShade = [CCMenuItemLabel itemWithLabel:labelShade];
                    //Music
                    CCMenuItem* musicON = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"MUSICBUTTON")  selectedImage:NJTraduccion(@"MUSICBUTTON") block:nil];
                    
                    CCMenuItem* musicOFF = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"MUSICOFFBUTTON")selectedImage:NJTraduccion(@"MUSICOFFBUTTON") block:nil];
                    
                    NSArray *items2;
                    if([[NJSettings sharedSettings] audioMusic])
                    {
                        items2 = [NSArray arrayWithObjects:musicON, musicOFF, nil];
                    }
                    else
                    {
                        items2 = [NSArray arrayWithObjects:musicOFF, musicON, nil];
                    }
                    
                    CCMenuItemToggle *music = [CCMenuItemToggle itemWithItems:items2 block:^(id sender){
                        if([[NJSettings sharedSettings] audioMusic])
                        {
                            [[NJSettings sharedSettings] saveAudioMusic:NO];
                        }
                        else
                        {
                            [[NJSettings sharedSettings] saveAudioMusic:YES];
                        }
                    }];
                    
                    music.position = ccp(-size.width/4+20, -150);
                    
                    settingsMenu = [CCMenu menuWithItems:gameCenter, SFX, music, labelMenuShade, labelMenu, nil];
                    [settingsMenu setOpacity:0];
                    settingsMenu.position = ccp(160,240);
                    [self addChild:settingsMenu z:0];
                    
                }
                [settingsMenu runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.20],[CCFadeTo actionWithDuration:0.30 opacity:255], nil] ];
            }
        }
            break;
            
        case 2: //Share
        {
            if(item.position.y == 10)
            {
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, -160)]];
                [shareMenu runAction:[CCFadeTo actionWithDuration:0.10 opacity:0]];
                [shareMenu setIsTouchEnabled:NO];
            }
            else
            {
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, 160)]];
                if(shareMenu != nil)
                {
                    [shareMenu runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.20],[CCFadeTo actionWithDuration:0.30 opacity:255], nil] ];
                    [shareMenu setIsTouchEnabled:YES];
                }
                else
                {
                    CCMenuItemImage *facebook = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"LIKEBUTTON") selectedImage:NJTraduccion(@"LIKEBUTTON") block:^(id sender) {
                        [self facebook];
                    }];
                    facebook.position = ccp(0, -67);
                    
                    CCMenuItemImage *weibo = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"WEIBOBUTTON") selectedImage:NJTraduccion(@"WEIBOBUTTON") block:^(id sender) {
                        [self sinaWeibo];
                    }];
                    weibo.position = ccp(-size.width/4-5, -160);
                    
                    CCMenuItemImage *twitter = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"TWITTERBUTTON") selectedImage:NJTraduccion(@"TWITTERBUTTON") block:^(id sender) {
                        [self twitter];
                    }];
                    twitter.position = ccp(0, -160);
                    
                    CCMenuItemImage *mail = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"MAILBUTTON") selectedImage:NJTraduccion(@"MAILBUTTON") block:^(id sender) {
                        MFMailComposeViewController *mViewController = [[MFMailComposeViewController alloc] init];
                        mViewController.mailComposeDelegate = self;
                        [mViewController setSubject:NJTraduccion(@"GASTONTHEELECTRICIAN")];
                        [mViewController setMessageBody:NJTraduccion(@"EMAILMESSAGE") isHTML:NO];
                        [emailController presentModalViewController:mViewController animated:YES];
                    }];
                    mail.position = ccp(size.width/4+5, -160);
                    
                    shareMenu = [CCMenu menuWithItems:facebook, weibo, twitter, mail, nil];
                    [shareMenu setOpacity:0];
                    shareMenu.position = ccp(160,240);
                    
                    [self addChild:shareMenu z:0];
                    
                }
                [shareMenu runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.20],[CCFadeTo actionWithDuration:0.30 opacity:255], nil] ];
            }
            
        }
            break;
            
        case 3: //About
        {
            
            if(item.position.y == 10)
            {
                
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, -205)]];
                [tapadera runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.25],  [CCDelayTime actionWithDuration:.10], nil]];
                [scroll.sprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.15],  [CCDelayTime actionWithDuration:.10], nil]];
                [self removeChild:scroll cleanup:YES];
                [self removeChild:tapadera cleanup:YES];
                tapadera = nil;
            }
            else
            {
                if(tapadera == nil)
                {
                    scroll = [pgeScrollLayer scrollLayer];
                    scroll.opacity = 0;
                    [self addChild:scroll z:menu.zOrder-1];
                    
                    tapadera = [CCSprite spriteWithFile:NJTraduccion(@"TAPADERA")];
                    tapadera.opacity = 0;
                    [self addChild:tapadera z:menu.zOrder-1];
                    tapadera.position = ccp(size.width/2, 342);
                }
                
                [tapadera runAction:[CCFadeIn actionWithDuration:0.25]];
                [scroll.sprite runAction:[CCFadeIn actionWithDuration:0.25]];
                
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, 205)]];
            }
        }
            break;
            
        case 4: //How to play
        {
            if(item.position.y == 10)
            {
                
                [HTPscroll runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.15],  [CCDelayTime actionWithDuration:0.10], nil]];
                [HTPscroll.howtoPlay1 runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.25],  [CCDelayTime actionWithDuration:0.10], nil]];
                [HTPscroll.howtoPlay2 runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.25],  [CCDelayTime actionWithDuration:0.10], nil]];
                [HTPscroll.howtoPlay3 runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.25],  [CCDelayTime actionWithDuration:0.10], nil]];
                [self removeChild:HTPscroll cleanup:YES];
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, -160)]];
                HTPscroll = nil;
                
                
            }
            else
            {
                if(HTPscroll == nil)
                {
                    HTPscroll.tag = 1;
                    HTPscroll = [howToPlayScrollLayer scrollLayer];
                    HTPscroll.opacity = 0;
                    HTPscroll.howtoPlay1.opacity = 0;
                    HTPscroll.howtoPlay2.opacity = 0;
                    HTPscroll.howtoPlay3.opacity = 0;
                    [self addChild:HTPscroll z:menu.zOrder-1];
                }
                
                
                
                
                [HTPscroll.howtoPlay1 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.20],[CCFadeIn actionWithDuration:0.25], nil]];
                [HTPscroll.howtoPlay2 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.20],[CCFadeIn actionWithDuration:0.25], nil]];
                [HTPscroll.howtoPlay3 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.20],[CCFadeIn actionWithDuration:0.25], nil]];
                
                [item runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, 160)]];
            }
        }
            break;
            
    }
    
}

-(void) gameCenter
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
    
    GKAchievementViewController *achievementsViewController = [[GKAchievementViewController alloc] init];
    achievementsViewController.achievementDelegate = self;
    
    [emailController presentModalViewController:achievementsViewController animated:YES];
}

-(void) facebook
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        SLComposeViewController* facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookPostVC setInitialText:NJTraduccion(@"FACEBOOKMESSAGE")];
        [facebookPostVC addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id463358640"]];
        [emailController presentViewController:facebookPostVC animated:YES completion:^{
            if(SLComposeViewControllerResultDone)
            {
                if([[NJSettings sharedSettings] ads])
                {
                    [[NJSettings sharedSettings] saveFBAds:NO];
                }
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Facebook error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

-(void) sinaWeibo
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        SLComposeViewController* sinaWeiboPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [sinaWeiboPost setInitialText:NJTraduccion(@"SINAWEIBOMESSAGE")];
        [sinaWeiboPost addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id463358640"]];
        [emailController presentViewController:sinaWeiboPost animated:YES completion:^{
            if(SLComposeViewControllerResultDone)
            {
                if([[NJSettings sharedSettings] ads])
                {
                    [[NJSettings sharedSettings] saveAds:NO];
                }
            }
        }];
        
    }
    else
    {
        NSURL *url = [NSURL URLWithString:@"http://www.weibo.com"];
        
        if (![[UIApplication sharedApplication] openURL:url])
            
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
}

-(void) twitter
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        SLComposeViewController* twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterPost setInitialText:NJTraduccion(@"TWITTERMESSAGE")];
        [twitterPost addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id463358640"]];
        [emailController presentViewController:twitterPost animated:YES completion:^{
            if(SLComposeViewControllerResultDone)
            {
                if([[NJSettings sharedSettings] ads])
                {
                    [[NJSettings sharedSettings] saveTwitterAds:NO];
                }
            }
        } ];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:@"http://www.twitter.com"];
        
        if (![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}


//DELEGATES
//MAIL COMPOSER
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

//GAMECENTER
-(void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    [viewController dismissModalViewControllerAnimated:YES];
}

//ALERTVIEW
-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 123 )
    {
        if( buttonIndex == 1 )
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=588202293"]];
        }
    }
}
@end