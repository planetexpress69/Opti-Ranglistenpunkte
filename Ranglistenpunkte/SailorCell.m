//
//  SailorCell.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 24.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "SailorCell.h"

@implementation SailorCell

- (void)awakeFromNib
{
    /*
     @property (nonatomic, weak) IBOutlet UILabel *firstnamenameLabel;
     @property (nonatomic, weak) IBOutlet UILabel *posLabel;
     @property (nonatomic, weak) IBOutlet UILabel *sailCountryLabel;
     @property (nonatomic, weak) IBOutlet UILabel *sailNumberLabel;
     @property (nonatomic, weak) IBOutlet UILabel *yobLabel;
     @property (nonatomic, weak) IBOutlet UILabel *clubLabel;
     @property (nonatomic, weak) IBOutlet UILabel *totalPointsLabel;

     */

    self.firstnamenameLabel.textColor = THECOLOR;
    self.posLabel.textColor = THECOLOR;
    self.sailCountryLabel.textColor = THECOLOR;
    self.sailNumberLabel.textColor = THECOLOR;
    self.yobLabel.textColor = THECOLOR;
    self.clubLabel.textColor = THECOLOR;
    self.totalPointsLabel.textColor = THECOLOR;
    self.totalRunsLabel.textColor = [UIColor whiteColor];
    self.totalRunsLabel.backgroundColor = THECOLOR;
    self.totalRunsLabel.layer.cornerRadius = 3.0f;
    self.totalRunsLabel.layer.masksToBounds = YES;

}


@end
