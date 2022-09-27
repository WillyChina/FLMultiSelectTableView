//
//  PatientLeftNoDataView.m
//  91Trial_iPad
//
//  Created by liweiwei on 2022/8/17.
//

#import "PatientLeftNoDataView.h"

@implementation PatientLeftNoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    _freshTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.noTiRefresh) {
            self.noTiRefresh();
        }
    }];
}

@end
