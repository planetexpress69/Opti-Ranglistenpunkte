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
#import "RankingDetailViewController.h"


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

#ifdef A
    self.title = NSLocalizedString(@"Score list DODV", @"Score list DODV");
#else
    self.title = NSLocalizedString(@"Score list opti-mv.de", @"Score list opti-mv.de");
#endif

    self.lovelyNetworkEngine                                = [[LovelyNetworkEngine alloc] initWithHostName:@"www.teambender.de"];
    self.theTableView.delegate                              = self;
    self.theTableView.dataSource                            = self;
    self.navigationController.navigationBar.translucent     = NO;
    self.navigationController.toolbar.translucent           = NO;
    self.theSpinner.hidesWhenStopped                        = YES;
    self.theTableView.backgroundView                        = nil; // hack the ios6 table background
    self.theTableView.backgroundColor                       = LIGHTBACK;
    self.searchDisplayController.searchBar.backgroundColor  = THECOLOR;
    self.searchDisplayController.searchBar.translucent      = NO;

    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
/*
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
 */
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Fetch the ranking list
//----------------------------------------------------------------------------------------------------------------------
- (void)fetchData
{
    [self.theSpinner startAnimating];

    [self.lovelyNetworkEngine fetchPayloadForPath:@"scrape.php" onCompletion:^(MKNetworkOperation *completedOperation) {
        NSError *parsingError = nil;
        NSArray *payload =
        [NSJSONSerialization JSONObjectWithData:completedOperation.responseData
                                        options:NSJSONReadingAllowFragments
                                          error:&parsingError];
        if (payload && !parsingError) {
            if (payload.count > 0) {
                self.theDatasource = [payload sortedArrayUsingComparator:^NSComparisonResult(id obj1,
                                                                                             id obj2) {
                    int fFirst = ((NSNumber *)(NSDictionary *)obj1[@"pos"]).intValue;
                    int fSecnd = ((NSNumber *)(NSDictionary *)obj2[@"pos"]).intValue;
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

    } onError:^(NSError *error) {
        // network error?
        DLog(@"error             : %@", error);
        self.errorMessageKey = @"NETWORKERROR";
        [self.theTableView reloadData];
        [self.theSpinner stopAnimating];
    }];
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Dismiss the view
//----------------------------------------------------------------------------------------------------------------------
- (IBAction)close:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource protocol methods
//----------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankingCell *cell = nil;
    cell = [self.theTableView dequeueReusableCellWithIdentifier:@"RankingCell" forIndexPath:indexPath];

#ifdef A
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary *elem      = self.theFilteredDatasource[indexPath.row];
        cell.posLabel.text      = [NSString stringWithFormat:@"%d", ((NSNumber *)elem[@"pos"]).intValue];
        cell.nameLabel.text     = [NSString stringWithFormat:@"%@ %@", elem[@"firstname"], elem[@"name"]];
        cell.sailLabel.text     = [NSString stringWithFormat:@"%@ %@", elem[@"sailCountry"], elem[@"sailNumber"]];
        cell.scoreLabel.text    = [NSString stringWithFormat:@"%.2f", ((NSNumber *)elem[@"totalPoints"]).floatValue];
        cell.yearLabel.text     = elem[@"yob"];
        cell.selectionStyle     = UITableViewCellSelectionStyleDefault;
    } else {
        NSDictionary *elem      = self.theDatasource[indexPath.row];
        cell.posLabel.text      = [NSString stringWithFormat:@"%d", ((NSNumber *)elem[@"pos"]).intValue];
        cell.nameLabel.text     = [NSString stringWithFormat:@"%@ %@", elem[@"firstname"], elem[@"name"]];
        cell.sailLabel.text     = [NSString stringWithFormat:@"%@ %@", elem[@"sailCountry"], elem[@"sailNumber"]];
        cell.scoreLabel.text    = [NSString stringWithFormat:@"%.2f", ((NSNumber *)elem[@"totalPoints"]).floatValue];
        cell.yearLabel.text     = elem[@"yob"];
        cell.selectionStyle     = UITableViewCellSelectionStyleDefault;
    }
    return cell;
#else
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary *elem      = self.theFilteredDatasource[indexPath.row];
        cell.posLabel.text      = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        cell.nameLabel.text     = elem[@"name"];
        cell.sailLabel.text     = elem[@"firstname"];

        cell.scoreLabel.text    = [NSString stringWithFormat:@"%@", ((NSString *)elem[@"score"])];
        cell.yearLabel.text     = elem[@"year"];
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    } else {
        NSDictionary *elem      = self.theDatasource[indexPath.row];
        cell.posLabel.text      = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        cell.nameLabel.text     = elem[@"name"];
        cell.sailLabel.text     = elem[@"firstname"];

        cell.scoreLabel.text    = [NSString stringWithFormat:@"%@", ((NSString *)elem[@"score"])];
        cell.yearLabel.text     = elem[@"year"];
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
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
#pragma mark - UITableViewDelegate protocol methods
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
#pragma mark - UIViewController - User triggered actions
//----------------------------------------------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
#ifdef A
    NSDictionary *elem= nil;
    NSIndexPath *selectedRowsIndexPath = nil;
    RankingDetailViewController *detailViewController = [segue destinationViewController];

    if (self.searchDisplayController.active) {
        selectedRowsIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        elem = self.theFilteredDatasource[selectedRowsIndexPath.row];
    } else {
        selectedRowsIndexPath = [self.theTableView indexPathForSelectedRow];
        elem = self.theDatasource[selectedRowsIndexPath.row];
    }
    [self.theTableView deselectRowAtIndexPath:selectedRowsIndexPath animated:YES];
    detailViewController.theDataSource = elem;
#else
#endif
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
#pragma mark - Search filter method
//----------------------------------------------------------------------------------------------------------------------
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSString *format =  @"(name contains[cd] %@) OR "
                        @"(firstname contains[cd] %@) OR "
                        @"(yob contains[cd] %@) OR "
                        @"(club contains[cd] %@)";

    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:format,
                                    searchText,
                                    searchText,
                                    searchText,
                                    searchText,
                                    searchText];

    self.theFilteredDatasource = [self.theDatasource filteredArrayUsingPredicate:resultPredicate];
}

@end
