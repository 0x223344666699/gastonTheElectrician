//
//  pgeScrollLayer.m
//  Tankimals
//
//  Created by Lars Birkemose on 10/25/12.
//  Copyright 2012 Protec Electronics. All rights reserved.
//
//------------------------------------------------------------------------------

#import "NJLevelPages.h"

//------------------------------------------------------------------------------

@implementation NJLevelPages

//------------------------------------------------------------------------------

@synthesize spacing = m_spacing;
@synthesize positions = m_positions;
@synthesize m_lockPosition;

//------------------------------------------------------------------------------

+( NJLevelPages* )pages {
    return( [ (NJLevelPages*)[self alloc ] init ] );
}

//------------------------------------------------------------------------------

-( NJLevelPages* )init {
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"tapOnButton.wav"];

    self = [ super init ];
    CCMenu *menu = [CCMenu menuWithArray:nil];
    NSString* imagen;
    BOOL enable;
    for(int i = 0; i < 5; i++) //creando levelChooser
    {
        for(int j = 0; j < 4; j++)
        {
            if(4*i+j > 0)
            {
                BOOL isLocked;
                isLocked = ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"completed%d",4*i+j]];
                if(isLocked)
                {
                    imagen = @"levelLOCKEDButton.png";
                    enable = NO;
                    
                }
                else
                {
                    imagen = [NSString stringWithFormat:@"level%dUNLOCKEDButton.png", 4*i+j+1];
                    enable = YES;
                }
                
            }
            else
            {
                imagen = @"level1UNLOCKEDButton.png";
                enable = YES;
            }
            
            CCMenuItemImage *chooseButton = [CCMenuItemImage itemWithNormalImage:imagen selectedImage:imagen block:^(id sender) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:(int)[(CCMenuItemImage*)sender tag]] withColor:ccBLACK]];
            }];
            [chooseButton setIsEnabled:enable];
            chooseButton.position = ccp(57 + 70*j, 330 - 70*i);
            chooseButton.tag = i*4+j;
            menu.position = ccp(0,0);
            [menu addChild:chooseButton];
        }
        for(int k = 0; k < 4; k++)
        {
                BOOL isLocked;
                isLocked = ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"completed%d",4*i+k+20]];
                if(isLocked)
                {
                    imagen = @"levelLOCKEDButton.png";
                    enable = NO;
                    
                }
                else
                {
                    imagen = [NSString stringWithFormat:@"level%dUNLOCKEDButton.png", 4*i+k+1];
                    enable = YES;
                }
            
            CCMenuItemImage *chooseButton = [CCMenuItemImage itemWithNormalImage:imagen selectedImage:imagen block:^(id sender) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];

                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:(int)[(CCMenuItemImage*)sender tag]] withColor:ccBLACK]];
            }];
            [chooseButton setIsEnabled:enable];
            chooseButton.position = ccp(377 + 70*k, 330 - 70*i);
            chooseButton.tag = i*4+k+20;
            menu.position = ccp(0,0);
            [menu addChild:chooseButton];
        }
        for(int h = 0; h < 4; h++)
        {
            BOOL isLocked;
            isLocked = ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"completed%d",4*i+h+40]];
            if(isLocked)
            {
                imagen = @"levelLOCKEDButton.png";
                enable = NO;
                
            }
            else
            {
                imagen = [NSString stringWithFormat:@"level%dUNLOCKEDButton.png", 4*i+h+1];
                enable = YES;
            }

            
            CCMenuItemImage *chooseButton = [CCMenuItemImage itemWithNormalImage:imagen selectedImage:imagen block:^(id sender) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"tapOnButton.wav"];
   [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameInterfaceLayer sceneWithLevel:(int)[(CCMenuItemImage*)sender tag]] withColor:ccBLACK]];
            }];
            [chooseButton setIsEnabled:enable];
            chooseButton.position = ccp(697 + 70*h, 330 - 70*i);
            chooseButton.tag = i*4+h+40;
            menu.position = ccp(0,0);
            [menu addChild:chooseButton];
        }
    }
    [self addChild:menu];
    // set scroll data to something meaningful
    m_spacing = SCROLL_LAYER_DEFAULT_SPACING1;
    m_positions = SCROLL_LAYER_DEFAULT_POSITIONS1;
    m_scrollForce = SCROLL_LAYER_SCROLL_FORCE1;
    m_magneticForce = SCROLL_LAYER_MAGNETIC_FORCE1;
    m_lockPosition = 0;
    
    // done
    return( self );
}

-( void )onEnter {
    [ super onEnter ];
    // enable touch handling
    [ [ [ CCDirector sharedDirector ] touchDispatcher ] addTargetedDelegate:self priority:1 swallowsTouches:YES ];
}

