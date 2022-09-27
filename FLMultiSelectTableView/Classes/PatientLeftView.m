//
//  PatientLeftView.m
//  PatientLeftNoDataView
//
//  Created by liweiwei on 2022/8/17.
//

#import "PatientLeftView.h"
#import "PatientLeftNoDataView.h"
#import <FLMultiSelectTableView/HospitalModel.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//颜色
#define Color_hex(hexString)       [UIColor colorWithHexString:hexString]
#define Color_hexA(hexString, a)   [UIColor colorWithHexString:hexString alpha:a]

//#import "UIButton+LXMImagePosition.h"
@interface PatientLeftView ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *stateArr;
@property (nonatomic, strong) NSMutableArray *orderArr;

//访视类型
@property (nonatomic,strong) NSString *strVisit;

//访视状态
@property (nonatomic,strong) NSString *strState;

//患者状态
@property (nonatomic,strong) NSString *strPatient;

//入组状态
@property (nonatomic,strong) NSString *strGroup;

//治愈状态
@property (nonatomic,strong) NSString *strCure;

//治疗状态
@property (nonatomic,strong) NSString *strTreat;

@property (nonatomic, strong) NSNumber *patientType;
@property (nonatomic, strong) NSNumber *patientGroup;

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong)UIScrollView *typeScroll;
@property (nonatomic, strong)UIButton *lastBtn;
@property (nonatomic, strong) NSMutableArray *centerArr;
@property (nonatomic, copy)NSString *searchStr;
@property (nonatomic, copy)NSString *hospitalStr;

@property (nonatomic, strong) PatientLeftNoDataView *noDataView;

@property (nonatomic,assign) BOOL isAddPatient;

@property (nonatomic,assign) CGRect lastRect;

@property (nonatomic, assign) BOOL isNoMore;
@end

@implementation PatientLeftView
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (instancetype)init {
    self = [super init];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PatientLeftView" owner:self options:nil] firstObject];
        self.frame = CGRectMake(0 , 0, 274, [UIScreen mainScreen].bounds.size.height);
    }
    _lastRect = CGRectMake(0, 100, 274, [UIScreen mainScreen].bounds.size.height - 100);
    

    self.pageIndex = 1;
//    //下拉刷新
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.pageIndex = 1;
//
//        [self requestDate];
//    }];
//    //..上拉加载
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageIndex = self.pageIndex + 1;
//        [self requestDate];
//    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    self.tableView.backgroundColor = KCustomAdjustColor([UIColor whiteColor], kMainColor);
    [self.tableView registerNib:[UINib nibWithNibName:@"PatientListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientListTableViewCell"];

    self.typeScroll = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [self.topView addSubview:self.typeScroll];
//    [self.typeScroll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.topView.mas_left).offset(16);
//        make.right.mas_equalTo(self.topView.mas_right).offset(-16);
//        make.bottom.mas_equalTo(self.topView.mas_bottom).offset(-29);
//        make.height.mas_equalTo(28);
//    }];
    self.typeScroll.hidden = YES;

        [self requestDate];
        [self requestSelectConditions];

    return self;
}
- (void)addPatient
{
    self.pageIndex = 1;
    self.hospitalStr = @"";
    self.searchStr = @"";
    self.strVisit = @"";
    self.strState = @"";
    self.strPatient = @"";
    self.strGroup = @"";
    self.searchBar.text = @"";
    self.isAddPatient = YES;
    [self requestDate];
}



- (IBAction)addPatient:(UIButton *)sender{


    
}

//获取筛选条件
-(void)requestSelectConditions{
    self.stateArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:[ASHCommon GetUserDefault:@"Cac_projectid"] forKey:@"projectId"];
