//
//  ViewController.m
//  TessOCR
//
//  Created by Arafat Hossain on 4/14/15.
//  Copyright (c) 2015 Arafat Hossain. All rights reserved.
//

#import "ViewController.h"
#import <TesseractOCR/TesseractOCR.h>


@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) G8Tesseract *tessEng;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_tessEng == nil) {
        _tessEng = [G8Tesseract new];
        _tessEng.language = @"eng+fra";
        _tessEng.engineMode = G8OCREngineModeCubeOnly;
        _tessEng.pageSegmentationMode = G8PageSegmentationModeAuto;
        _tessEng.maximumRecognitionTime = 60.0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tapMeToSnap:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose The Picture !!!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Camera"
                                                    otherButtonTitles:@"Photo",nil];
    [actionSheet showInView:self.view];
}

#pragma mark --
#pragma mark -- UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = (id)self;
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
            //NSLog(@"Camera Button Pressed");
            break;
        case 1:
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerController animated:YES completion:NULL];
            //NSLog(@"Photo Library Pressed");
            break;
        default:
            //NSLog(@"No Action triggered");
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _activityView.hidden = NO;
    [_activityView startAnimating];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        [self processImage:chosenImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)processImage:(UIImage *)processImg
{
    _tessEng.image = processImg.g8_blackAndWhite;
    [_tessEng recognize];
    //  NSLog(@" text ---------\n\n%@",_tessEng.recognizedText);
    
    _textView.text = _tessEng.recognizedText;
    //_textView.editable = true;
   
    _activityView.hidden = YES;
    [_activityView stopAnimating];
}
@end
