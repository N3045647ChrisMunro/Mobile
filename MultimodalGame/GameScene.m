//
//  GameScene.m
//  MultimodalGame
//
//  Created by MUNRO, CHRISTOPHER on 28/11/2016.
//  Copyright © 2016 MUNRO, CHRISTOPHER. All rights reserved.
//

#import "GameScene.h"
#import <CoreMotion/CoreMotion.h>
#import "GameViewController.h"

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
    @property (strong, nonatomic) NSMutableArray *asteriodsArray;
    @property (strong, nonatomic) CMMotionManager *motionManager;
    @property (strong, nonatomic) CMDeviceMotion *deviceMotion;

@end

@interface  GameScene(){
    SKNode *world;
    Camera *camera;
    Asteriod* asteriod;
    
    float width;
    float height;
    
    int frameCount; //For time controlled events (Spawning)
    
    int bulletIDX;
    int numOfBullets;
    
    int asteriodIDX; //To track the asteriods array to know which asteriod to spawn next
    int numOfAsteriods;
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
    frameCount = 0;
    
    // Setup the scene
    self.backgroundColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.gameBG = [SKSpriteNode spriteNodeWithImageNamed:@"GameBackground"];
    self.gameBG.size = CGSizeMake(width * 2, height + 50);
    self.gameBG.anchorPoint = CGPointMake(0.5, 0.5);
    self.gameBG.position = CGPointMake(0, height / 2);
    [camera addChild:_gameBG];
    
    // Set up the Asteriods
    _asteriodsSpawner = [AsteriodSpawner node];
    
    [_asteriodsSpawner createAsteriodArray:5];
    _asteriodsSpawner.position = CGPointMake(0, 0);
    [_asteriodsSpawner setActive:true];
    [_asteriodsSpawner setReset:true];
    
    [camera addChild:_asteriodsSpawner];
    

    // Create and setup the Asteriods array
    _asteriodsArray = [[NSMutableArray alloc] init];
    numOfAsteriods = 25; //Max number of possible asteriods to be 'active' at once
    _asteriodsArray = [NSMutableArray arrayWithCapacity:numOfAsteriods];
    
    for(unsigned int i = 0; i < numOfAsteriods; i++){
        
        Asteriod *tmpAsteriod = [Asteriod node];
        _asteriodsArray[i] = tmpAsteriod;
        [camera addChild:_asteriodsArray[i]];
        
    }
    
    
    //Create and setup the Bullets array
    _bullets = [[NSMutableArray alloc] init];
    numOfBullets = 10;
    _bullets = [NSMutableArray arrayWithCapacity:numOfBullets];
    
    for(unsigned int i = 0; i < numOfBullets; i++){
        
        Bullet *tempBullet = [Bullet node];
        [tempBullet setActive:false];
        _bullets[i] = tempBullet;
        [camera addChild:_bullets[i]];
        
    }
    bulletIDX = 0;
    
    // Setup the crosshair
    self.crosshair = [SKSpriteNode spriteNodeWithImageNamed:@"Crosshair"];
    self.crosshair.anchorPoint = CGPointMake(0.5, 0.5);
    self.crosshair.position = CGPointMake(0, 0);
    self.crosshair.name = @"Crosshair";
    [camera addChild:_crosshair];
    
    camera.position = CGPointMake(0, 0);
    
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    _crosshair.position = CGPointMake(camera.posX, camera.posY + (height / 2));
    
    // Update the Game Entities
    [camera update:currentTime];
    //[asteriod update];
    //[_asteriodsSpawner update];
    
    //Update bullets
    for(id b in _bullets){
        
        [b update];
        
    }
    
    //Update Asteriods
    for(id a in _asteriodsArray){
        [a update];
        
        if([a getZ] > 0.65){
            [a setActive:false];
        }
        
    }
    
    //the frames are counted, to act as a timer for the game
    if(frameCount > 210){
        
        [_asteriodsArray[asteriodIDX] setActive:true];
        CGPoint pos = CGPointMake(0, 0);
        [_asteriodsArray[asteriodIDX] setAsteriodPos:pos];
        
        asteriodIDX++;
        frameCount = 0;
        
    }
    
    //Check to see if a bullet 'hit' an asteriod;
    for(unsigned int i = 0; i < numOfBullets; i++){
        
        Bullet *tempBullet = _bullets[i];
        if([tempBullet isActive] == true){
            
            for(unsigned int j = 0; j < numOfAsteriods; j++){
                
                Asteriod *tempAsteriod = _asteriodsArray[j];
                if([tempAsteriod isActive] == true){
                    
                    CGPoint a = [tempAsteriod getAsteriodPos];
                    
                    if([tempBullet containsPoint:a] && [tempAsteriod getZ] > 0.35){
                        //Apply Damage to asteriod
                        [_asteriodsArray[j] dealDamage:5];
                        
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
    frameCount++;
    camera.frameCount++;
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
