//
//  PatientSelectTableView.h
//  91Trial_iPad
//
//  Created by liweiwei on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientSelectTableView : UIView
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, copy)void(^selectEnd)(NSArray *typeArr);
-(void)refreshData;
@end

NS_ASSUME_NONNULL_END
