//
//  UNPInquirySheetDetailVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPInquiryDetailVC.h"
#import "JPAddPhotoView.h"
#import "JPInquiryPartCell.h"
#import <Masonry/Masonry.h>
#import "JPAddPhotoView.h"
//#import "JPAudioRecordPlayView.h"
#import "JPAppStatus.h"
#import "JPUtils.h"
#import "AudioAmrUtil.h"
#import "KLAudioManager.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "InquiryApi_GetInquiryInfo.h"
#import "JPAudiosView.h"

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface UNPInquiryDetailVC () {
    UITableViewCell         *_codeCell;
    UITableViewCell         *_frameCodeCell;
    UITableViewCell         *_seriesCell;
    UITableViewCell         *_descCell;
    UITableViewCell         *_choosePhotosCell;
    UITableViewCell         *_recordAudioCell;
    UITableViewCell         *_dealerNameCell;
    UITableViewCell         *_dealerPhoneCell;
    
    
    UILabel                 *_lblCode;          // 询价单编号
    UILabel                 *_lblFrameCode;
    UILabel                 *_lblSeries;
    UILabel                 *_lblDesc;
    JPAddPhotoView          *_photoView;
    JPAudiosView            *_audioView;
    UILabel                 *_lblDealerName;
    UILabel                 *_lblDealerPhone;
    
    UIView                  *_viewHeaderNews;
    
    JPInquiry               *_inquiry;
}

@end

@implementation UNPInquiryDetailVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPInquiryDetailVC"];
}

