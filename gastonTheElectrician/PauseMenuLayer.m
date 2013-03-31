//
//  PauseMenuLayer.m
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 31/01/13.
//
//

#import "PauseMenuLayer.h"
#define NJTraduccion(key) \
NSLocalizedString( (key), nil)

@implementation PauseMenuLayer

-(id) init
{
    if(self = [super init])
    {
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"tapOnButton.wav"];
        
                
        //mailIniti
        emailController = [[UIViewController alloc] init];
        [[[CCDirector sharedDirector] view] addSubview:emailController.view];
        
        //init
        CGSize s = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
        bg.tag = 5;
        [self addChild:bg];
        
        //restartButton
        restartButton = [CCMenuItemImage itemWithNormalImage:@"restartButton.png" selectedImage:@"restartButton.png" block:^(id sender) {
            [self makeTransition:nil];
            
        }];
        restartButton.tag = 1;
        restartButton.position = ccp(s.width/2 + 70, 530);
        
        //exitButton
        exitButton = [CCMenuItemImage itemWithNormalImage:@"closeButton.png" selectedImage:@"closeButton.png" block:^(id sender) {
            
            if( level != 999)
            {
                [self makeTransition:sender];
            }
            else
            {
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[ChooseGameModeLayer scene] withColor:ccBLACK]];
            }
            
        }];
        exitButton.position = ccp(s.width/2 - 70, 530);
        exitButton.tag = 2;
        
        //Ads display
        if( [[NJSettings sharedSettings] ads] )
        {
            chooseAd = random()%2;
            NSString *adString;
            if(chooseAd) adString = @"pixelAds.png"; else adString = NJTraduccion(@"REMOVEADS");
            adMenu = [CCMenu menuWithItems:[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:adString] selectedSprite:[CCSprite spriteWithFile:adString] target:self selector:@selector(adsResponse)], nil];
            adMenu.position = ccp(-160,240);
            [self addChild:adMenu];
        }
        
        
        //ganarOperderDisplay
        CGSize maxSize = { 2000, 2000 };
        
        // Set the font size for the label text
        float fontSize = 30;
        
        // Create the text
        NSString *text1 = NJTraduccion(@"TEXT1");
        
        // Based on the text font type, font size and line break mode
        // find the actual width and height needed for our text (text1).
        CGSize actualSize = [text1 sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize+5]
                              constrainedToSize:maxSize
                                  lineBreakMode:UILineBreakModeWordWrap];
        
        // Use the actual width and height needed for our text to create a container
        CGSize containerSize = {actualSize.width, actualSize.height};
        
        // Create the label with our text (text1) and the container we created
        titleWL = [CCLabelTTF labelWithString:text1 dimensions:containerSize hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap fontName:@"Helvetica-Bold" fontSize:fontSize];
        titleWL.position = ccp(160, 292);
        titleWL.color = ccc3(255, 246, 196);
        titleWL.opacity = 0;
        [self addChild:titleWL];
        
        text1 = NJTraduccion(@"TEXT2");
        subtitleWL = [CCLabelTTF labelWithString:text1 dimensions:containerSize hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeCharacterWrap fontName:@"Helvetica-Bold" fontSize:fontSize];
        subtitleWL.position = ccp(160, 168);
        subtitleWL.color = ccc3(255, 246, 196);
        subtitleWL.opacity = 0;
        [self addChild:subtitleWL];
        
        scoreWL = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:55];
        scoreWL.position = ccp(160,234);
        scoreWL.color = ccc3(255, 96, 0);
        scoreWL.opacity = 0;
        [self addChild:scoreWL];
        
        //sharePause
        share2Menu = [CCMenu menuWithItems:[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"twitterBird.png"] selectedSprite:[CCSprite spriteWithFile:@"twitterBird.png"] block:^(id sender) {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
            {
                SLComposeViewController* twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [twitterPost setInitialText:[NSString stringWithFormat:NJTraduccion(@"TWITTERSHARETEXT"),shareText]];
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
        }],[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"fLogo.png"] selectedSprite:[CCSprite spriteWithFile:@"fLogo.png"] block:^(id sender) {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
            {
                SLComposeViewController* facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [facebookPostVC setInitialText:shareText];
                [facebookPostVC addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id463358640"]];
                [emailController presentViewController:facebookPostVC animated:YES completion:^{
                    if(SLComposeViewControllerResultDone)
                    {
                        if([[NJSettings sharedSettings] ads])
                        {
                            [[NJSettings sharedSettings] saveFBAds:NO];
                        }
                    }
                }];
            }
        }], nil];
        share2Menu.position = ccp (-160,55);
        [share2Menu alignItemsHorizontally];
        [self addChild:share2Menu];
        
        //playButton
        playButton = [CCMenuItemImage itemWithNormalImage:@"unPauseButton.png" selectedImage:@"unPauseButton.png" block:^(id sender) {
            //[self displayMenu:-1];
            [self playButtonFunction];
        }];
        playButton.position = ccp(s.width/2, 530);
        playButton.tag = 3;
        
        //pauseMenuBg
        pauseMenuBg = [CCSprite spriteWithFile:@"pauseMenuBg.png"];
        pauseMenuBg.position = ccp(s.width/2, 530);
        [self addChild:pauseMenuBg];
        pauseMenuBg.tag = 4;
        
        //pauseMenu
        pauseMenu = [CCMenu menuWithItems:exitButton,restartButton, playButton, nil];
        pauseMenu.position = ccp(0,0);
        pauseMenu.tag = 6;
        [self addChild:pauseMenu];
    }
    return self;
}

