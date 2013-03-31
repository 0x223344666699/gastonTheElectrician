//
//  NJPolygon.m
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 29/11/12.
//
//

#import "NJPolygon.h"
#define ARC4RANDOM_MAX      0x100000000

@implementation NJPolygon
@synthesize unoauno,libre,usar;

//Constructor
+(NJPolygon*) poligonoWithSommets:(NSMutableArray*) array
{
    NJPolygon *poligono = [[NJPolygon alloc] init];
    
    [poligono setSommets:array];
    [poligono setNuevosVerts:array];
    poligono.unoauno = YES;
    poligono.libre = YES;
    
    return poligono;
}

+(NJPolygon*) poligono
{
    int cont=0;
    int numb=8+(int)((double)arc4random() / ARC4RANDOM_MAX*(15));
    int x, y;
    NJPolygon *poligono = [NJPolygon alloc];
    poligono.sommets = [NSMutableArray array];
    for(int u=0 ; u < numb ; u++)
    {
        cont++;
        x=12+(int)((double)arc4random() / ARC4RANDOM_MAX*(309));
        y=70+(int)((double)arc4random() / ARC4RANDOM_MAX*(361));
        poligono.sommets[u]=[NJPoint pointWithX:x andY:y];
    }
    NJSegment* actual;
    int next,sig;
    NJPoint* comp;
    int count = [poligono.sommets count];
    
	for(int i = 0 ; i < count; i++)
    {
		next=i+1;
		if(next == count)
        {
			next = 0;
		}
		actual= [NJSegment segmentWithP1:poligono.sommets[i] P2:poligono.sommets[next]];
		for(int j = 0 ; j < count ; j++)
        {
			cont++;
			if(cont > 5000)
				break;
            
			sig = j+1;
			if(sig == count)
				sig = 0;
			
			BOOL pre = [poligono.sommets[j] perteneceA:actual];
			BOOL post= [poligono.sommets[sig] perteneceA:actual];
            
			if([actual cortanA:poligono.sommets[j] B:poligono.sommets[sig]] && !( pre || post) )
            {
                comp = poligono.sommets[next];
				poligono.sommets[next] = poligono.sommets[j];
				poligono.sommets[j] = comp;
				i=-1;
				break;
			}
		}
		if(cont>5000)
			break;
        
	}
	if(cont>5000)
        poligono = [NJPolygon poligono];
    
    return  poligono;
        
}

+(NJPolygon*) poligonoWithSommets:(NSMutableArray *)array Libre:(BOOL)lib
{
    NJPolygon* pol = [NJPolygon poligonoWithSommets:array];
    pol.libre = lib;
    
    return pol;
}

//Setters
-(void)setSommets:(NSMutableArray*)array
{
    sommets = array;
}

-(void)setNuevosVerts:(NSMutableArray*)array
{
    nuevosVerts = array;
}

//Getters
-(NSMutableArray*) sommets
{
    return sommets;
}

-(NSMutableArray*) nuevosVerts
{
    return nuevosVerts;
}

-(NSMutableArray*) CGPointSommets
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < (int)[sommets count] ; i++)
    {
        array[i] = [NSValue valueWithCGPoint:[((NJPoint*)([sommets objectAtIndex:i])) CGPointValue]];
    }
    return array;
}

