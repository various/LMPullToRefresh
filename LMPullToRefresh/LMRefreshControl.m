//
//  LMRefreshControl.m
//  LMPullToRefresh
//
//  Created by Tim Geng on 3/25/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import "LMRefreshControl.h"

static const CGFloat RefreshControlDefaultLoadingHeight = 100;
static const CGFloat RefreshControlAnimationHeight = 120;

@interface LMRefreshControl ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray *loadingImages;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@end


@implementation LMRefreshControl

+(LMRefreshControl *)initRefreshControl:(id)target targetAction:(SEL)targetAction scrollView:(UIScrollView *)scrollView{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"LMRefreshControl" owner:self options:nil];
    LMRefreshControl *refreshControl = (LMRefreshControl *)[nibViews firstObject];
    refreshControl.scrollView = scrollView;
    refreshControl.frame = CGRectMake(0, 0, refreshControl.scrollView.frame.size.width, 0);
    [refreshControl.scrollView addSubview:refreshControl];
    [refreshControl.scrollView addObserver:refreshControl forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%d",i]];
        NSLog(@"content offset y = %@",[NSString stringWithFormat:@"dropdown_loading_0%d",i]);

        [refreshControl.loadingImages addObject:image];
    }
    refreshControl.imageView.animationImages = refreshControl.loadingImages;
    refreshControl.imageView.animationDuration = refreshControl.loadingImages.count * 0.1;
    refreshControl.imageView.animationRepeatCount = HUGE_VAL;
    [refreshControl.imageView startAnimating];
    return refreshControl;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, ABS(self.scrollView.contentOffset.y));
    
}

-(void)dealloc{
    [self removeObserver:self.scrollView forKeyPath:@"contentOffset"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
