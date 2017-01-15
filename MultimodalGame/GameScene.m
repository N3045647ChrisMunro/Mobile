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

@interface GameScene()
    @property (nonatomic) SKSpriteNode *crosshair;
    @property (nonatomic) SKSpriteNode *gameBG;
    @property (nonatomic) AsteriodSpawner *asteriodsSpawner;
    @property (strong, nonatomic) CMMotionManager *motionManager;
    @property (strong, nonatomic) CMDeviceMotion *deviceMotion;

@end

@interface  GameScene(){
    SKNode *world;
    Camera *camera;
    Asteriod* asteriod;
    
    float width;
    float height;
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
    
    [camera addChild:_asteriodsSpawner];
    /*
    asteriod = [Asteriod node];
    
    [asteriod setZ:-0.100];
    
    asteriod.position = CGPointMake(0, 0);
    [asteriod setActive:true];
    [camera addChild:asteriod];
    */
}



-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    _crosshair.position = CGPointMake(camera.posX, camera.posY + (height / 2));
    
    // Update the Game Entities
    [camera update:currentTime];
    //[asteriod update];
    [_asteriodsSpawner update];
    
}

-(void)didFinishUpdate
{
    [self centerNode:_crosshair];
    camera.frameCount++;
    _asteriodsSpawner.frameCount++;
}

-(void) centerNode: (SKNode *)node
{
    CGPoint cameraScenePosition = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraScenePosition.x, node.parent.position.y - cameraScenePosition.y);
}

@end
