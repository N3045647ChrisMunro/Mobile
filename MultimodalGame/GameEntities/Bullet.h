//
//  Bullet.h
//  MultimodalGame
//
//  Created by ChrisMac on 17/01/2017.
//  Copyright © 2017 MUNRO, CHRISTOPHER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bullet : SKNode

@property (nonatomic, readwrite, getter=getZ) float z;
@property (nonatomic, readwrite, getter=isActive) bool active;

-(void) update;
-(void)shoot:(CGPoint)startPos targetPos:(CGPoint) targetPos;

-(BOOL)containsPoint:(CGPoint)p;

@end
