//
//  Camera.h
//  MultimodalGame
//
//  Created by ChrisMac on 11/01/2017.
//  Copyright © 2017 MUNRO, CHRISTOPHER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Camera : SKNode

@property (nonatomic, readwrite) float posX;
@property (nonatomic, readwrite) float posY;
@property (nonatomic, readwrite) int frameCount;

-(void)update: (CFTimeInterval) currentTime;

@end
