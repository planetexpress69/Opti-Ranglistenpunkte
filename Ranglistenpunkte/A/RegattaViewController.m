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
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaPosTextField;
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaFieldTextField;
@property (nonatomic, weak)     IBOutlet    UITextField     *regattaRacesTextField;
@property (nonatomic, weak)     IBOutlet    UIButton        *selectorButton;
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

    self.selectorButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:
                                           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 16.0f : 36.0f];

    [self.selectorButton.layer setCornerRadius:self.selectorButton.frame.size.height / 2];
    [self.selectorButton.layer setBorderWidth:0.0];
    self.selectorButton.clipsToBounds = YES;

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");

    [self initDatasource];

    self.title = NSLocalizedString(@"Regatta", @"Regatta");
    self.view.backgroundColor = LIGHTBACK;
}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.editing) {
        self.regattaNameTextField.userInteractionEnabled = YES;
        self.regattaNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.regattaPosTextField.userInteractionEnabled = YES;
        self.regattaPosTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled = YES;
        self.regattaFieldTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled = YES;
        self.regattaRacesTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.selectorButton.enabled = YES;
        self.selectorButton.titleLabel.textColor = [UIColor whiteColor];
        // ----------------------------------------------------------------------------

        if (self.theRegatta == nil) {
            self.dSelectedRegatta = [self firstRegatta];
        }
        self.editButtonItem.title = NSLocalizedString(@"Fertig", @"Fertig");
    }
    else {
        self.regattaNameTextField.userInteractionEnabled = NO;
        self.regattaNameTextField.borderStyle = UITextBorderStyleNone;
        self.regattaNameTextField.text = self.theRegatta[@"title"];
        // ----------------------------------------------------------------------------
        self.regattaPosTextField.userInteractionEnabled = NO;
        self.regattaPosTextField.borderStyle = UITextBorderStyleNone;
        self.regattaPosTextField.text = self.theRegatta[@"pos"];
        // ----------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled = NO;
        self.regattaFieldTextField.borderStyle = UITextBorderStyleNone;
        self.regattaFieldTextField.text = self.theRegatta[@"field"];
        // ----------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled = NO;
        self.regattaRacesTextField.borderStyle = UITextBorderStyleNone;
        self.regattaRacesTextField.text = self.theRegatta[@"races"];
        // ----------------------------------------------------------------------------
        self.dSelectedRegatta = self.theRegatta[@"type"];
        // ----------------------------------------------------------------------------
        self.selectorButton.enabled = NO;
        self.selectorButton.titleLabel.textColor = [UIColor grayColor];
        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
    }
    [self.selectorButton setTitle:self.dSelectedRegatta[@"title"] forState:UIControlStateNormal];
    [self.selectorButton setTitle:self.dSelectedRegatta[@"title"] forState:UIControlStateDisabled];
    [self.selectorButton setTitle:self.dSelectedRegatta[@"title"] forState:UIControlStateSelected];

    //self.selectorButton.titleLabel.text = self.dSelectedRegatta[@"title"];
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
        self.regattaPosTextField.userInteractionEnabled = YES;
        self.regattaPosTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled = YES;
        self.regattaFieldTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled = YES;
        self.regattaRacesTextField.borderStyle = UITextBorderStyleRoundedRect;
        // ----------------------------------------------------------------------------
        self.selectorButton.enabled = YES;
        self.editButtonItem.title = NSLocalizedString(@"Fertig", @"Fertig");
    }
    else {
        // Save the changes if needed and change the views to noneditable.
        self.regattaNameTextField.userInteractionEnabled = NO;
        self.regattaNameTextField.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.regattaPosTextField.userInteractionEnabled = NO;
        self.regattaPosTextField.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.regattaFieldTextField.userInteractionEnabled = NO;
        self.regattaFieldTextField.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.regattaRacesTextField.userInteractionEnabled = NO;
        self.regattaRacesTextField.borderStyle = UITextBorderStyleNone;
        // ----------------------------------------------------------------------------
        self.selectorButton.enabled = NO;
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
    NSInteger pos = self.regattaPosTextField.text.integerValue;
    NSInteger field = self.regattaFieldTextField.text.integerValue;
    float regattaFactor = ((NSNumber *)self.dSelectedRegatta[@"factor"]).floatValue;

    // some basic checks
    if (pos == 0 || field == 0 || pos > field || pos > 1500 || field > 1500) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    CGFloat score = [self calcForPosition:pos
                           andScoredBoats:field
                        withRegattaFactor:regattaFactor];

    NSDictionary *aRegatta = @{
                               @"title" : self.regattaNameTextField.text,
                               @"pos"   : self.regattaPosTextField.text,
                               @"field" : self.regattaFieldTextField.text,
                               @"races" : self.regattaRacesTextField.text,
                               @"type"  : self.dSelectedRegatta,
                               @"score" : [NSNumber numberWithFloat:score]
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

@end
