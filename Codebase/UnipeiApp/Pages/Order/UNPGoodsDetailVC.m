//
//  UNPGoodsDetailVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPGoodsDetailVC.h"
#import "DymStoryboard.h"
#import "JPDesignSpec.h"
#import "OrderApi_GetSysGoods.h"
#import <DYMRollingBanner/DYMRollingBannerVC.h>
#import "UIViewController+PSContainment.h"
#import <Masonry/Masonry.h>

@interface UNPGoodsDetailVC () <UITableViewDelegate, UITableViewDataSource> {
    id  _goodsDetail;
    
    DYMRollingBannerVC  *_rollingBannerVC;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UNPGoodsDetailVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiOrder_Storyboard] instantiateViewControllerWithIdentifier:@"UNPGoodsDetailVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    @weakify(self)
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    if ([_goodsID longLongValue] > 0) {
        
        OrderApi_GetSysGoods *api = [OrderApi_GetSysGoods new];
        api.goodsID = _goodsID;
        [self showLoadingView:YES];
        
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            @strongify(self)
            [self showLoadingView:NO];
            
            if (result.success) {
                
                self->_goodsDetail = result.body;
                
                [self.tableView reloadData];
            } else {
                [self showEmptyView:YES text:@"未找到该商品信息"];
            }
        }];
    }
    
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    }else if (section == 3){
        return 1;
    }
    
    return 0;
}


//{"spec":{"id":"","goodsid":"","validitytype":2,"validitydate":"保装车","unit":"1","bgancompany":"1111","bgangoodsno":"1111","deployid":""},"Brand":"AC德科","GoodsNum":"HHS-123456789","imgList":[{"id":"","organid":"","goodsid":"","imageurl":"dealer/169476/goods/small/A201504011612247238.jpg","createtime":"","imagename":"HHS001#4.jpg","mallimage":"dealer/169476/goods/thumb/A201504011612247238.jpg","bigimage":"dealer/169476/goods/normal/A201504011612247238.jpg"},{"id":"","organid":"","goodsid":"","imageurl":"dealer/169476/goods/small/A201504011612275958.jpg","createtime":"","imagename":"HHS004.jpg","mallimage":"dealer/169476/goods/thumb/A201504011612275958.jpg","bigimage":"dealer/169476/goods/normal/A201504011612275958.jpg"}],"memo":"11111111111111111","CpName":"火花塞","SellerName":"优质配件经销商-pp","GoodsOE":"HHS-123456789","ProPrice":115.00,"GoodsName":"火花塞","partsLevelName":"原厂"}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) { // 商品图片
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagesCell"];
            UIView *container = [cell.contentView viewWithTag:100];
            container.backgroundColor = [UIColor orangeColor];
            
            NSMutableArray *images = [NSMutableArray array];
            NSArray *imgList = _goodsDetail[@"imgList"];
            if ([imgList isKindOfClass:[NSArray class]]) {
                [imgList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    // {"id":"","organid":"","goodsid":"","imageurl":"dealer/169476/goods/small/A201504011612247238.jpg","createtime":"","imagename":"HHS001#4.jpg","mallimage":"dealer/169476/goods/thumb/A201504011612247238.jpg","bigimage":"dealer/169476/goods/normal/A201504011612247238.jpg"}
                    if (obj[@"imageurl"]) {
                        NSString *imageURL = [JPUtils fullMediaPath:obj[@"imageurl"]];
                        [images addObject:imageURL];
                    }
                }];
            }
            
            UIImage *placeHolderImage = [UIImage imageNamed:@"icon_goods_logo_default"];
            if (images.count <= 0) {
                [images addObject:placeHolderImage];
            }
            
            if (_rollingBannerVC == nil) {
                _rollingBannerVC = [DYMRollingBannerVC new];
                _rollingBannerVC.rollingInterval = 10;
                _rollingBannerVC.placeHolder = placeHolderImage;
                _rollingBannerVC.contentMode = UIViewContentModeScaleAspectFit;
                
                [_rollingBannerVC addBannerTapHandler:^(NSInteger whichIndex) {
                    NSLog(@"banner tapped, index = %@", @(whichIndex));
                }];
                
                // Install it
//                [self installChildVC:_rollingBannerVC toContainerView:container];
                [self addChildViewController:_rollingBannerVC];
                [container addSubview:_rollingBannerVC.view];
                [_rollingBannerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(container);
                }];
                [_rollingBannerVC didMoveToParentViewController:self];
            }
            
            _rollingBannerVC.rollingImages = images;
            if (images.count > 1) {
                [_rollingBannerVC startRolling];
            }
            
            return cell;
            
        } else if (indexPath.row == 1) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:100];
            lblTitle.text = _goodsDetail[@"GoodsName"];
            
            UILabel *lblPrice = (UILabel *)[cell.contentView viewWithTag:101];
            lblPrice.text = [NSString stringWithFormat:@"￥%.2f", [_goodsDetail[@"ProPrice"] floatValue]];
            
            UILabel *lblStandard = (UILabel *)[cell.contentView viewWithTag:102];
            lblStandard.text = [NSString stringWithFormat:@"标准名称:%@", _goodsDetail[@"CpName"]];
            UILabel *lblGoodsNum = (UILabel *)[cell.contentView viewWithTag:103];
            lblGoodsNum.text = [NSString stringWithFormat:@"商品编号:%@",_goodsDetail[@"GoodsNum"]];
