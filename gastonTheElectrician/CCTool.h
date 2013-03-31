//
//  CCTool.h
//  Gaston
//
//  Created by Juan Jacobo Montero Muñoz on 03/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCTool : CCSprite {
    CGPoint initialPosition;
    CGPoint pos;
    BOOL positionChanged;
    
}
@property(nonatomic) CGPoint initialPosition;
@property(nonatomic) CGPoint pos;

@property(nonatomic) BOOL positionChanged;
-(BOOL)posInicial;
 @end
