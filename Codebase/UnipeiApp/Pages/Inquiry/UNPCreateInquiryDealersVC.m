//
//  UNPCreateInquiryDealersVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPCreateInquiryDealersVC.h"
#import "JPSubmitButton.h"
#import <Masonry/Masonry.h>
#import "JPUtils.h"
#import "JPInquiryDealerCell.h"
#import "InquiryApi_ChoiceDealer.h"
#import "InquiryApi_InquiryListUpdate.h"
#import "JPAppStatus.h"
#import <UnipeiApp-Swift.h>
#import "CommonApi_UploadImage.h"
#import <YTKNetwork/YTKBatchRequest.h>
#import "AudioAmrUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface UNPCreateInquiryDealersVC () <UITableViewDataSource, UITableViewDelegate> {
    UIView              *_viewFooter;
    JPSubmitButton      *_btnNext;
    
    NSArray             *_dealerList;
    NSMutableArray      *_selectedDealers;
    
    NSArray             *_succeededUploadAPIs;
    
    
    BOOL _uploading;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UNPCreateInquiryDealersVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPCreateInquiryDealersVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    _selectedDealers = [NSMutableArray array];
    
   @weakify(self)
    self.title = _inquiryID ? @"修改询价单" : @"发布询价单";
    
    ///
    [self showLoadingView:YES];
    [[self getDealersSignal] subscribeNext:^(InquiryApi_ChoiceDealer_Result *result) {
        @strongify(self)
        [self showLoadingView:NO];
        
        [self handleGetDealersResult:result];
    }];
}

-(void)handleGetDealersResult:(InquiryApi_ChoiceDealer_Result *)result {
    if ([result isKindOfClass:[InquiryApi_ChoiceDealer_Result class]]) {
        [_selectedDealers removeAllObjects];
        _dealerList = result.dealerList;
        
        NSArray *selectedDealerIDs = [_dealerid componentsSeparatedByString:@","];
        
        for (id selectedDealerID in selectedDealerIDs) {
            
            for (id dealer in _dealerList) {
                if ([dealer[@"dealerID"] longLongValue] == [selectedDealerID longLongValue]) {
                    [_selectedDealers addObject:dealer];
                }
            }
        }
        
        if (self.inquiryID) {
            _dealerList = _selectedDealers;
        }
        
        [self showEmptyView:(_dealerList.count <= 0) text:@"暂无经销商可选"];
        
        [self updateConfirmButton];
        
        [self.tableView reloadData];
    }
}

-(void)updateConfirmButton {
    if (_inquiryID) {
        _btnNext.enabled = (_dealerList.count > 0 && _selectedDealers.count == 1);
    } else {
        _btnNext.enabled = (_dealerList.count > 0 && _selectedDealers.count > 0);
    }
}

#pragma mark - signals
-(RACSignal *)getDealersSignal {
    
    id params = @{@"makeID": _apiInquiryAdd.make ? : @0
                  , @"carID": _apiInquiryAdd.car ? : @0};
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_ChoiceDealer class] queue:self.apiQueue params:params];
}

#pragma mark - tableview methods
-(BOOL)isDataSourceEmpty {
    return _dealerList.count <= 0;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 200;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dealerList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    JPInquiryDealerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPInquiryDealerCell" forIndexPath:indexPath];
    
    //{"phone":"15007163326","inquiryID":980,"blPoto":"dealer/169474/BLPhoto/2015040711220103029.jpg","dealerID":169474,"organName":"测试经销商-勿动1"}
    id dealer = _dealerList[indexPath.row];
    cell.lblDealerName.text = [dealer objectForKey:@"organName"];
//    cell.lblDealerName.text = @"asdkhaskdjhaskdjhaskjdhkjsahdkjsahdkjashdkjashdkjhaskjdhkajshdkjashdjkashkdhaksdhakshdkashdkas";
    cell.lblBrand.text = [dealer objectForKey:@"majorCar"];
    cell.lblAddress.text = [dealer objectForKey:@"address"];
    cell.lblDealerPhone.text = [dealer objectForKey:@"phone"];
    
    cell.btnCheck.selected = ([_selectedDealers indexOfObject:dealer] != NSNotFound);
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (_viewFooter == nil) {
        _viewFooter = [UIView new];
        
        UIView *innerBgView = [UIView new];
        innerBgView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1];
        [_viewFooter addSubview:innerBgView];
        [innerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_viewFooter).insets(UIEdgeInsetsMake(18, 0, 0, 0));
        }];
        
