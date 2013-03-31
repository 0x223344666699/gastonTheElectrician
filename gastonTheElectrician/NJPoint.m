//
//  NJPoint.m
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 29/11/12.
//
//

#import "NJPoint.h"

@implementation NJPoint
//Constructor
+(NJPoint*)pointWithX:(float)xCoord andY:(float)yCoord
{
    NJPoint* punto = [[NJPoint alloc] init];
    
    [punto setX:xCoord];
    [punto setY:yCoord];
    [punto setVisi:NO];
    [punto setTag:0];
    return punto;
}

+(NJPoint*)pointWithX:(float)xCoord andY:(float)yCoord andVisi:(BOOL)visibilidad
{
    NJPoint* punto = [[NJPoint alloc] init];
    
    [punto setX:xCoord];
    [punto setY:yCoord];
    [punto setVisi:visibilidad];
    [punto setTag:0];
    
    return punto;
}

+(NJPoint*)pointWithNSValue:(NSValue*)point
{
    CGPoint punto = [point CGPointValue];
    
    return [self pointWithX: (float)punto.x andY: (float)punto.y];
}

+(NJPoint*)pointFromString:(NSString*)point
{
    CGPoint punto = CGPointFromString(point);
    return [self pointWithX: (float)punto.x andY: (float)punto.y];
    
}

//Setters
-(void)setTag:(int)tg
{
    if([tags count] == 0)
    {
        tags = [[NSMutableArray alloc] init];
    }
    for(NSNumber* tagg in tags)
    {
        if([tagg intValue] == tg)
        {
            return;
        }
    }
    [tags addObject:[NSNumber numberWithInt:tg]];
}

-(void)setX:(float)xCoord
{
    x = (((int)(1000*xCoord))/1000.0);
}

-(void)setY:(float)yCoord
{
    y = (((int)(1000*yCoord))/1000.0);
}

-(void)setVisi:(BOOL)visibilidad
{
    visi = visibilidad;
}

-(void)setIni:(BOOL)init
{
    ini = init;
}

//Getters
-(float)x
{
    return (((int)(1000*x))/1000.0);
}

-(float)y
{
    return (((int)(1000*y))/1000.0);
}

-(BOOL)visi
{
    return visi;
}

-(BOOL)ini
{
    return ini;
}

-(NSMutableArray*)tag
{
    return tags;
}

-(CGPoint)CGPointValue
{
    return ccp(x, y);
}

-(NSString*)toString
{
    return [NSString stringWithFormat:@"( %.4f, %.4f )", x, y];
}

-(BOOL)isTagged:(int)tg
{
    for(NSNumber* tagg in tags)
    {
        if([tagg intValue] == tg)
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)removeTag:(int)tg
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(NSNumber* tagg in tags)
    {
        if([tagg intValue] != tg)
        {
            [array addObject:tagg];
        }
    }
    tags = array;
    if([tags count] == 1)
    {
        [self setVisi: NO];
        if( ![self ini] )
        {
            return YES;
        }
    }
    return NO;
}

//Methods
-(BOOL) visibilidadPunto:(NJPoint*)toque poligono:(NJPolygon*)poly indice:(int)k
{
    int b = 0, c = 0;
    NJSegment *stoque = [NJSegment segmentWithP1:toque P2:self];
    int polylength = (int)[[poly sommets] count];
    for (int i = 0; i <= polylength - 2; i++) {
        if (k == polylength - 1)
        {
            k = -1;
        }
        
        b = k + 1;
        c = k + 2;
        
        if (k + 2 == polylength) {
            c = 0;
        }
        
        if ([stoque cortanA:[poly sommets][b] B:[poly sommets][c]]) {
            // //NSLog(@"MI POLLA CORTA CON: stoque: %@ :%@ - %@",[stoque toString], [[poly sommets][b] toString],[[poly sommets][c] toString] );
            return NO;
        }
        k++;
        
    }
    return YES;
}


