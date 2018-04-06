//
//  ViewController.h
//  TesteCodigoBarra
//
//  Created by Rodrigo Amora on 25/09/15.
//  Copyright © 2015 Rodrigo Amora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIView *viewFoto;
@property(nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic, strong) IBOutlet UIImageView *image;
@property(nonatomic, strong) IBOutlet UIButton *btTirarFoto;

-(IBAction)tirarFoto;
-(void) imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info;

@end

