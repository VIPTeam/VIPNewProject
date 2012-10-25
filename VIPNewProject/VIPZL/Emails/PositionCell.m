//
//  PositionCell.m
//  MyZhilian
//
//  Created by Ibokan on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PositionCell.h"

@implementation PositionCell

@synthesize btn,companyName,companyAddress,positionName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10, 20, 25, 25);
        [self.contentView addSubview:btn];
        
        positionName=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200, 30)];
        positionName.font = [UIFont fontWithName:@"Arial" size:15.0];
        [self.contentView addSubview:positionName];        
                
        companyName=[[UILabel alloc]initWithFrame:CGRectMake(40, 35, 200, 25)];
        companyName.font=[UIFont fontWithName:@"Arial" size:12.0];
        [self.contentView addSubview:companyName];
        
        companyAddress=[[UILabel alloc]initWithFrame:CGRectMake(240, 35, 50, 25)];
        companyAddress.font=[UIFont fontWithName:@"Arial" size:12.0];
        companyAddress.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:companyAddress];
    }
    return self;
}
-(void)dealloc{
    [btn release];
    [companyName release];
    [companyAddress release];
    [positionName release];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