//Methods
-(NSMutableArray*) polvisiToque:(NJPoint*)toque Tool:(CCTool*)tool
{
    
    int a = 0;
    int pos = 0;
    int count = (int)[[self sommets] count];
    BOOL present;
    
    NSMutableArray* puntosvisi = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        present = [(NJPoint*)([self sommets][i]) visibilidadPunto:toque poligono:self indice:i];
        puntosvisi[i] = [NSNumber numberWithBool: present];
        
        if(![puntosvisi[0] boolValue] && pos == 0 && present)
            pos = i;
        
        if (present == NO)
            a++;
        
        if(![(NJPoint*)([self sommets][i]) visi] && present)
        {
            [(NJPoint*)([self sommets][i]) setVisi:YES];
            [(NJPoint*)([self sommets][i]) setTag:[tool tag]];
        }
    }
    
    if( ![puntosvisi[0] boolValue] )
    {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSMutableArray * arrayPoints = [[NSMutableArray alloc] init];
        
        for(int s = 0 ; s < count ; s++)
        {
            if( s + pos <= count - 1)
            {
                array[s] = puntosvisi[s+pos];
                arrayPoints[s] = [self sommets][s + pos];
            }
            else
            {
                array[s] = puntosvisi[s + pos - count];
                arrayPoints[s] = [self sommets][s + pos - count];
            }
            
        }
        
        puntosvisi = array;
        [self setSommets:arrayPoints];
    }
    NSMutableArray* sommvisi = [[NSMutableArray alloc]init];

    if (a > 0)
    {
        int b = 0;
        int z = 0;
        int cont = 0;
        
        for (int j = 0; j < count; j++)
        {
            
            if (j != 0 && ![puntosvisi[j] boolValue] && [puntosvisi[j - 1] boolValue])
            {
                b = j - 1;
                z = j;
            }
            
            if (j + 1 <= count - 1 && ![puntosvisi[j] boolValue] && [puntosvisi[j + 1] boolValue])
            {
                NJPoint* prueba = [toque prolongarUltVisto:[self sommets][b] sigVisto:[self sommets][j + 1] primNov:[self sommets][z] ultNov:[self sommets][j]];
                
                if([prueba comprobarUltVisto:[self sommets][b] Toque:toque sigVisto:[self sommets][j + 1] primNov:[self sommets][z] ultNov:[self sommets][j]])
                {
                    sommvisi[cont] = prueba;
                    
                    [sommvisi[cont] setTag:[tool tag]];
                    
                    [self setNuevosVerts: [sommvisi[cont] actualizarSommets: [self nuevosVerts] toque:toque ultVisto:[self sommets][b] sigVisto:[self sommets][j + 1] primNoV:[self sommets][z] ultNoV:[self sommets][j]]];
                    cont++;
                    
                }
                else
                {
                    NJSegment *Jackpot = [[NJSegment alloc] jackpotToque:toque Poly:self Sommets:[self sommets] ultVisto:b sigVisto:j+1 primNoV:z ultNoV:j];
                    NJPoint* p1 = [toque prolongarProl:[self sommets][b] Corte:[Jackpot p1] Max:[Jackpot p2]];
                    NJPoint* p2 = [toque prolongarProl:[self sommets][j+1] Corte:[Jackpot p1] Max:[Jackpot p2]];
                    
                    [p1 setTag: [tool tag]];
                    [p2 setTag: [tool tag]];
                    
                    sommvisi[cont] = p1;
                    cont++;
                    [self setNuevosVerts: [p1 insertPostSommets: [self nuevosVerts] post:[Jackpot p1]]];
                    sommvisi[cont] = p2;
                    cont++;
                    [self setNuevosVerts: [p2 insertPreSommets: [self nuevosVerts] pre:[Jackpot p2]]];
                }
                
            }
            
            if (j + 1 == count)
            {
                
                if (![puntosvisi[j] boolValue])
                {
                    
                    NJPoint* prueba = [toque prolongarUltVisto:[self sommets][b] sigVisto:[self sommets][0] primNov:[self sommets][z] ultNov:[self sommets][j]];
                    
                    if([prueba comprobarUltVisto:[self sommets][b] Toque:toque sigVisto:[self sommets][0] primNov:[self sommets][z] ultNov:[self sommets][j]])
                    {
                        sommvisi[cont] = prueba;
                        
                        [sommvisi[cont] setTag:[tool tag]];
                        
                        [self setNuevosVerts: [sommvisi[cont] actualizarSommets: [self nuevosVerts] toque:toque ultVisto:[self sommets][b] sigVisto:[self sommets][0] primNoV:[self sommets][z] ultNoV:[self sommets][j]]];
                        cont++;
                        
                    }
                    else
                    {
                        NJSegment *Jackpot = [[NJSegment  alloc ] jackpotToque:toque Poly: self Sommets:[self sommets] ultVisto:b sigVisto:j+1 primNoV:z ultNoV:j];
                        
                        NJPoint* p1 = [toque prolongarProl:[self sommets][b] Corte:[Jackpot p1] Max:[Jackpot p2]];
                        NJPoint* p2 = [toque prolongarProl:[self sommets][0] Corte:[Jackpot p1] Max:[Jackpot p2]];
                        
                        [p1 setTag:[tool tag]];
                        [p2 setTag:[tool tag]];
                        
                        sommvisi[cont] = p1;
                        cont++;
                        [self setNuevosVerts: [p1 insertPostSommets: [self nuevosVerts] post:[Jackpot p1]]];
                        sommvisi[cont] = p2;
                        cont++;
                        [self setNuevosVerts: [p2 insertPreSommets: [self nuevosVerts] pre:[Jackpot p2]]];
                    }
                    
                }
                
            }
            
            if ([puntosvisi[j] boolValue])
            {
                sommvisi[cont] = [self sommets][j];
                int inex = [[self nuevosVerts] indexOfObject:[self sommets][j]];
                NJPoint*probando = [[self nuevosVerts] objectAtIndex:inex];
                [probando setTag: [tool tag]];
                [self nuevosVerts][inex] = probando;
                cont++;
            }
            
        }

    }
    return sommvisi;

}

