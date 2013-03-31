//
//  NJSegment.m
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 29/11/12.
//
//

#import "NJSegment.h"

@implementation NJSegment
//Constructor
+(NJSegment*)segmentWithP1:(NJPoint*)p1 P2:(NJPoint*)p2
{
    NJSegment *segmento = [[NJSegment alloc] init];
    
    [segmento setP1:p1];
    [segmento setP2:p2];
    
    return segmento;
}

//Setters
-(void)setP1:(NJPoint*)p
{
    p1 = p;
}

-(void)setP2:(NJPoint*)p
{
    p2 = p;
}
//Getters
-(NJPoint*)p1
{
    return p1;
}

-(NJPoint*)p2
{
    return p2;
}

-(NSString*)toString
{
    return [NSString stringWithFormat:@"%@ - %@", [[self p1] toString], [[self p2] toString]];
}

//Methods
-(float)funcionM:(float)m P:(float)p X:(float)x
{
    return m * x + p;
}

-(NJPoint*)minA:(NJPoint*)a B:(NJPoint*)b
{
    if ([a x] <= [b x])
    {
        return a;
    }
    else
    {
        return b;
    }
}

-(NJPoint*)minYWithPoint1:(NJPoint*)a andPoint2:(NJPoint*)b
{
    if(a.y <= b.y)
    {
        return a;
    }
    else
    {
        return b;
    }
}

-(NJPoint*)maxA:(NJPoint*)a B:(NJPoint*)b
{
    if ([a x] >= [b x])
    {
        return a;
    }
    else
    {
        return b;
    }
}

-(NJPoint*)maxYWithPoint1:(NJPoint*)a andPoint2:(NJPoint*)b
{
    if(a.y >= b.y)
    {
        return a;
    }
    else
    {
        return b;
    }
}

-(float)anguloCentro:(NJPoint*)centro vertice:(NJPoint*)vertice encima:(BOOL)encima
{
    if([centro isEqualTo:vertice])
    {
        return 0;
    }
    float theta;
    if (encima)
    {
        theta = (360 / (2 * M_PI))
        * atanf(([vertice x] - [centro x])
                    / ([centro y] - [vertice y]));
        if ([vertice x] > [centro x]
            && [vertice y] > [centro y])
        {
            theta = 180 + theta;	
        }
        if ([vertice x] < [centro x] && [vertice y] > [centro y])
        {
            theta = -180 + theta;
        }

//        if ( (int)[vertice x] == (int)[centro x] && [vertice y] > [centro y])
//        {
//            theta += 90;
//        }

    }
    else
    {
        theta = (360 / (2 * M_PI))
        * atanf(([vertice x] - [centro x])
                    / ([vertice y] - [centro y]));
        if ([vertice x] > [centro x] && [vertice y] < [centro y])
        {
            theta = 180 + theta;
        }
        if ([vertice x] < [centro x] && [vertice y] < [centro y])
        {
            theta = -180 + theta;
        }
        //        if ( (int)[vertice x] == (int)[centro x] && [vertice y] < [centro y])
        //        {
        //            theta -= 90;
        //        }

    }
    return theta;
}

-(BOOL)cortanTRESA:(NJPoint*)a B:(NJPoint*)b
{
    NJSegment* lado = [NJSegment segmentWithP1:[self minA:a B:b] P2:[self maxA:a B:b]];
    float m = ([[lado p2] y] - [[lado p1] y]) / ([[lado p2] x] - [[lado p1] x]);
    float p = [[lado p1] y] - m * [[lado p1] x];
    
    BOOL posicion = ([[self p1] y] >= [self funcionM:m P:p X:[[self p1] x]]);
    p = [[lado p2] y] - m * [[lado p2] x];
    BOOL pos2 = [[self p2] y] >= [self funcionM:m P:p X:[[self p2] x]];

    float theta1 = [self anguloCentro:[self p1] vertice:[lado p1] encima:posicion];
    float theta2 = [self anguloCentro:[self p1] vertice:[lado p2] encima:posicion];
    float theta3 = [self anguloCentro:[self p1] vertice:[self p2] encima:posicion];
    float theta4 = [self anguloCentro:[lado p1] vertice:[lado p2] encima:posicion];
    
    NJPoint* miny = [self minYWithPoint1:a andPoint2:b];
    NJPoint* maxy = [self maxYWithPoint1:a andPoint2:b];
    if (theta1 < theta3 && theta3 < theta2 && posicion != pos2)
    {
        return YES;
    }

    if( (int)theta3 == 90 && (int)theta4 == 0 && (int)p1.y >= (int)miny.y && (int)p1.y <= (int)maxy.y && p1.x < a.x)
        return YES;
    else
        return NO;
}
-(BOOL)cortanA:(NJPoint*)a B:(NJPoint*)b
{
    NJSegment* lado = [NJSegment segmentWithP1:[self minA:a B:b] P2:[self maxA:a B:b]];
    
    float m = ([[lado p2] y] - [[lado p1] y]) / ([[lado p2] x] - [[lado p1] x]);
    float p = [[lado p1] y] - m * [[lado p1] x];

    BOOL posicion = ([[self p1] y] >= [self funcionM:m P:p X:[[self p1] x]]);
    p = [[lado p2] y] - m * [[lado p2] x];

    BOOL pos2 = [[self p2] y] >= [self funcionM:m P:p X:[[self p2] x]];
    
    float theta1 = [self anguloCentro:[self p1] vertice:[lado p1] encima:posicion];
    float theta2 = [self anguloCentro:[self p1] vertice:[lado p2] encima:posicion];
    float theta3 = [self anguloCentro:[self p1] vertice:[self p2] encima:posicion];
    
    if (theta1 < theta3 && theta3 < theta2 && posicion != pos2)
    {
        return YES;
    }
    
        return NO;
}

