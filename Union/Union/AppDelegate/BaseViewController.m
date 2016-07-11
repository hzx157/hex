//
//  BaseViewController.m
//  XiaoWu
//
//  Created by xiaowuxiaowu on 15/11/15.
//  Copyright © 2015年 xiaowuxiaowu. All rights reserved.
//

#import "BaseViewController.h"
#import "UIAlertView+Block.h"
@interface BaseViewController()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>

@end

@implementation BaseViewController


#pragma mark - Publish Method

- (void)configuraTableViewNormalSeparatorInset {
    if ([self validateSeparatorInset]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
}
-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];

}
- (void)loadDataSource {
    // subClasse
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
  //  self.navigationController.navigationBar.backgroundColor = ColorWithRGB(178, 0, 12);

    
    if ([self.navigationController.viewControllers count] > 1 || self.presentingViewController != nil)
    {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
            
        }
        self.leftBtn.hidden = NO;
        

    }
 
    
}




#pragma mark --- 导航栏左侧按钮点击方法 ---
- (void)leftBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIButton *)rightBtn
{
    if(!_rightBtn){
        //导航栏右侧按钮
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 40, 40);
        // _rightBtn = [UIButton buttonWithType:101];
        
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_rightBtn addTarget:self
                      action:@selector(rightBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
    return _rightBtn;
}

-(void)addRightBtnImage:(CGRect)_rect image:(UIImage *)_image
{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:_rect];
    imageview.image = _image;
    imageview.tag = 9632;
    [self.rightBtn addSubview:imageview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark --- 导航栏右侧按钮点击方法 ---
- (void)rightBtnAction:(id )sender
{
    //虚方法...
}

- (UIButton *)leftBtn{
    if(!_leftBtn){
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0,60, 44);
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn setTitle:@"返回" forState:UIControlStateNormal];
        _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 0);
        [_leftBtn setImage:[UIImage imageNamed:@"navbtn_ios7_back_n"] forState:0];

        [_leftBtn addTarget:self
                     action:@selector(leftBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
        
    }
    
    return _leftBtn;
}

-(UIBarButtonItem *)rightBtnItem{
    if(!_rightBtnItem){
        
        _rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
        [_rightBtnItem setTintColor:[UIColor whiteColor]];
        [_rightBtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               fontSystemOfSize(16), NSFontAttributeName,
                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem =_rightBtnItem;
    }
    return _rightBtnItem;
    
}

#pragma mark - Propertys

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = self.view.bounds;
        tableViewFrame.origin.y=IOS7_TOP_Y;
        tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1 ? IOS7_TOP_Y : (CGRectGetHeight(self.tabBarController.tabBar.bounds))) ;
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setScrollsToTop:NO];
        
        _tableView.tableFooterView = [[UIView alloc] init];
        if (![self validateSeparatorInset]) {
            if (self.tableViewStyle == UITableViewStyleGrouped) {
                UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
                backgroundView.backgroundColor = _tableView.backgroundColor;
                _tableView.backgroundView = backgroundView;
            }
        }
        [self.view addSubview:self.tableView];

    }
    return _tableView;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

#pragma mark - Life cycle


- (void)dealloc {
    //    self.dataSource = nil;
    //    self.tableView.delegate = nil;
    //    self.tableView.dataSource = nil;
    //    self.tableView = nil;
}


#pragma mark - TableView Helper Method

- (BOOL)validateSeparatorInset {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView DataSource
//刷新头部
-(void)HeaderDataRereshingdelegate:(void (^)(BOOL))success{
    
}
//刷新底部
-(void)EndRequestDataRereshingdelegate:(void (^)(BOOL))success{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in subClass
    return nil;
}


//Tableview 分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {        [cell setLayoutMargins:UIEdgeInsetsZero];    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

-(void)hzxEndRefreshingWithPage:(NSInteger)page{
    if (page==1) {
      
        [self.tableView hzxHeaderEndRefreshing];
    }else{
        
        [self.tableView hzxFooterEndRefreshing];
    }
}
@end
