//
//  ChooseGameModeLayer.h
//  GastonK2D
//
//  Created by Juan Jacobo Montero Muñoz on 27/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ChooseLevelLayer.h"
#import "IntroLayer.h"

@interface ChooseGameModeLayer : CCLayer

+(CCScene *) scene;
-(void)makeTransition:(id)sender;
@end
