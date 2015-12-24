//
//  JPDealerDetailVC.m
//  DymIOSApp
//
//  Created by MacBook on 11/24/15.
//  Copyright © 2015 Dong Yiming. All rights reserved.
//

#import "JPDealerDetailVC.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "JPUtils.h"
#import "JPDesignSpec.h"
#import <AXRatingView/AXRatingView.h>
#import "DYMRollingBannerVC.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImage+ImageWithColor.h"

static NSInteger MAX_IMAGE = 3;
@interface JPDealerDetailVC ()<MWPhotoBrowserDelegate>
{
    NSDictionary  *_dealerDetail;
    NSString *_orgId;
    
    DYMRollingBannerVC  *_rollingBannerMD;  //门店roll bar
    
    //resize height
    UILabel *_lblIntroduction;  //机构简介
    UILabel *_lblLocation;  //地址
    UILabel *_lblMakeInfo;  //主营车系
    
    
    //rowser
    NSMutableArray       *_showingPhotos;
    MWPhotoBrowser      *_browserPhotoVC;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JPDealerDetailVC

#pragma mark Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orgId = [JPUtils stringValueSafe:self.dealer[@"id"]];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self dealerDetail];
    
    NSLog(@"%@",self.dealer);
    self.navigationItem.title = self.dealer[@"organName"];
    
//    NSString *adjustedTitle = [self adjustedTitle:@"哈哈哈哈哈哈哈哈哈哈哈哈"];
//    self.navigationItem.title = adjustedTitle;
    
    _showingPhotos = [NSMutableArray array];
    
    UIImage *clearImg = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(10, 40)];
    UIBarButtonItem *flexSpaceItem = [[UIBarButtonItem alloc] initWithImage:clearImg style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.rightBarButtonItem = flexSpaceItem;
}

