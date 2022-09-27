//
//  PatientLeftView.h
//  91Trial_iPad
//
//  Created by Ashermed on 2022/5/30.
//

#import <UIKit/UIKit.h>
#import "PatientListModel.h"
#import "PatientSelectTableView.h"
#import "PatientSelectTableViewSmall.h"
#import "ScreenView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PatientLeftView : UIView
@property (nonatomic,strong) ScreenView *screenView;
@property (nonatomic, strong)PatientSelectTableView *selectTableView;
@property (nonatomic, strong)PatientSelectTableViewSmall *selectTableViewSmall;

@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchAboveBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) void (^choosePatient)(PatientListModel *model);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (nonatomic,copy) void (^clearPatient)(void);
@end

NS_ASSUME_NONNULL_END
