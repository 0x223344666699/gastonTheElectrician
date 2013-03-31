//
//  pgeScrollLayer.h
//  Tankimals
//
//  Created by Lars Birkemose on 10/25/12.
//  Copyright 2012 Protec Electronics. All rights reserved.
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameInterfaceLayer.h"
//------------------------------------------------------------------------------

#define SCROLL_LAYER_HYSTERESIS1                             0.05f           // hysteresis for stopping automated movement
#define SCROLL_LAYER_TRIGGER1                                50

#define SCROLL_LAYER_DEFAULT_SPACING1                        320.0f          // spacing between lock positions
#define SCROLL_LAYER_DEFAULT_POSITIONS1                      3               // number of positions to lock onto
#define SCROLL_LAYER_SCROLL_FORCE1                           0.0f           // normalized force for how powerful scroll is
#define SCROLL_LAYER_MAGNETIC_FORCE1                         0.25f           // formalized force for how powerful magnetism is

#define SCROLL_LAYER_SCROLL_DECREASE1                        80.0f

//------------------------------------------------------------------------------

@interface NJLevelPages : CCLayerColor {
    // user scroll data
    float                   m_spacing;                      // spacing between scroll positions
    int                     m_positions;                    // number of scroll positions
    float                   m_scrollForce;                  // 0 = scroll will stop immediately. 1 = scroll will run forever
    float                   m_magneticForce;                // 0 = scroll will not be locked. 1 = scroll will be locked immediately
    // touch data
    float                   m_lastPosition;
    NSTimeInterval          m_lastTime;
    float                   m_scrollAmount;
    float                   m_lockPosition;
    CGPoint                 m_positionOffset;
    
    //me
}

//------------------------------------------------------------------------------

@property float spacing;
@property int positions;
@property float m_lockPosition;

//------------------------------------------------------------------------------

+( NJLevelPages* )pages;
-( NJLevelPages* )init;

//------------------------------------------------------------------------------

@end