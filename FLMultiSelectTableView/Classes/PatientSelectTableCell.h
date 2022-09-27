//
//  PatientSelectTableCell.h
//  91Trial_iPad
//
//  Created by liweiwei on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientSelectTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
-(void)configData:(HospitalModel *)model;
-(void)configCenterData:(HospitalModel *)model;

@end

NS_ASSUME_NONNULL_END
