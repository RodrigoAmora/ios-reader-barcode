//
//  LeituraCodigoDEBarraViewController.m
//  TesteCodigoBarra
//
//  Created by Rodrigo Amora on 25/09/15.
//  Copyright © 2015 Rodrigo Amora. All rights reserved.
//

#import "LeituraCodigoDEBarraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LeituraCodigoDEBarraViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
}

@end

@implementation LeituraCodigoDEBarraViewController

@synthesize viewFoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BV Rio";
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    viewFoto.layer.borderColor = [UIColor greenColor].CGColor;
    viewFoto.layer.borderWidth = 3;
    //    [self.view addSubview:_highlightView];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [self.view addSubview:_label];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.viewFoto.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.viewFoto.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:viewFoto];
    [self.view bringSubviewToFront:_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeDataMatrixCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeFace, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil) {
            _label.text = detectionString;
            break;
        } else {
            _label.text = @"(none)";
        }
    }
    
    _highlightView.frame = highlightViewRect;
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
