//
//  CamViewController.m
//  quick-ocr
//
//  Created by Blade on 9/6/14.
//  Copyright (c) 2014 Blade Chapman. All rights reserved.
//

#import "CamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

@interface CamViewController ()

@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, retain) IBOutlet UIImageView *vImage;
@property(nonatomic, retain) IBOutlet UIButton *useButton;
@property(nonatomic, retain) IBOutlet UIButton *captureButton;
@property(nonatomic, retain) IBOutlet UIButton *returnButton;

@end

@implementation CamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [_vImagePreview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"%f", self.view.frame.size.width);
    NSLog(@"%f", self.view.frame.size.height);
    [self previewMode:NO];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    [[self vImage] setBackgroundColor:[UIColor blackColor]];

}

- (void)viewDidAppear:(BOOL)animated
{

    AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetHigh;

	CALayer *viewLayer = self.vImagePreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);

	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];

	captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
	[self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];

	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];


    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];

    [session addOutput:_stillImageOutput];

	[session startRunning];


//    [self saveImageToServer:[UIImage imageNamed:@"text4.JPG"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCapture:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }

    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");

         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];

         self.vImage.image = image;
         [self previewMode:YES];
     }];
}

- (IBAction)returnButtonTapped:(id)sender {
    [self previewMode:NO];
}
- (IBAction)useButtonTapped:(id)sender {
    [[self delegate] imageCaptured:self.vImage.image];
    [self saveImageToServer:self.vImage.image];
    [self previewMode:NO];
}

-(void)saveImageToServer:(UIImage *)imageToSave
{
    // COnvert Image to NSData
    NSData *dataImage = UIImageJPEGRepresentation(imageToSave, 1.0f);

    // set your URL Where to Upload Image
    NSString *urlString = @"http://35.2.99.213:8080/api/analyze_picture";

    // set your Image Name
    NSString *filename = @"text";

    // Create 'POST' MutableRequest with Data and Other Image Attachment.
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:180];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:dataImage]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];

    // Get Response of Your Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"string: %@", responseString);

    [self performSelectorOnMainThread:@selector(dataReceived:) withObject:returnData waitUntilDone:YES];
}

- (void)dataReceived:(NSData *)response {
//    NSLog(@"response: %@", response);

    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:response

                          options:kNilOptions
                          error:&error];

    NSDictionary *val = nil;
    if ([json count] != 0)
        val = [json objectAtIndex:0];

    NSLog(@"val %@", val);

    NSString *title = [val objectForKey:@"title"];
    NSString *link = [val objectForKey: @"link"];
    NSLog(@"title");

    [[self delegate] dataReceivedWithTitle: title andLink: link];
}

- (void)previewMode:(BOOL)isPreview {
    if (!isPreview) {
            self.vImage.hidden = YES;
            self.useButton.hidden = YES;
            self.returnButton.hidden = YES;
        self.captureButton.hidden = NO;
    }
    else {
        
            self.vImage.hidden = NO;
            self.useButton.hidden = NO;
            self.returnButton.hidden = NO;
        self.captureButton.hidden = YES;



    }
}

@end