//    [dict setValue:[ASHCommon GetUserDefault:@"Cac_RoleName"] forKey:@"roleName"];
//    [dict setValue:[ASHCommon GetUserDefault:@"Cac_RoleId"] forKey:@"roleId"];
//    NSDictionary *userInfo = [ASHCommon getObjectFromJsonString:[ASHCommon GetUserDefault:@"userinfo"]];
//    [dict setValue:[userInfo objectForKey:@"userId"] forKey:@"userId"];
//    ASHWeakSelf;
//    [HttpTools Get:ASHUrl(ASHGetVisitString) parameters:dict success:^(id responseObject) {
//        NSDictionary *dictData = [responseObject objectForKey:@"Data"];
//        NSMutableArray *arrayVisit = [ASHValidate returnArray:[dictData objectForKey:@"VisitDDL"]];
//        NSMutableArray *arrayVist01 = [NSMutableArray new];
//        for (NSDictionary *dic in arrayVisit)
//        {
//            HospitalModel *model = [[HospitalModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [arrayVist01 addObject:model];
//        }
//        NSMutableArray *arrayStatus = [ASHValidate returnArray:[dictData objectForKey:@"VisitStatusDDL"]];
//        NSMutableArray *arrayStatus01 = [NSMutableArray new];
//        for (NSDictionary *dic in arrayStatus)
//        {
//            HospitalModel *model = [[HospitalModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [arrayStatus01 addObject:model];
//        }
//        NSMutableArray *arrayDataStatus = [ASHValidate returnArray:[dictData objectForKey:@"PatientDataStatusDDL"]];
//        NSMutableArray *arrayDataStatus01 = [NSMutableArray new];
//        for (NSDictionary *dic in arrayDataStatus)
//        {
//            HospitalModel *model = [[HospitalModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [arrayDataStatus01 addObject:model];
//        }
//        NSMutableArray *arrayGroup = [ASHValidate returnArray:[dictData objectForKey:@"IsInGroupDDL"]];
//        NSMutableArray *arrayGroup01 = [NSMutableArray new];
//        for (NSDictionary *dic in arrayGroup)
//        {
//            HospitalModel *model = [[HospitalModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [arrayGroup01 addObject:model];
//        }
//        NSMutableArray *arrayCureStatus = [ASHValidate returnArray:[dictData objectForKey:@"CureStatusDDL"]];
//        NSMutableArray *arrayCureStatus01 = [NSMutableArray new];
//        for (NSDictionary *dic in arrayCureStatus)
//        {
//            HospitalModel *model = [[HospitalModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [arrayCureStatus01 addObject:model];
//        }
//        NSMutableArray *arrayTreatStatus = [ASHValidate returnArray:[dictData objectForKey:@"TreatStatusDDL"]];
//        NSMutableArray *arrayTreatStatus01 = [NSMutableArray new];
//        for (NSDictionary *dic in arrayTreatStatus)
//        {
//            HospitalModel *model = [[HospitalModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [arrayTreatStatus01 addObject:model];
//        }
//        weakSelf.orderArr = [NSMutableArray arrayWithArray:[dictData objectForKey:@"OrderTypeDDL"]];
//        [weakSelf.stateArr addObject:arrayVist01];
//        [weakSelf.stateArr addObject:arrayStatus01];
//        [weakSelf.stateArr addObject:arrayDataStatus01];
//        [weakSelf.stateArr addObject:arrayGroup01];
//
//
//    } failure:^(NSError *error) {
//
//    }];
    
}


- (void)requestDate {
    
    if (!_noDataView && _pageIndex == 1) {
//        ASHWeakSelf;
        self.noDataView = [[NSBundle mainBundle] loadNibNamed:@"PatientLeftNoDataView" owner:self options:nil].lastObject;
        self.noDataView.noTiRefresh = ^{
//            weakSelf.searchBar.text = @"";
//            weakSelf.pageIndex = 1;
//            weakSelf.hospitalStr = @"";
//            weakSelf.searchStr = @"";
//            weakSelf.isAddPatient = YES;
//            //清除检索中心的数据
//            [weakSelf.screenView clearAllSelections];
//
//            [weakSelf requestDate];
        };
        self.noDataView.frame = _lastRect;
        [self addSubview:self.noDataView];
    }
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//
//    [HttpTools Get:ASHUrl(ASHPatientListString1) parameters:dict success:^(id responseObject) {
//        [self endRefresh];
//
//        NSArray *array = [responseObject objectForKey:@"Data"];
//
//        for (NSDictionary *dic in array) {
//            PatientListModel *model = [[PatientListModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//
//            [self.dataArray addObject:model];
//        }
//
//        [self.tableView reloadData];
//
//
//    } failure:^(NSError *error) {
//        [self endRefresh];
//
//    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count == 0)
    {
        return 8;
    }
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
//    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListTableViewCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    PatientListModel *model = [PatientListModel new];
//    if (_dataArray.count != 0)
//    {
//        model = _dataArray[indexPath.row];
//    }
//    [cell setDataWithModel:model];
//
//    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isNoMore && (indexPath.row == _dataArray.count-1)) {
        return 127;
    }
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)endRefresh{
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
    
//    [self.noDataView.freshTable.mj_header endRefreshing];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (IBAction)searchJump:(UIButton *)sender {

}

