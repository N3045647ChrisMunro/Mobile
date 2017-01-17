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

    float restingGyroXpos;
    float gyroXdifference;
    
}
@end

@implementation Camera

-(id) init{
    if(self == [super init]){
        //Do initization...
    }
    
    _posX = 0;
    _posY = 0;
    _frameCount = 280;
    
    restingGyroXpos = 0; //This will be updated every 3 seconds (180frames)
    gyroXdifference = 0; //This will be the difference between restingGyroXpos - GyroXpos (Current gyro x value)
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    // Set up the Coremotion manager
    self.motionManager = [[CMMotionManager alloc] init];
    [_motionManager startDeviceMotionUpdates];
    [_motionManager setDeviceMotionUpdateInterval:1.0/60.0];
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
    
    if(_frameCount > 300){
        restingGyroXpos = gyroX;
        _frameCount = 0;
    }
    
    //NSLog(@"GyroX: %f GyroY: %f GyroZ: %f", gyroX, gyroY, gyroZ);
    
    // Move the Camera node in relation to the accelerometer data
    _posX = _posX + (accelY * width * 0.25);
    _posY = _posY + (-accelX * height * 0.25);
    
    // Speed up the camera movement with gyroscope assist (tilt)
    if(gyroZ > 20){
        //NSLog(@"Speed Up Left");
        _posX += 7.5;
    }
    if(gyroZ < -20){
        //NSLog(@"Speed Up Right");
        _posX -= 7.5;
    }
    gyroXdifference = gyroX - restingGyroXpos;
    if(gyroXdifference > 20){
        _posY -= 7.5;
    }
    if(gyroXdifference < -20){
        _posY += 7.5;
    }
    
    [self detectTiltReload:gyroY];
    [self limitCameraToBounds];
    self.position = CGPointMake(_posX, _posY);
}

// Limit the camera so it doesnt go beyond the background image
-(void) limitCameraToBounds{
    
    //Check Horizonal bounds
    if(_posX + (width / 2) >= 750){
        _posX = 750 - (width / 2);
    }
    else if (_posX - (width / 2) <= -750){
        _posX = -750 + (width / 2);
    }
    
    //Check Vertical bounds
    if(_posY + (height /2) >= 458){
        _posY = 458 - (height / 2);
    }
    else if (_posY - (height / 2) <= -458){
        _posY = -458 + (height / 2);
    }
    
}

-(void)detectTiltReload: (float)gyroYval{
    
    if(gyroYval > 12.0 || gyroYval < -12.0){
        NSLog(@"Reload Gun");
    }
    
}

@end
