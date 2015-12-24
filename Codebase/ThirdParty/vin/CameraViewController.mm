//
//  CameraViewController.m
//
//  Created by etop on 15/10/22.
//  Copyright (c) 2015年 etop. All rights reserved.
//

#import "CameraViewController.h"
#import "TopView.h"
#import "vinTyper.h"
#import <Masonry/Masonry.h>
#import "EditVinViewController.h"

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAutoSizeScale ([UIScreen mainScreen].bounds.size.height/568.0)

@interface CameraViewController ()<UIAlertViewDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
    UIView* m_highlitView[100];
    CGAffineTransform m_transform[100];
    
    TopView *_topView;
    BOOL _on;
    BOOL _isRecoged;
    BOOL _isAlertShow;
    VinTyper *_vinTyper;
    BOOL _capture;
    NSTimer *_timer;
    
    UIButton *_returnBtn;
    UIButton *_takePictureBtn;
    EditVinViewController *_editVinViewController;
    

}
@property (assign, nonatomic) BOOL adjustingFocus;
@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic,assign) BOOL isProcessingImage;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    //初始化识别核心
    [self performSelectorInBackground:@selector(initRecog) withObject:nil];
    
    //初始化相机
    [self initialize];
    
    //创建相机界面控件
    [self createCameraView];
 
    UIImage *backImage = [self image:[UIImage imageNamed:@"back_camera_btn.png"] rotation:UIImageOrientationRight];
    _returnBtn = [UIButton new];

   [_returnBtn addTarget:self action:@selector(returnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
   [_returnBtn setImage:backImage forState:UIControlStateNormal];
    _returnBtn.layer.cornerRadius = 4;
    _returnBtn.clipsToBounds = YES;
   [self.view addSubview:_returnBtn];

    
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.trailing.equalTo(_topView.mas_trailing).with.offset(-15);
        make.bottom.equalTo(_topView.mas_bottom).with.offset(-20);
    }];
    
    _editVinViewController = [[EditVinViewController alloc] initWithNibName:@"EditVinViewController" bundle:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.adjustingFocus = YES;
    _capture = NO;
    [self performSelector:@selector(changeCapture) withObject:nil afterDelay:0.5];
    
    
    //定时器 开启连续对焦
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fouceMode) userInfo:nil repeats:YES];
    
    AVCaptureDevice *camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags =NSKeyValueObservingOptionNew;
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    [_session startRunning];
    

    //初始化识别核心 代理对象返回初始化参数
    int init = [_vinTyper initVinTyper:self.nsCompanyName nsReserve:@""];
    if ([self.delegate respondsToSelector:@selector(initVinTyperWithResult:)]) {
        [self.delegate initVinTyperWithResult:init];
    }
    if (init != 0) {
        if (_isAlertShow == NO) {
            [_session stopRunning];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [allLanguages objectAtIndex:0];
            if (![preferredLang isEqualToString:@"zh-Hans"]) {
                NSString *initStr = [NSString stringWithFormat:@"Error code:%d",init];
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Tips" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertV show];
            }else{
                NSString *initStr = [NSString stringWithFormat:@"初始化失败错误编码:%d",init];
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertV show];
            }
        }
    }
    
    //代理对象事项协议返回相机控制器
    if ([self.delegate respondsToSelector:@selector(viewWillAppearWithCameraViewController:)]) {
        [self.delegate viewWillAppearWithCameraViewController:self];
    }
    
    UIButton *upBtn = (UIButton *)[self.view viewWithTag:1001];
    upBtn.hidden = NO;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //代理对象事项协议返回相机控制器
    if ([self.delegate respondsToSelector:@selector(viewDidAppearWithCameraViewController:)]) {
        [self.delegate viewDidAppearWithCameraViewController:self];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //关闭定时器
    [_timer invalidate];
    _timer = nil;
    
    //代理对象事项协议返回相机控制器
    if ([self.delegate respondsToSelector:@selector(viewWillDisappearWithCameraViewController:)]) {
        [self.delegate viewWillDisappearWithCameraViewController:self];
    }
    _capture = NO;
   [_vinTyper freeVinTyper];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //代理对象事项协议返回相机控制器
    if ([self.delegate respondsToSelector:@selector(viewDidDisappearWithCameraViewController:)]) {
        [self.delegate viewDidDisappearWithCameraViewController:self];
    }
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    [_session stopRunning];
    
//    UIButton *photoBtn = (UIButton *)[self.view viewWithTag:1000];
//    photoBtn.hidden = YES;

}

- (void) changeCapture
{
    _capture = YES;
}

//初始化识别核心
- (void) initRecog
{
    _vinTyper = [[VinTyper alloc] init];
    
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
//        NSLog(@"Is adjusting focus? %@", self.adjustingFocus ?@"YES":@"NO");
    }
}

