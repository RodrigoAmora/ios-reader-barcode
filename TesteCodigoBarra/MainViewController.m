//
//  MainViewController.m
//  TesteCodigoBarra
//
//  Created by Rodrigo Amora on 25/09/15.
//  Copyright © 2015 Rodrigo Amora. All rights reserved.
//

#import "MainViewController.h"
#import "LeituraCodigoDEBarraViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize tvDesc;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BV Rio";
    
    tvDesc.editable = NO;
    tvDesc.selectable = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)changeViewController:(id)sender {
    LeituraCodigoDEBarraViewController *leituraViewController = [[LeituraCodigoDEBarraViewController alloc] init];
    [self.navigationController pushViewController:leituraViewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
