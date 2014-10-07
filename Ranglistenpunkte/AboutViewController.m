//
//  AboutViewController.m
//  EditableViewControllerExample
//
//  Created by Martin Kautz on 09.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController () <UITextViewDelegate>
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, weak) IBOutlet UITextView *theTextView;
@property (nonatomic, weak) IBOutlet UIButton   *ackButton;
@property (nonatomic, weak) IBOutlet UILabel    *versionLabel;
//----------------------------------------------------------------------------------------------------------------------
@end

@implementation AboutViewController
//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init & lifecycle
//----------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = LIGHTBACK;

    self.title = NSLocalizedString(@"About", @"About");


    self.theTextView.backgroundColor = [UIColor clearColor];
    self.theTextView.delegate = self;


    if ([self.theTextView respondsToSelector:@selector(setTintColor:)]) {
        self.theTextView.tintColor = THECOLOR;
    }

    if ([self.ackButton respondsToSelector:@selector(setTintColor:)]) {
        self.ackButton.tintColor = THECOLOR;
    }



    self.theTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];

    NSString *sPathToAboutText = [[NSBundle mainBundle]pathForResource:@"about"
                                                                ofType:@"txt"];
    NSError *readError = nil;
    NSString *theAboutText = [NSString stringWithContentsOfFile:sPathToAboutText
                                                       encoding:NSUTF8StringEncoding
                                                          error:&readError];

    self.theTextView.text = theAboutText;

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self.ackButton setTitle:NSLocalizedString(@"AckButtonTitle", nil) forState:UIControlStateNormal];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;

    self.ackButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:
                                           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 16.0f : 36.0f];

    [self.ackButton.layer setCornerRadius:self.ackButton.frame.size.height / 2];
    [self.ackButton.layer setBorderWidth:0.0];
    self.ackButton.clipsToBounds = YES;

    // load version
    self.versionLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Close the panel
//----------------------------------------------------------------------------------------------------------------------
- (IBAction)close:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          //
                                                      }];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UITextViewDelegate protocol methods
//----------------------------------------------------------------------------------------------------------------------
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Jump to sponsors
//----------------------------------------------------------------------------------------------------------------------
- (IBAction)callFleetmon:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fleetmon.com"]];
}

//----------------------------------------------------------------------------------------------------------------------
- (IBAction)callJakota:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.jakota.de"]];
}

//----------------------------------------------------------------------------------------------------------------------
- (IBAction)callRS:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rostocksailing.de"]];
}

@end
