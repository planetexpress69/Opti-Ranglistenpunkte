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
#import "UIImage+JAKExtensions.h"
#import <FontAwesome+iOS/UIImage+FontAwesome.h>


@interface RegattaViewController () <UITextFieldDelegate, UIActionSheetDelegate>
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaNameTextField;
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaPosTextField;
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaFieldTextField;
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaRacesTextField;
@property (nonatomic, weak)     IBOutlet    UIButton        *selectorButton;
@property (nonatomic, weak)     IBOutlet    UIButton        *threeDaysButton;
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, strong)               NSDictionary    *dSelectedRegatta;
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

    DLog(@"Loading RegattaViewController for A");

    self.regattaNameTextField.delegate = self;
    self.regattaNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.regattaNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.regattaNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.regattaNameTextField.returnKeyType = UIReturnKeyDone;

    self.regattaPosTextField.delegate = self;
    self.regattaPosTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.regattaPosTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.regattaPosTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.regattaPosTextField.returnKeyType = UIReturnKeyNext;

    self.regattaFieldTextField.delegate = self;
    self.regattaFieldTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.regattaFieldTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.regattaFieldTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.regattaFieldTextField.returnKeyType = UIReturnKeyNext;

    self.regattaRacesTextField.delegate = self;
    self.regattaRacesTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.regattaRacesTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.regattaRacesTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.regattaRacesTextField.returnKeyType = UIReturnKeyNext;

    self.selectorButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];

    [self.selectorButton setBackgroundImage:[UIImage imageWithColor:THECOLOR] forState:UIControlStateNormal];
    [self.selectorButton setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
    [self.selectorButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];

    [self.selectorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.selectorButton setTitleColor:THECOLOR forState:UIControlStateDisabled];


    [self.selectorButton.layer setCornerRadius:self.selectorButton.frame.size.height / 2];
    [self.selectorButton.layer setBorderWidth:0.0];
    self.selectorButton.clipsToBounds = YES;

    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
    UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-edit"
                                          backgroundColor:[UIColor clearColor]
                                                iconColor:[UIColor whiteColor]
                                                iconScale:1.0f
                                                  andSize:CGSizeMake(22.0f, 22.0f)];

    UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-edit"
                                             backgroundColor:[UIColor clearColor]
                                                   iconColor:[UIColor whiteColor]
                                                   iconScale:1.0f
                                                     andSize:CGSizeMake(18.0f, 18.0f)];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                    landscapeImagePhone:landscapeEditIconImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toggleEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;


    [self initDatasource];


    [self.threeDaysButton setTitle:@"\uf096" forState:UIControlStateNormal];
    [self.threeDaysButton setTitle:@"\uf14a" forState:UIControlStateSelected];
    self.threeDaysButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:30.0f];
    [self.threeDaysButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.threeDaysButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

/*
    [self.threeDaysButton setBackgroundImage:notselectedcheckbox
                                    forState:UIControlStateNormal];
    [self.threeDaysButton setBackgroundImage:selectedcheckbox
                                    forState:UIControlStateSelected]; */

    [self.threeDaysButton addTarget:self
                             action:@selector(toggleThreeDays:)
                   forControlEvents:UIControlEventTouchUpInside];


    self.title                      = NSLocalizedString(@"Regatta", @"Regatta");
    self.view.backgroundColor       = LIGHTBACK;
}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.editing) {
        self.regattaNameTextField.userInteractionEnabled    = YES;
        self.regattaNameTextField.borderStyle               = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        self.regattaPosTextField.userInteractionEnabled     = YES;
        self.regattaPosTextField.borderStyle                = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled   = YES;
        self.regattaFieldTextField.borderStyle              = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled   = YES;
        self.regattaRacesTextField.borderStyle              = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        BOOL checked = self.theRegatta[@"threeDays"] != nil ? ((NSNumber *)self.theRegatta[@"threeDays"]).boolValue : NO;
        self.threeDaysButton.selected                       = checked;
        self.threeDaysButton.userInteractionEnabled         = YES;
        // -------------------------------------------------------------------------------------------
        self.selectorButton.enabled                         = YES;
        self.selectorButton.titleLabel.textColor            = [UIColor whiteColor];
        // -------------------------------------------------------------------------------------------

        if (self.theRegatta == nil) {
            self.dSelectedRegatta = [self firstRegatta];
        }

        UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-check"
                                              backgroundColor:[UIColor clearColor]
                                                    iconColor:[UIColor whiteColor]
                                                    iconScale:1.0f
                                                      andSize:CGSizeMake(22.0f, 22.0f)];

        UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-check"
                                                 backgroundColor:[UIColor clearColor]
                                                       iconColor:[UIColor whiteColor]
                                                       iconScale:1.0f
                                                         andSize:CGSizeMake(18.0f, 18.0f)];

        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                        landscapeImagePhone:landscapeEditIconImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(toggleEdit:)];
        self.navigationItem.rightBarButtonItem = editButton;

    }
    else {
        self.regattaNameTextField.userInteractionEnabled    = NO;
        self.regattaNameTextField.borderStyle               = UITextBorderStyleNone;
        self.regattaNameTextField.text                      = self.theRegatta[@"title"];
        // -------------------------------------------------------------------------------------------
        self.regattaPosTextField.userInteractionEnabled     = NO;
        self.regattaPosTextField.borderStyle                = UITextBorderStyleNone;
        self.regattaPosTextField.text                       = self.theRegatta[@"pos"];
        // -------------------------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled   = NO;
        self.regattaFieldTextField.borderStyle              = UITextBorderStyleNone;
        self.regattaFieldTextField.text                     = self.theRegatta[@"field"];
        // -------------------------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled   = NO;
        self.regattaRacesTextField.borderStyle              = UITextBorderStyleNone;
        self.regattaRacesTextField.text                     = self.theRegatta[@"races"];
        // -------------------------------------------------------------------------------------------
        BOOL checked = self.theRegatta[@"threeDays"] != nil ? ((NSNumber *)self.theRegatta[@"threeDays"]).boolValue : NO;
        [self.threeDaysButton setSelected:checked];
        self.threeDaysButton.userInteractionEnabled         = NO;

        // -------------------------------------------------------------------------------------------
        self.dSelectedRegatta                               = self.theRegatta[@"type"];
        // -------------------------------------------------------------------------------------------
        self.selectorButton.enabled = NO;
        self.selectorButton.titleLabel.textColor = [UIColor grayColor];
        UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-edit"
                                              backgroundColor:[UIColor clearColor]
                                                    iconColor:[UIColor whiteColor]
                                                    iconScale:1.0f
                                                      andSize:CGSizeMake(22.0f, 22.0f)];

        UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-edit"
                                                 backgroundColor:[UIColor clearColor]
                                                       iconColor:[UIColor whiteColor]
                                                       iconScale:1.0f
                                                         andSize:CGSizeMake(18.0f, 18.0f)];

        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                        landscapeImagePhone:landscapeEditIconImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(toggleEdit:)];
        self.navigationItem.rightBarButtonItem = editButton;

    }
    [self.selectorButton setTitle:self.dSelectedRegatta[@"title"] forState:UIControlStateNormal];
    [self.selectorButton setTitle:self.dSelectedRegatta[@"title"] forState:UIControlStateDisabled];
    [self.selectorButton setTitle:self.dSelectedRegatta[@"title"] forState:UIControlStateSelected];

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
#pragma mark - Toggle edit
//----------------------------------------------------------------------------------------------------------------------
- (IBAction)toggleEdit:(id)sender
{
    if (self.editing) {
        [self setEditing:NO animated:YES];
    } else {
        [self setEditing:YES animated:YES];
    }
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Handle editing
//----------------------------------------------------------------------------------------------------------------------
- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];

    if (flag == YES){
        // Change views to edit mode.
        self.regattaNameTextField.userInteractionEnabled    = YES;
        self.regattaNameTextField.borderStyle               = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        self.regattaPosTextField.userInteractionEnabled     = YES;
        self.regattaPosTextField.borderStyle                = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled   = YES;
        self.regattaFieldTextField.borderStyle              = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled   = YES;
        self.regattaRacesTextField.borderStyle              = UITextBorderStyleRoundedRect;
        // -------------------------------------------------------------------------------------------
        self.threeDaysButton.userInteractionEnabled         = YES;
        // -------------------------------------------------------------------------------------------
        self.selectorButton.enabled                         = YES;

        UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-check"
                                              backgroundColor:[UIColor clearColor]
                                                    iconColor:[UIColor whiteColor]
                                                    iconScale:1.0f
                                                      andSize:CGSizeMake(22.0f, 22.0f)];

        UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-check"
                                                 backgroundColor:[UIColor clearColor]
                                                       iconColor:[UIColor whiteColor]
                                                       iconScale:1.0f
                                                         andSize:CGSizeMake(18.0f, 18.0f)];

        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                        landscapeImagePhone:landscapeEditIconImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(toggleEdit:)];
        self.navigationItem.rightBarButtonItem = editButton;

    }
    else {
        // Save the changes if needed and change the views to noneditable.
        self.regattaNameTextField.userInteractionEnabled    = NO;
        self.regattaNameTextField.borderStyle               = UITextBorderStyleNone;
        // -------------------------------------------------------------------------------------------
        self.regattaPosTextField.userInteractionEnabled     = NO;
        self.regattaPosTextField.borderStyle                = UITextBorderStyleNone;
        // -------------------------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled   = NO;
        self.regattaFieldTextField.borderStyle              = UITextBorderStyleNone;
        // -------------------------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled   = NO;
        self.regattaRacesTextField.borderStyle              = UITextBorderStyleNone;
        // -------------------------------------------------------------------------------------------
        self.threeDaysButton.userInteractionEnabled         = NO;
        // -------------------------------------------------------------------------------------------
        self.selectorButton.enabled = NO;
        //self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
        UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-edit"
                                              backgroundColor:[UIColor clearColor]
                                                    iconColor:[UIColor whiteColor]
                                                    iconScale:1.0f
                                                      andSize:CGSizeMake(22.0f, 22.0f)];

        UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-edit"
                                                 backgroundColor:[UIColor clearColor]
                                                       iconColor:[UIColor whiteColor]
                                                       iconScale:1.0f
                                                         andSize:CGSizeMake(18.0f, 18.0f)];

        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                        landscapeImagePhone:landscapeEditIconImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(toggleEdit:)];
        self.navigationItem.rightBarButtonItem              = editButton;

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
    NSInteger pos           = self.regattaPosTextField.text.integerValue;
    NSInteger field         = self.regattaFieldTextField.text.integerValue;
    BOOL threeDays          = self.threeDaysButton.selected;

    float regattaFactor     = ((NSNumber *)self.dSelectedRegatta[@"factor"]).floatValue;

    // some basic checks
    if (pos == 0 || field == 0 || pos > field || pos > 1500 || field > 1500) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    CGFloat score = [self calcForPosition:pos
                           andScoredBoats:field
                        withRegattaFactor:regattaFactor];

    NSDictionary *aRegatta = @{
                               @"title"     : self.regattaNameTextField.text,
                               @"pos"       : self.regattaPosTextField.text,
                               @"field"     : self.regattaFieldTextField.text,
                               @"races"     : self.regattaRacesTextField.text,
                               @"threeDays" : [NSNumber numberWithBool:threeDays],
                               @"type"      : self.dSelectedRegatta,
                               @"score"     : [NSNumber numberWithFloat:score]
                               };

    if (self.currentIndex == -1) {
        [[SimpleDataProvider sharedInstance] addObject:aRegatta];
    }
    else {
        [[SimpleDataProvider sharedInstance] replaceObject:aRegatta atIndex:self.currentIndex];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Show regatta type selector
//----------------------------------------------------------------------------------------------------------------------
- (IBAction)requestSelector:(id)sender
{

    [self.regattaNameTextField resignFirstResponder];
    [self.regattaPosTextField resignFirstResponder];
    [self.regattaFieldTextField resignFirstResponder];
    [self.regattaRacesTextField resignFirstResponder];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Wähle eine Regatta"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (NSDictionary *regatta in self.aRegattas) {
        [actionSheet addButtonWithTitle:regatta[@"title"]];
    }
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = [self.aRegattas count];
    [actionSheet showInView:self.view];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UIActionSheetDelegate protocol methods for regatta selection
//----------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == self.aRegattas.count)
        return;

    _dSelectedRegatta = nil;
    [[NSUserDefaults standardUserDefaults]setObject:self.aRegattas[buttonIndex] forKey:@"selectedRegatta"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.selectorButton setTitle:[NSString stringWithFormat:@"%@", self.dSelectedRegatta[@"title"]]
                             forState:UIControlStateNormal];
    [self.selectorButton sizeToFit];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Hack action sheet
//----------------------------------------------------------------------------------------------------------------------
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:THEWHITE forState:UIControlStateHighlighted];
            [button setTitleColor:THECOLOR forState:UIControlStateSelected];
            [button setTitleColor:THECOLOR forState:UIControlStateApplication];
            [button setTitleColor:THECOLOR forState:UIControlStateNormal];

            NSString *buttonText = button.titleLabel.text;
            if ([buttonText isEqualToString:NSLocalizedString(@"Cancel", nil)]) {
                button.titleLabel.textColor = [UIColor redColor];
            }
        }
    }];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init the list of regattas
