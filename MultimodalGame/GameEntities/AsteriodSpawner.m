//
//  AsteriodSpawner.m
//  MultimodalGame
//
//  Created by ChrisMac on 14/01/2017.
//  Copyright © 2017 MUNRO, CHRISTOPHER. All rights reserved.
//

#import "AsteriodSpawner.h"

@interface AsteriodSpawner(){
    
    Asteriod *asteriod;
    int idx;
    int size;
    
}
@end

@implementation AsteriodSpawner

-(id)init{
    if(self == [super init]){
        //Do initization
    }
    
    idx = 0;
    
    _asteriods = [[NSMutableArray alloc] init];
    
    _finishedSpawning = false;
    _reset = true;
    
    return self;
}

-(void)createAsteriodArray:(int)asteriodCount{
    [self.asteriods removeAllObjects];
    self.asteriods = [NSMutableArray arrayWithCapacity:asteriodCount];
    
    float x = self.position.x;
    float y = self.position.y;

    for(unsigned int i = 0; i < asteriodCount; i++){

        Asteriod *tempAsteriod = [Asteriod node];
        
        x = x + arc4random() % 10;
        y = y + arc4random() % 10;
        
        tempAsteriod.position = CGPointMake(x, y);
        
        [self.asteriods addObject:tempAsteriod];
    
        //[self addChild:_asteriods[i]];
    }
    
    size = asteriodCount;
    
}

-(void)update{
    
    if(idx > size - 1){
        idx = 0;
        //_finishedSpawning = true;
    }
    
    if(_reset == true){
        
        if(_frameCount > 210){
            
            [_asteriods[idx] setAsteriodRotation:0];
            [_asteriods[idx] setAsteriodSize:10];
            
            [self addChild:_asteriods[idx]];
            
            
            float randZValue = arc4random() % 150 + 40;
            randZValue = randZValue / 1000;
            
            NSLog(@"Rand Z: %f", randZValue);
            
            [_asteriods[idx] setZ:randZValue];
            
            [_asteriods[idx] setActive:true];

            idx++;
            _frameCount = 0;
            
            if(idx >= size){
                _reset = false;
                idx = 0;
                _frameCount = 0;
            }
            
        }
        
    }
    if(_active == true){
    
        for(unsigned int i = 0; i < size; i++){
            
            id tempAsteriod = _asteriods[i];
            
            [tempAsteriod update];
            
            if([tempAsteriod getZ] > 0.5){
                
                [tempAsteriod setActive:false];
                [tempAsteriod removeFromParent];
                
                if(i == size - 1){
                    _finishedSpawning = true;
                }
            }
            
            //Check if asteriod has health
            if([tempAsteriod health] <= 0){
                [tempAsteriod setActive:false];
                //[tempAsteriod removeFromParent];
            }
            
        }
    }
    
}


@end