-(NJPolygon*) fusionPrimero:(NJPolygon*)primero segundo:(NJPolygon*)segundo
{
    primero.unoauno = YES;
    segundo.unoauno = YES;
    
    if (![(NJPoint*)([primero sommets][0]) isOutToque:[primero sommets][0] sommets:[segundo sommets]])
    {
        NJPoint *verifica = [primero sommets][0];
        [primero setSommets: [[primero sommets][0] girarVectorPrimero: [primero sommets] segundo:[segundo sommets]]]; 
        if([verifica isEqualTo:[primero sommets][0]])
        {
            return segundo;
        }
    }

    NSMutableArray* fusion = [NSMutableArray array];
    NJSegment *actual = [NJSegment segmentWithP1:[primero sommets][0] P2:[primero sommets][1]];

    primero.usar = NO;
    segundo.usar = YES;
    NJPoint* verifica;
    
    do{
        NSLog(@"doWhile Fusion, %@", [[actual p1] toString] );
        verifica = [actual p1];
        
        actual = [actual darSiguientePrimero:primero segundo:segundo];
        if(![verifica isEqualTo:[actual p1]])
        {
            [fusion addObject:[actual p1]];
        }
        
    }while(![[actual p1] isEqualTo:[primero sommets][0]]);
    
    if( primero.unoauno == NO )
    {
        return [NJPolygon poligonoWithSommets:fusion Libre:NO];
    }

    return [NJPolygon poligonoWithSommets:fusion Libre:primero.libre];
}

-(float) area
{
    float pos = 0, neg = 0;
    int count = self.sommets.count;
    
    for (int i = 0; i < count; i++)
    {
        if ( i == count - 1 )
        {
            pos += ((NJPoint*)self.sommets[i]).x * ((NJPoint*)self.sommets[0]).y;
            neg += ((NJPoint*)self.sommets[i]).y * ((NJPoint*)self.sommets[0]).x;
        }
        else
        {
            pos += ((NJPoint*)self.sommets[i]).x *((NJPoint*)self.sommets[i+1]).y;
            neg += ((NJPoint*)self.sommets[i]).y * ((NJPoint*)self.sommets[i+1]).x;
        }
    }
    
    return fabsf(0.5*(pos-neg));
}


+(NSMutableDictionary*) masterPolvisis:(NSMutableDictionary*)polvisisDict
{
    NSDate *initDate = [NSDate date];
    
    NSMutableArray* finalList=[NSMutableArray array];
    NSMutableArray *polvisis = [NSMutableArray array];
    NJPolygon *comparator;
    int count = [polvisisDict count];
    for ( int i = 0; i < count; i++ )
    {
        id obj = [polvisisDict objectForKey:[NSString stringWithFormat:@"%d",i]];
        bool yesno = !([obj class] == [[NSNumber numberWithInt:1] class]);

        if ( yesno && obj )
        {
            [polvisis addObject:obj];
        }
    }
    polvisisDict = nil;
    while( (int)[polvisis count] > 1 )
    {
        NSLog(@"while: MasterPolvisis");
        comparator = [polvisis objectAtIndex:0];
        [polvisis removeObjectAtIndex:0];
        polvisis = [comparator compararPolvisis:polvisis];
        if(comparator.libre)
        {
            [finalList addObject:comparator];
        }
        else
        {
            comparator.libre = YES;
            comparator.unoauno = YES;
            [polvisis insertObject:comparator atIndex:0];
        }
    }
    
    if([polvisis count] == 1)  [finalList addObject:polvisis[0]];
    
    polvisisDict = [NSMutableDictionary dictionary];
    count = [finalList count];
    NSLog(@"Time: %f s", [[NSDate date] timeIntervalSinceDate:initDate]);

    for ( int k = 0; k < count; k++ )
    {
        [polvisisDict setValue:finalList[k] forKey:[NSString stringWithFormat:@"%d",k]];
    }

    NSLog(@"Time: %f s", [[NSDate date] timeIntervalSinceDate:initDate]);
    return polvisisDict;
}

-(NSMutableArray*) compararPolvisis:(NSMutableArray*)polvisis
{
    for(int i=0 ; i < (int)[polvisis count] ; i++){
        self.sommets = [polvisis[i] fusionPrimero:self segundo: polvisis[i]].sommets;
        if(!((NJPolygon*)(polvisis[i])).unoauno)
        {
            [polvisis removeObjectAtIndex:i];
        }
    }

    return polvisis;
}

@end
