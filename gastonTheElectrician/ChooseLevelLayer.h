//
//  ChooseLevelLayer.h
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 06/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameInterfaceLayer.h"
#import "ChooseGameModeLayer.h"
#import "NJLevelPages.h"
@class NJLevelPages;
@interface ChooseLevelLayer : CCLayer
{
    int plus;
    NJLevelPages* levelChooserPages;
    CCSprite* puntitos;
}
+(CCScene*)scene;
-(void) makeTransition:(id)sender;

@end
