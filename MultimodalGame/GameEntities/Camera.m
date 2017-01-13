//
//  Camera.m
//  MultimodalGame
//
//  Created by ChrisMac on 11/01/2017.
//  Copyright © 2017 MUNRO, CHRISTOPHER. All rights reserved.
//

#import "Camera.h"
#import <CoreMotion/CoreMotion.h>


@interface Camera()

    @property (strong, nonatomic) CMMotionManager *motionManager;
    @property (strong, nonatomic) CMDeviceMotion *deviceMotion;

@end

@interface Camera(){

    float width;
    float height;

}
@end

@implementation Camera

-(id) init{
    if(self == [super init]){
        //Do initization...
    }
    
    _posX = 0;
    _posY = 0;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    // Set up the Coremotion manager
    self.motionManager = [[CMMotionManager alloc] init];
    [_motionManager startDeviceMotionUpdates];
    [_motionManager setDeviceMotionUpdateInterval:1.0/30.0];
    self.deviceMotion = _motionManager.deviceMotion;
    
    if([_motionManager isAccelerometerAvailable] == YES){
        // Do nothing
    }
    else{
        NSLog(@"NOT AVAILABLE");
    }
    
    
    
    return self;
}

-(void)update: (CFTimeInterval) currentTime{
    
    CMDeviceMotion *currentDeviceMotion = _motionManager.deviceMotion;
    
    float accelX = (float)currentDeviceMotion.userAcceleration.x;
    float accelY = (float)currentDeviceMotion.userAcceleration.y;
    float accelZ = (float)currentDeviceMotion.userAcceleration.z;
    
    double gyroX = currentDeviceMotion.attitude.roll; // This returns radians
    double gyroY = currentDeviceMotion.attitude.pitch;
    double gyroZ = currentDeviceMotion.attitude.yaw;
    
    // Convert the radians to degrees
    gyroX = gyroX * (180 / M_PI);
    gyroY = gyroY * (180 / M_PI);
    gyroZ = gyroZ * (180 / M_PI);
    
    // Move the Camera node in relation to the accelerometer data
    _posX = _posX + (accelY * width * 0.25);
    _posY = _posY + (-accelX * height * 0.25);
    
    NSLog(@"GyroX: %f", currentTime);
    
    // Speed up the camera movement with gyroscope assist (tilt)
    if(gyroZ > 20){
        //NSLog(@"Speed Up Left");
        _posX += 7.5;
    }
    if(gyroZ < -20){
        //NSLog(@"Speed Up Right");
        _posX -= 7.5;
    }
    
    [self limitCameraToBounds];
    self.position = CGPointMake(_posX, _posY);
}

// Limit the camera so it doesnt go beyond the background image
-(void) limitCameraToBounds{
    
    //Check Horizonal bounds
    if(_posX + (width / 2) >= 1260){
        _posX = 1260 - (width / 2);
    }
    else if (_posX - (width / 2) <= -1260){
        _posX = -1260 + (width / 2);
    }
    
    //Check Vertical bounds
    if(_posY + (height /2) >= 800){
        _posY = 800 - (height / 2);
    }
    else if (_posY - (height / 2) <= -800){
        _posY = -800 + (height / 2);
    }
    
}

@end
