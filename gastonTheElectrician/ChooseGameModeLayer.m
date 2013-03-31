//
//  ChooseGameModeLayer.m
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 27/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseGameModeLayer.h"
#define NJTraduccion(key) \
NSLocalizedString( (key), nil)
@implementation ChooseGameModeLayer

+(CCScene *) scene
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    plus = 0;
    if ( size.height > 480) plus = 44;

	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseGameModeLayer *layer = [ChooseGameModeLayer node];
    layer.position = ccp( 0, plus );

	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init
{
	self = [super init];
	if (self)
	{
       
        
        //background
        CCSprite *bg = [CCSprite spriteWithFile:NJTraduccion(@"BGLEVELS") rect:CGRectMake(0, 0, 320, 480)];
        bg.position = ccp(160, 240);
        [self addChild:bg z:0 tag:0];
        
        CCMenu *chooseGameModeMenu;
        
        CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"MAINMENUBUTTON") selectedImage:NJTraduccion(@"MAINMENUBUTTON") block:^(id sender) {
            [self makeTransition:sender];
        }];
        back.tag = 1;
        back.position = ccp(255, 380);
        
        //careerModeButton
        CCMenuItemImage *careerButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"CAREERMODEBUTTON") selectedImage:NJTraduccion(@"CAREERMODEBUTTON") block:^(id sender) {
            [self makeTransition:sender];
        }];
        careerButton.position = ccp(160, 300);
        
        //insaneModeButton
        CCMenuItemImage *insaneButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"INSANEMODEBUTTON") selectedImage:NJTraduccion(@"INSANEMODEBUTTON") block:^(id sender) {
            //[self makeTransition:sender];
            
            //COOOOMING SOOOOON!
        }];
        insaneButton.position = ccp(160, 200);
        
        //third
        CCMenuItemImage *thirdButton = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"DARKNESSMODEBUTTON") selectedImage:NJTraduccion(@"DARKNESSMODEBUTTON") block:^(id sender) {
            [self makeTransition:sender];
        }];
        thirdButton.position = ccp(160, 100);
        thirdButton.tag = 3;
        chooseGameModeMenu = [CCMenu menuWithItems:back, careerButton, insaneButton, thirdButton, nil];
        chooseGameModeMenu.position = ccp ( 0, 0 );
        [self addChild:chooseGameModeMenu];

	}
	return self;
}

-(void)makeTransition:(id)sender
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];

    if ( [(CCMenuItemImage*)sender tag] == 3)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:999] withColor:ccBLACK]];
    }
    else if ([(CCMenuItemImage*)sender tag] != 1)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[ChooseLevelLayer scene] withColor:ccBLACK]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[IntroLayer scene] withColor:ccBLACK]];

    }

}

@end
