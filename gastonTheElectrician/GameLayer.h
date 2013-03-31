//
//  GameLayer.h
//  Gaston
//
//  Created by Juan Jacobo Montero Muñoz on 02/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PRFilledPolygon.h"
#import "GameInterfaceLayer.h"
#import "NJPolvisi.h"
#import "ChooseLevelLayer.h"
dispatch_queue_t NJQueue;

@class NJPolygon;
int level;
int puntosGlobal;
@interface GameLayer : CCLayer {
    NSMutableArray* points;
    NSInteger numPoints;
    NSMutableArray* vectorDevectores;
    CCLayerColor* pauseLayer;
    CCLayerColor* polvisisLayer;
}
@property(nonatomic,strong) NSMutableArray* points;
@property(nonatomic) NSInteger numPoints;
@property(nonatomic, strong) CCLayerColor* polvisisLayer;

-(void)dibujaPolvisi:(CGPoint)toque Tool:(CCTool*)tool Refrescar:(BOOL)refrescar;
-(void)elCreaPuntos;
+(id)nodeWithLevel:(int)lvl;
-(id) initWithLevel:(int)lvl;
-(void)porcentajeAreaTotal;
@end
