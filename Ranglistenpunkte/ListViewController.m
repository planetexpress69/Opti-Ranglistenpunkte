//
//  ListViewController.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 21.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "ListViewController.h"
#import "LovelyNetworkEngine.h"
#import "RankingCell.h"


@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, strong)               LovelyNetworkEngine         *lovelyNetworkEngine;
@property (nonatomic, strong)               NSArray                     *theDatasource;
@property (nonatomic, strong)               NSArray                     *theFilteredDatasource;
@property (nonatomic, weak)     IBOutlet    UITableView                 *theTableView;
@property (nonatomic, weak)     IBOutlet    UIActivityIndicatorView     *theSpinner;
@property (nonatomic, weak)                 NSString                    *errorMessageKey;
//----------------------------------------------------------------------------------------------------------------------
@end

@implementation ListViewController
//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init & lifecycle
//----------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UISearchBar appearance] setTintColor:THECOLOR];
        self.searchDisplayController.searchBar.tintColor = THECOLOR;
    } else {
        [[UISearchBar appearance] setBarTintColor:THECOLOR];
        self.searchDisplayController.searchBar.barTintColor = THECOLOR;
    }

    // Do any additional setup after loading the view.

#ifdef A
    self.title = NSLocalizedString(@"Score list DODV", @"Score list DODV");
#else
    self.title = NSLocalizedString(@"Score list opti-mv.de", @"Score list opti-mv.de");
#endif
    self.lovelyNetworkEngine                    = [[LovelyNetworkEngine alloc]initWithHostName:@"www.kimonolabs.com"];

    self.theTableView.delegate                  = self;
    self.theTableView.dataSource                = self;

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;

    self.theSpinner.hidesWhenStopped            = YES;

    self.theTableView.backgroundView            = nil; // hack the ios6 table background
    self.theTableView.backgroundColor           = LIGHTBACK;

    self.searchDisplayController.searchBar.backgroundColor = THECOLOR;

    self.searchDisplayController.searchBar.translucent = NO;

}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//----------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [self.theSpinner startAnimating];

    // please use your own api key!!!
    [self.lovelyNetworkEngine fetchPayloadForApiKey:@"04ac821fe0f3bd9c2905f196ab7ddb15"
                                       onCompletion:^(MKNetworkOperation *completedOperation)
     {
         NSError *parsingError = nil;
         NSDictionary *payload =
         [NSJSONSerialization JSONObjectWithData:completedOperation.responseData
                                         options:NSJSONReadingAllowFragments
                                           error:&parsingError];

         if (payload && !parsingError) {
             NSMutableArray *theRawArray = ((NSArray *)payload[@"results"][@"collection1"]).mutableCopy;

#ifndef A
             // get rid of the table header in B
             [theRawArray removeObjectAtIndex:0];
#endif
             if (theRawArray && theRawArray.count > 0) {

                 self.theDatasource = [theRawArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,
                                                                                                  id obj2) {
                     float fFirst = ((NSNumber *)(NSDictionary *)obj1[@"position"]).floatValue;
                     float fSecnd = ((NSNumber *)(NSDictionary *)obj2[@"position"]).floatValue;
                     if (fFirst > fSecnd)
                         return NSOrderedDescending;
                     else if (fFirst < fSecnd)
                         return NSOrderedAscending;
                     return NSOrderedSame;
                 }];
                 self.errorMessageKey = nil;
             }
             else {
                 self.errorMessageKey = @"NODATAERROR";
             }
         }
         else {
             self.errorMessageKey = @"PARSINGERROR";
         }

         [self.theTableView reloadData];
         [self.theSpinner stopAnimating];

     }
     onError:^(NSError *error) {
         // network error?
         DLog(@"error             : %@", error);
         self.errorMessageKey = @"NETWORKERROR";
         [self.theTableView reloadData];
         [self.theSpinner stopAnimating];
     }];
}

//----------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------------------------------
- (IBAction)close:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          //
                                                      }];
}

//----------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankingCell *cell = nil;
    cell = [self.theTableView dequeueReusableCellWithIdentifier:@"RankingCell" forIndexPath:indexPath];

#ifdef A
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary *elem = self.theFilteredDatasource[indexPath.row];
        cell.posLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        cell.nameLabel.text = elem[@"name"];
        cell.sailLabel.text = elem[@"sail"];

        cell.scoreLabel.text = [NSString stringWithFormat:@"%@", ((NSString *)elem[@"score"])];
        cell.yearLabel.text = elem[@"year"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSDictionary *elem = self.theDatasource[indexPath.row];
        cell.posLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        cell.nameLabel.text = elem[@"name"];
        cell.sailLabel.text = elem[@"sail"];

        cell.scoreLabel.text = [NSString stringWithFormat:@"%@", ((NSString *)elem[@"score"])];
        cell.yearLabel.text = elem[@"year"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
#else
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary *elem = self.theFilteredDatasource[indexPath.row];
        cell.posLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        cell.nameLabel.text = elem[@"name"];
        cell.sailLabel.text = elem[@"firstName"];

        cell.scoreLabel.text = [NSString stringWithFormat:@"%@", ((NSString *)elem[@"score"])];
        cell.yearLabel.text = elem[@"year"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSDictionary *elem = self.theDatasource[indexPath.row];
        cell.posLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        cell.nameLabel.text = elem[@"name"];
        cell.sailLabel.text = elem[@"firstName"];

        cell.scoreLabel.text = [NSString stringWithFormat:@"%@", ((NSString *)elem[@"score"])];
        cell.yearLabel.text = elem[@"year"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
#endif
}

//----------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.theFilteredDatasource.count;
    } else {
        return self.theDatasource.count;
    }
}

//----------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0.0f;
    }
    return 70.0f;
}

//----------------------------------------------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 70.0f)];
    textView.userInteractionEnabled = NO;
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    textView.textColor = [UIColor grayColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.textAlignment = NSTextAlignmentCenter;

#ifdef A
    NSString *scoreListDescKey = @"ScoreListDescTextA";
#else
    NSString *scoreListDescKey = @"ScoreListDescTextB";
#endif

    textView.text = self.theDatasource && self.theDatasource.count > 0 ?
    NSLocalizedString(scoreListDescKey, scoreListDescKey) :
    NSLocalizedString(self.errorMessageKey, self.errorMessageKey);
    return textView;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UISearchDisplayController delegate methods
//----------------------------------------------------------------------------------------------------------------------
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"(name contains[cd] %@) OR (firstName contains[cd] %@) OR (year contains[cd] %@)",
                                    searchText, searchText, searchText, searchText];
    self.theFilteredDatasource = [self.theDatasource filteredArrayUsingPredicate:resultPredicate];
}

@end