-(void)playButtonFunction
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
    
    if(fullscreenAd)
    {
        [fullscreenAd showAd];
    }
    if( whichMenu == 1)//ganar con +87
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:level+1] withColor:ccBLACK]];//pasar a nivel+1
    }
    else if( whichMenu == 2)//ganar con +70
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:level+1] withColor:ccBLACK]];//pasar a nivel+1
    }
    else if( whichMenu == 3)//ganar con +60
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:level+1] withColor:ccBLACK]];//pasar a nivel+1
    }
    else if( whichMenu == 4)//perder con -60
    {
        [self makeTransition:nil]; //reiniciar nivel
    }
    else //pausa
    {
        [self displayMenu:whichMenu];
    }
    
}

-(void)adsResponse
{
    if(!chooseAd)
    {
        [self comprarNoAds];
    }
    else
    {
        NSString *iTunesLink = @"https://itunes.apple.com/app/pixelated-color-puzzle/id463358640?mt=8";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

-(void)displayMenu:(int)menu
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    [scoreWL setString:[NSString stringWithFormat:@"%d%c",puntosGlobal,37]];
    if(puntosGlobal<60)
    {
        [subtitleWL setString:NJTraduccion(@"SUBTITLELOSS")];
        shareText = [NSString stringWithFormat:NJTraduccion(@"SHARELOSS")];
        
    }
    else
    {
        [subtitleWL setString:[NSString stringWithFormat:NJTraduccion(@"SUBTITLEWIN")]];
        if(level != 999)shareText = [NSString stringWithFormat:NJTraduccion(@"SHAREWIN"),puntosGlobal,37,level+1]; else shareText = [NSString stringWithFormat:NJTraduccion(@"SHARE999WIN"),puntosGlobal,37];
    }
    if( ((CCLayerColor*)[self getChildByTag:5]).opacity != 160 )
    {
        whichMenu = menu;
        [[self getChildByTag:5] runAction:[CCFadeTo actionWithDuration:0.25 opacity:160]];
        if(menu == 0)
        {
            [adMenu runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(160, 240)]];
            [share2Menu runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(160, 55)]];
            shareText = [NSString stringWithFormat:NJTraduccion(@"SHAREPAUSE")];
        }
        else
        {
            [titleWL runAction:[CCFadeTo actionWithDuration:0.30 opacity:255]];
            [subtitleWL runAction:[CCFadeTo actionWithDuration:0.30 opacity:255]];
            [scoreWL runAction:[CCFadeTo actionWithDuration:0.30 opacity:255]];
            [share2Menu runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(160, 55)]];
            //Parse
            PFQuery *query = [PFQuery queryWithClassName:@"level"];
            [query whereKey:@"level" equalTo:[NSNumber numberWithInt:level+1]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if( objects.count != 0 )
                {
                    PFObject *level = objects[0];
                    [level incrementKey:@"times"];
                    if([[level objectForKey:@"score"] intValue] < puntosGlobal)
                    {
                        [level setObject:[NSNumber numberWithInt:puntosGlobal] forKey:@"score"];
                    }
                    if (puntosGlobal > 60)
                    {
                        [level incrementKey:@"wins"];
                    }
                    [level saveInBackground];
                }
            }];
            
            
        }
        [pauseMenuBg runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(s.width/2, 430)]];
        [pauseMenu runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, -100)]];
    }
    else
        
    {
        [[self getChildByTag:5] runAction:[CCFadeTo actionWithDuration:0.25 opacity:0]];
        if(menu == 0)
        {
            [adMenu runAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:0.25 position:ccp(480, 240)] two:[CCCallFuncND actionWithTarget:self selector:@selector(reiniciarAds) data:nil] ]];
            [share2Menu runAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:0.25 position:ccp(480, 55)] two:[CCCallFuncND actionWithTarget:self selector:@selector(reiniciarAds) data:nil] ]];
            
        }
        else
        {
            [titleWL runAction:[CCFadeTo actionWithDuration:0.15 opacity:0]];
            [subtitleWL runAction:[CCFadeTo actionWithDuration:0.15 opacity:0]];
            [scoreWL runAction:[CCFadeTo actionWithDuration:0.15 opacity:0]];
            [share2Menu runAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:0.25 position:ccp(480, 55)] two:[CCCallFuncND actionWithTarget:self selector:@selector(reiniciarAds) data:nil] ]];
            
        }
        [pauseMenuBg runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(s.width/2, 574)]];
        [pauseMenu runAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0, 100 + plus)]];
        ((CCLayer*)(self.parent)).isTouchEnabled = YES;
        ((CCMenu*) [self.parent getChildByTag:345]).enabled = YES;
    }
}