-(BOOL)cortanDOSA:(NJPoint*)a B:(NJPoint*)b
{
    BOOL conta = ([[self p1] isEqualTo:a] && [[self p2] isEqualTo:b]) || ([[self p1] isEqualTo:b] && [[self p2] isEqualTo:a]);
    
    if(conta)
    {
        return NO;
    }
    
    if(([[self p1] isEqualTo:a] || [[self p1] isEqualTo:b] || [[self p2] isEqualTo:a] || [[self p2] isEqualTo:b]) && !conta){
        return YES;
    }
    
    NJSegment* lado = [NJSegment segmentWithP1:[self minA:a B:b] P2:[self maxA:a B:b]];
    
    float m = ([[lado p2] y] - [[lado p1] y]) / ([[lado p2] x] - [[lado p1] x]);
    float p = [[lado p1] y] - m * [[lado p1] x]; // para la funcion tb
    
    BOOL posicion = ([[self p1] y] >= [self funcionM:m P:p X:[[self p1] x]] -0.01) || [[self p1] y] >= 0.01 + [self funcionM:m P:p X:[[self p1] x]];
    
    BOOL pos2=([[self p2] y] >= [self funcionM:m P:p X:[[self p2] x]] - 0.01) || [[self p2] y] >= 0.01 + [self funcionM:m P:p X:[[self p2] x]];
    
    float theta1 = [self anguloCentro:[self p1] vertice:[lado p1] encima:posicion];
    float theta2 = [self anguloCentro:[self p1] vertice:[lado p2] encima:posicion]; 
    float theta3 = [self anguloCentro:[self p1] vertice:[self p2] encima:posicion];
    
    if ((theta1 - 2.5 <= theta3 || theta3 >= theta1 + 2) && (theta3 <= theta2 - 2 || theta2+ 2.5 >= theta3) && posicion != pos2)
    {
        return YES;  
    }
    else
    {
        return NO;
    }
}

-(NJSegment*)jackpotToque:(NJPoint*)toque Poly:(NJPolygon*)poly Sommets:(NSMutableArray*)sommets ultVisto:(int)ultVisto sigVisto:(int)sigVisto primNoV:(int)primNoV ultNoV:(int)ultNoV
{
    float m = 0, p = 0;
    BOOL posicion;
    NJSegment *jackpot = [NJSegment segmentWithP1:sommets[primNoV] P2:sommets[ultNoV] ];
    
    if(sigVisto == (int)[sommets count])
    {
        sigVisto = 0;
    }
    for ( int i = primNoV; i < ultNoV; i++)
    {
        m = ([(NJPoint*)sommets[i] y] - [(NJPoint*)sommets[i+1] y]) / ( [(NJPoint*)sommets[i] x] - [(NJPoint*)sommets[i+1] x]);
        p = [(NJPoint*)sommets[i] y] - m*[(NJPoint*)sommets[i] x];
        posicion = [toque y] > m * [toque x] + p;
        
        float thetault = [self anguloCentro:toque vertice:sommets[ultVisto] encima:posicion];
        float thetapa = [self anguloCentro:toque vertice:sommets[i] encima:posicion];

        float thetasig = [self anguloCentro:toque vertice:sommets[sigVisto] encima:posicion];
        float thetapb = [self anguloCentro:toque vertice:sommets[i+1] encima:posicion];
        
        
        
        if(posicion && thetault >= thetapa && thetapb >= thetasig)
        {
            NJPoint *pp1 = [toque prolongarProl:[poly sommets][ultVisto] Corte:[poly sommets][i] Max:[poly sommets][i+1]];
            BOOL seve = [pp1 comprobarRarosProl:[poly sommets][ultVisto] Poly:poly Pos:i];
            if(seve)
            {
                jackpot = [NJSegment segmentWithP1:sommets[i] P2:sommets[i+1]];
                break;
            }

        }
        
        if(!posicion && thetault <=thetapa && thetapb <= thetasig)
        {
            NJPoint *pp1 = [toque prolongarProl:[poly sommets][ultVisto] Corte:[poly sommets][i] Max:[poly sommets][i+1]];
            BOOL seve = [pp1 comprobarRarosProl:[poly sommets][ultVisto] Poly:poly Pos:i];
            if(seve)
            {
                jackpot = [NJSegment segmentWithP1:sommets[i] P2:sommets[i+1]];
                break;
            }
        }
    }
    
return jackpot;
}

