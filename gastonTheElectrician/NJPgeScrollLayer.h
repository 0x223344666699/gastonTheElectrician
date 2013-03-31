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

//------------------------------------------------------------------------------

#define SCROLL_LAYER_HYSTERESIS                             0.01f           // hysteresis for stopping automated movement
#define SCROLL_LAYER_TRIGGER                                0

#define SCROLL_LAYER_DEFAULT_SPACING                        -240.0f          // spacing between lock positions
#define SCROLL_LAYER_DEFAULT_POSITIONS                      2               // number of positions to lock onto
#define SCROLL_LAYER_SCROLL_FORCE                           0.00005f           // normalized force for how powerful scroll is
#define SCROLL_LAYER_MAGNETIC_FORCE                         0.0015f           // formalized force for how powerful magnetism is

#define SCROLL_LAYER_SCROLL_DECREASE                        50.0f

//------------------------------------------------------------------------------

@interface pgeScrollLayer : CCLayerColor {
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
    CCSprite *sprite;
}

//------------------------------------------------------------------------------

@property float spacing;
@property int positions;
@property (strong)CCSprite *sprite;

//------------------------------------------------------------------------------

+( pgeScrollLayer* )scrollLayer;
-( pgeScrollLayer* )init;

//------------------------------------------------------------------------------

@end