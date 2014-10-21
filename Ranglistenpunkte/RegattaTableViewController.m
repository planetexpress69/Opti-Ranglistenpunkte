//
//  RegattaTableViewController.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 09.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "RegattaTableViewController.h"
#import "RegattaViewController.h"
#import "SimpleDataProvider.h"
#import "RegattaCell.h"
#import <FontAwesome+iOS/NSString+FontAwesome.h>
#import <FontAwesome+iOS/UIImage+FontAwesome.h>


@interface RegattaTableViewController ()
@end

@implementation RegattaTableViewController
//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init & lifecycle
//----------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-edit" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(22.0f, 22.0f)];
    UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-edit" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(18.0f, 18.0f)];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                    landscapeImagePhone:landscapeEditIconImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toggleEdit:)];
    self.navigationItem.leftBarButtonItem = editButton;

    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");

    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 39)];
    UILabel *customLabelView = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 39)];

    customLabelView.backgroundColor = [UIColor clearColor];
    customLabelView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0f];
    customLabelView.textColor = [UIColor whiteColor];
    customLabelView.text = @"000.000";
    [containerView addSubview:customLabelView];

    UIBarButtonItem *customBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                         target:self action:nil];

    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                         target:self action:nil];

    NSDictionary *txtAttr = @{ UITextAttributeFont : [UIFont fontWithName: kFontAwesomeFamilyName size: 22],
                                        UITextAttributeTextColor : [UIColor whiteColor],
                               //UITextAttributeTextShadowColor: [UIColor blackColor],
                               //UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:  CGSizeMake(0,-1)]
                               };

    UIBarButtonItem *listItem = [[UIBarButtonItem alloc]initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-list"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(callList:)];
    [listItem setTitleTextAttributes:txtAttr forState:UIControlStateNormal];
    listItem.tintColor = THEWHITE;

    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-info-sign"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(info:)];
    [infoItem setTitleTextAttributes:txtAttr forState:UIControlStateNormal];
    infoItem.tintColor = THEWHITE;
    
#ifdef A
    self.toolbarItems = @[customBarButtonItem, flex, listItem, flex, infoItem, fix];
#else
    self.toolbarItems = @[customBarButtonItem, flex, infoItem, fix];
#endif
    self.title = NSLocalizedString(@"Your regattas", @"Your regattas");
    /*[self.tableView registerClass:[RegattaCell class]
           forCellReuseIdentifier:@"RegattaCell"]; */

    self.tableView.backgroundView = nil; // hack the ios6 table background
    self.tableView.backgroundColor = LIGHTBACK;

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;

}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self update];
    self.navigationController.toolbarHidden = NO;
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Call info sheet
//----------------------------------------------------------------------------------------------------------------------
- (IBAction)info:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        sb = [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    }
    UINavigationController *aboutNavigationController =
    [sb instantiateViewControllerWithIdentifier:@"AboutNavigationController"];
    [self presentViewController:aboutNavigationController animated:YES completion:^{
        // just in case the table is still in edit mode
        if ([self.tableView isEditing]) {
            [self.tableView setEditing:NO];
        }
    }];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Call info sheet
