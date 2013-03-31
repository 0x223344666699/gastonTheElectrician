//
//  NJPoint.h
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 29/11/12.
//
//

#import <Foundation/Foundation.h>
#import "NJPolygon.h"
#import "NJSegment.h"
#import "CCTool.h"

@class NJPolygon;
@class NJSegment;
@class CCTool;
@interface NJPoint : NSObject
{
    float x;
    float y;
    NSMutableArray* tags;
    BOOL ini;
    BOOL visi;
}

+(NJPoint*)pointWithX:(float)xCoord andY:(float)yCoord;
+(NJPoint*)pointWithX:(float)xCoord andY:(float)yCoord andVisi:(BOOL)visibilidad;
+(NJPoint*)pointWithNSValue:(NSValue*)point;
+(NJPoint*)pointFromString:(NSString*)point;
-(void)setX:(float)xCoord;
-(void)setY:(float)yCoord;
-(void)setTag:(int)tg;
-(void)setVisi:(BOOL)visibilidad;
-(void)setIni:(BOOL)init;

-(float)x;
-(float)y;
-(BOOL)visi;
-(BOOL)ini;
-(NSMutableArray*)tag;

-(CGPoint)CGPointValue;
-(NSString*)toString;
-(BOOL)isTagged:(int)tg;

-(BOOL)removeTag:(int)tg;
-(BOOL) visibilidadPunto:(NJPoint*)punto poligono:(NJPolygon*)polygon indice:(int)k;
-(float) distASegmentoA:(NJPoint*)A B:(NJPoint*)B;
-(BOOL)comprobarUltVisto:(NJPoint*)ultvisto Toque:(NJPoint*)toque sigVisto:(NJPoint*)sigvisto primNov:(NJPoint*)primnov ultNov:(NJPoint*)ultnov;
-(BOOL)comprobarRarosProl:(NJPoint*)prol Poly:(NJPolygon*)poly Pos:(int)pos;
-(BOOL)isOutToque:(NJPoint*)touch sommets:(NSMutableArray*)sommets;

-(NJPoint*) prolongarProl:(NJPoint*)prol Corte:(NJPoint*)corte Max:(NJPoint*)max;
-(NJPoint*) prolongarUltVisto:(NJPoint*)ultvisto sigVisto:(NJPoint*)sigvisto primNov:(NJPoint*)primnov ultNov:(NJPoint*)ultnov;

-(NSMutableArray*) actualizarSommets:(NSMutableArray*)puntos toque:(NJPoint*)toque ultVisto:(NJPoint*)ultVisto sigVisto:(NJPoint*)sigvisto primNoV:(NJPoint*)primnov ultNoV:(NJPoint*)ultNoV;
-(NSMutableArray*) insertPreSommets:(NSMutableArray*)puntos pre:(NJPoint*)pre;
-(NSMutableArray*) insertPostSommets:(NSMutableArray*)puntos post:(NJPoint*)post;
-(NSMutableArray*)girarVectorPrimero:(NSMutableArray*)primero segundo:(NSMutableArray*)segundo;
-(float)anguloHorizontalCentro:(NJPoint*)centro;
-(BOOL)perteneceA:(NJSegment*) actual;
-(BOOL)perteneceAPolygon:(NJPolygon*)poly;
-(NJPoint*)nextInPolygon:(NJPolygon*)poly;
-(BOOL)verificarMasterActual:(NJPolygon*)actual Centro:(NJPoint*)centro;
-(BOOL)perteneceAPolygonEnSegmentos:(NJPolygon *)poly;

-(BOOL)isEqualTo:(NJPoint*)punto;

@end
