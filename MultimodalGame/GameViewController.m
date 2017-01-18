//
//  GameViewController.m
//  MultimodalGame
//
//  Created by MUNRO, CHRISTOPHER on 28/11/2016.
//  Copyright © 2016 MUNRO, CHRISTOPHER. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController()


@property (nonatomic) int score;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

}

- (BOOL)shouldAutorotate {
    return NO;
}

-(void)setScore:(int)score{
    
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];

}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
