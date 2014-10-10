//
//  AckViewController.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 02.06.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "AckViewController.h"


@interface AckViewController ()
@end

@implementation AckViewController
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

    if ([self.theTextView respondsToSelector:@selector(setTintColor:)])
        self.theTextView.tintColor = THECOLOR;
    self.theTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];

    NSString *sPathToAboutText = [[NSBundle mainBundle]pathForResource:@"about" ofType:@"txt"];
    NSError *readError = nil;
    NSString *theAboutText = [NSString stringWithContentsOfFile:sPathToAboutText
                                                       encoding:NSUTF8StringEncoding
                                                          error:&readError];

    self.theTextView.text = theAboutText;

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;

    self.title = NSLocalizedString(@"AckViewControllerTitle", @"AckViewControllerTitle");

    if ([self.theTextView respondsToSelector:@selector(setTintColor:)])
        self.theTextView.tintColor = THECOLOR;


    // read acks and load it into the appr. textview
    NSError *ackFileReadError = nil;
    NSString *sAckFile = [[NSBundle mainBundle] pathForResource:@"Acknowledgements" ofType:@"markdown"];
    if (sAckFile) {
        NSString *sAckText = [NSString stringWithContentsOfFile:sAckFile
                                                       encoding:NSUTF8StringEncoding
                                                          error:&ackFileReadError];
        if (sAckText && !ackFileReadError) {
            self.theTextView.text = [self beautifyLicense:sAckText];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//----------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - beautify nasty formatted license text (by removing line breaks).
//----------------------------------------------------------------------------------------------------------------------
- (NSString *)beautifyLicense:(NSString *)sLicense
{
    sLicense = [sLicense stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"__3__"];
    sLicense = [sLicense stringByReplacingOccurrencesOfString:@"\n\n" withString:@"__2__"];
    sLicense = [sLicense stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    sLicense = [sLicense stringByReplacingOccurrencesOfString:@"__2__" withString:@"\n\n"];
    sLicense = [sLicense stringByReplacingOccurrencesOfString:@"__3__" withString:@"\n\n\n"];
    sLicense = [sLicense stringByReplacingOccurrencesOfString:@"    " withString:@""];
    return sLicense;
}

@end