//初始化
- (void) initialize
{
    //判断摄像头授权
    _isAlertShow = NO;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
        NSString * preferredLang = [allLanguages objectAtIndex:0];
        if (![preferredLang isEqualToString:@"zh-Hans"]) {
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"Please allow to access your device’s camera in “Settings”-“Privacy”-“Camera”" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alt show];
        }else{
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在iOS '设置中-隐私-相机' 中打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alt show];
        }
        _isAlertShow = YES;
        return;
    }
    
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset1280x720];
    
    //2.创建、配置输入设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == AVCaptureDevicePositionBack){
            _device = device;
            _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    [_session addInput:_captureInput];
    
    ///out put
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]
                                               init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    //    dispatch_release(queue);
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber
                       numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary
                                   dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [_session addOutput:captureOutput];
    
    //3.创建、配置输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
    [_session addOutput:_captureOutput];
    //
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_preview];
    [_session startRunning];
    
    //设置覆盖层
    CAShapeLayer *maskWithHole = [CAShapeLayer layer];
    
    // Both frames are defined in the same coordinate system
    CGRect biggerRect = self.view.bounds;
    CGFloat offset = 1.0f;
    if ([[UIScreen mainScreen] scale] >= 2) {
        offset = 0.5;
    }
    
    //设置检测视图层
    if (!_topView) {
        _topView = [[TopView alloc] initWithFrame:self.view.bounds];
    }
    CGRect smallFrame = _topView.smallrect;
    CGRect smallerRect = CGRectInset(smallFrame, -offset, -offset) ;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskWithHole setPath:[maskPath CGPath]];
    [maskWithHole setFillRule:kCAFillRuleEvenOdd];
    [maskWithHole setFillColor:[[UIColor colorWithWhite:0 alpha:0.35] CGColor]];
    [self.view.layer addSublayer:maskWithHole];
    [self.view.layer setMasksToBounds:YES];
    
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    //设置检测范围
    [_vinTyper setRoiWithLeft:225 Top:247 Right:1025 Bottom:472];//图像分辨率1280*720
}

//从摄像头缓冲区获取图像
#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    unsigned char *pWarpLine = new unsigned char[400*80*4];
    
    self.vinResult = @"";
    self.resultImg = nil;
    
    if (_capture == YES) {
        if (!self.adjustingFocus) {
            int bSuccess = [_vinTyper recognizeVinTyper:baseAddress Width:(int)width Height:(int)height];
           if(bSuccess == 0)
            {
                //设置识别状态为YES
                _isRecoged = YES;
                //设置震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    
                [self performSelectorOnMainThread:@selector(readyToGetImage:) withObject:_vinTyper.resultImg waitUntilDone:NO];
                _capture = NO;
            }
        }
    }
    delete[] pWarpLine;
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
}

//识别成功
-(void)readyToGetImage:(UIImage *)image
{
//    NSLog(@"--识别成功%s",__FUNCTION__);
//    [_topView.resultImg setImage:image];
//    _topView.label.text = _vinTyper.nsResult;
//    if (self.resultImg) {
//        self.resultImg = nil;
//    }
    
    _editVinViewController.vinResultImage = image;
    
     NSString  *_vinString = [_vinTyper.nsResult stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \0"]];
    
    _editVinViewController.vinResultTxt = _vinString;
    
    [self navigateToEditVinViewController];
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

- (void)createCameraView{
    
    //设置检边视图层
//    if (!_topView) {
//        _topView = [[TopView alloc] initWithFrame:self.view.bounds];
//        _topView.backgroundColor = [UIColor redColor];
//        [self.view addSubview:_topView];
//    }

//    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                               action:@selector(handleSingleFingerEvent:)];
//    singleFingerOne.numberOfTouchesRequired = 1; //手指数
//    singleFingerOne.numberOfTapsRequired = 1; //tap次数
//    [self.view addGestureRecognizer:singleFingerOne];
//    [singleFingerOne release];
   /*
    _topView.label = [[UILabel alloc] initWithFrame:CGRectMakeImage(0, 305, 500, 60)];
//    _topView.label.text = @"请对准Vin码";  //2001
    _topView.label.font = [UIFont fontWithName:@"Helvetica" size:40];
    _topView.label.textColor = [UIColor orangeColor];
    _topView.label.textAlignment = NSTextAlignmentLeft;
    _topView.label.transform = CGAffineTransformMakeRotation(3.14/2);
    [self.view addSubview:_topView.label];
    
    _topView.resultImg = [[UIImageView alloc] initWithFrame:CGRectMakeImage(-17, 227, 355, 100)];
    [_topView.resultImg setImage:nil];
    _topView.resultImg.transform = CGAffineTransformMakeRotation(3.14/2);
    [self.view addSubview:_topView.resultImg];
    */
}

//- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
//{
//    if (sender.numberOfTapsRequired == 1) {
//        //单指单击
//        _capture = YES;
//        self.vinResult = @"";
//        _topView.label.text = @"";
//        [_topView.resultImg setImage:nil];
//        }
//}

//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

//对焦
- (void)fouceMode{

    NSError *error;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    //    NSLog(@"%d",_count);
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if ([device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [_preview captureDevicePointOfInterestForPoint:self.view.center];
            [device setFocusPointOfInterest:cameraPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            //NSLog(@"Error: %@", error);
        }
    }
}

#pragma mark -- 内联函数适配屏幕 --

CG_INLINE CGRect
CGRectMakeImage(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    
    if (kScreenHeight==480) {
        rect.origin.y = y-20;
        rect.origin.x = x;
        rect.size.width = width;
        rect.size.height = height;
    }else{
        rect.origin.x = x * kAutoSizeScale;
        rect.origin.y = y * kAutoSizeScale;
        rect.size.width = width * kAutoSizeScale;
        rect.size.height = height * kAutoSizeScale;
        
    }
    return rect;
}

#pragma mark - Vin返回按钮处理
#pragma mark - 功能：返回处理
-(void)returnButtonClicked:(UIButton *)sender
{
//    NSLog(@"%s",__FUNCTION__);
//    [[self navigationController] popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -功能：图片旋转90,180,270的方法
-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

-(void)navigateToEditVinViewController
{
    NSLog(@"==navigateToEditVinViewController");
    [self.navigationController pushViewController:_editVinViewController animated:YES];
}


@end
