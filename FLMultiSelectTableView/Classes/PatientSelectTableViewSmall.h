//
//  PatientSelectTableViewSmall.h
//  91Trial_iPad
//
//  Created by liweiwei on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientSelectTableViewSmall : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, copy)void(^selectEnd)(NSString *titleStr);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectH;
-(void)configData:(NSMutableArray *)arr withIndex:(NSInteger)tag;
@property (nonatomic, assign)NSInteger index;
@end

NS_ASSUME_NONNULL_END
