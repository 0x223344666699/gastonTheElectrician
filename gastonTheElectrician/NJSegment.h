//
//  NJSegment.h
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 29/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NJPolvisi.h"

@class NJPoint;
@class NJPolygon;

@interface NJSegment : NSObject
{
    NJPoint *p1;
    NJPoint *p2;
}
+(NJSegment*)segmentWithP1:(NJPoint*)p1 P2:(NJPoint*)p2;

-(NJPoint*)p1;
-(NJPoint*)p2;
-(void)setP1:(NJPoint*)p;
-(void)setP2:(NJPoint*)p;
-(NSString*)toString;

-(float)funcionM:(float)m P:(float)p X:(float)x;
-(float)anguloCentro:(NJPoint*)centro vertice:(NJPoint*)vertice encima:(BOOL)encima;
-(BOOL)cortanA:(NJPoint*)a B:(NJPoint*)b;
-(NJPoint*)minA:(NJPoint*)a B:(NJPoint*)b;
-(NJPoint*)maxA:(NJPoint*)a B:(NJPoint*)b;
-(NJSegment*)jackpotToque:(NJPoint*)toque Poly:(NJPolygon*)poly Sommets:(NSMutableArray*)sommets ultVisto:(int)ultVisto sigVisto:(int)sigVisto primNoV:(int)primNoV ultNoV:(int)ultNoV;
-(NJSegment*) darSiguientePrimero:(NJPolygon*)primero segundo:(NJPolygon*)segundo;
-(BOOL)cortanDOSA:(NJPoint*)a B:(NJPoint*)b;
-(BOOL)cortanTRESA:(NJPoint*)a B:(NJPoint*)b;
@end