//------------------------------------------------------------------------------

-( void )onExit {
    // disable touch handling
    [ [ [ CCDirector sharedDirector ] touchDispatcher ] removeDelegate:self ];
    // remove schedulers
    [ self unscheduleAllSelectors ];
    //
    [ super onExit ];
}

//------------------------------------------------------------------------------
// touch handling
//------------------------------------------------------------------------------

-( BOOL )ccTouchBegan:( UITouch* )touch withEvent:( UIEvent* )event {
    // check if touch is for us
    CGPoint pos = [ [ CCDirector sharedDirector ] convertToGL:[ touch locationInView: [ touch view ] ] ];
    if ( CGRectContainsPoint( CGRectMake( m_positionOffset.x, m_positionOffset.y, self.contentSize.width, self.contentSize.height ), pos ) == NO ) return( NO );
    // save data
    m_lastPosition = pos.x;
    m_lastTime = event.timestamp;
    // stop any running scrolling
    [ self unschedule:@selector( scrollUpdate: ) ];
    // grab touch
    return( YES );
}

-( void )ccTouchMoved:( UITouch* )touch withEvent:( UIEvent* )event {
    CGPoint pos;
    float scroll, interval;
    
    // calculkate time interval and touch position
    interval = event.timestamp - m_lastTime;
    pos = [ [ CCDirector sharedDirector ] convertToGL:[ touch locationInView: [ touch view ] ] ];
    // calculate scroll amount and save positions
    scroll = m_lastPosition - pos.x;
    m_scrollAmount = scroll / interval;
    m_lastPosition = pos.x;
    // apply new position
    super.position = ccp( super.position.x - scroll, self.position.y );
}

-( void )ccTouchEnded:( UITouch* )touch withEvent:( UIEvent* )event {
    
    // [ self ccTouchMoved:touch withEvent:event ];
    
    // find out what to scroll against
    if ( fabs( m_scrollAmount ) <= SCROLL_LAYER_TRIGGER1 ) {
        // find nearest position to move towards
        m_lockPosition = - ( super.position.x - m_positionOffset.x ) / m_spacing;
        if ( ( m_lockPosition - ( int )m_lockPosition ) > 0.5 ) m_lockPosition += 1;
        m_lockPosition = ( int )m_lockPosition;
    }
    
    // scroll update
	[ self schedule:@selector( scrollUpdate: ) ];
}

-( void )scrollUpdate:( ccTime )dt {
    float magnetism;
    float timing;
    if ( fabs( m_scrollAmount ) > SCROLL_LAYER_TRIGGER1 ) {
        // find position to move towards
        m_lockPosition = ( int )( - ( super.position.x - m_positionOffset.x ) / m_spacing );
        if ( m_scrollAmount > 0 ) m_lockPosition += 1;
    }
    
    // clamp
    if ( m_lockPosition >= m_positions ) m_lockPosition = m_positions - 1;
    if ( m_lockPosition < 0 ) m_lockPosition = 0;
    
    // calculate magnetism
    magnetism = ( ( m_lockPosition * m_spacing ) + ( super.position.x - m_positionOffset.x ) ) * m_magneticForce;
    
    // only lock at end positions
    // if ( ( m_lockPosition != 0 ) && ( m_lockPosition != ( m_positions - 1 ) ) ) magnetism = 0;
    
    // calculate decrease in scroll
    timing = clampf( dt * SCROLL_LAYER_SCROLL_DECREASE1, 0, 1 );
    m_scrollAmount = m_scrollAmount - ( m_scrollAmount * ( 1.0f - m_scrollForce ) * timing );
    
    // move towards position
    super.position = ccp( super.position.x - ( m_scrollAmount + magnetism ), super.position.y );
    
    // check if no movement
    if ( ( fabs( magnetism ) + fabs( m_scrollAmount ) ) < SCROLL_LAYER_HYSTERESIS1 ) [ self unschedule:@selector( scrollUpdate: ) ];
}

//------------------------------------------------------------------------------
// properties
//
//- scrollForce ----------------------------------------------------------------

-( float )scrollForce { return( m_scrollForce ); }

-( void )setScrollForce:( float )scrollForce { m_scrollForce = clampf( scrollForce, 0.0f, 1.0f ); }

//- magneticForce --------------------------------------------------------------

-( float )magneticForce { return( m_magneticForce ); }

-( void )setMagneticForce:( float )magneticForce { m_magneticForce = clampf( magneticForce, 0.0f, 1.0f ); };

//- position -------------------------------------------------------------------

-( CGPoint )position { return( [ super position ] ); }

-( void )setPosition:(CGPoint)position {
    m_positionOffset = position;
    [ super setPosition:position ];
}

//------------------------------------------------------------------------------

@end