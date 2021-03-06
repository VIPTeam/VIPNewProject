//
//  VIPMyZhilianViewController.m
//  VIPZL
//
//  Created by Ibokan on 12-10-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VIPMyZhilianViewController.h"
#import "A2ResumeView.h"
#import "Resume.h"
#import "DNWrapper.h"
#import "IsLogin.h"
#import "ResumeViewCell.h"
#import "GetPath.h"
#import "PersonnelMessageViewController.h"
#import "Position_recordViewController.h"
#import "PositionFavoriteViewController.h"
//#import "CompanListInfoViewController.h"

@implementation VIPMyZhilianViewController
@synthesize resumeNameLabel;
@synthesize resumeScrollView;
@synthesize pageControl = _pageControl;
@synthesize rsmArray = _rsmArray,someNumber = _someNumber;
@synthesize rsmViewArray = _rsmViewArray;
@synthesize beforeDefaultNumber = _beforeDefaultNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的智联";
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"智联招聘" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeft)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
    
    if ([_rsmArray count]!= 0) {
        self.rsmViewArray = [NSMutableArray arrayWithCapacity:[_rsmArray count]];
        Resume *rsm = [_rsmArray objectAtIndex:0];
        resumeNameLabel.text = rsm.rsmName;
        
        self.resumeScrollView.tag = 100;
        self.resumeScrollView.showsHorizontalScrollIndicator = NO;//隐藏指示器
        int page = _rsmArray.count;
        self.resumeScrollView.frame = CGRectMake(0, 105, 320, 72);
        resumeScrollView.contentSize = CGSizeMake(320*page,72);
        resumeScrollView.delegate = self;
        self.resumeScrollView.pagingEnabled = YES;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
        _pageControl.numberOfPages = page;
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(changePageCtrl:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_pageControl];
        
        for (int i = 0; i<_rsmArray.count; i++) {
            Resume *rsm = [_rsmArray objectAtIndex:i];
            A2ResumeView *resumeView = [[A2ResumeView alloc] initWithFrame:CGRectMake(320*i+10, 0, 300, 70) resume:rsm];
            resumeView.userInteractionEnabled = YES;//打开用户交互
            resumeView.delegate = self;
            resumeView.number = i;
            if ([rsm.rsmLanguage isEqualToString:@"1"]) {
                resumeView.isDefault = YES;
                self.beforeDefaultNumber = i;
            }else
            {
                resumeView.isDefault = NO;
            }
            [self.resumeScrollView addSubview:resumeView];
            [self.rsmViewArray addObject:resumeView];
            [resumeView release];
        }
    }
    else
    {
        UIButton *addResume = [UIButton buttonWithType:UIButtonTypeCustom];
        addResume.frame = CGRectMake(100, 20, 120, 30);
        [addResume setTitle:@"添加简历" forState:UIControlStateNormal];
        [addResume addTarget:self action:@selector(addresume) forControlEvents:UIControlEventTouchUpInside];
        [addResume setBackgroundImage:[UIImage imageNamed:@"loginNormal@2x.png"] forState:UIControlStateNormal];
        [self.view addSubview:addResume];
        
        resumeNameLabel.text = @"";
        Resume *rsm =[[Resume alloc] init];
        A2ResumeView *resumeView = [[A2ResumeView alloc] initWithFrame:CGRectMake(10, 0, 300, 70) resume:rsm];
        resumeView.userInteractionEnabled = YES;//打开用户交互
        resumeView.delegate = self;
        resumeView.number = 0;
        if ([rsm.rsmLanguage isEqualToString:@"1"]) {
            resumeView.isDefault = YES;
            self.beforeDefaultNumber = 0;
        }else
        {
            resumeView.isDefault = NO;
        }
        [self.resumeScrollView addSubview:resumeView];
        [self.rsmViewArray addObject:resumeView];
        [resumeView release];
        
    }
    //未读人事来信等列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 230, 300, 140) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.tag = 200;
    
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- 左右键
-(void)clickLeft
{
    NSLog(@"controolers = %@",self.navigationController.viewControllers);
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
- (void)clickRight
{
    int c = [self.navigationController.viewControllers count];


    UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(100, 100, 0, 0)style:UITableViewStyleGrouped];
    tbView.backgroundColor = [UIColor clearColor];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.tag = 100;
    [self.view addSubview:tbView];
    
    [UIView animateWithDuration:2 animations:^{
        tbView.frame = CGRectMake(0,0, 110,40*c  );
    }];
}
- (void)logOut
{
    IsLogin *islg = [IsLogin defaultIsLogin];
    [islg setValue:NO utkt:nil rsmArray:nil nrdEmal:nil aplct:nil favct:nil jbsc:nil];
    NSArray *accounts = [NSArray arrayWithObjects:@"",@"", nil];
    [accounts writeToFile:[self filePath] atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addresume 
{
    NSLog(@"推出添加简历界面");
}

- (void)viewDidUnload
{
    [self setResumeNameLabel:nil];
    [self setResumeScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [resumeNameLabel release];
    [resumeScrollView release];
    [super dealloc];
}

#pragma mark -- 
//点击pagecontrol触发的方法
- (void)changePageCtrl:(UIPageControl *)p
{
    Resume *rsm = [_rsmArray objectAtIndex:p.currentPage];
    resumeNameLabel.text = rsm.rsmName;    
    int x = p.currentPage *320;
    UIScrollView *sview = (UIScrollView *)[self.view viewWithTag:100];
    [sview setContentOffset:CGPointMake(x, 0) animated:YES];
}
//实现scrollview协议的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int page1 = scrollView.contentOffset.x/320;
    Resume *rsm = [_rsmArray objectAtIndex:page1];
    resumeNameLabel.text = rsm.rsmName;
    NSLog(@"pagecontrol = %@",rsm.rsmName);
    _pageControl.currentPage = page1;
}
//实现resumeview里协议的方法

//点击浏览推出新窗口
- (void)pushNewPage:(Resume *)resume
{
    //点击浏览简历 按钮 推出特定界面 展示公司列表
//    CompanListInfoViewController *controller =[[CompanListInfoViewController alloc] init];
//    
//    //属性传值
//    controller.resumeItemsOfCompany = resume;
//    
//    [self.navigationController pushViewController:controller animated:YES];
//    

}
//设置了默认属性后
- (void)setDefaultResume:(NSString *)msg
{
    //新的默认简历为蓝，将之前的默认简历标志之为灰色，isdefault标志为no
    A2ResumeView *view = [_rsmViewArray objectAtIndex:_beforeDefaultNumber];
    [view.setDefalutResumebt setImage:[UIImage imageNamed:@"resume_unselected@2x.png"] forState:UIControlStateNormal];
    view.isDefault = NO;
}
- (void)sentNumber:(int)nmb
{
    self.beforeDefaultNumber = nmb;
}


//实现表格协议的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return [self.navigationController.viewControllers count];
    }
    else{
    return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200) {
        
        static NSString *CellIdentifier = @"Cell";
        ResumeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[ResumeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        //四张图片
        UIImage *img1 = [UIImage imageNamed:@"unreader@2x.png"];
        UIImage *img2 = [UIImage imageNamed:@"job_record@2x.png"];
        UIImage *img3 = [UIImage imageNamed:@"favorite@2x.png"];
        UIImage *img4 = [UIImage imageNamed:@"searchSubscribeViewController@2x.png"];
        NSArray *imgArr = [NSArray arrayWithObjects:img1,img2,img3,img4, nil];
        NSArray *nameArr = [NSArray arrayWithObjects:@"未读人事来信",@"职位申请记录",@"职位收藏夹",@"搜索与订阅", nil];
        
        cell.imgv1.image = [imgArr objectAtIndex:indexPath.row];
        cell.nameLabel.text = [nameArr objectAtIndex:indexPath.row];
        cell.countLabel.text = [_someNumber objectAtIndex:indexPath.row];
        // Configure the cell...
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }

        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:indexPath.row];
        NSString *name = vc.navigationItem.title;
        NSLog(@"路径 -- %@",name);
        cell.textLabel.text = name;
        
        cell.alpha = 0.8;
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200) {
        
        switch (indexPath.row) {
            case 0:
            {
                NSLog(@"推出未读人事来信");
                PersonnelMessageViewController *psmss = [[PersonnelMessageViewController alloc] init];
                [self.navigationController pushViewController:psmss animated:YES];
                [psmss release];
                break;
            }
            case 1:
            {
                NSLog(@"推出职位申请记录");
                Position_recordViewController *p1 = [[Position_recordViewController alloc] init];
                [self.navigationController pushViewController:p1 animated:YES];
                [p1 release];
                break;
            }
            case 2:
            {
                NSLog(@"推出职位收藏夹");
                PositionFavoriteViewController *p2 = [[PositionFavoriteViewController alloc] init];
                [self.navigationController pushViewController:p2 animated:YES];
                [p2 release];
                break;
            }
            default:
                break;
        }
    }
    else
    {
        NSLog(@"返回到哪一个假面");
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:indexPath.row] animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200) {
        return 40;
    }
    else
    {
        return 30;
    }
}
//文件路径
- (NSString *)filePath
{
    //document路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //具体文件路径
    NSString *path1 = [docPath stringByAppendingPathComponent:@"account"];
    return path1;
}

@end
