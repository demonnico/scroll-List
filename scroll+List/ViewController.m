//
//  ViewController.m
//  scroll+List
//
//  Created by demon on 11/19/12.
//  Copyright (c) 2012 NicoFun. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

#define PAGE_BEFORE CGRectMake(0, 0, 320, 480)

#define PAGE_0 CGRectMake(320, 0, 320, 480)
#define PAGE_1 CGRectMake(640, 0, 320, 480)
#define PAGE_2 CGRectMake(960, 0, 320, 480)

#define PAGE_AFTER CGRectMake(1280, 0, 320, 480)

/**
 *	@brief	设置page初始tag，避免冲突
 */
#define TAG_BEGINNER 100


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    CGRect rects []= {PAGE_BEFORE,PAGE_0,PAGE_1,PAGE_2,PAGE_AFTER};
    
    for (int i=TAG_BEGINNER;i<TAG_BEGINNER+5;i++)
    {
        UITableView * tableView = [[UITableView alloc] initWithFrame:rects[i-TAG_BEGINNER]
                                                               style:UITableViewStylePlain];
        tableView.delegate  = self;
        tableView.dataSource= self;
        [_tv_scrollView addSubview:tableView];
        [tableView release];
        
        tableView.tag = i;
    }
    
    _tv_scrollView.contentSize  =CGSizeMake(320*5,
                                            _tv_scrollView.frame.size.width);
    _tv_scrollView.pagingEnabled= YES;
    _tv_scrollView.bounces = NO;
    _tv_scrollView.delegate = self;
    
    [_tv_scrollView scrollRectToVisible:PAGE_0
                               animated:NO];
}

/**
 *	@brief	滚动结束后对页面属性进行判断，进行伪处理，实现无限循环滚动
 *
 *	@param 	scrollView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if (scrollView.contentOffset.x==0) [scrollView scrollRectToVisible:PAGE_2
                                                              animated:NO];
    else if(scrollView.contentOffset.x==1280)[scrollView scrollRectToVisible:PAGE_0
                                                                    animated:NO];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}

/**
 *	@brief	因为UITablView比较特殊，在容器内的子页面不像固定的View。随着page内容改变，对应
 *          的伪页面中试图的VisibleRect也要作相应的改变，所以在这里需要做一个简单的判断，假
 *          如页面是tableView并且是第一页或者最后一页，我们设置对应伪页面中的显示区域。
 *          对应关系为:
 *          realPage0(start)--->>>pageLast（真实页面中的起始页对应最后一页）
 *          realPage2(end)--->>>pageBeginger(真实页面中的末尾页对应第一页）
 *
 *	@param 	scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        if (scrollView.tag ==TAG_BEGINNER+1)
        {
            UITableView * begin_view = (UITableView*)[_tv_scrollView viewWithTag:TAG_BEGINNER+4];
            [begin_view scrollRectToVisible:CGRectMake(scrollView.contentOffset.x,
                                                       scrollView.contentOffset.y,
                                                       scrollView.frame.size.width,
                                                       scrollView.frame.size.height)
                                   animated:YES];
        }else if(scrollView.tag==TAG_BEGINNER+3){
            UITableView * last_view = (UITableView*)[_tv_scrollView viewWithTag:TAG_BEGINNER];
            [last_view scrollRectToVisible:CGRectMake(scrollView.contentOffset.x,
                                                       scrollView.contentOffset.y,
                                                       scrollView.frame.size.width,
                                                      scrollView.frame.size.height)
                                  animated:YES];
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString* static_str = @"identify";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:static_str];
    if(!cell)
    {
        cell =[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:static_str] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ line:%d",
                           [self getTitleWithTag:tableView.tag],
                           indexPath.row];
    return cell;
}

-(NSString*)getTitleWithTag:(int)tag
{
    switch (tag)
    {
        case TAG_BEGINNER:
        case TAG_BEGINNER+3:
            return @"i'm from page III";
            
        case TAG_BEGINNER+1:
        case TAG_BEGINNER+4:
            return @"i'm from page I";
        case TAG_BEGINNER+2:
            return @"i'm from page II";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tv_scrollView release];
    [super dealloc];
}
@end
