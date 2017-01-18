//
//  Bullet.m
//  MultimodalGame
//
//  Created by ChrisMac on 17/01/2017.
//  Copyright © 2017 MUNRO, CHRISTOPHER. All rights reserved.
//

#import "Bullet.h"
@interface Bullet(){

    SKSpriteNode* bullet;
    CGPoint bulletTargetPos;
}
@end

@implementation Bullet

-(id) init{
    
    if(self == [super init]){
        //Do initialization...
        
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"LaserBullet"];
        
        [self addChild:bullet];
    }
    
    bullet.position = CGPointMake(3000, 0);
    bullet.size = CGSizeMake(bullet.size.width * 2, bullet.size.height * 2);
    
    return self;
}

-(void)update{
    
    if(_active == true){
        
        //check if the bullet reached it's desternation
        if(bullet.position.x == bulletTargetPos.x && bullet.position.y == bulletTargetPos.y){
            
            //Move the bullet out of view, i dont want to remove it as a child just to
            // 'de-render' it
            bullet.position = CGPointMake(3000, 0);
            _active = false;
            
        }
        
    }else{
        //Move the bullet out of bounds
        bullet.position = CGPointMake(3000, 0);
    }
    
}

-(void)shoot:(CGPoint)startPos targetPos:(CGPoint) targetPos{
    
    _active = true;
    
    bulletTargetPos = targetPos;
    bullet.position = startPos; // This will be a pos slightly below the bottom of the screen
    
    SKAction *action = [SKAction moveTo:targetPos duration:1.2];
    
    [bullet runAction:action];
}

@end