-(void)dealloc {
    [[KLAudioManager sharedInstance] stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emptyMessage = @"暂无询价单详情";
    
    [self initCells];
    
    @weakify(self)
    self.dataSourceIsLoading = YES;
    [[self getInquiryDetail] subscribeNext:^(InquiryApi_GetInquiryInfo_Result *result) {
        @strongify(self)
        self.dataSourceIsLoading = NO;
        if ([result isKindOfClass:[InquiryApi_GetInquiryInfo_Result class]] && result.success) {
            
            self->_inquiry = result.inquiryInfo;
            
            [self handleDataReady];
            
        } else {
            self->_inquiryID = nil;
            [self.tableView reloadData];
        }
        
    }];
}

-(void)initCells {
    
    if (_codeCell == nil) {
        _codeCell = [self.tableView dequeueReusableCellWithIdentifier:@"codeCell"];
        _lblCode = (UILabel *)[_codeCell.contentView viewWithTag:100];
    }
    
    if (_frameCodeCell == nil) {
        _frameCodeCell = [self.tableView dequeueReusableCellWithIdentifier:@"frameCodeCell"];
        _lblFrameCode = (UILabel *)[_frameCodeCell.contentView viewWithTag:100];
    }
    
    if (_seriesCell == nil) {
        _seriesCell = [self.tableView dequeueReusableCellWithIdentifier:@"seriesCell"];
        _lblSeries = (UILabel *)[_seriesCell.contentView viewWithTag:100];
    }
    
    if (_descCell == nil) {
        _descCell = [self.tableView dequeueReusableCellWithIdentifier:@"descCell"];
        _lblDesc = (UILabel *)[_descCell.contentView viewWithTag:100];
    }
    
    if (_choosePhotosCell == nil) {
        _choosePhotosCell = [self.tableView dequeueReusableCellWithIdentifier:@"choosePhotosCell"];
        _photoView = (JPAddPhotoView *)[_choosePhotosCell.contentView viewWithTag:100];
        _photoView.presentingVC = self;
        _photoView.maxPhotoCount = 3;
        _photoView.buttonSize = 56;
        
    }
    
    if (_recordAudioCell == nil) {
        _recordAudioCell = [self.tableView dequeueReusableCellWithIdentifier:@"recordAudioCell"];
        _audioView = (JPAudiosView *)[_recordAudioCell.contentView viewWithTag:100];
//        [_audioView setAudioRemotePath:nil recordEnabled:NO];
    }
    
    if (_dealerNameCell == nil) {
        _dealerNameCell = [self.tableView dequeueReusableCellWithIdentifier:@"dealerNameCell"];
        _lblDealerName = (UILabel *)[_dealerNameCell.contentView viewWithTag:100];
        _lblDealerName.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    if (_dealerPhoneCell == nil) {
        _dealerPhoneCell = [self.tableView dequeueReusableCellWithIdentifier:@"dealerPhoneCell"];
        _lblDealerPhone = (UILabel *)[_dealerPhoneCell.contentView viewWithTag:100];
    }

}

-(BOOL)isDataSourceEmpty {
    return self->_inquiryID == nil;
}

-(void)handleDataReady {
    NSMutableArray *fullPathPhotos = [NSMutableArray array];
    for (id photo in _inquiry.picfilepList) {
        NSString *relativePath = [photo objectForKey:@"picpath"];
        [fullPathPhotos addObject:[JPUtils fullMediaPath:relativePath]];
    }
    
    [_photoView showImages:fullPathPhotos pickEnabled:NO];
    _photoView.hidden = fullPathPhotos.count <= 0;
    
    [self.tableView reloadData];
}


#pragma mark - table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection_IfDataOK:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 7;
        
    } else if (section == 2) {
        return _inquiry.categorieList.count;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView_IfDataOK:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath_IfDataOK:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 48;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return 56;
        } else if (indexPath.row == 1) {
            
            _lblSeries.preferredMaxLayoutWidth = tableView.frame.size.width - (112 + 16);
            _lblSeries.text = _inquiry.fullModelString;
            CGFloat height = [_lblSeries intrinsicContentSize].height + 16;
            
            return height > 48 ? height : 48;
            
        } else if (indexPath.row == 2) {
            
            _lblDesc.preferredMaxLayoutWidth = tableView.frame.size.width - (112 + 16);
            _lblDesc.text = [_inquiry.describe stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            CGFloat height = [_lblDesc intrinsicContentSize].height + 16;
            
            return height > 48 ? height : 48;
            
        } else if (indexPath.row == 3) {
            
            return [_photoView sizeWithImageCount:_inquiry.picfilepList.count].height + 16;
            
        } else if (indexPath.row == 4) {
            return _audioView.intrinsicContentSize.height + 16;
        } else if (indexPath.row == 5) {
            return 48;
        } else if (indexPath.row == 6) {
            return 48;
        }
        
    } else if (indexPath.section == 2) {
        return 168;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.emptyCell || cell == self.loadingCell) {
        return cell;
    }
    
    if (indexPath.section == 0) {
        
        _lblCode.text = _inquiry.inquirysn;
        
        return _codeCell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            _lblFrameCode.text = [JPUtils vinFormatedString:_inquiry.vin];
            
            return _frameCodeCell;
            
        } else if (indexPath.row == 1) {
            
            _lblSeries.text = _inquiry.fullModelString;
            
            return _seriesCell;
            
        } else if (indexPath.row == 2) {
            
            _lblDesc.text = _inquiry.describe;
            
            return _descCell;
            
        }  else if (indexPath.row == 3) {
            
            return _choosePhotosCell;
            
        }  else if (indexPath.row == 4) {
            
            NSArray *voices = _inquiry.picfilevList;
            [_audioView setAudioURLs:voices];
            
            return _recordAudioCell;
            
        }  else if (indexPath.row == 5) {
            
            _lblDealerName.text = _inquiry.dealerOrganName;
            
            return _dealerNameCell;
            
        } else if (indexPath.row == 6) {
            
            _lblDealerPhone.text = _inquiry.dealerPhone;
            
            return _dealerPhoneCell;
            
        }
        
        
    } else if (indexPath.section == 2) {
        
        JPInquiryPartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPInquiryPartCell" forIndexPath:indexPath];
        
//        {"id":10006517,"inquiryid":1391,"maincategory":"电子电器及线束","subcategory":"启动和充电","leafcategory":"起动机驱动轴","number":2,"standcode":"3KP"}
        
        id catagories = _inquiry.categorieList[indexPath.row];
        cell.lblBaseCategory.text = [catagories objectForKey:@"maincategory"];
        cell.lblSubCategory.text = [catagories objectForKey:@"subcategory"];
        cell.lblStandardName.text = [catagories objectForKey:@"leafcategory"];
        cell.lblAmmount.text = [NSString stringWithFormat:@"%@", [catagories objectForKey:@"number"]];
        
        return cell;
    }
    
    return [UITableViewCell new];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (_viewHeaderNews == nil) {
            _viewHeaderNews = [UIView new];
            _viewHeaderNews.backgroundColor = self.tableView.backgroundColor;
            UILabel *lbl = [UILabel new];
            lbl.textColor = [UIColor colorWithWhite:0 alpha:0.87];
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.text = @"配件信息";
            [_viewHeaderNews addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_viewHeaderNews.mas_centerY).offset(4);
                make.leading.equalTo(_viewHeaderNews.mas_leading).offset(16);
            }];
        }
        
        _viewHeaderNews.hidden = _inquiry.categorieList.count <= 0;
        
        return _viewHeaderNews;
    }
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 32;
    }
    
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

#pragma mark - signals
-(RACSignal *)getInquiryDetail {
    
    id params = @{@"inquiryid": [JPUtils numberValueSafe:_inquiryID]};
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_GetInquiryInfo class] queue:self.apiQueue params:params];
}

@end
