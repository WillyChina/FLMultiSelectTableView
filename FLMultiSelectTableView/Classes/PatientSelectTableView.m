//
//  PatientSelectTableView.m
//  PatientLeftNoDataView
//
//  Created by liweiwei on 2022/6/6.
//

#import "PatientSelectTableView.h"
#import "PatientSelectTableCell.h"
//颜色
#define Color_hex(hexString)       [UIColor colorWithHexString:hexString]
#define Color_hexA(hexString, a)   [UIColor colorWithHexString:hexString alpha:a]

@interface PatientSelectTableView ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sectionArr;
@property (nonatomic, strong)NSMutableArray *flagArray;
@property (nonatomic, strong)NSMutableArray *rightDownArr;
@property (nonatomic, assign)NSInteger lastRowZero;
@property (nonatomic, assign)NSInteger lastRowOne;
@property (nonatomic, assign)NSInteger lastRowTwo;
@property (nonatomic, assign)NSInteger lastRowThree;

@property (nonatomic, assign)BOOL isSelectedZero;
@property (nonatomic, assign)BOOL isSelectedOne;
@property (nonatomic, assign)BOOL isSelectedTwo;
@property (nonatomic, assign)BOOL isSelectedThree;

@end

@implementation PatientSelectTableView


- (IBAction)backClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)clearClick:(UIButton *)sender {
    for (NSMutableArray *sectionArr in self.dataArr) {
        for (HospitalModel *model in sectionArr) {
            model.IsChoose = NO;
        }
    }
    [self.tableView reloadData];
    if (self.selectEnd) {
        self.selectEnd(@[]);
    }
}

