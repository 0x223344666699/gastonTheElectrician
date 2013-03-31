//
//  CCTool.m
//  Gaston
//
//  Created by Juan Jacobo Montero Muñoz on 03/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCTool.h"


@implementation CCTool
@synthesize initialPosition, positionChanged, pos;

-(BOOL)posInicial
{
    return (self.position.x == self.initialPosition.x && self.position.y == self.initialPosition.y);
}

@end
