//
//  RegattaCell.h
//  EditableViewControllerExample
//
//  Created by Martin Kautz on 09.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegattaCell : UITableViewCell
//----------------------------------------------------------------------------------------------------------------------
@property (nonatomic, strong)     IBOutlet UILabel *titleLabel;
@property (nonatomic, strong)     IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong)     IBOutlet UILabel *positLabel;
@property (nonatomic, strong)     IBOutlet UILabel *mFactorLabel;
//----------------------------------------------------------------------------------------------------------------------
@end