//-(NSString *)adjustedTitle:(NSString *)title {
//    NSInteger low = 9, high = 18;
//    if (title.length > low && title.length < high) {
//        NSInteger diff =  high - title.length;
//        for (NSInteger i = 0; i < diff; i++) {
//            title = [title stringByAppendingString:@"　　"];
//        }
//    }
//    
//    return title;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 2;
    }else if (section == 3) {
        return 5;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    "logo": "logo/169528/file_20150427114415_1389.jpg", 经销商图标
    //    "phone": "15391513315",   联系人电
    //    "mdPhotoPath": "dealer/169528/201504271135402226.jpg", 	门店图片	多个用逗号分割
    //    "score": "",  平台评分
    //    "storeSize": "1-30人",  公司规模
    //    "registration": "222222222332222",  营业执照注册号
    //    "id": 169528,  主键
    //    "foundDate": "1980",  成立年份
    //    "address": "2222222233333",  联系人地址
    //    "makeInfo": "奇瑞汽车全车系,上海大众全车系",主营车系	多个用逗号分割
    //    "saleMoney": "1000万以下", 年销售额
    //    "bossName": "zhangfang", 联系人名称
    //    "ppPhotoPath": "dealer/169528/BrandPhoto/201504271135499718.jpg,dealer/169528/BrandPhoto/201504271135518567.jpg,dealer/169528/BrandPhoto/201504271135568089.jpg,dealer/169528/BrandPhoto/201504271135594286.jpg,dealer/169528/BrandPhoto/201504271136025162.jpg,dealer/169528/BrandPhoto/201504271136065650.jpg",
    //    牌授权书	多个用英文逗号分割
    
    //    "introduction": "IM聊天-修理厂账户，经销商标签中显示的同一个经销商的排列方式不同？？IM聊天-修理厂账户，经销商标签中显示的同一个经销商的排列方式不同？？IM聊天-修理厂账户，经销商标签中显示的同一个经销商的排列方式不同？？IM聊天-修理厂账户，经销商标签中显示的同一个经销商的排列方式不同？？",
    //    "organName": "测试经销商-李化永", （ 机构简介）
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //经销商图片
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            UIView *container = [cell.contentView viewWithTag:1000];
            [container setBackgroundColor:[UIColor lightGrayColor]];
            
            NSMutableArray *images = [NSMutableArray array];
            NSString *stringImgListMD = _dealerDetail[@"mdPhotoPath"];  //机构照片
            NSArray *imgList = nil;
            if ([stringImgListMD isKindOfClass:[NSString class]] && stringImgListMD.length > 0) { //stringImgList排除二次查询空结果
                imgList = [stringImgListMD componentsSeparatedByString:@","];
            }
            if ([imgList isKindOfClass:[NSArray class]]) {
                [imgList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx<MAX_IMAGE) {
                        NSString *imageURL = [JPUtils fullMediaPath:obj];
                        [images addObject:imageURL];
                    }
                }];
            }
            
            
            UIImage *placeHolderImage = [UIImage imageNamed:@"icon_goods_logo_default"];
            if (images.count <= 0) {
                images = @[[UIImage imageNamed:@"icon_goods_logo_default"]].mutableCopy;
            }
            
            
            if (_rollingBannerMD == nil) {
                _rollingBannerMD = [DYMRollingBannerVC new];
                //                _rollingBannerMD.rollingInterval = 10;
                _rollingBannerMD.placeHolder = placeHolderImage;
//                _rollingBannerMD.contentMode = UIViewContentModeScaleAspectFit;
                _rollingBannerMD.contentMode = UIViewContentModeCenter;

                
                [_rollingBannerMD addBannerTapHandler:^(NSInteger whichIndex) {
                    NSLog(@"banner tapped, index = %@", @(whichIndex));
                }];
                
                // Install it
                [self addChildViewController:_rollingBannerMD];
                [container addSubview:_rollingBannerMD.view];
                [_rollingBannerMD.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(container);
                }];
                [_rollingBannerMD didMoveToParentViewController:self];
            }
            
            
            _rollingBannerMD.rollingImages = images;
            //            if (images.count > 1) {
            //                [_rollingBannerMD startRolling];
            //            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            UILabel *lblFoundDate = (UILabel *)[cell.contentView viewWithTag:1000];
            lblFoundDate.text = _dealerDetail[@"foundDate"];
            
            UILabel *lblCompanySize = (UILabel *)[cell.contentView viewWithTag:1001];
            lblCompanySize.text = _dealerDetail[@"storeSize"];
            
            UILabel *lblSaleMoney = (UILabel *)[cell.contentView viewWithTag:1002];
            lblSaleMoney.text =  _dealerDetail[@"saleMoney"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }  if (indexPath.section == 1) {   //平台评分
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ratingCell"];
        cell.backgroundColor = [UIColor whiteColor];
        
        AXRatingView *rating = (AXRatingView *)[cell.contentView viewWithTag:1000];
        rating.baseColor = [JPDesignSpec colorGray];
        rating.highlightColor =  [JPDesignSpec colorMajorHighlighted];
        NSNumber *score = [_dealerDetail objectForKey:@"score"];
        [rating sizeToFit];
        [rating setUserInteractionEnabled:NO];
        [rating setNumberOfStar:5];
        [rating setValue:[score intValue]];
        
        UILabel *lblScore = (UILabel *)[cell.contentView viewWithTag:1001];
        
        lblScore.text = [JPUtils stringValueSafe:score];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (indexPath.section == 2) {//电话和地址（支持多行）
        
        if (indexPath.row == 0) { // phoneCell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
            UILabel *lblPhoneNumber = (UILabel *)[cell.contentView viewWithTag:1000];
            NSString *contact = nil;
            if ( _dealerDetail[@"bossName"]) {
                contact = [NSString  stringWithFormat:@"%@(%@)", _dealerDetail[@"phone"], _dealerDetail[@"bossName"]];
            }else{
                contact= _dealerDetail[@"phone"];
            }
            lblPhoneNumber.text = contact;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (indexPath.row == 1) {  //address
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
            UILabel *lblLocation = (UILabel *)[cell.contentView viewWithTag:1000];
//            lblLocation.text = _dealerDetail[@"address"];
            lblLocation.text = [JPUtils stringReplaceNil:_dealerDetail[@"address"] defaultValue:@"暂无数据"];
            lblLocation.lineBreakMode = NSLineBreakByWordWrapping;
            [lblLocation setNumberOfLines:0];
            _lblLocation = lblLocation;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailTitleCell"];
            UILabel *title = (UILabel *)[cell.contentView viewWithTag:1000];
            title.text = @"经销商详情";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailContetntCell1"];
            UILabel *lblMakeInfo = (UILabel *)[cell.contentView viewWithTag:1000];
            lblMakeInfo.text = @"主营车系";
            UILabel *makeInfo = (UILabel *)[cell.contentView viewWithTag:1001];
//            makeInfo.text = _dealerDetail[@"makeInfo"]?_dealerDetail[@"makeInfo"]:@"暂无数据";
            makeInfo.text = [JPUtils stringReplaceNil:_dealerDetail[@"makeInfo"] defaultValue:@"暂无数据"];
            _lblMakeInfo = makeInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailContetntCell1"];
            UILabel *lblIntroduction = (UILabel *)[cell.contentView viewWithTag:1000];
            lblIntroduction.text = @"机构简介";
            
            UILabel *introduction = (UILabel *)[cell.contentView viewWithTag:1001];
            _lblIntroduction.lineBreakMode = NSLineBreakByWordWrapping;
            [_lblIntroduction setNumberOfLines:0];
            
            introduction.text = [JPUtils stringReplaceNil:_dealerDetail[@"introduction"] defaultValue:@"暂无数据"];
//            introduction.text = _dealerDetail[@"introduction"]?_dealerDetail[@"introduction"]:@"暂无数据";
            _lblIntroduction = introduction;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailContetntCell2"];
            
            NSString *stringImgListPP = _dealerDetail[@"ppPhotoPath"];  //品牌授权书
            NSArray *imgList = nil;
            if ([stringImgListPP isKindOfClass:[NSString class]]) {
                imgList = [stringImgListPP componentsSeparatedByString:@","];
            }
            
            [_showingPhotos removeAllObjects];
            if ([imgList isKindOfClass:[NSArray class]]) {
                [imgList enumerateObjectsUsingBlock:^(id  _Nonnull imgUrl, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(idx<MAX_IMAGE){
                        NSURL *localImgURL = [NSURL URLWithString:[JPUtils fullMediaPath:imgUrl]];
                        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1000+idx];
                        [imageView sd_setImageWithURL:localImgURL placeholderImage:[UIImage imageNamed:@"icon_goods_logo_default"]];
                        //添加点击事件
                        if (stringImgListPP.length > 0) {
                            imageView.userInteractionEnabled = YES;
                            UITapGestureRecognizer *viewImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browsePhoto:)];
                            [imageView addGestureRecognizer:viewImageTap];
                       
                        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:(NSString *)[JPUtils fullMediaPath:imgUrl]]];
                        [_showingPhotos addObject:photo];
                             }
                        
                    }
                    
                    
                }];
            }
            
            //                int count = imgList.count;
            //                if (count<MAX_IMAGE) {
            //                    for (int i=0; i<=MAX_IMAGE-count; i++) {
            //                        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1002-i];
            //                        NSLog(@"tag=%d,imageView=%@",1002-i,imageView);
            //                        [imageView setHidden:NO];
            //
            //                    }
            //                }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailContetntCell1"];
            UILabel *lblRegistration = (UILabel *)[cell.contentView viewWithTag:1000];
            lblRegistration.text = @"营业执照注册号";
            UILabel *registration = (UILabel *)[cell.contentView viewWithTag:1001];

            registration.text = [JPUtils stringReplaceNil:_dealerDetail[@"registration"] defaultValue:@"暂无数据"];
    
            NSLog(@"营业注册号%@",registration.text);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    return [UITableViewCell new];
}

