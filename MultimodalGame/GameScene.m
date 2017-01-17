//
//  GameScene.m
//  MultimodalGame
//
//  Created by MUNRO, CHRISTOPHER on 28/11/2016.
//  Copyright © 2016 MUNRO, CHRISTOPHER. All rights reserved.
//

#import "GameScene.h"
#import <CoreMotion/CoreMotion.h>

#import "Asteriod.h"
#import "Camera.h"
#import "AsteriodSpawner.h"
#import "Bullet.h"

@interface GameScene()
    @property (nonatomic) SKSpriteNode *crosshair;
    @property (nonatomic) SKSpriteNode *gameBG;
    @property (nonatomic) AsteriodSpawner *asteriodsSpawner;
    @property (nonatomic) Bullet *bullet;
    @property (strong, nonatomic) NSMutableArray *bullets;
    @property (strong, nonatomic) CMMotionManager *motionManager;
    @property (strong, nonatomic) CMDeviceMotion *deviceMotion;

@end

@interface  GameScene(){
    SKNode *world;
    Camera *camera;
    Asteriod* asteriod;
    
    float width;
    float height;
    
    int bulletIDX;
    int numOfBullets;
}
@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    
    // Setup the world node
    world = [SKNode node];
    [self addChild:world];
    
    //Setup the Camera
    camera = [Camera node];
    camera.name = @"Cameraa";
    [world addChild:camera];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    // Setup the scene
    self.backgroundColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.gameBG = [SKSpriteNode spriteNodeWithImageNamed:@"GameBackground"];
    self.gameBG.anchorPoint = CGPointMake(0.5, 0.5);
    [camera addChild:_gameBG];
    
    // Setup the crosshair
    self.crosshair = [SKSpriteNode spriteNodeWithImageNamed:@"Crosshair"];
    self.crosshair.anchorPoint = CGPointMake(0.5, 0.5);
    self.crosshair.position = CGPointMake(0, 0);
    self.crosshair.name = @"Crosshair";
    [camera addChild:_crosshair];
    
    // Set up the Asteriods
    _asteriodsSpawner = [AsteriodSpawner node];
    
    [_asteriodsSpawner createAsteriodArray:5];
    _asteriodsSpawner.position = CGPointMake(0, 0);
    [_asteriodsSpawner setActive:true];
    [_asteriodsSpawner setReset:true];
    
    [camera addChild:_asteriodsSpawner];
    
    //_bullet = [Bullet node];
    //[camera addChild:_bullet];
    
    _bullets = [[NSMutableArray alloc] init];
    numOfBullets = 10;
    _bullets = [NSMutableArray arrayWithCapacity:numOfBullets];
    
    for(unsigned int i = 0; i < numOfBullets; i++){
        
        Bullet *tempBullet = [Bullet node];
        _bullets[i] = tempBullet;
        [camera addChild:_bullets[i]];
        
    }
    
    bulletIDX = 0;
    
}



-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    _crosshair.position = CGPointMake(camera.posX, camera.posY + (height / 2));
    
    // Update the Game Entities
    [camera update:currentTime];
    //[asteriod update];
    [_asteriodsSpawner update];
    
    //Update bullets
    for(id b in _bullets){
        
        [b update];
        
    }
    
    //Check to see if a bullet 'hit' an asteriod;
    for(unsigned int i = 0; i < numOfBullets; i++){
        
        Bullet *tempBullet = _bullets[i];
        if([tempBullet isActive] == true){
            
            NSMutableArray *tempArray = [_asteriodsSpawner asteriods];
            NSUInteger count = [tempArray count];
            for(unsigned int j = 0; j < count; j++){
                
                if([tempArray[j] isActive] == true){
                    
                    float t_x = [tempArray[j] getAsteriodPos].x;
                    float t_y = [tempArray[j] getAsteriodPos].y;
                    
                    int dx = fabs(t_x - tempBullet.position.x);
                    int dy = fabs(t_y - tempBullet.position.y);
                    
                    if(dx < 75 && dy < 75){
                        
                        //[_asteriodsSpawner ]
                        NSLog(@"hit Asteriod");
                        
                        //Apply Damage to asteriod
                        [[_asteriodsSpawner asteriods][j] dealDamage:5];
                        
                        //Remove bullet
                        [_bullets[i] setActive:false];
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

-(void)didFinishUpdate
{
    [self centerNode:_crosshair];
    camera.frameCount++;
    _asteriodsSpawner.frameCount++;
    
    if([_asteriodsSpawner isFinishedSpawning] == true && [_asteriodsSpawner reset] == false){
        
        //Pick a new spawn Loaction
        float randX = arc4random() % 2000;
        randX = randX - 1000;
        
        float randY = arc4random() % 1200;
        randY = randY - 1000;
        _asteriodsSpawner.position = CGPointMake(randX, randY);
        [_asteriodsSpawner setFinishedSpawning:false];
        [_asteriodsSpawner setReset:true];
        
        //NSLog(@"X: %f, Y: %f", randX, randY);
        camera.posX = randX;
        camera.posY = randY;
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    const float xPos = camera.posX;
    const float yPos = camera.posY - 100;
    
    CGPoint startPos = CGPointMake(xPos, yPos);
    
    //find the next avaible bullet in the array, and shoot it
    for(unsigned int i = 0; i < numOfBullets; i++){
        if([_bullets[i] isActive] == false){
            [_bullets[i] shoot:startPos targetPos:_crosshair.position];
            break;
        }
    }
    
}

-(void) centerNode: (SKNode *)node
{
    CGPoint cameraScenePosition = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraScenePosition.x, node.parent.position.y - cameraScenePosition.y);
}

@end
