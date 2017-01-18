//
//  Asteriod.h
//  MultimodalGame
//
//  Created by MUNRO, CHRISTOPHER on 10/12/2016.
//  Copyright © 2016 MUNRO, CHRISTOPHER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>



@interface Asteriod : SKNode

@property (nonatomic, readwrite, getter=getZ) float z;
@property (nonatomic, readwrite, getter=isActive) bool active;

@property (nonatomic, readwrite) float asteriodSize;
@property (nonatomic, readwrite) float asteriodRotation;
@property (nonatomic, readwrite) int health;

-(void)update;
-(CGPoint)getAsteriodPos;
-(void)setAsteriodPos:(CGPoint)pos;

-(void)dealDamage :(int)amount;

@end