- (IBAction)selectShow:(UIButton *)sender {
    
    if (_selectTableViewSmall) {
        [_selectTableViewSmall removeFromSuperview];
        _lastBtn.selected = NO;
    }
    

        if (!_selectTableView) {
            _selectTableView = [[NSBundle mainBundle] loadNibNamed:@"PatientSelectTableView" owner:self options:nil].lastObject;
            _selectTableView.frame = self.bounds;
        }
        [self addSubview:_selectTableView];
//        HXWeakSelf;
//        _selectTableView.selectEnd = ^(NSArray * _Nonnull typeArr) {
//            if (typeArr.count) {
//                weakSelf.topViewH.constant = 130;
//                weakSelf.typeScroll.hidden = NO;
//                [weakSelf refreshScrollData:typeArr];
//                weakSelf.showWaitView.frame = CGRectMake(0, 130, 274, kIphoneHeight - 130);
//                weakSelf.lastRect = CGRectMake(0, 130, 274, kIphoneHeight - 130);
//
//            }else{
//                weakSelf.topViewH.constant = 100;
//                weakSelf.typeScroll.hidden = YES;
//                weakSelf.showWaitView.frame = CGRectMake(0, 100, 274, kIphoneHeight - 100);
//                weakSelf.lastRect = CGRectMake(0, 100, 274, kIphoneHeight - 100);
//            }
//        };
        self.selectTableView.dataArr = self.stateArr;
        [self.selectTableView refreshData];

}

-(void)refreshScrollData:(NSArray *)arr{
    
    for (UIView *btn in self.typeScroll.subviews) {
        [btn removeFromSuperview];
    }
    CGFloat btnW = 90;
    CGFloat btnTap = 15;
    CGFloat btnEdg = 0;
    
    NSMutableArray *arr0 = arr[0];
    NSMutableArray *arr1 = arr[1];
    NSMutableArray *arr2 = arr[2];
    NSMutableArray *arr3 = arr[3];
    
    //访视类型
    BOOL show0 = 0;
    _strVisit = @"";
    NSMutableArray *zeroSelect = [NSMutableArray arrayWithCapacity:0];
    for (HospitalModel *model in arr0) {
        if (model.IsChoose) {
            show0 = YES;
            if (![zeroSelect containsObject:[NSString stringWithFormat:@"%@",model.Value]])
            {
                [zeroSelect addObject:[NSString stringWithFormat:@"%@",model.Value]];
            }
            _strVisit = [NSString stringWithFormat:@"%@",model.Value];
        }
    }
    
    //访视状态
    NSMutableArray *arraySelect = [NSMutableArray arrayWithCapacity:0];
    BOOL show1 = 0;
    _strState = @"";
    for (HospitalModel *model in arr1) {
        if (model.IsChoose) {
            show1 = YES;
            if (![arraySelect containsObject:[NSString stringWithFormat:@"%@",model.Value]])
            {
                [arraySelect addObject:[NSString stringWithFormat:@"%@",model.Value]];
            }
            _strState = [arraySelect componentsJoinedByString:@","];
        }
    }
    //患者状态
    BOOL show2 = 0;
    _strPatient = @"";
    for (HospitalModel *model in arr2) {
        if (model.IsChoose) {
            show2 = YES;
            _strPatient = [NSString stringWithFormat:@"%@",model.Value];
        }
    }
    //入组状态
    BOOL show3 = 0;
    _strGroup = @"";
    for (HospitalModel *model in arr3) {
        if (model.IsChoose) {
            show3 = YES;
            _strGroup = [NSString stringWithFormat:@"%@",model.Value];
        }
    }

    self.isAddPatient = YES;
    
    if (show0 ==0 && show1 == 0 && show2 == 0 && show3 == 0) {
        self.topViewH.constant = 100;
        self.typeScroll.hidden = YES;
        _strVisit = @"";
        _strState = @"";
        _strPatient = @"";
        _strGroup = @"";
        _lastRect = CGRectMake(0, 100, 274, kScreenHeight - 100);
        if (self.noDataView) {
            self.noDataView.frame = _lastRect;
        }
        [self requestDate];
        return;
    }

    
    for (int i = 0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"selectDown"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"selectUp"] forState:UIControlStateSelected];
        if (i == 0) {
            btn.frame = CGRectMake(btnEdg + (btnW+btnTap)*i, 0, btnW, 28);
            btn.hidden = !show0;
        }else if (i == 1){
            if (show0) {
                btn.frame = CGRectMake(btnEdg + (btnW+btnTap)*i, 0, btnW, 28);
            }else{
                btn.frame = CGRectMake(btnEdg + (btnW+btnTap)*0, 0, btnW, 28);
            }
            btn.hidden = !show1;
        }else if (i==2){
            int j = 0;
            if (show0) {
                j++;
            }
            if (show1) {
                j++;
            }
            btn.frame = CGRectMake(btnEdg + (btnW+btnTap)*j, 0, btnW, 28);
            btn.hidden = !show2;
        }else if (i==3){
            int j = 0;
            if (show0) {
                j++;
            }
            if (show1) {
                j++;
            }
            if (show2) {
                j++;
            }
            btn.frame = CGRectMake(btnEdg + (btnW+btnTap)*j, 0, btnW, 28);
            btn.hidden = !show3;
        }
