//
//  MainViewController.h
//  TesteCodigoBarra
//
//  Created by Rodrigo Amora on 25/09/15.
//  Copyright © 2015 Rodrigo Amora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIButton *btLerCodigoBarra;
@property(nonatomic, strong) IBOutlet UITextView *tvDesc;

-(IBAction)changeViewController:(id)sender;

@end
