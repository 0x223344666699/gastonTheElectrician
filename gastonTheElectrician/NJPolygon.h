//
//  NJPolygon.h
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 29/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NJPoint.h"

@class NJPoint;
@class CCTool;
@interface NJPolygon : NSObject
{
    NSMutableArray *sommets;
    NSMutableArray *nuevosVerts;
    BOOL usar, libre, unoauno;
}
@property (nonatomic) BOOL usar, libre, unoauno;
+(NJPolygon*) poligonoWithSommets:(NSMutableArray*) array;
+(NJPolygon*) poligono;

-(void)setSommets:(NSMutableArray*)array;
-(void)setNuevosVerts:(NSMutableArray*)array;
-(NSMutableArray*) sommets;
-(NSMutableArray*) nuevosVerts;
-(NSMutableArray*) CGPointSommets;
-(NSMutableArray*) polvisiToque:(NJPoint*)toque Tool:(CCTool*)tool;
+(NSMutableDictionary*) masterPolvisis:(NSMutableDictionary*)polvisis;
-(float) area;
@end
