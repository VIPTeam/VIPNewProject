//
//  VIPJobSearchViewController.m
//  VIPZL
//
//  Created by Ibokan on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VIPJobSearchViewController.h"
#import "SecOptionCell.h"
#import "VIPCompanyViewController.h"

@implementation VIPJobSearchViewController
@synthesize tableView1;
@synthesize industry = _industry,position = _position,postName = _postName,workPositon = _workPositon,range = _range,keyWord = _keyWord;


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
    NSLog(@"controolers = %@",self.navigationController.viewControllers);
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.backgroundColor = [UIColor clearColor];
    numbers = [[NSMutableArray alloc] initWithObjects:@"10",@"10",@"10",@"10",@"10",@"10", nil];
    j = 0;
    cellName = [[NSArray alloc] initWithObjects:@"当前位置:",@"职位名称:",@"行业类别:",@"工作地点:",@"关键字:",@"定位范围:", nil];
    cellOption = [[NSMutableArray alloc] initWithObjects:@"北京市石景山区",@"请选择职位名称",@"请选择行业",@"请选择工作地点",@"请输入关键词",@"请输入定位范围", nil];
    //tableView1.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView1:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//第一个分区
        static NSString *CellIdentifier = @"Cell1";
        SecOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[SecOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        
        
        NSString *name = [cellName objectAtIndex:indexPath.row];
        cell.textLabel.text = name;
        NSString *optionText = [cellOption objectAtIndex:indexPath.row];
        cell.optionLabel.text = optionText;
        for (int i = 0; i<[numbers count]; i++) {
            
            if (indexPath.row == [[numbers objectAtIndex:indexPath.row] intValue]) {
                cell.optionLabel.textColor = [UIColor blackColor];
                break;
            }
            else
            {
                cell.optionLabel.textColor = [UIColor grayColor];
            }
        }
        if (indexPath.row == 4) {
            keyField = [[UITextField alloc] initWithFrame:CGRectMake(140, 10, 160, 25)];
            keyField.borderStyle = UITextBorderStyleRoundedRect;
            [cell addSubview:keyField];
        }
         return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"Cell2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        // Configure the cell...
        cell.textLabel.text = @"历史记录";
        cell.textLabel.font = [UIFont fontWithName:@"" size:16];
        return cell;
    }
   
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 4) {
            
        }
        else
        {
            VIPSearchOptionViewController *serchVC = [[VIPSearchOptionViewController alloc] init];
            serchVC.tag = indexPath.row;
            serchVC.delegate = self;
            [self.navigationController pushViewController:serchVC animated:YES];
            [serchVC release];
        }
    }
    else
    {
        NSLog(@"点击了历史记录");
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     S *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"选择职位搜索条件";
    }
    else
    {
        return @"我的历史搜索";
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor clearColor];
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(100, 7, 100, 35);
        [searchButton setBackgroundImage:[UIImage imageNamed:@"loginNormal@2x.png"] forState:UIControlStateNormal];
        [searchButton setTitle:@"查询" forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:searchButton];
        return footView;
    }
    else
    {
        return nil;
    }
}
- (void)dealloc {
    [tableView1 release];
    [super dealloc];
}

#pragma mark -- 点击了查询按钮
- (void)clickSearch
{
    NSLog(@"点击了查询按钮");
//    VIPCompanyViewController *comVC = [[VIPCompanyViewController alloc] init];
//    comVC.position = self.position;
//    comVC.postName = self.postName;
//    comVC.industry = self.industry;
//    comVC.workPositon = self.workPositon;
//    comVC.range = self.range;
//    comVC.keyWord = keyField.text;
//    //comVC.keyWord = self.keyWord;
//    NSLog(@"%@,%@,%@,%@,%@",comVC.position,comVC.postName,comVC.industry,comVC.workPositon,comVC.range);
//    [self.navigationController pushViewController:comVC animated:YES];
//    [comVC release];
//    VIPJobTableViewController *vc=[[VIPJobTableViewController alloc]init];
//    VIPSearchJob * seachJob = [[VIPSearchJob alloc] initWithschJobType:_postName industry:_industry city:_workPositon keyWord:keyField.text pointRanger:_range sort:nil];
//    vc.searchjob=seachJob;
//    vc.dataSourseSign=2;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 以下是实现了一些用于传值的协议的方法

- (void)sentOption:(NSString *)selectedOption tag:(int)tag
{
    NSLog(@"tag ===== %d",tag);
    switch (tag) {
        case 0:
        {
            self.position = selectedOption;
            selectPositon = YES;
            break;
        }
        case 1:
        {
            self.postName = selectedOption;
            selectPostName = YES;
        }
        case 2:
        {
            self.industry = selectedOption;
            selectIndustry = YES;
        }
        case 3:
        {
            self.workPositon = selectedOption;
            selectWorkPositon = YES;
        }
        case 5:
        {
            self.range = selectedOption;
            selectRange = YES;
        }
        default:
            break;
    }
    
    [cellOption replaceObjectAtIndex:tag withObject:selectedOption];
    [numbers replaceObjectAtIndex:tag withObject:[NSString stringWithFormat:@"%d",tag]];
    for (int i = 0; i<[numbers count]; i++) {
        NSLog(@"number = %@",[numbers objectAtIndex:i]);
    }
    [tableView1 reloadData];
    j++;
}
@end
