//
//  GameInterfaceLayer.m
//  Gaston
//
//  Created by Juan Jacobo Montero Muñoz on 03/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameInterfaceLayer.h"
CGPoint punto1;
CGPoint punto2;
#define NJTraduccion(key) \
NSLocalizedString( (key), nil)
@implementation GameInterfaceLayer

+(CCScene*) sceneWithLevel:(int)lvl
{
    NJQueue = dispatch_queue_create("com.nachoJuan.Gaston", NULL);

    CGSize size = [[CCDirector sharedDirector] winSize];
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer nodeWithLevel:lvl];
	GameInterfaceLayer *interfaceLayer = [GameInterfaceLayer node];
    CCSprite *foreground = [CCSprite spriteWithFile:@"gameScreenForeground.png"];
    foreground.position = ccp(size.width/2,size.height/2);
    interfaceLayer.tag = 111;
    [interfaceLayer setGameLayer:layer];
    
	// add layer as a child to scene
    plus = 0;
    if(size.height > 480) plus = 44;
        layer.position = ccp(0, plus);
        interfaceLayer.position = ccp(0, plus);
    
	[scene addChild: layer];
	[scene addChild: interfaceLayer];
    [scene addChild: foreground];
	// return the scene
	return scene;
}

-(void) setGameLayer:(GameLayer*)gameL
{
    gameLayer = gameL;
}

