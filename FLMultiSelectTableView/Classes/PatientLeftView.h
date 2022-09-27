//
//  PatientLeftView.h
//  PatientLeftNoDataView
//
//  Created by liweiwei on 2022/8/17.
//

#import <UIKit/UIKit.h>
#import "PatientSelectTableView.h"
#import "PatientSelectTableViewSmall.h"
NS_ASSUME_NONNULL_BEGIN

@interface PatientLeftView : UIView
@property (nonatomic, strong)PatientSelectTableView *selectTableView;
@property (nonatomic, strong)PatientSelectTableViewSmall *selectTableViewSmall;

@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchAboveBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (nonatomic,copy) void (^clearPatient)(void);
@end

NS_ASSUME_NONNULL_END
