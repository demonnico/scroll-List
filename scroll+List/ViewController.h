//
//  ViewController.h
//  scroll+List
//
//  Created by demon on 11/19/12.
//  Copyright (c) 2012 NicoFun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *tv_scrollView;
@end
