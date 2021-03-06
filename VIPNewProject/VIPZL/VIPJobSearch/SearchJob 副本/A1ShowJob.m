//
//  A1ShowJob.m
//  A1ShowJob
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "A1ShowJob.h"
#import "CollectJob.h"
#import "SearchJob.h"
#import "A1ShowTable.h"
#import "A1ShowOtherJob.h"
#import "A1MapVC.h"
#import "A1SingleApply.h"
#import "IsLogin.h"
#import "VIPLoginViewController.h"

@implementation A1ShowJob

@synthesize job,jD;
@synthesize delegate;
@synthesize applyTapnumber;


-(void)loadView
{
    
    
    [super loadView];
    
    self.view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"职位详情" object:nil];
    [JobDetails GetJobDetailWithJobNumber:self.job.jobNumber Page:1 PageSize:20];
    
    self.navigationItem.title=self.job.jobTitle;
    
    //自定义segmentControl类型
    NSArray *arr = [NSArray arrayWithObjects:[UIImage imageNamed:@"jobDescSelected.png"],[UIImage imageNamed:@"companyDescNormal.png"], nil];
    segControl = [[UISegmentedControl alloc]initWithItems:arr];
    segControl.frame = CGRectMake(0, 0, 320, 35);
    [segControl setSegmentedControlStyle:UISegmentedControlStyleBezeled];
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];       
    [self.view addSubview:segControl];
    
    //textView
    NSString *str = @"\n\n\n\n\n\n\n\n\n\n载入中...";
    
    textView = [[[UITextView alloc]initWithFrame:CGRectMake(0, 35, 320, 291)]autorelease];
    textView.editable = NO;
    textView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    textView.text = str;
    [self.view addSubview:textView];
    
    titleLable = [[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 310, 23)]autorelease];
    titleLable.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    titleLable.text = self.job.jobTitle;
    titleLable.textColor = [UIColor colorWithRed:0.89 green:0.47 blue:(12/255) alpha:1];//字体颜色需要measure后确定
    titleLable.font= [UIFont fontWithName:@"Arial" size:19];//字体同样
    [textView addSubview:titleLable];
    
    scaleLable = [[[UILabel alloc]initWithFrame:CGRectMake(10, 29, 310, 21)]autorelease];
    scaleLable.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    scaleLable.font= [UIFont fontWithName:@"Arial" size:13];//字体同样
    scaleLable.text = @"月薪：载入中...";
    [textView addSubview:scaleLable];
    
    
    locationLable = [[[UILabel alloc]initWithFrame:CGRectMake(10, 51, 310, 21)]autorelease];
    locationLable.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    locationLable.font= [UIFont fontWithName:@"Arial" size:13];
    locationLable.text = [NSString stringWithFormat:@"地点：%@",self.job.jobCity];
    [textView addSubview:locationLable];
    
    
    experienceLable = [[[UILabel alloc]initWithFrame:CGRectMake(10, 73, 310, 21)]autorelease];
    experienceLable.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    experienceLable.font= [UIFont fontWithName:@"Arial" size:13];
    experienceLable.text = @"经验：载入中...";
    [textView addSubview:experienceLable];
    
    numLable = [[[UILabel alloc]initWithFrame:CGRectMake(10, 95, 310, 21)]autorelease];
    numLable.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    numLable.font= [UIFont fontWithName:@"Arial" size:13];
    numLable.text = @"人数：载入中...";
    [textView addSubview:numLable];
    
    //contentSprarator
    UIImageView *sprerator = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 135, 320, 2)]autorelease];
    sprerator.image = [UIImage imageNamed:@"contentSprarator.png"];
    [textView addSubview:sprerator];
    
    //otherJobView
    otherJobView = [[[UIView alloc]initWithFrame:CGRectMake(0, 326, 320, 45)]autorelease];
    otherJobView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"recommendJobBg.png"]];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherJob)];
    [otherJobView addGestureRecognizer:tap];
    [self.view addSubview:otherJobView];
    
    //otherJob lable
    UILabel *lable = [[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 150, 21)]autorelease];
    lable.text = @"该公司其他职位";
    lable.backgroundColor=[UIColor clearColor];
    [lable setFont:[UIFont systemFontOfSize:18]];
    [otherJobView addSubview:lable];
    
    
    //arrow
    UIImageView *arrow = [[[UIImageView alloc]initWithFrame:CGRectMake(290, 16, 10, 14)]autorelease];
    arrow.image = [UIImage imageNamed:@"accessoryArrow.png"];
    [otherJobView addSubview:arrow];
    
    //tabBar
    //        NSArray *tabBarArr = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D", nil];
    UITabBar *tabBar = [[[UITabBar alloc]initWithFrame:CGRectMake(0, 371, 320, 45)]autorelease];
    //tabBar.backgroundImage = [UIImage imageNamed:@"bottombar.png"];
    tabBar.backgroundColor = [UIColor brownColor];
    tabBar.tintColor = [UIColor brownColor];
    //        [tabBar setItems:tabBarArr];
    [self.view addSubview:tabBar];
    
    //joinJob
    UIButton *joinJobButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinJobButton.frame = CGRectMake(3, 373, 73, 38);
    [joinJobButton setImage:[UIImage imageNamed:@"joinjob.png"] forState:UIControlStateNormal];
    [joinJobButton setImage:[UIImage imageNamed:@"joinjob_s.png"] forState:UIControlStateHighlighted];
    [joinJobButton addTarget:self action:@selector(joinjob) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinJobButton];
    
    //backUpJob
    UIButton *backUpJobButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backUpJobButton.frame = CGRectMake(82, 373, 73, 38);
    [backUpJobButton setImage:[UIImage imageNamed:@"backupjob.png"] forState:UIControlStateNormal];
    [backUpJobButton setImage:[UIImage imageNamed:@"backupjob_s.png"] forState:UIControlStateHighlighted];
    [backUpJobButton addTarget:self action:@selector(backupjob) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backUpJobButton];
    
    //samejob
    UIButton *sameJobButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sameJobButton.frame = CGRectMake(163, 373, 73, 38);
    [sameJobButton setImage:[UIImage imageNamed:@"samejob.png"] forState:UIControlStateNormal];
    [sameJobButton setImage:[UIImage imageNamed:@"samejob_s.png"] forState:UIControlStateHighlighted];
    [sameJobButton addTarget:self action:@selector(samejob) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sameJobButton];
    
    //map
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(244, 373, 73, 38);
    [mapButton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
    [mapButton setImage:[UIImage imageNamed:@"map_s.png"] forState:UIControlStateHighlighted];
    [mapButton addTarget:self action:@selector(jobmap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton];
    
    applyTapnumber=0;//用来记录申请职位点击次数的
}

-(void)otherJob
{
    A1ShowOtherJob *soj=[[A1ShowOtherJob alloc]init];
    soj.jd=self.jD;
    soj.dataSourceSign=1;
    [self.navigationController pushViewController:soj animated:YES];
}

-(void)loadData:(NSNotification *)not
{
    NSDictionary *dic=[not userInfo];
    self.jD=[dic objectForKey:@"jd"];
    
    titleLable.text = self.job.jobTitle;
    scaleLable.text=[NSString stringWithFormat:@"月薪：%@",self.self.jD.salaryRange];
    locationLable.text = [NSString stringWithFormat:@"地点：%@",self.job.jobCity];
    experienceLable.text = [NSString stringWithFormat:@"经验：%@",self.jD.workingExp];
    numLable.text = [NSString stringWithFormat:@"人数：%@",self.jD.number];
    
    NSString *str = @"\n\n\n\n\n\n\n\n\n\n";
    NSString *str1 = [str stringByAppendingFormat:@"%@",self.jD.responsibility];
    textView.text = [str1 stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
}

#pragma mark - segControl Changed
//segControl Changed
-(void)segmentChanged:(UISegmentedControl *)sender
{
    //改变segControl图片
    int selectedSegmentIndex = [segControl selectedSegmentIndex];
    //    NSLog(@"_______segment %d is selected",selectedSegmentIndex);
    if (selectedSegmentIndex == 0)
    {
        [segControl setImage:[UIImage imageNamed:@"jobDescSelected.png"] forSegmentAtIndex:0];
        [segControl setImage:[UIImage imageNamed:@"companyDescNormal.png"] forSegmentAtIndex:1];
        
        if (self.jD!=nil) 
        {
            
            titleLable.text = self.job.jobTitle;
            scaleLable.text=[NSString stringWithFormat:@"月薪：%@",self.self.jD.salaryRange];
            locationLable.text = [NSString stringWithFormat:@"地点：%@",self.job.jobCity];
            experienceLable.text = [NSString stringWithFormat:@"经验：%@",self.jD.workingExp];
            numLable.text = [NSString stringWithFormat:@"人数：%@",self.jD.number];
            
            NSString *str = @"\n\n\n\n\n\n\n\n\n\n";
            NSString *str1 = [str stringByAppendingFormat:@"%@",self.jD.responsibility];
            textView.text = [str1 stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            
        }
        else
        {
            NSString *str = @"\n\n\n\n\n\n\n\n\n\n载入中...";
            
            textView.text = str;
            titleLable.text = self.job.jobTitle ;
            //            titleLable.font= [UIFont fontWithName:@"ArialMT" size:20];
            scaleLable.text = @"月薪：载入中...";
            locationLable.text = [NSString stringWithFormat:@"地点：%@",self.job.jobCity];
            experienceLable.text = @"经验：载入中...";
            numLable.text = @"人数：载入中...";
            
        }
        
    }
    else if(selectedSegmentIndex == 1)
    {
        [segControl setImage:[UIImage imageNamed:@"jobDescNormal.png"] forSegmentAtIndex:0];
        [segControl setImage:[UIImage imageNamed:@"companyDescSelected.png"] forSegmentAtIndex:1];
        
        if (self.jD!=nil) 
        {
            CGSize maximumLableSize = CGSizeMake(300, MAXFLOAT);
            UIFont *font = [UIFont fontWithName:@"Arial" size:13];
            NSString *addressStr = [NSString stringWithFormat:@"地址：%@",self.jD.address];
            CGSize newLableSize = [addressStr sizeWithFont:font constrainedToSize:maximumLableSize lineBreakMode:UILineBreakModeWordWrap
                                   ];
            //            numLable.frame.size.height = newLableSize.height;
            numLable.frame = CGRectMake(10, 95, 310, newLableSize.height);
            numLable.lineBreakMode = UILineBreakModeWordWrap;
            numLable.numberOfLines = 0;
            
            //            titleLable.text = self.job.companyName;
            //第二次获取companyName时应该从self.jD.companyName获取
            titleLable.text = [NSString stringWithFormat:@"%@",self.jD.companyName];
            
            scaleLable.text=[NSString stringWithFormat:@"类别： %@",self.jD.companyProperty];
            locationLable.text = [NSString stringWithFormat:@"规模： %@",self.jD.companySize];
            experienceLable.text = [NSString stringWithFormat:@"行业： %@",self.jD.industry];
            numLable.text = [NSString stringWithFormat:@"地址： %@",self.jD.address];
            
            NSString *str = @"\n\n\n\n\n\n\n\n\n\n";
            NSString *str1 = [str stringByAppendingFormat:@"%@",self.jD.companyDesc];
            textView.text = [str1 stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            
        }
        else
        {
            NSString *str = @"\n\n\n\n\n\n\n\n\n\n载入中...";
            
            textView.text = str;
            titleLable.text = self.job.jobTitle ;
            // titleLable.font= [UIFont fontWithName:@"ArialMT" size:20];
            scaleLable.text = @"类别：载入中...";
            locationLable.text = [NSString stringWithFormat:@"规模：%@",self.job.jobCity];
            experienceLable.text = @"行业：载入中...";
            numLable.text = @"地址：载入中...";
            
        }
        
    }
    
}

#pragma mark - tabBarButton tapped

-(void)joinjob
{
    NSLog(@"申请职位");
    applyTapnumber++;
    if(applyTapnumber==1)
    {
    ApplyProcess *aApply=[ApplyProcess Apply];
    self.delegate=aApply;
    NSArray *arr=[NSArray arrayWithObject:self.job.jobNumber];
    [self.delegate singleApply:arr];
    }
    else
    {
        UIAlertView *moreApplyAlert=[[UIAlertView alloc]init];
        [moreApplyAlert setMessage:@"您已经申请过了"];
        [moreApplyAlert addButtonWithTitle:@"取消"];
        [moreApplyAlert show];
        [moreApplyAlert release];
    }
}

-(void)backupjob
{
    //IsLogin *isLg=[[IsLogin alloc]init];
    IsLogin *isLg = [IsLogin defaultIsLogin];
    if (isLg.isLogin) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CollectJob:) name:@"收藏职位" object:nil];
        [CollectJob CollectJobWithUticket:isLg.uticket JobNumber:self.job.jobNumber];
    }else
    {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginedCollectJob) name:@"登陆后收藏职位" object:nil];
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"您需要登录后才可继续操作，是否决定登陆？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        VIPLoginViewController *lv=[[VIPLoginViewController alloc]init];
//lv.tag=2;
        [self.navigationController pushViewController:lv animated:YES];
    }
}
-(void)loginedCollectJob
{
    //IsLogin *isLg=[[IsLogin alloc]init];
    IsLogin *isLg = [IsLogin defaultIsLogin];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CollectJob:) name:@"收藏职位" object:nil];
    [CollectJob CollectJobWithUticket:isLg.uticket JobNumber:self.job.jobNumber];
}


-(void)samejob
{
    A1ShowTable *vc=[[A1ShowTable alloc]init];
    vc.jobNumber=self.job.jobNumber;
    vc.dataSourseSign=3;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)jobmap
{
    
    A1MapVC *mc = [[A1MapVC alloc]init];
    mc.longitude = self.jD.latitude;
    mc.latitude = self.jD.longitude;
    mc.companyName = self.jD.companyName;
    mc.jobName = self.jD.jobTitle;
    [self.navigationController pushViewController:mc animated:YES];
    [mc release];
    
}



-(void)CollectJob:(NSNotification *)not
{
    NSDictionary *dic=[not userInfo];
    NSString *result=[dic objectForKey:@"result"];
    NSString *message=[dic objectForKey:@"message"];
    if ([result isEqualToString:@"1"]) {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        [av release];
    }
    else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        [av release];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