-(void)reiniciarAds
{
    adMenu.position = ccp(-160,240);
    share2Menu.position = ccp(-160,55);
}

-(void)makeTransition:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
    
    
    if(sender)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[ChooseLevelLayer scene] withColor:ccBLACK]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:level] withColor:ccBLACK]];
    }
}

-(BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView:touch.view]];
    CGRect myRect = CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
    
    return CGRectContainsPoint(myRect, location);
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([self containsTouchLocation:touch]) {
		return YES;
	}
	return NO;
}

#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                [[NJSettings sharedSettings] saveAds:NO];
                [adMenu removeFromParentAndCleanup:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"The ads were successfully removed! Thank you for your support." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                //Parse
                PFQuery *query = [PFQuery queryWithClassName:@"visitas"];
                [query whereKey:@"ID" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if(objects.count != 0)
                    {
                        PFObject *user = objects[0];
                        [user setObject:[NSNumber numberWithBool:YES] forKey:@"haveBoughtAds"];
                        [user saveInBackground];
                    }
                }];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
            }
                
                
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:transaction.error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                    NSLog(@"Error en la transacción: %@", transaction.error.localizedDescription);
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
        }
    }
}

- (void)comprarNoAds
{
    if( [NJSettings sharedSettings].skProductNoAds )
    {
        // Añadimos el producto que recibimos en el método delegado productsRequest:didReceiveResponse:
        SKPayment *pago = [SKPayment paymentWithProduct:[NJSettings sharedSettings].skProductNoAds];
        // Nos añadimos a nosotros mismos como observadores de la transacción.
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:pago];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NJTraduccion(@"ERROR") message:NJTraduccion(@"REACHSTORE") delegate:nil cancelButtonTitle:NJTraduccion(@"OK") otherButtonTitles: nil];
        [alert show];
    }
}

//DELEGATES ********************************
//UIVIEWCONTROLLER
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

////INAPP
//-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
//{
//    NSArray *misProductos = response.products;
//    
//    NSLog(@"Número de productos devueltos: %i", misProductos.count);
//    
//    if (misProductos.count > 0)
//    {
//        [NJSettings sharedSettings].skProductNoAds = [misProductos objectAtIndex:0];
//    }
//    else{
//        NSLog(@"Productos no disponibles");
//    }
//}
//
//-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alertView show];
//    NSLog(@"Error al conectar a la AppStore para las In-App Purchase: %@", error);
//}


@end