-(BOOL)comprobarUltVisto:(NJPoint*)ultvisto Toque:(NJPoint*)toque sigVisto:(NJPoint*)sigvisto primNov:(NJPoint*)primnov ultNov:(NJPoint*)ultnov
{
    NJPoint* corte = primnov;
    NJPoint* max = ultvisto;
    NJPoint* prol = sigvisto;
    
    
    float m = ([ultvisto y] - [primnov y]) / ([ultvisto x] - [primnov x]);
    float p = [ultvisto y] - m * [ultvisto x];
    BOOL position = ([toque y] > m * [toque x] + p);
    
    float thetaultv = [[NJSegment alloc] anguloCentro:toque vertice:ultvisto encima:position];
    float thetaprimnov = [[NJSegment alloc] anguloCentro:toque vertice:primnov encima:position];
    
    if ( (position && thetaultv >  thetaprimnov) || (!position && thetaprimnov > thetaultv))
    {
        corte = ultnov;
        max = sigvisto;
        prol = ultvisto;
    }
    
    
    
    float segmento = sqrtf(([corte x] - [max x])*([corte x] - [max x]) + ([corte y] - [max y]) * ([corte y] - [max y]));
    float analizar = sqrtf(([self x] - [corte x])*([self x] - [corte x])+ ([self y] - [corte y])* ([self y] - [corte y]));
    
    if(analizar <= segmento)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(float) distASegmentoA:(NJPoint*)A B:(NJPoint*)B
{
    float m, pa, pt, xq, yq;
    if( [A x] != [B x] && [A y] != [B y] )
    {
        m = ( ( [A y] - [B y] ) / ( [A x] - [B x] ) );
        pa = [A y] - m * [A x];
        pt = [self y] + 1/m * [self x];
        xq = ( pt - pa ) / ( m + 1 / m );
        yq = m * xq + pa;
    }
    else if( [A x] != [B x])
    {
        xq = [self x];
        yq = [A y];
    }
    else if( [A y] != [B y])
    {
        xq =  [A x];
        yq = [self y];
    }
    
    
    return sqrtf(( [self x] - xq ) * ( [self x] - xq ) + ( [self y] - yq ) * ( [self y] - yq ) );
}

//Prolongar 2
-(NJPoint*) prolongarProl:(NJPoint*)prol Corte:(NJPoint*)corte Max:(NJPoint*)max
{
    if([prol x] != [self x] && [max x] != [corte x]){
		float m1 = ([prol y] - [self y]) / ([prol x] - [self x]);   // pendiente de la recta
		float p1 = [prol y] - m1 * [prol x];
		float m2 = ([max y] - [corte y]) / ([max x] - [corte x]);   // pendiente de la recta
		float p2 = [max y] - m2 * [max x];
		float xprol = ( p2 - p1 ) / ( m1 - m2 );
		float yprol = m1 * xprol + p1;
        NJPoint* bueno = [NJPoint pointWithX:xprol andY:yprol andVisi:YES];
		return bueno;
    }
    if([prol x] == [self x] && [corte x] != [max x]){
        float m2 = ([max y] - [corte y]) / ([max x] - [corte x]);   // pendiente de la recta
        float p2 = [max y] - m2 * [max x];
        float xprol= [self x];
        float yprol= m2 * xprol + p2;
        NJPoint* bueno = [NJPoint pointWithX:xprol andY:yprol andVisi:YES];
        return bueno;
    }
    if([prol x] != [self x] && [corte x] == [max x]){
        float m1 = ([prol y] - [self y]) / ([prol x] - [self x]);   // pendiente de la recta
        float p1=[prol y] - m1 * [prol x];
        float xprol=[corte x];
        float yprol=m1 * xprol + p1;
        NJPoint* bueno = [NJPoint pointWithX:xprol andY:yprol andVisi:YES];
        return bueno;
    }
    return self;
}

-(NJPoint*) prolongarUltVisto:(NJPoint*)ultvisto sigVisto:(NJPoint*)sigvisto primNov:(NJPoint*)primnov ultNov:(NJPoint*)ultnov
{
    
    NJPoint* prol = sigvisto;
    NJPoint* corte = primnov;
    NJPoint* max = ultvisto;
    float m1, p1, m2, p2, xprol, yprol;
    float m = ([ultvisto y] - [primnov y]) / ([ultvisto x] - [primnov x]);
    float p = [ultvisto y] - m * [ultvisto x];
    BOOL position = ([self y] > m * [self x] + p);
    
    float thetaultv = [[NJSegment alloc] anguloCentro:self vertice:ultvisto encima:position];
    float thetaprimnov = [[NJSegment alloc] anguloCentro:self vertice:primnov encima:position];
    
    if ( (position && thetaultv >  thetaprimnov) || (!position && thetaprimnov > thetaultv))
    {
        corte = ultnov;
        max = sigvisto;
        prol = ultvisto;
    }
    
	if ( [prol x] != [self x] && [max x] != [corte x])
    {
        m1 = ( [prol y] - [self y] ) / ( [prol x] - [self x] );
        p1 = [prol y] - m1 * [prol x];
        m2 = ( [max y] - [corte y] ) / ( [max x] - [corte x] );
        p2 = [max y] - m2 * [max x];
        xprol = ( p2 - p1 ) / ( m1 - m2 );
        yprol = m1 * xprol + p1;
        
        return [NJPoint pointWithX:xprol andY:yprol andVisi:YES];
    }
    else if( [prol x] == [self x] && [corte x] != [max x])
    {
        m2 = ( [max y] - [corte y] ) / ( [max x] - [corte x] );
        p2 = [max y] - m2 * [max x];
        xprol = [self x];
        yprol = m2 * xprol + p2;
        
        return [NJPoint pointWithX:xprol andY:yprol andVisi:YES];
    }
    else if ( [prol x] != [self x] && [max x] == [corte x])
    {
        m1 = ( [prol y] - [self y] ) / ( [prol x] - [self x] );
        p1 = [prol y] - m1 * [prol x];
        xprol = [corte x];
        yprol = m1 * xprol + p1;
        
        return [NJPoint pointWithX:xprol andY:yprol andVisi:YES];
    }
    
    return self;
}

-(NSMutableArray*) actualizarSommets:(NSMutableArray*)puntos toque:(NJPoint*)toque ultVisto:(NJPoint*)ultvisto sigVisto:(NJPoint*)sigvisto primNoV:(NJPoint*)primnov ultNoV:(NJPoint*)ultNoV
{
    
    float medultvprimnov = [toque distASegmentoA:ultvisto B:primnov];
    float medsigvultnov = [toque distASegmentoA:sigvisto B:ultNoV];
    
    if (medultvprimnov < medsigvultnov)
    {
        return [self insertPreSommets:puntos pre:sigvisto];
    }
    else
    {
        return [self insertPostSommets:puntos post:ultvisto];
    }
    
}

-(NSMutableArray*) insertPreSommets:(NSMutableArray*)puntos pre:(NJPoint*)pre
{
    int cont=0;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0 ; i <= (int)[puntos count]; i++){
        if( ![puntos[cont] isEqualTo:pre])
        {
            array[i] = puntos[cont];
        }
        else
        {
            array[i] = self;
            array[i+1] = puntos[cont];
            i++;
        }
        cont++;
        
    }
    
    return array;
}

