//
//  GameLayer.m
//  Gaston
//
//  Created by Juan Jacobo Montero Muñoz on 02/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#define NJTraduccion(key) \
NSLocalizedString( (key), nil)

@implementation GameLayer
@synthesize points,numPoints;
@synthesize polvisisLayer;

+(CCScene*) sceneWithLevel:(int)lvl
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	CGSize size = [[CCDirector sharedDirector] winSize];
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer nodeWithLevel:lvl];
	GameInterfaceLayer *interfaceLayer = [GameInterfaceLayer node];
    plus = 0;
    if(size.height > 480) plus = 44;
    layer.position = ccp(0, plus);
    interfaceLayer.position = ccp(0, plus);
	// add layer as a child to scene
	[scene addChild: layer];
	[scene addChild: interfaceLayer];
    
	// return the scene
	return scene;
}

+(id) nodeWithLevel:(int)lvl
{
    return [[self alloc] initWithLevel:lvl];
}

-(void) dibujaPolvisi:(CGPoint)toque Tool:(CCTool *)tool Refrescar:(BOOL)refrescar
{
    NJPolygon *tocho = [NJPolygon poligonoWithSommets:polyg];
    polyg2 = [tocho polvisiToque:[NJPoint pointWithX:toque.x andY:toque.y] Tool:tool];
    
    if (polvisacos == nil )
        polvisacos = [NSMutableDictionary dictionary];
    
    [polvisacos setValue:[NJPolygon poligonoWithSommets:polyg2] forKey:[NSString stringWithFormat:@"%d", tool.tag-1]];
    CCTexture2D *texture2D = [[CCTextureCache sharedTextureCache] addImage:@"backgroundLightWood1024x1024.png"];
    PRFilledPolygon *pasapo = [[PRFilledPolygon alloc] initWithPoints:polyg2 andTexture:texture2D];
    [polvisisLayer addChild:pasapo z:2 tag:tool.tag];
}

-(void) porcentajeAreaTotal
{
    NJPolygon *tocho = [NJPolygon poligonoWithSommets: polyg];
    float areaTocho = [tocho area];
    float areaDePolvisis = 0;
    
    polvisacos = [NJPolygon masterPolvisis:polvisacos];

    int count = [polvisacos count];
    for(int i = 0; i < count; i++)
    {
        areaDePolvisis += [[polvisacos objectForKey:[NSString stringWithFormat:@"%d",i]] area];
        //NSLog(@"Poligono numero %d th con %d puntos y %.2f px2", i+1, (int)[[polvisacos[i] sommets] count], [polvisacos[i] area]);
    }
    [NSThread sleepForTimeInterval:1.0f];
    float porcentajeAreaTotal = (areaDePolvisis / areaTocho) * 100;
dispatch_sync(dispatch_get_main_queue(), ^{
    
    if( level != 999)
    {
        if( porcentajeAreaTotal >= 87 )
        {
            [self saveScore:porcentajeAreaTotal andPower:3];
            [((GameInterfaceLayer*)([self.parent getChildByTag:111])) pauseMenu:1 porcentaje:porcentajeAreaTotal];
        }
        else if( porcentajeAreaTotal >= 70 )
        {
            [self saveScore:porcentajeAreaTotal andPower:2];
            [((GameInterfaceLayer*)([self.parent getChildByTag:111])) pauseMenu:2 porcentaje:porcentajeAreaTotal];
        }
        else if( porcentajeAreaTotal >= 60 )
        {
            [self saveScore:porcentajeAreaTotal andPower:1];
            [((GameInterfaceLayer*)([self.parent getChildByTag:111])) pauseMenu:3 porcentaje:porcentajeAreaTotal];
        }
        else
        {
            [self saveScore:porcentajeAreaTotal andPower:0];
            [((GameInterfaceLayer*)([self.parent getChildByTag:111])) pauseMenu:4 porcentaje:porcentajeAreaTotal];
        }
    }
    else
    {
        int score = 10000+1000*([self angulosMayores180] - [polyg count])+porcentajeAreaTotal*23;
        [self saveScore:score andPower:0];
        
        [((GameInterfaceLayer*)([self.parent getChildByTag:111])) pauseMenu:1 porcentaje:score];
    }
});
    }

-(int) angulosMayores180
{
    int n = 0;
    int count = [polyg count];
    int next = 1;
    int prochain = 2;
    NJPolygon *poligono = [NJPolygon poligonoWithSommets:polyg];
    
    for (int i = 0; i < count; i++)
    {
        next = i+1;
        if ( next == count ) next = 0;
        prochain = next + 1;
        if ( prochain == count ) prochain = 0;
        
        NJSegment *segmento1 = [NJSegment segmentWithP1:poligono.sommets[i] P2:poligono.sommets[next]];
        NJSegment *segmento2 = [NJSegment segmentWithP1:poligono.sommets[next] P2:poligono.sommets[prochain]];
        
        float thetaAnt = [segmento1.p1 anguloHorizontalCentro:segmento1.p2];
        float thetaNext = [segmento2.p2 anguloHorizontalCentro:segmento2.p1];
        
        if(fabs(thetaNext - thetaAnt) > 180)
        {
            n++;
        }
    }
    return n;
}