//        UIColor *lineColor = [UIColor colorWithWhite:230/255.0 alpha:1];
//        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
//        [JPUtils installTopLine:innerBgView color:lineColor insets:insets];
        
        _btnNext = [[JPSubmitButton alloc] initWithStyle:kJPButtonOrange];
        [_btnNext setTitle:(_inquiryID ? @"确认修改" : @"确认发送") forState:UIControlStateNormal];
        [innerBgView addSubview:_btnNext];
        [_btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(innerBgView).insets(UIEdgeInsetsMake(8, 16, 16, 16));
        }];
        
        @weakify(self)
        [[_btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            @strongify(self)
            DDLogDebug(@"确认发送");
            if (self->_selectedDealers.count <= 0) {
                [[JLToast makeTextQuick:@"请选择经销商"] show];
            } else {
                
                // 开始上传文件
                self->_uploading = YES;
                self->_btnNext.userInteractionEnabled = NO;
                
                if (self->_photos.count > 0 || self.localAudios.count > 0) {
//                    [SVProgressHUD showWithStatus:@"文件上传中"];
                    [SVProgressHUD showWithStatus:(self->_inquiryID ? @"正在提交修改" : @"正在发布")];
                }

                self->_btnNext.enabled = NO;
                
                @weakify(self)
                [[self uploadFilesSignal] subscribeNext:^(NSNumber *result) {
                    @strongify(self)
                    // 文件上传结果
                    if ([result isKindOfClass:[NSNumber class]] && [result boolValue]) {
                        DDLogDebug(@"文件上传成功");
                        
                        BOOL hasUploadedAudio = NO;
                        
                        NSMutableArray *uploadedFileInfos = NSMutableArray.new;
                        for (CommonApi_UploadImage *api in self->_succeededUploadAPIs) {
                            CommonApi_UploadImage_Result *resp = api.responseModel;
                            
                            NSMutableDictionary *info = [NSMutableDictionary dictionary];
                            [info setObjectSafe:resp.picPath forKey:@"picpath"];
                            [info setObjectSafe:[resp.picPath lastPathComponent] forKey:@"picname"];
                            [info setObjectSafe:@(api.fileType) forKey:@"type"];
                            
                            [uploadedFileInfos addObject:info];
                            
                            if (api.fileType == kJPUploadFileTypeAMR) {
                                hasUploadedAudio = YES;
                            }
                        }
                        
                        [uploadedFileInfos addObjectsFromArray:self.remoteAudios];
                        
                        [uploadedFileInfos addObjectsFromArray:self->_photosRemote];
                        
                        self->_apiInquiryAdd.picfileList = uploadedFileInfos;
                        
                        // 发布询价单
                        [SVProgressHUD showWithStatus:(self->_inquiryID ? @"正在提交修改" : @"正在发布")];
                        
                        @weakify(self)
                        [[self inquiryAddSignal] subscribeNext:^(DymBaseRespModel *result) {
                            
                            @strongify(self)
                            
                            [self updateConfirmButton];
                            
                            [SVProgressHUD dismiss];
                            
                            // 发布成功
                            if ([result isKindOfClass:[DymBaseRespModel class]] && result.success) {
                                [[JLToast makeText:self->_inquiryID ? @"修改成功" : @"发布成功"] show];
                                [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_INQUIRY_CHANGED object:nil];
                                @strongify(self)
                                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                            }
                        }];
                        
                    } else {
                        
                        [self updateConfirmButton];
                        
                        [SVProgressHUD dismiss];
                        [[JLToast makeText:@"文件上传失败"] show];
                    }

                    
                    //操作结束
                    self->_uploading = NO;
                    self->_btnNext.userInteractionEnabled = YES;
                }];
                
            }
            
        }];
    }
    
    [self updateConfirmButton];
    
    return _viewFooter;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isDataSourceEmpty]) {
        return;
    }
    
    if (_uploading) {
        return;
    }
    
    id dealer = _dealerList[indexPath.row];
    
    if (_inquiryID) { // 修改的时候，不能选择
        
//        [_selectedDealers removeAllObjects];
//        [_selectedDealers addObject:dealer];
        
    } else {
        if ([_selectedDealers indexOfObject:dealer] != NSNotFound) {
            [_selectedDealers removeObject:dealer];
        } else if (_selectedDealers.count > 2) {
            [[JLToast makeTextQuick:@"最多只能选择三个经销商"] show];
        } else {
            [_selectedDealers addObject:dealer];
        }
    }
    
    
    CGPoint offset = tableView.contentOffset;
    [tableView reloadData];
    [tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
    [tableView setContentOffset:offset];
    
    [self updateConfirmButton];
}


