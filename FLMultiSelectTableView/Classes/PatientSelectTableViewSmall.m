//
//  PatientSelectTableViewSmall.m
//  91Trial_iPad
//
//  Created by liweiwei on 2022/6/6.
//

#import "PatientSelectTableViewSmall.h"
#import "PatientSelectTableCell.h"

@interface PatientSelectTableViewSmall ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *flagArray;
@property (nonatomic, strong)NSMutableArray *rightDownArr;
@property (nonatomic, assign)NSInteger lastRow;
@end

@implementation PatientSelectTableViewSmall


- (IBAction)clearClick:(UIButton *)sender {
    
    for (HospitalModel *model in self.dataArr) {
        model.IsChoose = NO;
    }
    [self.tableView reloadData];
//    if (self.selectEnd) {
//        self.selectEnd(@"");
//    }
}

- (IBAction)sureClick:(UIButton *)sender {
    if (self.selectEnd) {
        NSString *titleStr = @"";
        for (HospitalModel *model in self.dataArr) {
            if (_index == 0 || _index == 1) {
                if (model.IsChoose) {
                    if (titleStr.length) {
                        titleStr = [titleStr stringByAppendingString:[NSString stringWithFormat:@"/%@",model.Text]];
                    }else{
                        titleStr = [titleStr stringByAppendingString:[NSString stringWithFormat:@"%@",model.Text]];
                    }
                }else{
                    
                }
            }else{
                if (model.IsChoose) {
                    titleStr = model.Text;
                }else{
                    
                }
            }

        }
        
        self.selectEnd(titleStr);
    }
    [self removeFromSuperview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientSelectTableCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HospitalModel *model = self.dataArr[indexPath.row];
    [cell configData:model];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_index == 0 || _index == 1) {
        HospitalModel *model = self.dataArr[indexPath.row];
        model.IsChoose = !model.IsChoose;
    }else{

        HospitalModel *model = self.dataArr[indexPath.row];

        if (indexPath.row == _lastRow) {
            model.IsChoose = !model.IsChoose;
        }else{
            for (HospitalModel *allModel in self.dataArr) {
                allModel.IsChoose = NO;
            }
            model.IsChoose = YES;
        }
        _lastRow = indexPath.row;
        
    }
    

//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
//
//    ProjectModel *model = self.dataArr[indexPath.row];
//    model.isSelect = !model.isSelect;
    
    [self.tableView reloadData];

}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    CGRect tableFrame = self.bounds;
//    tableFrame.origin.y = 62;
//    tableFrame.size.height = kScreenHeight-62-72;
//    self.tableView.frame = tableFrame;
//    [self.tableView reloadData];
}

-(void)configData:(NSMutableArray *)arr withIndex:(NSInteger)tag{
    self.dataArr = arr;
    self.index = tag;
    [self.tableView reloadData];
}



-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.shadowColor = Color_hexA(@"#000000", 0.2).CGColor;
    self.layer.shadowOffset = CGSizeMake(3, 0);
    self.layer.shadowOpacity = .5;
    
    
    self.clearBtn.layer.cornerRadius = 8;
    self.clearBtn.layer.borderWidth = 1;
    self.clearBtn.layer.borderColor = Color_hex(@"#DCDEE0").CGColor;
    
    self.sureBtn.layer.cornerRadius = 8;

    self.lastRow = 10000;
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0.01;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
        if ((NO)) {
#endif
        }
        [_tableView registerNib:[UINib nibWithNibName:@"PatientSelectTableCell" bundle:nil] forCellReuseIdentifier:@"PatientSelectTableCell"];

}
    


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
