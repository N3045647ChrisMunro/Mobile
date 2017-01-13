//
//  Camera.h
//  MultimodalGame
//
//  Created by ChrisMac on 11/01/2017.
//  Copyright © 2017 MUNRO, CHRISTOPHER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Camera : SKNode

@property (nonatomic, readonly) float posX;
@property (nonatomic, readonly) float posY;

-(void)update: (CFTimeInterval) currentTime;

@end