#pragma mark - requests
-(RACSignal *)inquiryAddSignal {
    
    _apiInquiryAdd.dealerid = [self selectedDealerIDs];
    
    DymRequest *api = _apiInquiryAdd;
    
    if ([_inquiryID longLongValue] > 0) {
        InquiryApi_InquiryListUpdate *apiUpdate = [InquiryApi_InquiryListUpdate new];
        apiUpdate.inquiryid = _inquiryID;
        apiUpdate.vin = _apiInquiryAdd.vin;
        apiUpdate.describe = _apiInquiryAdd.describe;
        apiUpdate.dealerid = _apiInquiryAdd.dealerid;
        apiUpdate.make = _apiInquiryAdd.make;
        apiUpdate.car = _apiInquiryAdd.car;
        apiUpdate.year = _apiInquiryAdd.year;
        apiUpdate.model = _apiInquiryAdd.model;
        apiUpdate.remark = _apiInquiryAdd.remark;
        apiUpdate.categorieList = _apiInquiryAdd.categorieList;
        apiUpdate.picfileList = _apiInquiryAdd.picfileList;
        
        api = apiUpdate;
    }
    
    return [DymRequest commonApiSignal:api queue:self.apiQueue];
}

-(NSString *)selectedDealerIDs {
    NSMutableArray *selectedDealerIDs = [NSMutableArray array];
    for (id dealer in _selectedDealers) {
        id dealerID = [dealer objectForKey:@"dealerID"];
        if (dealerID) {
            [selectedDealerIDs addObject:dealerID];
        }
    }
    return [selectedDealerIDs componentsJoinedByString:@","];
}

-(RACSignal *)uploadFilesSignal {
    @weakify(self)
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        NSMutableArray *allRequests = [NSMutableArray array];
        
        ///
        NSArray *thePhotos = self.photos ? : @[];
        for (UIImage *image in thePhotos) {
            CommonApi_UploadImage *uploadImage = [[CommonApi_UploadImage alloc] initWithParams:
                                                  @{@"pathType": @(kServerUploadPathShopInquiryPhoto)
                                                    , @"fileType": @(kJPUploadFileTypeJPEG)
                                                    , @"name": [JPUtils randomDigitString]
                                                    , @"image": image}];
            [allRequests addObject:uploadImage];
            [self.apiQueue addObject:uploadImage];
        }
        
        ///
        @weakify(self)
        [AudioAmrUtil asyncEncondeWavesToAmrs:_localAudios completion:^(NSArray *amrDatas, NSArray *amrFiles, EJPAudioFormat fmt) {
            @strongify(self);
            if (amrDatas && amrFiles && amrDatas.count == amrFiles.count) {
                [amrDatas enumerateObjectsUsingBlock:^(id amrData, NSUInteger idx, BOOL *stop) {
                    NSString *amrFile = amrFiles[idx];
                    NSString *name = [[amrFile lastPathComponent] componentsSeparatedByString:@"."].firstObject;
                    CommonApi_UploadImage *uploadAudio = [[CommonApi_UploadImage alloc] initWithParams:
                                                          @{@"pathType": @(kServerUploadPathShopInquiryAudio)
                                                            , @"fileType": @(kJPUploadFileTypeAMR)
                                                            , @"name": name
                                                            , @"audioData": amrData}];
                    [allRequests addObject:uploadAudio];
                    [self.apiQueue addObject:uploadAudio];
                }];
            }
            
            // 如果没有需要上传的文件，返回成功
            if (allRequests.count <= 0) {
                [subscriber sendNext:@YES];
                [subscriber sendCompleted];
            }
            
            ///
            YTKBatchRequest *batch = [[YTKBatchRequest alloc] initWithRequestArray:allRequests];
            
            __weak typeof (self) weakSelf = self;
            [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
                
                __strong typeof (self) strongSelf = weakSelf;
                NSArray *requests = batchRequest.requestArray;
                
                NSMutableArray  *succeededAPIs = [NSMutableArray array];
                
                
                for (CommonApi_UploadImage *uploadImage in requests) {
                    CommonApi_UploadImage_Result *resp = uploadImage.responseModel;
                    if (resp.success) {
                        [succeededAPIs addObject:uploadImage];
                    }
                }
                strongSelf->_succeededUploadAPIs = succeededAPIs;
                
                [subscriber sendNext:
                 @(strongSelf->_succeededUploadAPIs.count > 0)];
                
                [subscriber sendCompleted];
                
            } failure:^(YTKBatchRequest *batchRequest) {
                
                NSError *error = [YTKBaseRequest createTimeoutError:nil];
                [[JLToast makeTextQuick:error.domain] show];
                
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
            }];
            
            [self.apiQueue addObject:batch];
        }];
        
        
        
        return nil;
    }];
}

-(void)dealloc {
    [SVProgressHUD dismiss];
}


@end
