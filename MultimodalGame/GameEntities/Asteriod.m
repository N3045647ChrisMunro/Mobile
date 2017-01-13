//
//  Asteriod.m
//  MultimodalGame
//
//  Created by MUNRO, CHRISTOPHER on 10/12/2016.
//  Copyright © 2016 MUNRO, CHRISTOPHER. All rights reserved.
//

#import "Asteriod.h"

@interface Asteriod(){
 
    SKSpriteNode* asteriod;
    float width, height;
    
    float x, y, rotation, rotationIncrement;
    
}
@end

@implementation Asteriod

-(id) init{
    if(self == [super init]){
        //Do initization...
        
        asteriod = [SKSpriteNode spriteNodeWithImageNamed:@"RedAsteroid"];
        
        [self addChild:asteriod];
        
    }
    
    _active = false;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    x = 10;
    y = 10;
    rotation = 0;
    rotationIncrement = arc4random() % 5 + 1;
    rotationIncrement = rotationIncrement / 100; // devide by 100 to get a range of 0.01 - 0.05;
    
    asteriod.size = CGSizeMake(x, y);
    
    return self;
    
}

-(void)update{
    
    if(_active == true){
    
        x += 0.25;
        y += 0.25;
        asteriod.size = CGSizeMake(x, y);
    
        rotation += rotationIncrement;
        asteriod.zRotation = rotation;

        
        //Move the asteriod
        const float eyePos_ = 150.0;
         
        const float pos_X = ((eyePos_ * ([asteriod position].x - (height / 2))) / (eyePos_ + self.z) + (height / 2));
         
        const float pos_Y = ((eyePos_ * ([asteriod position].y - (width / 2))) / (eyePos_ + self.z) + (width / 2));
         
        self.z += 0.001;
    
    
        if(x > 100.0 && y > 100.0){
            x = 100.0;
            y = 100.0;
        }
       
        asteriod.position = CGPointMake(pos_X, pos_Y);
    }
}

@end
