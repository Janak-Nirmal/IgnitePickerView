//
//  ViewController.m
//  IgnitePickerViewDemo
//
//  Created by Michal on 9/3/13.
//  Copyright (c) 2013 Michal Lichwa Ignite. All rights reserved.
//

#import "ViewController.h"
#import <Twitter/Twitter.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize languageNamesArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    languageNamesArray = [[NSArray alloc]init];
    languageNamesArray = @[@"Polish", @"English", @"German", @"Turkish", @"Spanish", @"Bulgarian", @"Chinese", @"Korean", @"Russian", @"French", @"Esperanto"];
    
    //  IgnitePickerView init
    IgnitePickerView *ignitePickerView = [[IgnitePickerView alloc] initWithFrame:CGRectMake(15.0, 80.0, 270.0, 135.0)];
    ignitePickerView.delegate = self;
    ignitePickerView.dataSource = self;
    ignitePickerView.backgroundColor = [UIColor clearColor];
    ignitePickerView.framingColor = [UIColor colorWithRed:114.0/255.0 green:11.0/255.0 blue:58.0/255.0 alpha:1.0];
    ignitePickerView.normalFont = [UIFont fontWithName:@"Helvetica" size:24];
    ignitePickerView.selectedFont = [UIFont fontWithName:@"Helvetica" size:30];
    [ignitePickerView selectRow:3];
    //--------
    
    
    UIImage *btnImage =[[UIImage alloc]init];
    UIImage *btnImage2 =[[UIImage alloc]init];
    btnImage = [UIImage imageNamed:@"twitter.png"];
    btnImage2 = [UIImage imageNamed:@"initeLogo.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     button.frame = CGRectMake(60.0, 250.0, 180.0, 80.0);
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button addTarget:self
               action:@selector(tweetMe:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:btnImage forState:UIControlStateNormal];
   
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(60.0, 340.0, 180.0, 80.0);
    button2.layer.borderWidth = 1.0;
    button2.layer.borderColor = [UIColor blackColor].CGColor;

    [button2 addTarget:self
               action:@selector(checkOutMyBlog)
     forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundImage:btnImage2 forState:UIControlStateNormal];

    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];

    [self.view addSubview:ignitePickerView];
    [self.view addSubview:button];
    [self.view addSubview:button2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IgnitePickerViewDelegate functions

- (NSString *)ignitePickerView:(IgnitePickerView *)ignitePickerView titleForRow:(NSInteger)row {
    return [languageNamesArray objectAtIndex:row];
}

- (void)ignitePickerView:(IgnitePickerView*)ignitePickerView didSelectRow:(NSInteger)row {
    NSLog(@"Row is %d", row);
    
}

- (CGFloat)rowHeightForIgnitePickerView:(IgnitePickerView *)ignitePickerView {
    return 45.0;
}

- (void)labelStyleForIgnitePickerView:(IgnitePickerView*)ignitePickerView forLabel:(UILabel*)label {
    label.textColor = [UIColor blackColor];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:24.0];
}

#pragma mark - IgnitePickerViewDataSource functions

- (NSInteger)numberOfRowsInIgnitePickerView:(IgnitePickerView*)ignitePickerView {
    return [languageNamesArray count];
}

-(void) tweetMe:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        [controller setInitialText:@"I will be using IgnitePickerView for my iOS app. Thanks @mlichwa"];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:@"http://www.thisisignite.com"]];
        
        //Adding the Image to the facebook post value from iOS
        
        //[controller addImage:[UIImage imageNamed:@"fb.png"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        NSLog(@"UnAvailable");
    }
}

-(void) checkOutMyBlog{
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.thisisignite.com"]];
    }
    
}

@end
