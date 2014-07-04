//
//  RegattaViewController.m
//  EditableViewControllerExample
//
//  Created by Martin Kautz on 09.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "RegattaViewController.h"
#import "RegattaTableViewController.h"
#import "SimpleDataProvider.h"


@interface RegattaViewController () <UITextFieldDelegate, UIActionSheetDelegate>
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaNameTextField;
@property (nonatomic, weak)     IBOutlet    UITextField     *posOfYou;
@property (nonatomic, weak)     IBOutlet    UITextField     *numberOfSailors;
@property (nonatomic, weak)     IBOutlet    UITextField     *pointsOfWinner;
@property (nonatomic, weak)     IBOutlet    UITextField     *pointsOfYou;
@property (nonatomic, weak)     IBOutlet    UITextField     *pointsOfLoser;
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, strong)               NSArray         *aRegattas;
@property (nonatomic, strong)               NSDictionary    *theRegatta;
@property (nonatomic)                       NSInteger       currentIndex;
//----------------------------------------------------------------------------------------------------------------------
@end

@implementation RegattaViewController
//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init & lifecycle
//----------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    DLog(@"Loading RegattaViewController for B");

    self.regattaNameTextField.delegate = self;
    self.regattaNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.regattaNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.regattaNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.regattaNameTextField.returnKeyType = UIReturnKeyDone;

    self.posOfYou.delegate = self;
    self.posOfYou.keyboardType = UIKeyboardTypeNumberPad;
    self.posOfYou.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.posOfYou.autocorrectionType = UITextAutocorrectionTypeNo;
    self.posOfYou.returnKeyType = UIReturnKeyNext;

    self.numberOfSailors.delegate = self;
    self.numberOfSailors.keyboardType = UIKeyboardTypeNumberPad;
    self.numberOfSailors.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.numberOfSailors.autocorrectionType = UITextAutocorrectionTypeNo;
    self.numberOfSailors.returnKeyType = UIReturnKeyNext;

    self.pointsOfWinner.delegate = self;
    self.pointsOfWinner.keyboardType = UIKeyboardTypeNumberPad;
    self.pointsOfWinner.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.pointsOfWinner.autocorrectionType = UITextAutocorrectionTypeNo;
    self.pointsOfWinner.returnKeyType = UIReturnKeyNext;

    self.pointsOfYou.delegate = self;
    self.pointsOfYou.keyboardType = UIKeyboardTypeNumberPad;
    self.pointsOfYou.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.pointsOfYou.autocorrectionType = UITextAutocorrectionTypeNo;
    self.pointsOfYou.returnKeyType = UIReturnKeyNext;

    self.pointsOfLoser.delegate = self;
    self.pointsOfLoser.keyboardType = UIKeyboardTypeNumberPad;
    self.pointsOfLoser.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.pointsOfLoser.autocorrectionType = UITextAutocorrectionTypeNo;
    self.pointsOfLoser.returnKeyType = UIReturnKeyNext;


    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");

    //[self initDatasource];

    self.title = NSLocalizedString(@"Regatta", @"Regatta");
    self.view.backgroundColor = LIGHTBACK;
}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    if (self.editing) {
        self.regattaNameTextField.userInteractionEnabled = YES;
        self.regattaNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.posOfYou.userInteractionEnabled = YES;
        self.posOfYou.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.numberOfSailors.userInteractionEnabled = YES;
        self.numberOfSailors.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.pointsOfWinner.userInteractionEnabled = YES;
        self.pointsOfWinner.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.pointsOfYou.userInteractionEnabled = YES;
        self.pointsOfYou.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.pointsOfLoser.userInteractionEnabled = YES;
        self.pointsOfLoser.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------

        self.editButtonItem.title = NSLocalizedString(@"Fertig", @"Fertig");
    }
    else {
        self.regattaNameTextField.userInteractionEnabled = NO;
        self.regattaNameTextField.borderStyle = UITextBorderStyleNone;
        self.regattaNameTextField.text = self.theRegatta[@"title"];
        // ----------------------------------------------------------------------------
        self.posOfYou.userInteractionEnabled = NO;
        self.posOfYou.borderStyle = UITextBorderStyleNone;
        self.posOfYou.text = self.theRegatta[@"posOfYou"];
        // ----------------------------------------------------------------------------
        self.numberOfSailors.userInteractionEnabled = NO;
        self.numberOfSailors.borderStyle = UITextBorderStyleNone;
        self.numberOfSailors.text = self.theRegatta[@"numberOfSailors"];
        // ----------------------------------------------------------------------------
        self.pointsOfWinner.userInteractionEnabled = NO;
        self.pointsOfWinner.borderStyle = UITextBorderStyleNone;
        self.pointsOfWinner.text = self.theRegatta[@"pointsOfWinner"];
        // ----------------------------------------------------------------------------
        self.pointsOfYou.userInteractionEnabled = NO;
        self.pointsOfYou.borderStyle = UITextBorderStyleNone;
        self.pointsOfYou.text = self.theRegatta[@"pointsOfYou"];
        // ----------------------------------------------------------------------------
        self.pointsOfLoser.userInteractionEnabled = NO;
        self.pointsOfLoser.borderStyle = UITextBorderStyleNone;
        self.pointsOfLoser.text = self.theRegatta[@"pointsOfLoser"];
        // ----------------------------------------------------------------------------
        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
    }
    self.navigationController.toolbarHidden = YES;
}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//----------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Handle editing
//----------------------------------------------------------------------------------------------------------------------
- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];

    if (flag == YES){
        // Change views to edit mode.
        self.regattaNameTextField.userInteractionEnabled = YES;
        self.regattaNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.posOfYou.userInteractionEnabled = YES;
        self.posOfYou.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.numberOfSailors.userInteractionEnabled = YES;
        self.numberOfSailors.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.pointsOfWinner.userInteractionEnabled = YES;
        self.pointsOfWinner.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.pointsOfYou.userInteractionEnabled = YES;
        self.pointsOfYou.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.pointsOfLoser.userInteractionEnabled = YES;
        self.pointsOfLoser.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.editButtonItem.title = NSLocalizedString(@"Fertig", @"Fertig");
    }
    else {
        // Save the changes if needed and change the views to noneditable.
        self.regattaNameTextField.userInteractionEnabled = NO;
        self.regattaNameTextField.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.posOfYou.userInteractionEnabled = NO;
        self.posOfYou.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.numberOfSailors.userInteractionEnabled = NO;
        self.numberOfSailors.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.pointsOfWinner.userInteractionEnabled = NO;
        self.pointsOfWinner.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.pointsOfYou.userInteractionEnabled = NO;
        self.pointsOfYou.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.pointsOfLoser.userInteractionEnabled = NO;
        self.pointsOfLoser.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
        // ----------------------------------------------------------------------------
        [self store];
    }
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UITextFieldDelegate protocol methods
//----------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self store];
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Load regatta from datasource for a given index
//----------------------------------------------------------------------------------------------------------------------
- (void)loadObjectWithIndex:(NSInteger)index
{
    if (index == -1)
    {
        [self setEditing:YES animated:YES];
    }
    else {
        self.theRegatta = [SimpleDataProvider sharedInstance].theDataStorageArray[index];
    }
    self.currentIndex = index;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Storing regatta
//----------------------------------------------------------------------------------------------------------------------
- (void)store
{
    int posOfYou            =   self.posOfYou.text.intValue;
    int numberOfSailors     =   self.numberOfSailors.text.intValue;
    int pointsOfWinner      =   self.pointsOfWinner.text.intValue;
    int pointsOfYou         =   self.pointsOfYou.text.intValue;
    int pointsOfLoser       =   self.pointsOfLoser.text.intValue;

#pragma mark - TODO - add more checks
    if (pointsOfYou == 0 || numberOfSailors == 0 || pointsOfYou > pointsOfLoser) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    /*
     CGFloat score = [self calcForPosition:pos
     andScoredBoats:field
     withRegattaFactor:regattaFactor];
     */

    NSDictionary *args = @{
                           @"posOfYou"          :   [NSNumber numberWithInt:posOfYou],
                           @"numberOfSailors"   :   [NSNumber numberWithInt:numberOfSailors],
                           @"pointsOfWinner"    :   [NSNumber numberWithInt:pointsOfWinner],
                           @"pointsOfYou"       :   [NSNumber numberWithInt:pointsOfYou],
                           @"pointsOfLoser"     :   [NSNumber numberWithInt:pointsOfLoser]
                           };

    float score = [self calc:args];

    NSDictionary *aRegatta = @{
                               @"title"             : self.regattaNameTextField.text,
                               @"posOfYou"          : self.posOfYou.text,
                               @"numberOfSailors"   : self.numberOfSailors.text,
                               @"pointsOfWinner"    : self.pointsOfWinner.text,
                               @"pointsOfYou"       : self.pointsOfYou.text,
                               @"pointsOfLoser"     : self.pointsOfLoser.text,
                               @"score"             : [NSNumber numberWithFloat:score]
                               };

    if (self.currentIndex == -1) {
        [[SimpleDataProvider sharedInstance]addObject:aRegatta];
    }
    else {
        [[SimpleDataProvider sharedInstance]replaceObject:aRegatta atIndex:self.currentIndex];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Actual calculation
//----------------------------------------------------------------------------------------------------------------------
- (float)calc:(NSDictionary *)args
{
    float numberOfSailors     = ((NSNumber *)args[@"numberOfSailors"]).floatValue;
    float pointsOfWinner      = ((NSNumber *)args[@"pointsOfWinner"]).floatValue;
    float pointsOfYou         = ((NSNumber *)args[@"pointsOfYou"]).floatValue;
    float pointsOfLoser       = ((NSNumber *)args[@"pointsOfLoser"]).floatValue;
    return (1+((numberOfSailors-50)/400))*(100*((pointsOfLoser+1-pointsOfYou)/(pointsOfLoser+1- pointsOfWinner)));
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Prevent autorotation
//----------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