-(id) init
{
    if(self = [super init])
    {
        [self scheduleUpdate];
if ( [[NJSettings sharedSettings] ads] )
{
    [[[RevMobAds session] fullscreenWithPlacementId:@"512b82ecc930a90c0000003b"] loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        fullscreenAd = fs;
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"%@",error);
        fullscreenAd = nil;
    }];
}
        pauseMenuLayer = [[PauseMenuLayer alloc] init];
        pauseMenuLayer.tag = 4;
        [self addChild:pauseMenuLayer];
        //init
        CGSize s = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        polygon = polyg;
        tools = [NSMutableArray array];
        usedTools = [NSMutableArray array];
        
        //background
        bottomBg = [CCSprite spriteWithFile:@"tabbarBackground.png"];
        bottomBg.position = ccp(s.width/2, 60/2);
        [self addChild:bottomBg];
        
        //largeBulb
        CCTool *largeBulb = [CCTool spriteWithFile:@"largeBulbSprite.png"];
        largeBulb.position = ccp(45,55/2);
        largeBulb.tag = 0;
        [tools addObject:largeBulb];
        [self addChild:largeBulb];
        
        //indicadorBombs
        largeBulbNumb = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",maxBulbs] fontName:@"Helvetica-Bold" fontSize:15];
        largeBulbNumb.color = ccc3(255, 96, 0);
        largeBulbNumb.position = ccp(65,18);
        [self addChild:largeBulbNumb];
        
        //switch
        CCMenuItemImage *switchOn = [CCMenuItemImage itemWithNormalImage:@"switchOn.png" selectedImage:@"switchOn.png" block:nil];
        CCMenuItemImage *switchOff = [CCMenuItemImage itemWithNormalImage:@"switchOff.png" selectedImage:@"switchOff.png" block:nil];
        
        ccSwitch = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects:switchOff, switchOn, nil] block:^(id sender) {
            if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];

            [self switchar];
        }];
        ccSwitch.position = ccp(290, 110);
        
        //hintButton
        NSString* hintButtonString = [NSString stringWithFormat:@"hintButton.png"];
        CCMenuItemImage *hintButton = [CCMenuItemImage itemWithNormalImage:hintButtonString selectedImage:hintButtonString block:^(id sender) {
            if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];

            if(level != 999)
        {
            if( !([[NJSettings sharedSettings] doIHaveKeys] > 0))
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NJTraduccion(@"UNLOCKALERTTITLE") message:NJTraduccion(@"UNLOCKALERTMESSAGE") delegate:self cancelButtonTitle:nil otherButtonTitles:@"5", @"12", NJTraduccion(@"UNLIMITED"), NJTraduccion(@"NONE"), nil];
                alertView.tag = 232323;
                [alertView show];
            }
            else if ( ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"completed%d", level+1]] )
            {
                [[NJSettings sharedSettings] updateKeys:-1];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"completed%d", level+1]];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NJTraduccion(@"UNLOCKEDALERTTITLE") message:[NSString stringWithFormat:NJTraduccion(@"UNLOCKEDALERTMESSAGE"),level+2] delegate:self cancelButtonTitle:NJTraduccion(@"CONTINUE") otherButtonTitles: nil];
                alert.tag = 1111;
                [alert show];
                //Parse
                PFQuery *query = [PFQuery queryWithClassName:@"visitas"];
                [query whereKey:@"ID" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                 {
                     if(objects.count != 0)
                     {
                         PFObject *user = objects[0];
                         [user incrementKey:@"haveUsedUnlocker"];
                         [user saveInBackground];
                     }
                 }];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:NJTraduccion(@"UNLOCKERRORALERTMESSAGE"),level+2] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }

        }
    }];
        hintButton.position = ccp(240,453);
        
        if(level != 999)
        {
            //powerIndicator
            int power = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"powerLevel%d",level+1]];
            for(int i = 0; i < power; i++)
            {
                if( power == 0 )
                    break;
                else
                {
                    CCSprite* lightning = [CCSprite spriteWithFile:@"lightning.png"];
                    lightning.position = ccp(173 + 13*i, 450);
                    [self addChild:lightning];
                }
            }
            
            //score
            CCLabelTTF *textLabel = [CCLabelTTF labelWithString:NJTraduccion(@"SCORE") fontName:@"Helvetica-Bold" fontSize:10];
            textLabel.position = ccp(30,465);
            textLabel.color = ccc3(255, 96, 0);
            [self addChild:textLabel];
            
            CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d%c",[[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"puntosLevel%d",level+1]], 37] fontName:@"Helvetica-Bold" fontSize:24];
            scoreLabel.position = ccp(35,448);
            scoreLabel.color = ccc3(255, 246, 196);
            [self addChild:scoreLabel];
        }
        
        
        //pauseButton
        NSString* pauseButtonString = [NSString stringWithFormat:@"pauseButton.png"];
        if(level == 999) pauseButtonString = [NSString stringWithFormat:@"darkPauseButton.png"];
        CCMenuItemImage *pauseButton = [CCMenuItemImage itemWithNormalImage:pauseButtonString selectedImage:pauseButtonString block:^(id sender) {
            [self pauseMenu:0 porcentaje:0];
            if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];

        }];
        pauseButton.position = ccp(290,453);
        
        //menu
        CCMenu *menu = [CCMenu menuWithItems:pauseButton, hintButton, ccSwitch, nil];
        menu.position = ccp(0,0);
        menu.tag = 345;
        [self addChild:menu];
        //fin Init
    }
    return self;
}

/*
-(void)draw
 {
 #ifndef NDEBUG
 ccDrawColor4F(255, 255, 255, 255);
 ccPointSize(5);
     ccDrawLine(punto1, punto2);
// for(int i = 0; i < 7; i++)
// {
// ccDrawLine(ccp(50*i, 0), ccp(50*i, 480));
// }
// 
// for(int j = 0; j < 10; j++)
// {
// ccDrawLine(ccp(0, 50*j), ccp(320, 50*j));
// 
// }
for(NJPoint* punto in polyg)
 {
 if([punto visi] == YES)
 {
 if( [punto isTagged:2])
 {
 ccDrawColor4B(255, 0, 0, 255);
 }
 else
 {
 ccDrawColor4B(0, 255, 0, 255);
 }
 }
 else
 {
 ccDrawColor4F(255, 255, 255, 255);
 
 }
 ccDrawPoint(ccp([punto x], [punto y]));
 }
 
 #endif

 }
*/

