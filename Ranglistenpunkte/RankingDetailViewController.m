//
//  RankingDetailViewController.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 24.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "RankingDetailViewController.h"
#import "RegattaDetailCell.h"
#import "SailorCell.h"

@interface RankingDetailViewController() <UITableViewDataSource, UITableViewDelegate>
// ---------------------------------------------------------------------------------------------------------------------
@property (nonatomic, weak)     IBOutlet    UITableView                 *theTableView;
// ---------------------------------------------------------------------------------------------------------------------
@end

@implementation RankingDetailViewController


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Init & lifecycle
//----------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.theTableView.delegate      = self;
    self.theTableView.dataSource    = self;
    self.title                      = @"Detail";
}


//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDataSorce protocol methods
//----------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;

        default:
        {
            NSArray *aRegattas = self.theDataSource[@"regatta"];
            if (aRegattas == nil) {
                return 1;
            } else {
                int counter = 0;
                NSDictionary *regatta;
                for (regatta in aRegattas) {
                    if (regatta.count > 0) {
                        counter ++;
                    }
                }
                return counter;
            }
        }
            break;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// ---------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            SailorCell *cell                = (SailorCell *)[self.theTableView dequeueReusableCellWithIdentifier:@"SailorCell"
                                                                                                    forIndexPath:indexPath];
            NSDictionary *sailor            = self.theDataSource;
            cell.firstnamenameLabel.text    = [NSString stringWithFormat:@"%@ %@", sailor[@"firstname"], sailor[@"name"]];
            cell.posLabel.text              = [NSString stringWithFormat:@"%@", sailor[@"pos"]];
            cell.clubLabel.text             = [NSString stringWithFormat:@"%@", sailor[@"club"]];
            cell.sailCountryLabel.text      = [NSString stringWithFormat:@"%@", sailor[@"sailCountry"]];
            cell.sailNumberLabel.text       = [NSString stringWithFormat:@"%@", sailor[@"sailNumber"]];
            cell.totalPointsLabel.text      = [NSString stringWithFormat:@"%.2f", [sailor[@"totalPoints"]floatValue]];

            cell.yobLabel.text              = [NSString stringWithFormat:@"%@", sailor[@"yob"]];
            cell.totalRunsLabel.text        = [NSString stringWithFormat:@"%@", sailor[@"totalRuns"]];
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;

            return cell;
        }
            break;

        default:
        {
            RegattaDetailCell *cell         = (RegattaDetailCell *)[self.theTableView dequeueReusableCellWithIdentifier:@"RegattaDetailCell"
                                                                                                           forIndexPath:indexPath];
            NSDictionary *regatta           = self.theDataSource[@"regatta"][indexPath.row];
            cell.rnamelabel.text            = [NSString stringWithFormat:@"%@", regatta[@"rname"]];
            cell.sl_pointsLabel.text        = [NSString stringWithFormat:@"%.2f", [regatta[@"sl_points"]floatValue]];
            cell.sl_points_cupLabel.text    = [NSString stringWithFormat:@"%.2f", [regatta[@"sl_points_cup"]floatValue]];
            cell.positionboatsLabel.text    = [NSString stringWithFormat:@"%@/%@", regatta[@"position"], regatta[@"boats"]];
            cell.runs_totalLabel.text       = [NSString stringWithFormat:@"%@", regatta[@"runs_total"]];
            cell.runs_scoredLabel.text      = [NSString stringWithFormat:@"%@", regatta[@"runs_scored"]];
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;

            return cell;
        }
            break;
    }
    return nil;

}

//----------------------------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate protocol methods
//----------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 120.0f : 80.0f;
}

@end
