//
//  Asteriod.h
//  MultimodalGame
//
//  Created by MUNRO, CHRISTOPHER on 10/12/2016.
//  Copyright © 2016 MUNRO, CHRISTOPHER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>



@interface Asteriod : SKNode

@property (nonatomic, readwrite) float z;
@property (nonatomic, readwrite, getter=isActive) bool active;

-(void)update;

@end