-(void) makeTransition:(id)sender
{
    if(productRequest)
        [productRequest cancel];
    if(sender)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[ChooseLevelLayer scene] withColor:ccBLACK]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:level] withColor:ccBLACK]];
    }
}

-(void) pauseMenu:(int)menu porcentaje:(float)percent
{
    self.isTouchEnabled = NO;
    ((CCMenu*) [self getChildByTag:345]).enabled = NO;
    
   
    
    //bringing it to the front
    [self reorderChild:pauseMenuLayer z:10000];
    
    
    switch (menu) {
        case 0: //Pause
            NSLog(@"Pause");
            [pauseMenuLayer displayMenu:menu];
            
            break;
        case 1://Fin A
        {
            NSLog(@"A -> %.2f",percent);
            [pauseMenuLayer displayMenu:menu];
        }
            break;
        case 2://Fin B
        {
            NSLog(@"B -> %.2f",percent);
            [pauseMenuLayer displayMenu:menu];
            
        }
            break;
        case 3://Fin C
        {
            NSLog(@"C -> %.2f",percent);
            [pauseMenuLayer displayMenu:menu];
            
        }
            break;
        case 4://Fin FAIL
        {
            NSLog(@"FAIL -> %.2f",percent);
            [pauseMenuLayer displayMenu:menu];
        }
            break;
            
        default:
            break;
    }
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //init
    UITouch *touch = [touches anyObject];
    CGPoint touchLoc = [touch locationInView: [touch view]];
    touchLoc = [[CCDirector sharedDirector] convertToGL:touchLoc];
    
    //if iPhone5
    touchLoc = ccp(touchLoc.x, touchLoc.y - plus);
    
    
    if( CGRectContainsPoint(bottomBg.boundingBox, touchLoc) )
    {
        for( CCTool* tool in tools )
        {
            if ( CGRectContainsPoint(tool.boundingBox, touchLoc) && maxBulbs != 0)
            {
                if(ccSwitch.selectedIndex != 0)
                {
                    [ccSwitch setSelectedIndex:0];
                    [self switchar];
                }
                if(level != 999) tocado = [CCTool spriteWithFile:@"largeUsedBulbOFF.png"]; else tocado = [CCTool spriteWithFile:@"largeUsedBulb.png"];
                tocado.position = ccp(touchLoc.x, touchLoc.y);
                tocado.tag = ((CCTool*)[usedTools lastObject]).tag +1;
                [tocado setPositionChanged:NO];
                [self addChild:tocado];
                break;
            }
        }
    }
    
    for( CCTool * tool in usedTools )
    {
        if( CGRectContainsPoint(tool.boundingBox, touchLoc) )
        {
            tocado = tool;
            [gameLayer.polvisisLayer removeChildByTag:tocado.tag cleanup:YES];
            
            [tocado setPositionChanged:NO];
            mov = YES;
            break;
        }
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //init
    UITouch *touch = [touches anyObject];
    CGPoint touchLoc = [touch locationInView: [touch view]];
    touchLoc = [[CCDirector sharedDirector] convertToGL:touchLoc];
    
    //if iPhone5
    touchLoc = ccp(touchLoc.x, touchLoc.y - plus);

    
    //updatePos
    if( tocado )
    {
        [tocado setPosition:touchLoc];
        [tocado setPositionChanged:YES];
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];

    //init
    UITouch *touch = [touches anyObject];
    CGPoint touchLoc = [touch locationInView: [touch view]];
    touchLoc = [[CCDirector sharedDirector] convertToGL:touchLoc];
    
    //if iPhone5
    touchLoc = ccp(touchLoc.x, touchLoc.y - plus);

    
    //Dentro o Fuera??
    NJPoint *punto = [NJPoint pointWithX:touchLoc.x andY:touchLoc.y];
    NJPoint *inf = [NJPoint pointWithX:9999 andY:touchLoc.y];
    
    
    punto1 = touchLoc;
    punto2 = ccp(999, touchLoc.y);
    
    
    
    NJSegment *segmento = [NJSegment segmentWithP1:punto P2:inf];
    
    int length = (int)[polyg count];
    int cuentaCortes = 0;
    //CuentaCortes
    for(int i = 0; i < length; i++)
    {
        if(i < length - 1)
        {
            if([segmento cortanTRESA:polyg[i] B:polyg[i + 1]] && [punto distASegmentoA:polyg[i] B:polyg[i+1]] > 0.1)
                cuentaCortes++;
        }
        else
        {
            if([segmento cortanTRESA:polyg[i] B:polyg[0]] && [punto distASegmentoA:polyg[i] B:polyg[0]] > 0.1)
                cuentaCortes++;
        }
    }
    NSLog(@"cuenta: %d",cuentaCortes);
    if( cuentaCortes % 2 == 0 || [punto perteneceAPolygonEnSegmentos:[NJPolygon poligonoWithSommets:polyg]] || tocado.positionChanged == NO )
    {
        if( level != 999)
        {
            if( tocado )
            {
                [tocado runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3 position:ccp(45,55/2)], [CCDelayTime actionWithDuration:.05],[CCCallFuncND actionWithTarget:tocado selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
            }
            if( [usedTools indexOfObject:tocado] < 1000 )
            {
                [usedTools removeObject:tocado];
                [polvisacos setValue:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%d", tocado.tag - 1]];
                NSLog(@"Tag eliminado: %d", tocado.tag - 1);
                maxBulbs++;
            }
        }
        else if( level == 999)
        {
            if( tocado )
            {
                [tocado runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3 position:ccp(45,55/2)], [CCDelayTime actionWithDuration:.05],[CCCallFuncND actionWithTarget:tocado selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
            }
            if( [usedTools indexOfObject:tocado] < 1000 )
            {
                [usedTools removeObject:tocado];
                [polvisacos removeObjectForKey:[NSString stringWithFormat:@"%d", tocado.tag - 1]];
            }
            for (CCTool* tool in usedTools)
            {
                [tool runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3 position:ccp(45,55/2)], [CCDelayTime actionWithDuration:.05],[CCCallFuncND actionWithTarget:tool selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
                [gameLayer.polvisisLayer removeChildByTag:tool.tag cleanup:YES];
            }
            usedTools = [[NSMutableArray alloc] init];
        }
    }
    else
    {
        bool ref = NO;
        if ( mov )
        {
            ref = YES;
        }
        [gameLayer dibujaPolvisi:tocado.position Tool:tocado Refrescar:ref];
        if([usedTools indexOfObject:tocado] > 100000)
        {
            [usedTools addObject:tocado];
            maxBulbs--;
        }
    }
    
    //tocado -> nil
    if( tocado )
        tocado = nil;
    
    mov = NO;
}

-(void)luces
{
    if(!switchPosition)
    {
        NSArray *temp = [NSArray arrayWithArray:usedTools];
        for( CCTool *tool in temp )
        {
            CCTool* lightsOn = [CCTool spriteWithFile:@"largeUsedBulb.png"];
            lightsOn.position = tool.position;
            lightsOn.tag = tool.tag;
            lightsOn.zOrder = 3;
            [usedTools replaceObjectAtIndex:[usedTools indexOfObject:tool] withObject:lightsOn];
            [self addChild:lightsOn];
            [lightsOn runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.2], [CCCallFuncND actionWithTarget:tool selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        }
        if(level != 999)[gameLayer addChild:gameLayer.polvisisLayer z:1];

        switchPosition = YES;
    }
    else
    {
        NSArray *temp = [NSArray arrayWithArray:usedTools];
        for( CCTool *tool in temp )
        {
            CCTool* lightsOff = [CCTool spriteWithFile:@"largeUsedBulbOFF.png"];
            lightsOff.position = tool.position;
            [usedTools replaceObjectAtIndex:[usedTools indexOfObject:tool] withObject:lightsOff];
            [tool runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.2], nil]];
            lightsOff.tag = tool.tag;
            [self addChild:lightsOff z:tool.zOrder-1];
        }
        if(level != 999)[gameLayer removeChild:gameLayer.polvisisLayer cleanup:YES];
        
        switchPosition = NO;
    }
}

-(void) switchar
{
    if(!switchPosition)
        dispatch_async(NJQueue, ^{
            //[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0f],[CCCallFunc actionWithTarget:gameLayer selector:@selector(porcentajeAreaTotal)], nil]];
            [gameLayer porcentajeAreaTotal];

        });
    
    [self runAction:[CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(luces)], [CCDelayTime actionWithDuration:.2f],[CCCallFunc actionWithTarget:self selector:@selector(luces)], [CCDelayTime actionWithDuration:.2f], [CCCallFunc actionWithTarget:self selector:@selector(luces)], nil]];
}

-(void)update:(ccTime)delta
{
    [largeBulbNumb setString:[NSString stringWithFormat:@"%d",maxBulbs]];
}
//Inapp
#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NJTraduccion(@"SUCCESSALERTVIEWTITLE") message:NJTraduccion(@"SUCCESSALERTVIEWMESSAGE") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                [[NJSettings sharedSettings] updateKeys:boughtKeys];
                boughtKeys = 0;
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

- (void)comprarUnlocker
{
    if([NJSettings sharedSettings].skProductLevels5 && boughtKeys==5)
    {
        // Añadimos el producto que recibimos en el método delegado productsRequest:didReceiveResponse:
        SKPayment *pago = [SKPayment paymentWithProduct:[NJSettings sharedSettings].skProductLevels5];
        // Nos añadimos a nosotros mismos como observadores de la transacción.
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:pago];
    }
    else   if([NJSettings sharedSettings].skProductLevels12 && boughtKeys==12)
    {
        // Añadimos el producto que recibimos en el método delegado productsRequest:didReceiveResponse:
        SKPayment *pago = [SKPayment paymentWithProduct:[NJSettings sharedSettings].skProductLevels12];
        // Nos añadimos a nosotros mismos como observadores de la transacción.
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:pago];
    }
    else    if([NJSettings sharedSettings].skProductLevelsINF && boughtKeys==9999)
    {
        // Añadimos el producto que recibimos en el método delegado productsRequest:didReceiveResponse:
        SKPayment *pago = [SKPayment paymentWithProduct:[NJSettings sharedSettings].skProductLevels12];
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

//DELEGATES
-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( alertView.tag == 232323 ) //alert Elegir keys
    {
        switch (buttonIndex)
        {
            case 0:
            {
                boughtKeys = 5;
                break;
            }
            case 1:
            {
                boughtKeys = 12;
                break;
            }
            case 2:
            {
                boughtKeys = 9999;
                break;
            }
        }
    }
    else if ( alertView.tag == 1111 )//alert unlocked
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:level+1] withColor:ccBLACK]];//pasar a nivel+1
    }
}
////INAPP
//-(void)productsRequest:(SKProductsRequest *)reqest didReceiveResponse:(SKProductsResponse *)response
//{
//    NSArray *misProductos = response.products;
//    
//    NSLog(@"Número de productos devueltos: %i", misProductos.count);
//    if (misProductos.count > 0)
//    {
//        unlockLevels = [misProductos objectAtIndex:0];
//        [self comprarUnlocker];
//
//    }
//    else{
//        NSLog(@"Productos no disponibles");
//    }
//    
//}
//
//-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alertView show];
//    NSLog(@"Error al conectar a la AppStore para las In-App Purchase: %@", error);
//}

@end
