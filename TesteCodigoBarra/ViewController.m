//
//  ViewController.m
//  TesteCodigoBarra
//
//  Created by Rodrigo Amora on 25/09/15.
//  Copyright © 2015 Rodrigo Amora. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
}

@end

@implementation ViewController

@synthesize btTirarFoto, image, imagePicker, viewFoto;

- (void)viewDidLoad {
    [super viewDidLoad];

    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    

//    viewFoto = [[UIView alloc] init];
    //viewFoto.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
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

-(void)tirarFoto {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    UIImage *i = [info objectForKey:UIImagePickerControllerOriginalImage];
    image.image = i;
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeDataMatrixCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeFace, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _label.text = detectionString;
            break;
        }
        else
            _label.text = @"(none)";
    }
    
    _highlightView.frame = highlightViewRect;
}

@end
