//
//  ChooseLevelLayer.m
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 06/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseLevelLayer.h"
#define NJTraduccion(key) \
NSLocalizedString( (key), nil)

@implementation ChooseLevelLayer

+(CCScene *) scene
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    plus = 0;
    if ( size.height > 480) plus = 44;
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseLevelLayer *layer = [ChooseLevelLayer node];
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
        [self scheduleUpdate];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite* background = [CCSprite spriteWithFile:NJTraduccion(@"BGLEVELS")];
        background.position = ccp(160, 240);
        
        [self addChild:background];
        
        CCMenu *menu = [CCMenu menuWithArray:nil];
        menu.position = ccp(0, 0);
        
        CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:NJTraduccion(@"CHOOSEMODEBUTTON") selectedImage:NJTraduccion(@"CHOOSEMODEBUTTON") block:^(id sender) {
            [self makeTransition:sender];
        }];
        back.position = ccp(255, 380);
        [menu addChild:back];
        puntitos = [CCSprite spriteWithFile:[NSString stringWithFormat:@"puntosPag%d.png",1]];
        puntitos.position = ccp(size.width/2, 10);
        [self addChild:puntitos];
            levelChooserPages = [NJLevelPages pages];
            levelChooserPages.opacity = 0;
        
            levelChooserPages.position = ccp(0, 0);
            [self addChild:levelChooserPages];
        [self addChild:menu];

	}
	return self;
}

-(void) makeTransition:(id)sender
{
    if([[NJSettings sharedSettings] audioSFX])    [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];

        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[ChooseGameModeLayer scene] withColor:ccBLACK]];
}

-(void) cleanup
{
	[super cleanup];

	// any cleanup code goes here
	
	// specifically release/nil any references that could cause retain cycles
	// since dealloc might not be called if this class retains another node that is
   // either a sibling or in a different branch of the node hierarchy
}

-(void)update:(ccTime)delta
{
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"puntosPag%d.png",(int)levelChooserPages.m_lockPosition+1]];
    [puntitos setTexture: tex];
    
}

@end