//        btn.backgroundColor = Color_hex(@"#F5F5F5");
        btn.layer.cornerRadius = 4;
//        [btn setTitleColor:Color_hex(@"#595959") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = i;
        [btn addTarget:self action:@selector(showSmallSelectTableView:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeScroll addSubview:btn];
        
        NSString *titleStr = @"";
        for (HospitalModel *model in arr[i]) {
            if (i==0 || i == 1) {
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
        
//        CGSize titleSize = [titleStr sizeWithAttributes:@{@"NSFontAttributeName" :[UIFont systemFontOfSize:13]}];
//        CGFloat titleWidth1 = titleSize.width;
//        CGFloat titleHeight1 = titleSize.height;
        if (titleStr.length >4) {
            titleStr = [titleStr substringToIndex:4];
            titleStr = [titleStr stringByAppendingString:@"..."];
        }
        [btn setTitle:titleStr forState:UIControlStateNormal];
//        [btn setImagePosition:LXMImagePositionRight spacing:5];

    }
    int w = 0;
    if (show0) {
        w++;
    }
    if (show1) {
        w++;
    }
    if (show2) {
        w++;
    }
    if (show3) {
        w++;
    }

    self.typeScroll.contentSize = CGSizeMake(w*(btnW+btnTap), 0);
    
    [self requestDate];
    
}

-(void)showSmallSelectTableView:(UIButton *)btn{
    if (!_selectTableViewSmall) {
        _selectTableViewSmall = [[NSBundle mainBundle] loadNibNamed:@"PatientSelectTableViewSmall" owner:self options:nil].lastObject;
        _selectTableViewSmall.frame = self.bounds;
        _selectTableViewSmall.frame = CGRectMake(0, 105, self.bounds.size.width, kScreenHeight-105);
    }
    

    
    if (btn == _lastBtn) {
        btn.selected = !_lastBtn.selected;
        if (btn.selected) {
            [self addSubview:_selectTableViewSmall];
        }else{
            [_selectTableViewSmall removeFromSuperview];
        }
        return;
    }
    
    if (_selectTableViewSmall.superview) {
        [_selectTableViewSmall removeFromSuperview];
    }

    [self addSubview:_selectTableViewSmall];
    _lastBtn.selected = NO;
    btn.selected = YES;
    _lastBtn = btn;

    
    
    NSMutableArray *arr = self.stateArr[btn.tag];
    _selectTableViewSmall.selectH.constant = 70+35*arr.count;
    if (arr.count > 18) {
        _selectTableViewSmall.selectH.constant = 70+35*18;
    }
//    HXWeakSelf;
    _selectTableViewSmall.selectEnd = ^(NSString * _Nonnull titleStr) {
        [btn setTitle:titleStr forState:UIControlStateNormal];
        btn.selected = NO;
//        [weakSelf refreshScrollData:weakSelf.stateArr];
    };

    [_selectTableViewSmall configData:arr withIndex:btn.tag];
    
    
}

@end