- (IBAction)sureClick:(UIButton *)sender {
    if (self.selectEnd) {
        self.selectEnd(self.dataArr);

    }
    [self removeFromSuperview];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
    headerView.tag = 100 + section;
    NSLog(@"---%ld",section);

    UIView *colorView = [[UIView alloc]init];
    colorView.frame = CGRectMake(20, 15, 2, 14);
//    colorView.backgroundColor = Color_hex(@"#4CC5CD");
    [headerView addSubview:colorView];

    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.frame = CGRectMake(28, 12, 80, 20);
//    sectionLabel.textColor = Color_hex(@"#595959");
    sectionLabel.font = [UIFont systemFontOfSize:14];
    sectionLabel.text = self.sectionArr[section];
    [headerView addSubview:sectionLabel];

    UIButton *rightDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightDownBtn.frame = CGRectMake(self.bounds.size.width-36, 14, 16, 16);
    [rightDownBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [rightDownBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateSelected];
    [headerView addSubview:rightDownBtn];
    rightDownBtn.tag = 200+section;
    rightDownBtn.userInteractionEnabled = NO;

    if (self.rightDownArr.count < 4) {
        [self.rightDownArr addObject:rightDownBtn];
    }
    if (self.rightDownArr.count == 4) {
        [self.rightDownArr removeObjectAtIndex:section];
        [self.rightDownArr insertObject:rightDownBtn atIndex:section];
    }
    
    switch (section) {
        case 0:
            rightDownBtn.selected = _isSelectedZero;
            break;
        case 1:
            rightDownBtn.selected = _isSelectedOne;
            break;
        case 2:
            rightDownBtn.selected = _isSelectedTwo;
            break;
        case 3:
            rightDownBtn.selected = _isSelectedThree;
            break;
            
        default:
            break;
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [headerView addGestureRecognizer:tap];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientSelectTableCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *arr = self.dataArr[indexPath.section];
    HospitalModel *model = arr[indexPath.row];
    [cell configData:model];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_flagArray[indexPath.section] isEqualToString:@"0"]){
        return 0;
    }else{
        return 35;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableArray *arr = self.dataArr[indexPath.section];

    
    if (indexPath.section == 0) {
        HospitalModel *model = arr[indexPath.row];
        model.IsChoose = !model.IsChoose;
        
    }else if (indexPath.section == 1) {
        HospitalModel *model = arr[indexPath.row];
        model.IsChoose = !model.IsChoose;
    }else{

        HospitalModel *model = arr[indexPath.row];
        if (indexPath.section == 2){
            if (indexPath.row == _lastRowTwo) {
                model.IsChoose = !model.IsChoose;
            }else{
                for (HospitalModel *allModel in arr) {
                    allModel.IsChoose = NO;
                }
                model.IsChoose = YES;
            }
            _lastRowTwo = indexPath.row;

        }else if (indexPath.section == 3){
            if (indexPath.row == _lastRowThree) {
                model.IsChoose = !model.IsChoose;
            }else{
                for (HospitalModel *allModel in arr) {
                    allModel.IsChoose = NO;
                }
                model.IsChoose = YES;
            }
            _lastRowThree = indexPath.row;
        }
    }
    
    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSMutableArray *indexArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<arr.count; i++) {
        NSIndexPath *index=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
        [indexArr addObject:index];
    }
    
    [_tableView reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];


}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)sectionClick:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag % 100;
    NSLog(@"%d===",index);
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    NSArray *arr = _dataArr[index];
    for (int i = 0; i < arr.count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:index];
        [indexArray addObject:path];
    }
    

    
    //展开
    if ([_flagArray[index] isEqualToString:@"0"]) {
        _flagArray[index] = @"1";
        for (UIButton *btn in self.rightDownArr) {
            if (btn.tag == index+200) {
                btn.selected = YES;
            }
        }
        if (index == 0) {
            _isSelectedZero = YES;
        }else if (index == 1){
            _isSelectedOne = YES;
        }
        else if (index == 2){
            _isSelectedTwo = YES;
        }else if (index == 3){
            _isSelectedThree = YES;
        }
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    } else { //收起
        _flagArray[index] = @"0";
        for (UIButton *btn in self.rightDownArr) {
            if (btn.tag == index+200) {
                btn.selected = NO;
            }
        }
        if (index == 0) {
            _isSelectedZero = NO;
        }else if (index == 1){
            _isSelectedOne = NO;
        }
        else if (index == 2){
            _isSelectedTwo = NO;
        }else if (index == 3){
            _isSelectedThree = NO;
        }
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect tableFrame = self.bounds;
    tableFrame.origin.y = 62;
    tableFrame.size.height = [UIScreen mainScreen].bounds.size.height-62-72;
    self.tableView.frame = tableFrame;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
//
//        if (@available(iOS 15.0, *)) {
//            _tableView.sectionHeaderTopPadding = 0;
//        }
        
    return _tableView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    self.layer.shadowColor = Color_hexA(@"#000000", 0.2).CGColor;
    self.layer.shadowOffset = CGSizeMake(3, 0);
    self.layer.shadowOpacity = .5;
    
    
    self.clearBtn.layer.cornerRadius = 8;
    self.clearBtn.layer.borderWidth = 1;
//    self.clearBtn.layer.borderColor = Color_hex(@"#DCDEE0").CGColor;
    
    self.sureBtn.layer.cornerRadius = 8;

    
    [self addSubview:self.tableView];
 
    self.lastRowZero = 100000;
    self.lastRowOne = 10000;
    self.lastRowTwo = 10000;
    self.lastRowThree = 10000;
    
    self.sectionArr = [NSMutableArray arrayWithArray:@[@"访视类型",@"访视状态",@"患者状态",@"入组状态"]];

    _flagArray  = [NSMutableArray arrayWithCapacity:0];
    _rightDownArr  = [NSMutableArray arrayWithCapacity:0];
    
    self.isSelectedZero = NO;
    self.isSelectedOne = NO;
    self.isSelectedTwo = NO;
    self.isSelectedThree = NO;


    NSInteger num = self.sectionArr.count;
    for (int i = 0; i < num; i ++) {
        [_flagArray addObject:@"0"];
    }


}
 
-(void)refreshData{
    [self.tableView reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
