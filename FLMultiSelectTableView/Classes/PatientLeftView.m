//
//  PatientLeftView.m
//  91Trial_iPad
//
//  Created by Ashermed on 2022/5/30.
//

#import "PatientLeftView.h"
#import "PatientLeftNoDataView.h"
#import "UIButton+LXMImagePosition.h"
#import "IDCardViewController.h"
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

@property (nonatomic, strong) ALWShowWaitView *showWaitView;
@property (nonatomic, strong) PatientLeftNoDataView *noDataView;
@property (nonatomic,strong) PatientListModel *model;

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
        self.frame = CGRectMake(LeftWidth, 0, 274, kScreenHeight);
    }
    _lastRect = CGRectMake(0, 100, 274, kIphoneHeight - 100);
    
    NSInteger type = 1;
    if (![ASHValidate isBlankString:[ASHCommon GetUserDefault:@"IsAddPatient"]])
    {
        type = [ASHValidate returnIntWith:[ASHCommon GetUserDefault:@"IsAddPatient"]];
    }
    //添加患者按钮
    //当角色为CRA时则不需要添加患者
    if (![ASHCommon isCRA] && ![[ASHCommon GetUserDefault:@"Cac_RoleName"] isEqualToString:@"CE"] && ![[ASHCommon GetUserDefault:@"Cac_RoleName"] isEqualToString:@"Auditor"] && type != 0) {
        self.addView.hidden = NO;
    } else {
        self.addView.hidden = YES;
    }
    [ASHNoteCenter addObserver:self selector:@selector(addPatient) name:@"changeDataId" object:nil];
    _searchBar.delegate = self;
    [_searchBar setPlaceholder:@"请输入编号、姓名或中心"];
    if (@available(iOS 13, *)) {
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:15];
    }
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.searchTextField.clearButtonMode = UITextFieldViewModeNever;
    self.pageIndex = 1;
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self addPatient];
        self.pageIndex = 1;
        self.hospitalStr = @"";
        self.searchStr = @"";
        self.searchBar.text = @"";
        self.isAddPatient = YES;
        //清除检索中心的数据
        [self.screenView clearAllSelections];

        [self requestDate];
    }];
    //..上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self requestDate];
    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.backgroundColor = KCustomAdjustColor([UIColor whiteColor], kMainColor);
    [self.tableView registerNib:[UINib nibWithNibName:@"PatientListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientListTableViewCell"];

    self.typeScroll = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [self.topView addSubview:self.typeScroll];
    [self.typeScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).offset(16);
        make.right.mas_equalTo(self.topView.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.topView.mas_bottom).offset(-29);
        make.height.mas_equalTo(28);
    }];
    self.typeScroll.hidden = YES;
    if (![ASHValidate isBlankString:[ASHCommon GetUserDefault:@"Cac_projectid"]])
    {
        [self requestDate];
        [self requestSelectConditions];
        [self requestCenterDatas];
    }
    
    [_selectBtn setEnlargeEdgeWithTop:20 right:10 bottom:20 left:10];
    _searchStr = @"";
    _hospitalStr = @"";
    return self;
}
- (void)addPatient
{
    self.model = nil;
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

#pragma mark 添加完患者 默认选中（数据返回在最前）
-(void)selectIndex0{
    
    if (_dataArray.count > 0 && self.isAddPatient == YES) {
        PatientListModel *model = _dataArray[0];
        for (PatientListModel *model01 in _dataArray)
        {
            model01.isSelect = NO;
        }
        model.isSelect = YES;
        _model = model;
        self.choosePatient(model);
        self.isAddPatient = NO;
    }

}

- (IBAction)addPatient:(UIButton *)sender{

//    NSString *str = [ASHCommon GetUserDefault:@"Cac_IsUseIdCard"];
//    if ([str integerValue] == 1){
        IDCardViewController *addPatientVC = [[IDCardViewController alloc] init];
        [[ASHCommon viewController].navigationController pushViewController:addPatientVC animated:YES];
//    }else{
//        AddPatientViewController *addPatientVC = [[AddPatientViewController alloc] init];
//        [[ASHCommon viewController].navigationController pushViewController:addPatientVC animated:YES];
//    }
    
}

//获取筛选条件
-(void)requestSelectConditions{
    self.stateArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[ASHCommon GetUserDefault:@"Cac_projectid"] forKey:@"projectId"];
    [dict setValue:[ASHCommon GetUserDefault:@"Cac_RoleName"] forKey:@"roleName"];
    [dict setValue:[ASHCommon GetUserDefault:@"Cac_RoleId"] forKey:@"roleId"];
    NSDictionary *userInfo = [ASHCommon getObjectFromJsonString:[ASHCommon GetUserDefault:@"userinfo"]];
    [dict setValue:[userInfo objectForKey:@"userId"] forKey:@"userId"];
    ASHWeakSelf;
    [HttpTools Get:ASHUrl(ASHGetVisitString) parameters:dict success:^(id responseObject) {
        NSDictionary *dictData = [responseObject objectForKey:@"Data"];
        NSMutableArray *arrayVisit = [ASHValidate returnArray:[dictData objectForKey:@"VisitDDL"]];
        NSMutableArray *arrayVist01 = [NSMutableArray new];
        for (NSDictionary *dic in arrayVisit)
        {
            HospitalModel *model = [[HospitalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arrayVist01 addObject:model];
        }
        NSMutableArray *arrayStatus = [ASHValidate returnArray:[dictData objectForKey:@"VisitStatusDDL"]];
        NSMutableArray *arrayStatus01 = [NSMutableArray new];
        for (NSDictionary *dic in arrayStatus)
        {
            HospitalModel *model = [[HospitalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arrayStatus01 addObject:model];
        }
        NSMutableArray *arrayDataStatus = [ASHValidate returnArray:[dictData objectForKey:@"PatientDataStatusDDL"]];
        NSMutableArray *arrayDataStatus01 = [NSMutableArray new];
        for (NSDictionary *dic in arrayDataStatus)
        {
            HospitalModel *model = [[HospitalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arrayDataStatus01 addObject:model];
        }
        NSMutableArray *arrayGroup = [ASHValidate returnArray:[dictData objectForKey:@"IsInGroupDDL"]];
        NSMutableArray *arrayGroup01 = [NSMutableArray new];
        for (NSDictionary *dic in arrayGroup)
        {
            HospitalModel *model = [[HospitalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arrayGroup01 addObject:model];
        }
        NSMutableArray *arrayCureStatus = [ASHValidate returnArray:[dictData objectForKey:@"CureStatusDDL"]];
        NSMutableArray *arrayCureStatus01 = [NSMutableArray new];
        for (NSDictionary *dic in arrayCureStatus)
        {
            HospitalModel *model = [[HospitalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arrayCureStatus01 addObject:model];
        }
        NSMutableArray *arrayTreatStatus = [ASHValidate returnArray:[dictData objectForKey:@"TreatStatusDDL"]];
        NSMutableArray *arrayTreatStatus01 = [NSMutableArray new];
        for (NSDictionary *dic in arrayTreatStatus)
        {
            HospitalModel *model = [[HospitalModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arrayTreatStatus01 addObject:model];
        }
        weakSelf.orderArr = [NSMutableArray arrayWithArray:[dictData objectForKey:@"OrderTypeDDL"]];
        [weakSelf.stateArr addObject:arrayVist01];
        [weakSelf.stateArr addObject:arrayStatus01];
        [weakSelf.stateArr addObject:arrayDataStatus01];
        [weakSelf.stateArr addObject:arrayGroup01];
        
//        if (arrayCureStatus01.count != 0)
//        {
//            [weakSelf.stateArr addObject:arrayCureStatus01];
//        }
//        [weakSelf.stateArr addObject:arrayTreatStatus01];
        
                
    } failure:^(NSError *error) {
        
    }];
    
}

//获取受试者列表/中心列表
-(void)requestCenterDatas{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //处理耗时的任务，以下载
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //后台任务完成，更新界面
//            });
        
        NSDictionary *userInfo = [ASHCommon getObjectFromJsonString:[ASHCommon GetUserDefault:@"userinfo"]];
        NSArray *array = [userInfo objectForKey:@"project"];
        NSString *projectid =[ASHCommon GetUserDefault:@"Cac_projectid"];
        self.centerArr  = [NSMutableArray arrayWithCapacity:0];
        for(int i = 0;i < array.count;i++)
        {
            if([[array[i] objectForKey:@"id"] isEqualToString:projectid])
            {
                NSMutableArray *array1 = [array[i] objectForKey:@"HospitalDDL"];
                for (NSDictionary *dict in array1)
                {
                    HospitalModel *model = [[HospitalModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.centerArr addObject:model];
                }
            }
        }

    });
}



- (void)requestDate {
    
    if (!_showWaitView && _pageIndex == 1) {
        @weakify(self);

        _showWaitView = [[ALWShowWaitView  alloc] initWithFrame:_lastRect refreshBlock:^{
            @strongify(self)
            [self requestDate];
        }];
        
        [self insertSubview:_showWaitView aboveSubview:self];
    }
    self.showWaitView.backgroundColor = [UIColor whiteColor];
    [self.showWaitView showLoading];
    
    if (!_noDataView && _pageIndex == 1) {
        ASHWeakSelf;
        self.noDataView = [[NSBundle mainBundle] loadNibNamed:@"PatientLeftNoDataView" owner:self options:nil].lastObject;
        self.noDataView.noTiRefresh = ^{
            weakSelf.searchBar.text = @"";
            weakSelf.pageIndex = 1;
            weakSelf.hospitalStr = @"";
            weakSelf.searchStr = @"";
            weakSelf.isAddPatient = YES;
            //清除检索中心的数据
            [weakSelf.screenView clearAllSelections];
            
            [weakSelf requestDate];
        };
        self.noDataView.frame = _lastRect;
        [self addSubview:self.noDataView];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *userInfo = [ASHCommon getObjectFromJsonString:[ASHCommon GetUserDefault:@"userinfo"]];
    //NSLog(@"owe--%@--%@",[ASHCommon GetUserDefault:@"Cac_RoleId"],[ASHCommon GetUserDefault:@"Cac_projectid"]);
    [dict setValue:[userInfo objectForKey:@"userId"] forKey:@"userId"];
    [dict setValue:[ASHValidate returnStringWith:[ASHCommon GetUserDefault:@"Cac_projectid"]] forKey:@"projectId"];
//    [dict setValue:[ASHValidate returnStringWith:[ASHCommon GetUserDefault:@"FangShiHosid"]] forKey:@"hospital"];
    [dict setValue:[ASHValidate returnStringWith:_hospitalStr] forKey:@"hospital"];
    //患者状态
    [dict setValue:[ASHValidate returnStringWith:_strPatient] forKey:@"patientDataStatus"];
    //访视状态
    if ([ASHValidate isBlankString:_strState] || [_strState isEqualToString:@"999"])
    {
        [dict setValue:@"" forKey:@"transformStatus"];
    }
    else
    {
        [dict setValue:[ASHValidate returnStringWith:_strState] forKey:@"transformStatus"];
    }
    //访视类型
    [dict setValue:[ASHValidate returnStringWith:_strVisit] forKey:@"tablename"];
    //入组状态
    [dict setValue:[ASHValidate returnStringWith:_strGroup] forKey:@"isInGroup"];
    [dict setValue:[ASHValidate returnStringWith:_strCure] forKey:@"cureStatus"];
    [dict setValue:[ASHValidate returnStringWith:_strTreat] forKey:@"treatStatus"];
    if (_patientGroup == nil)
    {
        [dict setValue:@"" forKey:@"groupId"];
    }
    else if([_patientGroup intValue] > 0)//防止崩溃
    {
        NSString *groupidstr = [ASHValidate returnStringWith:[[self.titleArr objectAtIndex:[_patientGroup intValue]-1]  objectForKey:@"GroupId"]];
        [dict setValue:groupidstr forKey:@"groupId"];
    }
    if (_patientType == nil) {
        [dict setValue:@"" forKey:@"ordertype"];
    } else {
        if ([_patientType intValue] == 0)
        {
            [dict setValue:@"" forKey:@"ordertype"];
        }
        else
        {
            NSDictionary *dictP = _orderArr[[_patientType intValue] - 1];
            [dict setValue:[ASHValidate returnStringWith:[NSString stringWithFormat:@"%@",[dictP objectForKey:@"Value"]]] forKey:@"ordertype"];
        }
    }
    [dict setValue:[ASHValidate returnStringWith:_searchStr] forKey:@"searchText"];
    [dict setValue:@(_pageIndex) forKey:@"pageIndex"];
    [dict setValue:@(10) forKey:@"pageSize"];
    
    [HttpTools Get:ASHUrl(ASHPatientListString1) parameters:dict success:^(id responseObject) {
        [self endRefresh];
        
        NSArray *array = [responseObject objectForKey:@"Data"];
        if (array.count > 0) {
            self.isNoMore = NO;
        }else{
            self.isNoMore = YES;
        }
        if (self.pageIndex == 1) {
            [self.dataArray removeAllObjects];
        } else if (array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        BOOL isClear = YES;
        for (NSDictionary *dic in array) {
            PatientListModel *model = [[PatientListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            //hosid拼接 医院科室的情况下
            if (![ASHValidate isBlankString:[dic objectForKey:@"DeptId"]] && ![ASHValidate isBlankString:[dic objectForKey:@"HosId"]])
            {
                model.HosId = [NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"HosId"],[dic objectForKey:@"DeptId"]];
            }
            //hosid拼接 医院科室医生的情况下
            if (![ASHValidate isBlankString:[dic objectForKey:@"DeptId"]] && ![ASHValidate isBlankString:[dic objectForKey:@"HosId"]] && ![ASHValidate isBlankString:[dic objectForKey:@"DoctorId"]])
            {
                model.HosId = [NSString stringWithFormat:@"%@,%@,%@",[dic objectForKey:@"HosId"],[dic objectForKey:@"DeptId"],[dic objectForKey:@"DoctorId"]];
            }
            [self.dataArray addObject:model];
        }
        for (PatientListModel *model in self.dataArray)
        {
            if ([model.PatientId isEqualToString:self.model.PatientId])
            {
                model.isSelect = YES;
                isClear = NO;
            }
        }
        if (isClear)
        {
            self.clearPatient();
        }
        self.numLab.text = [NSString stringWithFormat:@"(%ld)",[ASHValidate returnIntWith:responseObject[@"TotalCount"]]];
        if (self.dataArray.count == 0) {
            self.model = nil;
            self.showWaitView.searchNoResultImageV.image = [UIImage imageNamed:@"img_chazhao"];
            [self.showWaitView showSearchNoResultWith:@"暂未搜索到相关信息"];
//            [self.selectBtn setTitle:@"取消" forState:UIControlStateNormal];
//            [self.selectBtn setImage:Image_str(@"") forState:UIControlStateNormal];
            self.noDataView.noResultView.hidden = NO;
        } else {
            [self.showWaitView remove];
            self.showWaitView = nil;
//            [self.selectBtn setTitle:@"" forState:UIControlStateNormal];
//            [self.selectBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
            [self.noDataView removeFromSuperview];
            self.noDataView = nil;
        }
        
        [self.tableView reloadData];
    
        [self selectIndex0];
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [self.showWaitView showErrorWithType:2];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count == 0)
    {
        return 8;
    }
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PatientListModel *model = [PatientListModel new];
    if (_dataArray.count != 0)
    {
        model = _dataArray[indexPath.row];
    }
    [cell setDataWithModel:model];
    
    return cell;
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
    PatientListModel *model = _dataArray[indexPath.row];
    for (PatientListModel *model01 in _dataArray)
    {
        model01.isSelect = NO;
    }
    model.isSelect = YES;
    _model = model;
    self.choosePatient(model);
    [_tableView reloadData];
}
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    [self.noDataView.freshTable.mj_header endRefreshing];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (IBAction)searchJump:(UIButton *)sender {
    [self.searchBar resignFirstResponder];
    sender.selected = !sender.selected;
    if (_selectTableViewSmall) {
        [_selectTableViewSmall removeFromSuperview];
        _lastBtn.selected = NO;
    }
    
    UIWindow *windview = [UIApplication sharedApplication].keyWindow;
    
    if (!_screenView) {
        _screenView = [[ScreenView alloc] init];
    }
    
    [_screenView configPerson:self.dataArray center:self.centerArr];
    ASHWeakSelf;
    _screenView.PersonSelect = ^(NSString * _Nonnull searchStr) {
        weakSelf.searchStr = searchStr;
        weakSelf.pageIndex = 1;
        weakSelf.searchBar.text = searchStr;
        [weakSelf requestDate];
    };
    
    _screenView.centerSelect = ^(NSString * _Nonnull centerStr,NSString * _Nonnull centerId) {
        weakSelf.hospitalStr = centerId;
        weakSelf.pageIndex = 1;
        weakSelf.searchBar.text = centerStr;
        [weakSelf requestDate];
    };
    
    [windview addSubview:_screenView];
}

- (IBAction)selectShow:(UIButton *)sender {
    
    if (_selectTableViewSmall) {
        [_selectTableViewSmall removeFromSuperview];
        _lastBtn.selected = NO;
    }
    
//    if (_dataArray.count == 0)
//    {
////        [self addPatient];
//        self.searchBar.text = @"";
//        self.pageIndex = 1;
//        self.hospitalStr = @"";
//        self.searchStr = @"";
//        self.isAddPatient = YES;
//        [self requestDate];
//    }
//    else
//    {
        if (!_selectTableView) {
            _selectTableView = [[NSBundle mainBundle] loadNibNamed:@"PatientSelectTableView" owner:self options:nil].lastObject;
            _selectTableView.frame = self.bounds;
        }
        [self addSubview:_selectTableView];
        HXWeakSelf;
        _selectTableView.selectEnd = ^(NSArray * _Nonnull typeArr) {
            if (typeArr.count) {
                weakSelf.topViewH.constant = 130;
                weakSelf.typeScroll.hidden = NO;
                [weakSelf refreshScrollData:typeArr];
                weakSelf.showWaitView.frame = CGRectMake(0, 130, 274, kIphoneHeight - 130);
                weakSelf.lastRect = CGRectMake(0, 130, 274, kIphoneHeight - 130);

            }else{
                weakSelf.topViewH.constant = 100;
                weakSelf.typeScroll.hidden = YES;
                weakSelf.showWaitView.frame = CGRectMake(0, 100, 274, kIphoneHeight - 100);
                weakSelf.lastRect = CGRectMake(0, 100, 274, kIphoneHeight - 100);
            }
        };
        self.selectTableView.dataArr = self.stateArr;
        [self.selectTableView refreshData];
//    }
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
        _lastRect = CGRectMake(0, 100, 274, kIphoneHeight - 100);
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
        btn.backgroundColor = Color_hex(@"#F5F5F5");
        btn.layer.cornerRadius = 4;
        [btn setTitleColor:Color_hex(@"#595959") forState:UIControlStateNormal];
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
        [btn setImagePosition:LXMImagePositionRight spacing:5];

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
    HXWeakSelf;
    _selectTableViewSmall.selectEnd = ^(NSString * _Nonnull titleStr) {
        [btn setTitle:titleStr forState:UIControlStateNormal];
        btn.selected = NO;
        [weakSelf refreshScrollData:weakSelf.stateArr];
    };

    [_selectTableViewSmall configData:arr withIndex:btn.tag];
    
    
}

@end