-(NSMutableArray*) insertPostSommets:(NSMutableArray*)puntos post:(NJPoint*)post
{
    int cont=0;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0 ; i <= (int)[puntos count]; i++){
        if( ![puntos[cont] isEqualTo:post])
        {
            array[i] = puntos[cont];
        }
        else
        {
            array[i] = puntos[cont];
            array[i+1] = self;
            
            i++;
        }
        cont++;
        
    }
    return array;
}

-(BOOL)isEqualTo:(NJPoint*)punto
{
    if ( (int)((int)x - (int)punto.x) == 0 && (int)( (int)y - (int)punto.y ) == 0 )
    {
        return YES;
    }
    return NO;
}

-(BOOL)comprobarRarosProl:(NJPoint*)prol Poly:(NJPolygon*)poly Pos:(int)pos
{
    int next = 0;
    int num = (int)[[poly sommets] count];
    
    NJSegment* stoque = [NJSegment segmentWithP1:prol P2:self];
    for(int i = 0; i < num; i++)
    {
        next = i+1;
        if(i == num -1)
        {
            next = 0;
        }
        
        if( ![[poly sommets][i] isEqualTo:[poly sommets][pos]] && ![[poly sommets][i] isEqualTo:self] && ![[poly sommets][next] isEqualTo:self] && [stoque cortanA:[poly sommets][i] B:[poly sommets][next]])
        {
            return NO;
        }
        
    }
    return YES;
}