//----------------------------------------------------------------------------------------------------------------------
- (void)initDatasource
{
    NSError     *readError      = nil;
    NSString    *sPathToJson    = [[NSBundle mainBundle]pathForResource:@"aRegattas" ofType:@"json"];
    NSData      *dJson          = [NSData dataWithContentsOfFile:sPathToJson
                                                         options:NSDataReadingMapped
                                                           error:&readError];
    if (dJson && !readError) {
        NSError *parsingError = nil;
        self.aRegattas = [NSJSONSerialization JSONObjectWithData:dJson
                                                         options:NSJSONReadingAllowFragments
                                                           error:&parsingError];
        if (!self.aRegattas && parsingError) {
            NSLog(@"error: %@", parsingError);
        }


    } else {
        NSLog(@"error: %@", readError);
    }
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Lazy loading _dSelectedRegatta
//----------------------------------------------------------------------------------------------------------------------
- (NSDictionary *)dSelectedRegatta
{
    // loading
    if (_dSelectedRegatta == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"selectedRegatta"]) {
            _dSelectedRegatta = [userDefaults objectForKey:@"selectedRegatta"];
        } else {
            _dSelectedRegatta = [self firstRegatta];
            [userDefaults setObject:_dSelectedRegatta forKey:@"selectedRegatta"];
            [userDefaults synchronize];
        }
    }
    return _dSelectedRegatta;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Getter for firstRegatta
