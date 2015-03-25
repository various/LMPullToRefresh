//
//  LMRefreshControl.m
//  LMPullToRefresh
//
//  Created by Tim Geng on 3/25/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import "LMRefreshControl.h"

static const CGFloat RefreshControlDefaultLoadingHeight = 70;
static const CGFloat RefreshControlAnimationHeight = 100;

static const CGFloat ImageViewDefaultWidth = 20;
static const CGFloat imageViewDefaultHeight = 20;

@interface LMRefreshControl ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray *loadingImages;
@property(nonatomic,strong) NSMutableArray *dropDownImages;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property(nonatomic,assign) CGFloat pullingPercent;
@property(nonatomic,weak) id target;
@property(nonatomic,assign) SEL targetAction;
@end


@implementation LMRefreshControl

+(LMRefreshControl *)initRefreshControl:(id)target targetAction:(SEL)targetAction scrollView:(UIScrollView *)scrollView{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"LMRefreshControl" owner:self options:nil];
    LMRefreshControl *refreshControl = (LMRefreshControl *)[nibViews firstObject];
    refreshControl.scrollView = scrollView;
    refreshControl.frame = CGRectMake(0, 0, refreshControl.scrollView.frame.size.width, 0);
    [refreshControl.scrollView addSubview:refreshControl];
    [refreshControl.scrollView addObserver:refreshControl forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    refreshControl.target = target;
    refreshControl.targetAction = targetAction;
    refreshControl.loadingImages = [[NSMutableArray alloc] initWithCapacity:3];
    refreshControl.dropDownImages = [[NSMutableArray alloc] initWithCapacity:60];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%d",i]];
        [refreshControl.loadingImages addObject:image];
    }
    for (int i = 1; i < 61; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%d",i]];
        [refreshControl.dropDownImages addObject:image];
    }
    refreshControl.imageView.image = [refreshControl.dropDownImages firstObject];
//    refreshControl.imageView.animationImages = refreshControl.loadingImages;
//    refreshControl.imageView.animationDuration = refreshControl.loadingImages.count * 0.1;
//    refreshControl.imageView.animationRepeatCount = HUGE_VAL;
//    [refreshControl.imageView startAnimating];
    return refreshControl;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, ABS(self.scrollView.contentOffset.y));
    self.pullingPercent = ABS(self.scrollView.contentOffset.y) / RefreshControlDefaultLoadingHeight;
    if (ABS(self.scrollView.contentOffset.y) < RefreshControlDefaultLoadingHeight) {
        self.imageViewHeightConstraint.constant = (self.imageView.image.size.height - imageViewDefaultHeight) * self.pullingPercent + imageViewDefaultHeight;
        self.imageViewWidthConstraint.constant = (self.imageView.image.size.width - ImageViewDefaultWidth) * self.pullingPercent + ImageViewDefaultWidth;
        int index = self.pullingPercent * self.dropDownImages.count;
        self.imageView.image = [self.dropDownImages objectAtIndex:index];
    }
    
}

-(void)dealloc{
    [self removeObserver:self.scrollView forKeyPath:@"contentOffset"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
