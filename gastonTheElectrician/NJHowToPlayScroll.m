//
//  pgeScrollLayer.m
//  Tankimals
//
//  Created by Lars Birkemose on 10/25/12.
//  Copyright 2012 Protec Electronics. All rights reserved.
//
//------------------------------------------------------------------------------

#import "NJHowToPlayScroll.h"

//------------------------------------------------------------------------------

@implementation howToPlayScrollLayer

//------------------------------------------------------------------------------

@synthesize spacing = m_spacing;
@synthesize positions = m_positions;
@synthesize howtoPlay1,howtoPlay2,howtoPlay3;
//------------------------------------------------------------------------------

+( howToPlayScrollLayer* )scrollLayer {
    return( [ (howToPlayScrollLayer*)[ self alloc ] init ] );
}

//------------------------------------------------------------------------------

-( howToPlayScrollLayer* )init {
    self = [ super init ];
    CGSize size = [[CCDirector sharedDirector] winSize];
    // initialize
    howtoPlay1 = [CCSprite spriteWithFile:@"howToPlay1.png"];
    howtoPlay2 = [CCSprite spriteWithFile:@"howToPlay1.png"];
    howtoPlay3 = [CCSprite spriteWithFile:@"howToPlay1.png"];
    
    howtoPlay1.position = ccp(size.width/2, size.height/4);
    howtoPlay2.position = ccp(3*size.width/2, size.height/4);
    howtoPlay3.position = ccp(5*size.width/2, size.height/4);
    
    [self addChild:howtoPlay1];
    [self addChild:howtoPlay2];
    [self addChild:howtoPlay3];
    
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