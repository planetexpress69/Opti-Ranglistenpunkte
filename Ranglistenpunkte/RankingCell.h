//
//  RankingCellTableViewCell.h
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 21.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RankingCell : UITableViewCell
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, weak)     IBOutlet UILabel *posLabel;
@property (nonatomic, strong)   IBOutlet UILabel *nameLabel;
@property (nonatomic, weak)     IBOutlet UILabel *sailLabel;
@property (nonatomic, weak)     IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak)     IBOutlet UILabel *yearLabel;
//----------------------------------------------------------------------------------------------------------------------
@end