-(void) saveScore:(int)puntos andPower:(int)power
{
    puntosGlobal = puntos;
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"puntosLevel%d",level+1]] <= puntos )
    {
        [[NSUserDefaults standardUserDefaults] setInteger:puntos forKey:[NSString stringWithFormat:@"puntosLevel%d",level+1]];
        [[NSUserDefaults standardUserDefaults] setInteger:power forKey:[NSString stringWithFormat:@"powerLevel%d",level+1]];
        if(puntos >= 60)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"completed%d",level+1]];
        }
    }
}

-(void) loadScoreAndPower
{
    
    //NSLog(@"Puntos: %d", [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"puntosLevel%d",level+1]]);
    //NSLog(@"Score: %d", [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"powerLevel%d",level+1]]);
    
}

-(id) initWithLevel:(int)lvl
{
    if(self = [super init])
    {
        //setLevel
        level = lvl;
        if ( level % 10 == 0 && level != 0 )
        {
            GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier:[NSString stringWithFormat:@"%d",level/10 + 1]];
            [achievement setPercentComplete:100];
            [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
                if(error) NSLog(@"%@",error); else [GKNotificationBanner showBannerWithTitle:NJTraduccion(@"ACHIEVREPORT") message:[NSString stringWithFormat:NJTraduccion(@"CONGRATULATIONSACHIEV"), level] completionHandler:nil];
            }];
        }
        //NSLog(@"LVL: %d", lvl);
        //size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //background
        CCSprite *bg = [CCSprite spriteWithFile:NJTraduccion(@"BGGAMESCREEN")];
        bg.position = ccp(size.width/2, 240);
        if(level != 999)[self addChild:bg z:0];
        
        //createPolygon
        [self elCreaPuntos];
        
        //drawPolygon
        CCTexture2D *texture2D = [[CCTextureCache sharedTextureCache] addImage:@"backgroundWood1024x1024.png"];
        PRFilledPolygon *poly = [[PRFilledPolygon alloc] initWithPoints:points andTexture:texture2D ];
        if(level != 999)[self addChild:poly z:1 tag:1];
        
        //polvisisLayer init
        polvisisLayer = [CCLayerColor node];
        if(level == 999)[self addChild:polvisisLayer z:1];
        
    }
    return self;
}

-(void) makeTransition:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[ChooseLevelLayer scene] withColor:ccBLACK]];
}

-(void) elCreaPuntos
{
    

    //DibujaContornos
    if(level != 999)
    {
        NSMutableArray *myArray;
        myArray = [NSMutableArray arrayWithArray:[(NSDictionary*)[NSDictionary dictionaryWithContentsOfFile:@"Levels.plist"] objectForKey:[NSString stringWithFormat:@"level%d",level+1]]];
        //myArray = [NSMutableArray arrayWithArray:[(NSDictionary*)[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://www.gastontheelectrician.com/recoverLevels/gastonLevels.plist"]] allValues][1]];
        maxBulbs = [[myArray lastObject] intValue];
        [myArray removeLastObject];
        polvisacos = nil;
        numPoints = [myArray count];
        points = [NSMutableArray array];
        polyg = [[NSMutableArray alloc] init];
        for(int i = 0; i < numPoints; i++)
        {
            polyg[i] = [NJPoint pointFromString:myArray[i]];
            points[i] = [NSValue valueWithCGPoint:CGPointFromString(myArray[i])];
            [polyg[i] setIni:YES];
        }
        
        NSMutableArray *spritesArray = [[NSMutableArray alloc] init];
        
        
        for(int i = 0; i < numPoints; i++)
        {
            CGPoint uno = CGPointFromString(myArray[i]);
            CGPoint dos;
            
            if(i < (int)[myArray count] - 1)
                dos = CGPointFromString(myArray[i+1]);
            else
                dos = CGPointFromString(myArray[0]);
            
            CGPoint diff = ccpSub(dos,uno );
            float rads = atan2f( diff.y, diff.x);
            float degs = -CC_RADIANS_TO_DEGREES(rads);
            float dist = ccpDistance(uno, dos);
            CCSprite *line = [CCSprite spriteWithFile:@"line.png"];
            [line setAnchorPoint:ccp(0.0f, 0.5f)];
            [line setPosition:uno];
            [line setScaleX:dist/4.5];
            [line setRotation: degs];
            spritesArray[i] = line;
            [self addChild:spritesArray[i] z:10+i];
        }
    }
    else
    {
        NJPolygon *pol = [NJPolygon poligono];
        points = [NSMutableArray array];
        polyg = [NSMutableArray array];
        numPoints = [pol.sommets count];
        polyg = pol.sommets;
        for(int i = 0; i < numPoints; i++)
        {
            NJPoint *point = pol.sommets[i];
            points[i] = [NSValue valueWithCGPoint:ccp(point.x, point.y)];
            [polyg[i] setIni:YES];
        }

    }
}

-(void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    [viewController dismissModalViewControllerAnimated:YES];
}

@end
