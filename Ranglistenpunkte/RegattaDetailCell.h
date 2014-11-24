//
//  RegattaDetailCell.h
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 24.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegattaDetailCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *rnamelabel;
@property (nonatomic, weak) IBOutlet UILabel *sl_pointsLabel;
@property (nonatomic, weak) IBOutlet UILabel *sl_points_cupLabel;
@property (nonatomic, weak) IBOutlet UILabel *positionboatsLabel;
@property (nonatomic, weak) IBOutlet UILabel *runs_totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *runs_scoredLabel;
@end