//----------------------------------------------------------------------------------------------------------------------
- (NSDictionary *)firstRegatta
{
    NSError     *readError      = nil;
    NSString    *sPathToJson    = [[NSBundle mainBundle]pathForResource:@"aRegattas" ofType:@"json"];
    NSData      *dJson          = [NSData dataWithContentsOfFile:sPathToJson
                                                         options:NSDataReadingMapped
                                                           error:&readError];
    if (dJson && !readError) {
        NSError *parsingError = nil;
        NSArray *allRegattas = [NSJSONSerialization JSONObjectWithData:dJson
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&parsingError];
        if (!allRegattas && parsingError) {
            NSLog(@"error: %@", parsingError);
        } else {
            //NSLog(@"all regattas: %@", allRegattas);
            return allRegattas[0];
        }
    } else {
        NSLog(@"error: %@", readError);
    }
    return nil;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Actual calculation
//----------------------------------------------------------------------------------------------------------------------
- (CGFloat)calcForPosition:(NSInteger)position
            andScoredBoats:(NSInteger)scoredBoats
         withRegattaFactor:(float)regattaFactor
{
    if (position > scoredBoats)
        return 0;

    float secondFactor = 0.2f;
    if (scoredBoats < 100) {
        secondFactor = ((float)scoredBoats - 10.0f) / 450.0f;
    }

    float ffactor = regattaFactor + secondFactor;
    return ffactor * 100.0f *(((float)scoredBoats + 1.0f - (float)position)/(float)scoredBoats);
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Prevent autorotation
//----------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)toggleThreeDays:(id)sender
{
    self.threeDaysButton.selected = !self.threeDaysButton.selected;
}
@end
