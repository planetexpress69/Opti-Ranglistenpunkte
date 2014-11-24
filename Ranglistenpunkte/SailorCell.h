//
//  SailorCell.h
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 24.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SailorCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *firstnamenameLabel;
@property (nonatomic, weak) IBOutlet UILabel *posLabel;
@property (nonatomic, weak) IBOutlet UILabel *sailCountryLabel;
@property (nonatomic, weak) IBOutlet UILabel *sailNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *yobLabel;
@property (nonatomic, weak) IBOutlet UILabel *clubLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalPointsLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalRunsLabel;
@end