-(NJSegment*) darSiguientePrimero:(NJPolygon*)primero segundo:(NJPolygon*)segundo
{
    
    NJPolygon *ausar = segundo;
    NJPolygon *actual = primero;
    
    if(primero.usar)
    {
        ausar = primero;
        actual = segundo;
    }
    
    int next = 1;
    float distancia = 0;
    float mindist = 0;
    
    NSLog(@"actual: %@ con  %d", [self toString], (int)[[ausar sommets] count]);

    NJSegment* devolver = nil;
    mindist = sqrtf((( p1.x - p2.x ) * ( p1.x - p2.x )) + ( p1.y - p2.y ) * ( p1.y - p2.y ));
    NSLog(@"mindist %f", mindist);

    NJSegment *compare;
    BOOL bp1, bp2, comp1, comp2;
    int count = [ausar.sommets count];
    for(int i = 0; i < count; i++)
    {
        if(next == count)
        {
            next = 0;
        }
        compare = [NJSegment segmentWithP1:ausar.sommets[i] P2:ausar.sommets[next]];
        
        bp1 = [self.p1 perteneceA:compare];
        bp2 = [self.p2 perteneceA:compare];
        comp1 = [compare.p1 perteneceA:self];
        comp2 = [compare.p2 perteneceA:self];
        
        if( [p1 isEqualTo:compare.p1] && [p2 isEqualTo:compare.p2] ){
            return [NJSegment segmentWithP1:p2 P2: [p2 nextInPolygon:actual]];
        }
        
        distancia = sqrtf( (p1.x - compare.p1.x) * (p1.x - compare.p1.x) + (p1.y - compare.p1.y) * (p1.y - compare.p1.y) );
        
        if ( comp1 && !comp2 && ![compare.p1 isEqualTo:p2] && [ausar.sommets[next] verificarMasterActual:actual Centro:p2] && distancia <= mindist )
        {
            mindist = distancia;
            primero.libre = NO;
            segundo.libre = NO;
            primero.unoauno = NO;
            segundo.unoauno = NO;
            devolver = [NJSegment segmentWithP1:ausar.sommets[i] P2:ausar.sommets[next]];
            NSLog(@"Punto en segmento");

        }
    
        if( bp1 && ![p1 isEqualTo:compare.p1] && ![p1 isEqualTo:compare.p2] && [ausar.sommets[next] verificarMasterActual:actual Centro:p2] && !bp2 )
        {
            primero.libre = NO;
            segundo.libre = NO;
            primero.unoauno = NO;
            segundo.unoauno = NO;
            devolver = [NJSegment segmentWithP1:p1 P2:ausar.sommets[next]];
            NSLog(@"CASO RARO");
        }
        
        if( [self cortanDOSA:[ausar sommets][i] B:[ausar sommets][next]] && !(comp1 || comp2) && !(bp1 || bp2) )
        {
            NSLog(@"corta con: %@ - %@", [[ausar sommets][i] toString], [[ausar sommets][next] toString]);

            NJPoint* corte = [p1 prolongarProl:p2 Corte:[ausar sommets][i] Max:[ausar sommets][next]];
           
            distancia = sqrtf((( corte.x - p1.x ) * ( corte.x - p1.x )) + (( corte.y - p1.y ) * ( corte.y - p1.y )));
            NSLog(@"distancia1 %f", distancia);
            if( distancia < mindist )
            {
                mindist = distancia;
                NSLog(@"mindist %f", mindist);

                NSLog(@"distancia %f", distancia);
                primero.libre = NO;
                segundo.libre = NO;
                primero.unoauno = NO;
                segundo.unoauno = NO;
                devolver = [NJSegment segmentWithP1: corte P2: [ausar sommets][next]];
                NSLog(@"Caso corta en medio");
            }
        }
        next++;
    }
    
    if(devolver)
    {
        NSLog(@" devolver: %@ ", [devolver toString]);
        ausar.usar = NO;
        actual.usar = YES;
        return devolver;
    }
    int actualp2 = 0;
    count = [actual.sommets count];
    for(int k = 0; k < count ; k++)
    {
        if([[actual sommets][k] isEqualTo:p2 ])
        {
            actualp2 = k;
            break;
        }
    }
    NJSegment* nocorta = [NJSegment segmentWithP1:[actual sommets][actualp2] P2:[actual sommets][0]]; 

    if( actualp2 < count -1 )
    {
		nocorta = [NJSegment segmentWithP1:[actual sommets][actualp2] P2:[actual sommets][actualp2+1]];
    }
    return nocorta;
}

@end
