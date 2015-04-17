//
//  ViewController.m
//  TessOCR
//
//  Created by Arafat Hossain on 4/14/15.
//  Copyright (c) 2015 Arafat Hossain. All rights reserved.
//

#import "ViewController.h"
#import <TesseractOCR/TesseractOCR.h>


@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIImage *capturedImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapMeToSnap:(id)sender
{
    NSLog(@"I'm available");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick up "
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Camera"
                                                    otherButtonTitles:@"Photo",nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark --
#pragma mark -- UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:_imagePickerController animated:YES completion:NULL];
            NSLog(@"Camera Button Pressed");
            break;
        case 1:
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerController animated:YES completion:NULL];
            NSLog(@"Photo Library Pressed");
            break;
        default:
            NSLog(@"No Action triggered");
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _capturedImage = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self processImage:_capturedImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)processImage:(UIImage *)processImg
{
    G8Tesseract *tessEng = [G8Tesseract new];
    tessEng.language = @"eng+fra";
    tessEng.engineMode = G8OCREngineModeCubeOnly;
    tessEng.pageSegmentationMode = G8PageSegmentationModeAuto;
    tessEng.maximumRecognitionTime = 60.0;
    tessEng.image = processImg.g8_blackAndWhite;
    [tessEng recognize];
    
    // 7
    NSLog(@" text ---------\n\n%@",tessEng.recognizedText);
    _textView.text = tessEng.recognizedText;
    //_textView.editable = true;
}
@end