//            UILabel *lblSN = (UILabel *)[cell.contentView viewWithTag:103];
//            lblSN.text = [NSString stringWithFormat:@"商品编号:%@", _goodsDetail[@"GoodsNum"]];
            
            if ([cell.contentView viewWithTag:1000] == nil) {
                UIView *line = [JPUtils installBottomLine:lblGoodsNum color:[JPDesignSpec colorWhiteHighlighted]
                                                   insets:UIEdgeInsetsMake(0, 16, -15, 16)];
                line.tag = 1000;
            }
            
            return cell;
            
        }  else if (indexPath.row == 2) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandCell"];
            cell.backgroundColor = [UIColor whiteColor];
            UILabel *lblBrand = (UILabel *)[cell.contentView viewWithTag:100];
            lblBrand.text = _goodsDetail[@"Brand"];
            
            UILabel *lblQality = (UILabel *)[cell.contentView viewWithTag:101];
            lblQality.text = _goodsDetail[@"partsLevelName"];
            
            UILabel *lblRepair = (UILabel *)[cell.contentView viewWithTag:102];
            lblRepair.text = _goodsDetail[@"spec"][@"validitydate"];
            
            if ([cell.contentView viewWithTag:1000] == nil) {
                UIView *line = [JPUtils installRightLine:lblBrand extendToSuperview:YES color:[JPDesignSpec colorWhiteHighlighted]
                                                   insets:UIEdgeInsetsMake(20, 0, 15, 0)];
                line.tag = 1000;
            }
            
            if ([cell.contentView viewWithTag:1001] == nil) {
                UIView *line = [JPUtils installRightLine:lblQality extendToSuperview:YES color:[JPDesignSpec colorWhiteHighlighted]
                                                  insets:UIEdgeInsetsMake(20, 0, 15, 0)];
                line.tag = 1001;
            }
            
            return cell;
        }
        
    }  else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dealerCell"];
        UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:100];
        lblTitle.text = _goodsDetail[@"SellerName"];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OECell"];
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *lblOE = (UILabel *)[cell.contentView viewWithTag:100];
        lblOE.text = _goodsDetail[@"GoodsOE"] ? [NSString stringWithFormat:@"OE号:%@", _goodsDetail[@"GoodsOE"]] : nil;
        lblOE.lineBreakMode = NSLineBreakByCharWrapping;
//        UILabel *lblDesc = (UILabel *)[cell.contentView viewWithTag:101];
//        lblDesc.text = _goodsDetail[@"memo"];
//        
//        if ([cell.contentView viewWithTag:1000] == nil) {
//            UIView *line = [JPUtils installTopLine:lblDesc
//                                                color:[JPDesignSpec colorWhiteHighlighted]
//                                               insets:UIEdgeInsetsMake(-8, 16, 0, 16)];
//            line.tag = 1000;
//        }
        
        return cell;
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *lblDesc = (UILabel *)[cell.contentView viewWithTag:101];
        lblDesc.text = _goodsDetail[@"memo"];
        
        if ([cell.contentView viewWithTag:1000] == nil) {
            UIView *line = [JPUtils installTopLine:lblDesc
                                             color:[JPDesignSpec colorWhiteHighlighted]insets:UIEdgeInsetsMake(-4, 16, 0, 16)];

            line.tag = 1000;
        }
        return cell;
    }
    
    return [UITableViewCell new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2 || section == 3) {
        return 8;
    }
    
    return 0.1;
}

@end