#pragma mark - tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //经销商图片
            return 170;
            
        } else if (indexPath.row == 1) {
            return 90;
        }
        
    }  if (indexPath.section == 1) {  //平台评分
        return 60;
        
    } else if (indexPath.section == 2) { //电话和地址（支持多行）
        if (indexPath.row == 0) { //
            return 50;
            
        } else if (indexPath.row == 1) { //address

            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:_lblLocation.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize labelSize = [_lblLocation.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//            NSLog(@"content=%@,height=%f", _lblLocation.text,labelSize.height);
            return  labelSize.height+55 ; //
        }
    }else if (indexPath.section == 3) { //经销商详情
        if (indexPath.row == 0) {
            return 30;
        } else if (indexPath.row == 1) { //主营车系
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:_lblMakeInfo.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize labelSize = [_lblMakeInfo.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            return labelSize.height+55;
        } else if (indexPath.row == 2) { //机构简介
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:_lblIntroduction.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize labelSize = [_lblIntroduction.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            return  labelSize.height+55 ;
        }else if (indexPath.row == 3) {  //品牌授权书
            return 170;
        }else if (indexPath.row == 4) {  //营业执照注册号
            return 70;
        }
    }
    return 0;
}

//-

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view =[UIView new];
    [view setBackgroundColor: [JPDesignSpec colorWhiteHighlighted]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.1;
    }
    return 10;
}



#pragma mark Query
-(void) dealerDetail
{
    [self showLoadingView:YES];
    @weakify(self)
    [[self dealerDetailSignal] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self)
        [self showLoadingView:NO];
        NSDictionary *dealerDetail = result.body[@"sysDealer"];
        if ([dealerDetail isKindOfClass:[NSDictionary class]]) {
            if (result.success) {
                _dealerDetail = dealerDetail;
            }
        }
        [self.tableView reloadData];
        
    }];
    
}


-(RACSignal *)dealerDetailSignal {
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_dealerApi_getSysDealer;
    api.params = @{@"orgId": [self.dealer[@"id"] stringValue]};
    return [DymRequest commonApiSignal:api queue:self.apiQueue];
}

#pragma mark - photo browser delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _showingPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _showingPhotos.count) {
        return _showingPhotos[index];
    }
    return nil;
}

- (void)browsePhoto:(UITapGestureRecognizer *)recognizer
{
    
    NSUInteger index = recognizer.view.tag - 1000;
    
    _browserPhotoVC = [[MWPhotoBrowser alloc] initWithDelegate:self];
    _browserPhotoVC.displayActionButton = NO;
    _browserPhotoVC.zoomPhotosToFill = YES;
    _browserPhotoVC.enableGrid = NO;
    _browserPhotoVC.autoPlayOnAppear = NO;
    //        _browserPhotoVC.pickEnabled = pickEnabled;
    
    [_browserPhotoVC setCurrentPhotoIndex:index];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:_browserPhotoVC];
    [[JPUtils topMostVC] presentViewController:nc animated:YES completion:nil];
    
}


@end