//----------------------------------------------------------------------------------------------------------------------
- (IBAction)callList:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        sb = [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    }
    UINavigationController *listNavigationController =
    [sb instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    [self presentViewController:listNavigationController animated:YES completion:^{
        // just in case the table is still in edit mode
        if ([self.tableView isEditing]) {
            [self.tableView setEditing:NO];
        }
    }];
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Update
//----------------------------------------------------------------------------------------------------------------------
- (void)update
{

#ifdef A
    CGFloat bestScore = [[SimpleDataProvider sharedInstance] bestScoreA];
#else
    CGFloat bestScore = [[SimpleDataProvider sharedInstance] bestScoreB];
#endif

    UIView *theView = (UIView *)((UIBarButtonItem *)self.toolbarItems[0]).customView;
    UILabel *theLabel = (UILabel *)theView.subviews[0];
    theLabel.text = [NSString stringWithFormat:@"%.3f", bestScore];

    UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-edit" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(22.0f, 22.0f)];
    UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-edit" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(18.0f, 18.0f)];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                    landscapeImagePhone:landscapeEditIconImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toggleEdit:)];
    self.navigationItem.leftBarButtonItem = editButton;

    self.navigationItem.leftBarButtonItem.enabled = [SimpleDataProvider sharedInstance].theDataStorageArray.count > 0;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource protocol methods
//----------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//----------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SimpleDataProvider sharedInstance].theDataStorageArray.count;
}

//----------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegattaCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"RegattaCell"];

    [cell.contentView viewWithTag:123].backgroundColor = [UIColor clearColor];

#ifdef A

    [cell.contentView viewWithTag:123].backgroundColor = THECOLOR;

#endif
    CALayer *layer = [cell.contentView viewWithTag:123].layer;
    layer.cornerRadius = 3.0f;

    cell.scoreLabel.textColor = THECOLOR;
    cell.positLabel.textColor = THECOLOR;

#ifdef A

    NSDictionary *currentRegattaRecord = [SimpleDataProvider sharedInstance].theDataStorageArray[indexPath.row];
    cell.titleLabel.text = currentRegattaRecord[@"title"];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%.3f", ((NSNumber *)currentRegattaRecord[@"score"]).floatValue];
    cell.positLabel.text = [NSString stringWithFormat:@"%ld/%ld",
                            (long)((NSNumber *)currentRegattaRecord[@"pos"]).integerValue,
                            (long)((NSNumber *)currentRegattaRecord[@"field"]).integerValue];
    NSInteger races = ((NSNumber *)currentRegattaRecord[@"races"]).integerValue;
    BOOL threeDays = currentRegattaRecord[@"threeDays"] != nil ?
    ((NSNumber *)currentRegattaRecord[@"threeDays"]).boolValue : NO;

    cell.mFactorLabel.text = [NSString stringWithFormat:@"%d",
                              [[SimpleDataProvider sharedInstance]mFactor:races atLeastThreeDays:threeDays]];
#else

    NSDictionary *currentRegattaRecord = [SimpleDataProvider sharedInstance].theDataStorageArray[indexPath.row];
    cell.titleLabel.text = currentRegattaRecord[@"title"];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%.3f",
                            ((NSNumber *)currentRegattaRecord[@"score"]).floatValue];
    cell.positLabel.text = [NSString stringWithFormat:@"%ld/%ld",
                            (long)((NSNumber *)currentRegattaRecord[@"posOfYou"]).integerValue,
                            (long)((NSNumber *)currentRegattaRecord[@"numberOfSailors"]).integerValue];
#endif

    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.navigationItem.leftBarButtonItem.enabled = YES;

    return cell;
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[SimpleDataProvider sharedInstance] removeObjectAtIndex:indexPath.row];
        [self update];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate protocol methods
//----------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [SimpleDataProvider sharedInstance].theDataStorageArray.count == 0 ?
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 140 : 70 : 0;
}

//----------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [SimpleDataProvider sharedInstance].theDataStorageArray.count == 0 ?
    NSLocalizedString(@"No regattas", @"No regattas") : @"";
}

//----------------------------------------------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([SimpleDataProvider sharedInstance].theDataStorageArray.count == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
        UILabel *theLabel = [[UILabel alloc]initWithFrame:headerView.frame];
        theLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:
                         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 20.0f : 30.0f];
        theLabel.text = [self tableView:tableView titleForHeaderInSection:0];
        theLabel.textColor = THECOLOR;
        theLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:theLabel];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 140 : 70;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
//----------------------------------------------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RegattaViewController *viewController = (RegattaViewController *)[segue destinationViewController];

    if ([segue.identifier isEqualToString:@"editViewController"]) {
        [viewController loadObjectWithIndex:-1];
    } else {
        CGPoint subviewPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:subviewPosition];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSIndexPath* pathOfTheCell = [self.tableView indexPathForCell:cell];
        NSInteger rowOfTheCell = [pathOfTheCell row];
        [viewController loadObjectWithIndex:rowOfTheCell];
    }
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Editing
//----------------------------------------------------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    if (editing) {
        UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-check" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(22.0f, 22.0f)];
        UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-check" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(18.0f, 18.0f)];

        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                        landscapeImagePhone:landscapeEditIconImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(toggleEdit:)];
        self.navigationItem.leftBarButtonItem = editButton;

    }
    else {
        UIImage *normalEditIconImage = [UIImage imageWithIcon:@"icon-edit" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(22.0f, 22.0f)];
        UIImage *landscapeEditIconImage = [UIImage imageWithIcon:@"icon-edit" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1.0f andSize:CGSizeMake(18.0f, 18.0f)];

        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:normalEditIconImage
                                                        landscapeImagePhone:landscapeEditIconImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(toggleEdit:)];
        self.navigationItem.leftBarButtonItem = editButton;

    }
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Prevent rotation
//----------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)toggleEdit:(id)sender
{
    if (self.tableView.isEditing) {
        [self setEditing:NO animated:YES];
    } else {
        [self setEditing:YES animated:YES];
    }
}


@end
