//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJCollectionViewController.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJCollectionViewController.h"
#import "MJTestViewController.h"
#import "UIViewController+Example.h"
#import "MJRefresh.h"

#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"

static const CGFloat MJDuration = 2.0;
/**
 * 随机色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface MJCollectionViewController()
/** 存放假数据 */
@property (strong, nonatomic) NSMutableArray *colors;
@end

@implementation MJCollectionViewController
#pragma mark - 示例
#pragma mark UICollectionView 上下拉刷新
- (void)example21
{
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<10; i++) {
            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];

    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [weakSelf.colors addObject:MJRandomColor];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark UICollectionView 左右拉刷新
- (void)example22
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    self.collectionView.collectionViewLayout=layout;
    
    self.collectionView.mj_refreshDirection=MJRefreshDirectionHorizontal;
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<10; i++) {
            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [weakSelf.colors addObject:MJRandomColor];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    }];
    
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
    
    // 由于prepare方法执行时还没进行设置scrollview所以手动状态调整，真正使用时把一个header或footer仅支持一种方向可省略，或自己内部处理
    [(MJRefreshStateHeader*)self.collectionView.mj_header setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHorizontalHeaderIdleText] forState:MJRefreshStateIdle];
    [(MJRefreshBackStateFooter*)self.collectionView.mj_footer setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHorizontalBackFooterIdleText] forState:MJRefreshStateIdle];
    self.collectionView.mj_footer.state=MJRefreshStatePulling;
    self.collectionView.mj_footer.state=MJRefreshStateIdle;
}

#pragma mark UICollectionView 左右拉刷新Gif带文字
- (void)example23
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    self.collectionView.collectionViewLayout=layout;
    
    self.collectionView.mj_refreshDirection=MJRefreshDirectionHorizontal;
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header= [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<10; i++) {
            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJChiBaoZiFooter2 footerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [weakSelf.colors addObject:MJRandomColor];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    }];
    
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
    
    // 由于prepare方法执行时还没进行设置scrollview所以手动状态调整，真正使用时把一个header或footer仅支持一种方向可省略，或自己内部处理
    [(MJRefreshStateHeader*)self.collectionView.mj_header setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHorizontalHeaderIdleText] forState:MJRefreshStateIdle];
    [(MJRefreshBackStateFooter*)self.collectionView.mj_footer setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHorizontalBackFooterIdleText] forState:MJRefreshStateIdle];
    self.collectionView.mj_footer.state=MJRefreshStatePulling;
    self.collectionView.mj_footer.state=MJRefreshStateIdle;
}

#pragma mark UICollectionView 左右拉刷新Gif不带文字
- (void)example24
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    self.collectionView.collectionViewLayout=layout;
    
    self.collectionView.mj_refreshDirection=MJRefreshDirectionHorizontal;
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header= [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<10; i++) {
            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [weakSelf.colors addObject:MJRandomColor];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    }];
    
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
    
    // 由于prepare方法执行时还没进行设置scrollview所以手动状态调整，真正使用时把一个header或footer仅支持一种方向可省略，或自己内部处理
    [(MJChiBaoZiHeader*)self.collectionView.mj_header stateLabel].hidden=YES;
    [(MJChiBaoZiHeader*)self.collectionView.mj_header lastUpdatedTimeLabel].hidden=YES;
    ((MJChiBaoZiFooter*)self.collectionView.mj_footer).refreshingTitleHidden=YES;
    self.collectionView.mj_footer.state=MJRefreshStatePulling;
    self.collectionView.mj_footer.state=MJRefreshStateIdle;
}

#pragma mark - 数据相关
- (NSMutableArray *)colors
{
    if (!_colors) {
        self.colors = [NSMutableArray array];
    }
    return _colors;
}

#pragma mark - 其他

/**
 *  初始化
 */
- (id)init
{
    // UICollectionViewFlowLayout的初始化（与刷新控件无关）
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    return [self initWithCollectionViewLayout:layout];
}

static NSString *const MJCollectionViewCellIdentifier = @"color";
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MJPerformSelectorLeakWarning(
        [self performSelector:NSSelectorFromString(self.method) withObject:nil];
                                 );
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 设置尾部控件的显示和隐藏
    self.collectionView.mj_footer.hidden = self.colors.count == 0;
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJTestViewController *test = [[MJTestViewController alloc] init];
    if (indexPath.row % 2) {
        [self.navigationController pushViewController:test animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:test];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
@end