-(BOOL)isOutToque:(NJPoint*)touch sommets:(NSMutableArray*)sommets
{
    int numero = 0;
    int count = [sommets count];
    
    NJSegment *recta = [NJSegment segmentWithP1:touch P2:[NJPoint pointWithX:-1 andY:[touch y]+2]];
    for(int i = 0; i < count; i++)
    {
        if([touch isEqualTo: sommets[i]])
        {
            return NO;
        }
        if(i+1 <= count - 1 && [recta cortanDOSA:sommets[i] B:sommets[i+1]])
        {
            numero++;
        }
        if([recta cortanDOSA:sommets[0] B:sommets[count-1]])
        {
            numero++;
        }
    }
    
    if(numero % 2 == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSMutableArray*)girarVectorPrimero:(NSMutableArray*)primero segundo:(NSMutableArray*)segundo
{
    int empezar = 0;
    int count = (int)[primero count];
    for(int i = 0; i <  count; i++)
    {
        if([primero[i] isOutToque:primero[i] sommets:segundo])
        {
            empezar = i;
            break;
        }
    }
    if(empezar == 0)
    {
        return primero;
    }
    NSMutableArray* array = [NSMutableArray array];
    for(int j = 0; j < count; j++)
    {
        if(empezar == count)
        {
            empezar = 0;
        }
        if( empezar < count)
        {
            array[j] = primero[empezar];
        }
        empezar++;
    }
    return array;
}

-(BOOL)anteriorMolaThetaPrev:(float)thetaPrev thetaAnt:(float)thetaAnt
{
    if ( thetaAnt > 0 )
    {
        if ( (thetaPrev > 0 && thetaPrev > thetaAnt ) || (thetaPrev < 0 && thetaPrev < thetaAnt-180) )
        {
            return YES;
        }
    }
    else
    {
        if ( ( thetaPrev > 0 && thetaPrev < thetaAnt + 180) || (thetaPrev < 0 && thetaPrev > thetaAnt ) )
        {
            return YES;
        }
    }
    return  NO;
}


-(float)anguloHorizontalCentro:(NJPoint*)centro
{
    float theta=(360 / (2 * M_PI))*atanf(([self y]- [centro y])/([self x]- [centro x]));
    if([self x] < [centro x] && [self y] < [centro y]){
        theta-=180;
    }
    if([self x] < [centro x] && [self y] > [centro y]){
        theta+=180;
    }
    if([self x] == [centro x]){
        if([self y] > [centro y] ){
            theta=90;
        }else{
            theta=-90;
        }
    }
    
    if ( [self y] == [centro y] && [self x] < [centro x] )
        theta = 180;
    
    return theta;
}


-(BOOL)verificarMasterActual:(NJPolygon*)actual Centro:(NJPoint*)centro
{
    NJPoint* prevAnt = self;
    NJPoint* prev = self;
    NJPoint* next = self;
    int nextInd = 0;
    int prevInd = 0;
    int count = [actual.sommets count];
    for(int i = 0 ; i < count ; i++)
    {
        nextInd = i + 1;
        prevInd = i - 1;
        if([[actual sommets][i] isEqualTo: centro])
        {
            if( i - 1 < 0 )
            {
                prevInd = (int)[[actual sommets] count]-1;
            }
            if( i + 1 == (int)[[actual sommets]count])
            {
                nextInd = 0;
            }
            next=actual.sommets[nextInd];
            prev=actual.sommets[prevInd];
            
            if ( prevInd == 0 )
                prevAnt = actual.sommets[[actual.sommets count] - 1];
            else
                prevAnt = actual.sommets[prevInd - 1];
            
            break;
        }
    }
    
    float thetaAnt = [prev anguloHorizontalCentro:centro];
    float thetaNext = [next anguloHorizontalCentro:centro];
    float thetaP = [self anguloHorizontalCentro:centro];
    float thetaPrev = [prevAnt anguloHorizontalCentro:centro];
    
    //NSLog(@"\n thetaAnt: %.6f thetaNext: %.6f thetaP: %.6f \n Centro: %@ , This: %@", thetaAnt, thetaNext, thetaP, [centro toString], [self toString]);
    
    if ( thetaAnt * thetaNext > 0 )
    {
        if ( thetaAnt < thetaNext && thetaAnt < thetaP + 1 && thetaP <= thetaNext + 1)
            return YES;
        else if(thetaAnt > thetaNext )
        {
            if ( [self anteriorMolaThetaPrev:thetaPrev thetaAnt:thetaAnt] )
                return [self verificarMasterActual:actual Centro:prev];
            else
            {
                if ( thetaAnt > 0 )
                {
                    if ( (thetaP > 0 && thetaP >= thetaAnt ) || (thetaP < 0 && thetaP <= thetaAnt - 180 ) )
                        return YES;
                }
                else
                {
                    if ( (thetaP > 0 && thetaP <= thetaAnt + 180) || (thetaP < 0 && thetaP >= thetaAnt) )
                        return YES;
                }
            }
        }
    }
    else if ( thetaNext * thetaAnt < 0 )
    {
        if ( thetaNext >= 0 && thetaAnt >= thetaNext - 180 )
        {
            if( (thetaP > 0 && thetaP <= thetaNext ) || ( thetaP < 0 && thetaP >= thetaAnt ) )
                return YES;
        }
        else if ( thetaNext < 0 && thetaAnt > thetaNext + 180)
        {
            if ( (thetaP >= 0 && thetaP >= thetaAnt ) || ( thetaP < 0 && thetaP <= thetaNext ) )
                return YES;
        }
        else if ( thetaNext > 0 && thetaAnt < thetaNext - 180 )
        {
            if ( [self anteriorMolaThetaPrev:thetaPrev thetaAnt:thetaAnt] )
                return [self verificarMasterActual:actual Centro:prev];
            else
            {
                if ( (thetaP > 0 && thetaP <= thetaAnt + 180) || ( thetaP <= 0 && thetaP >= thetaAnt) )
                    return YES;
            }
        }
        else if( thetaNext < 0 && thetaAnt < thetaNext + 180 )
        {
            if ( [self anteriorMolaThetaPrev:thetaPrev thetaAnt:thetaAnt] )
                return [self verificarMasterActual:actual Centro:prev];
            else
            {
                if ( ( thetaP > 0 && thetaP >= thetaAnt ) || ( thetaP <= 0 && thetaP <= thetaAnt - 180) )
                    return YES;
            }
        }
    }
    return NO;
}

-(BOOL)perteneceA:(NJSegment*) actual
{
    if( [self isEqualTo:[actual p1]] || [self isEqualTo:[actual p2]])
    {
        return YES;
    }
    if( [actual minA:actual.p1 B:actual.p2].x -0.1f <= self.x && [actual maxA:actual.p1 B:actual.p2].x + 0.1f >= self.x )
    {
        float m = ([[actual p1] y] - [[actual p2] y]) / ([[actual p1] x] - [[actual p2] x]);
        float p = [[actual p1] y] - m * [[actual p1] x];
        
        return fabs([self y]-(m * [self x] + p)) < 1;
    }
    return NO;
    
}

-(BOOL)perteneceAPolygonEnSegmentos:(NJPolygon *)poly
{
    int next;
    int length = (int) [[poly sommets] count];
    for( int i = 0; i < length; i++)
    {
        next = i+1;
        if( next == length )  next = 0;
        if ( i == length ) { i = 0; next = 1; }
        if( [self perteneceA:[NJSegment segmentWithP1:poly.sommets[i] P2:poly.sommets[next]]] )
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)perteneceAPolygon:(NJPolygon*)poly
{
    for(int i = 0; i < (int)[[poly sommets] count]; i++)
    {
        if( [self isEqualTo:[poly sommets][i]] )
        {
            return YES;
        }
    }
    return NO;
}

-(NJPoint*)nextInPolygon:(NJPolygon*)poly
{
    int next = 1;
    int count = [poly.sommets count];
    
    for ( int i = 0; i < count; i++)
    {
        if (next == count)
        {
            next = 0;
        }
        if ([poly.sommets[i] isEqualTo:self])
        {
            return poly.sommets[next];
        }
        next++;
    }
    return self;
}
@end
