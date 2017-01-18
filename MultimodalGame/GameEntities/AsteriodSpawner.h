//
//  AsteriodSpawner.h
//  MultimodalGame
//
//  Created by ChrisMac on 14/01/2017.
//  Copyright © 2017 MUNRO, CHRISTOPHER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Asteriod.h"

@interface AsteriodSpawner : SKNode

@property (strong, nonatomic, readwrite) NSMutableArray *asteriods;
@property (nonatomic, readwrite, getter=isActive, setter=setActive:) bool active;
@property (nonatomic, readwrite) int frameCount;
@property (nonatomic, readwrite, getter=isFinishedSpawning) bool finishedSpawning;
@property (nonatomic, readwrite) bool reset;


-(void) createAsteriodArray: (int)asteriodCount;
-(void) update;

@end
