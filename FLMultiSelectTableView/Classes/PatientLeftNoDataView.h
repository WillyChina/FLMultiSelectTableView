//
//  PatientLeftNoDataView.h
//  PatientLeftNoDataView
//
//  Created by liweiwei on 2022/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientLeftNoDataView : UIView
@property (weak, nonatomic) IBOutlet UITableView *freshTable;
@property (nonatomic, copy)void(^noTiRefresh)(void);
@property (weak, nonatomic) IBOutlet UIView *noResultView;

@end

NS_ASSUME_NONNULL_END
