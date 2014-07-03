//
//  RankingCellTableViewCell.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 21.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "RankingCell.h"


@implementation RankingCell
//----------------------------------------------------------------------------------------------------------------------
#pragma mark - Waking up...
//----------------------------------------------------------------------------------------------------------------------
- (void)awakeFromNib
{
    self.posLabel.textColor = THECOLOR;
    self.nameLabel.textColor = THECOLOR;
    self.sailLabel.textColor = THECOLOR;
    self.scoreLabel.textColor = THECOLOR;
    self.yearLabel.textColor = THECOLOR;
}

@end
