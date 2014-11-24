//
//  RegattaDetailCell.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 24.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "RegattaDetailCell.h"

@implementation RegattaDetailCell
- (void)awakeFromNib
{
    self.rnamelabel.textColor = THECOLOR;
    self.sl_points_cupLabel.textColor = THECOLOR;
    self.sl_pointsLabel.textColor = THECOLOR;
    self.positionboatsLabel.textColor = THECOLOR;
    self.runs_scoredLabel.textColor = [UIColor whiteColor];
    self.runs_scoredLabel.backgroundColor = THECOLOR;
    self.runs_scoredLabel.layer.cornerRadius = 3.0f;
    self.runs_scoredLabel.layer.masksToBounds = YES;
}

@end
