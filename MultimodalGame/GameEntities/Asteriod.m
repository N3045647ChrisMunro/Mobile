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
    
    float x, y, rotation, rotationIncrement, maxSize;
    
}
@end

@implementation Asteriod

-(id) init{
    if(self == [super init]){
        //Do initization...
        
        asteriod = [SKSpriteNode spriteNodeWithImageNamed:@"RedAsteriod"];
        
        [self addChild:asteriod];
        
    }
    
    _active = false;
    _asteriodSize = 0;
    _asteriodRotation = 0;
    _health = 10;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    x = 10;
    y = 10;
    maxSize = 100;
    rotation = 0;
    rotationIncrement = arc4random() % 5 + 1;
    rotationIncrement = rotationIncrement / 100; // devide by 100 to get a range of 0.01 - 0.05;
    
    asteriod.size = CGSizeMake(x, y);
    return self;
    
}

-(void)update{
    
    if(_active == true){
    
        _asteriodSize += 0.25;
        asteriod.size = CGSizeMake(_asteriodSize, _asteriodSize);
        
        if(asteriod.size.width > maxSize || asteriod.size.height > maxSize){
            asteriod.size = CGSizeMake(maxSize, maxSize);
        }
    
        _asteriodRotation += rotationIncrement;
        asteriod.zRotation = _asteriodRotation;

        //Move the asteriod
        const float eyePos_ = 150.0;
         
        const float pos_X = ((eyePos_ * ([asteriod position].x - (height / 2))) / (eyePos_ + self.z) + (height / 2));
         
        const float pos_Y = ((eyePos_ * ([asteriod position].y - (width / 2))) / (eyePos_ + self.z) + (width / 2));
         
        self.z -= 0.01;
    
    
        if(x > 100.0 && y > 100.0){
            x = 100.0;
            y = 100.0;
        }
        asteriod.position = CGPointMake(pos_X, pos_Y);
    }else{
        //Move the asteriod out of view, instead of removing from parent
        asteriod.position = CGPointMake(-2000, 0);
        //Rester the size
        asteriod.size = CGSizeMake(10, 10);
        self.z = 0;
    }
    
    if(_health <= 0){
        //Move the asteriod out of view, instead of removing from parent
        asteriod.position = CGPointMake(-2000, 0);
        //Rester the size
        asteriod.size = CGSizeMake(10, 10);
    }
    
}

-(CGPoint)getAsteriodPos{
    
    return asteriod.position;
    
}

-(void)setAsteriodPos:(CGPoint)pos{
    
    asteriod.position = pos;
    
}

-(void)dealDamage:(int)amount{
    
    _health -= amount;
    
}

@end
