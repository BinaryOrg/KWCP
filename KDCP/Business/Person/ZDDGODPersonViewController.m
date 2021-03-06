//
//  ZDDGODPersonViewController.m
//  KDCP
//
//  Created by ZDD on 2019/3/9.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDGODPersonViewController.h"
#import <QMUIKit/QMUIKit.h>
#import <MFHUDManager/MFHUDManager.h>
#import "ZDDNotificationName.h"
#import "GODUserModel.h"
#import "ZDDPersonHeadTableViewCell.h"
#import "ZDDGODPersonSettingTableViewCell.h"
#import "ZDDFuckPersonLogoutTableViewCell.h"

#import "ZDDMenuLogInController.h"
#import "ZDDThemeConfiguration.h"
#import "UIColor+ZDDColor.h"

#import "FUCKNoteViewController.h"
#import "ABCMyCollectionViewController.h"

@interface ZDDGODPersonViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
QMUIAlbumViewControllerDelegate,
QMUIImagePickerViewControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *funcList;
@property (nonatomic, strong) QMUITips *tips;
@end

@implementation ZDDGODPersonViewController

- (NSArray *)funcList {
    if (!_funcList) {
        _funcList = @[
                      @"我的笔记",
                      @"我的收藏",
                      @"联系我们"
                      ];
    }
    return _funcList;
}

- (QMUITips *)tips {
    if (!_tips) {
        _tips = [QMUITips createTipsToView:self.view];
    }
    return _tips;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - STATUSBARANDNAVIGATIONBARHEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"个人中心";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCustomInfo) name:LoginSuccessNotification object:nil];
    NSLog(@"%@", [GODUserTool shared].user.user_id);
}

- (void)reloadCustomInfo {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) {
        return 1;
    }
    else if (section == 1) {
        return self.funcList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        GODUserModel *user = [GODUserTool shared].user;
        ZDDPersonHeadTableViewCell *cell = [[ZDDPersonHeadTableViewCell alloc] init];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.78.124.36:10005/%@", user.avater]] placeholder:[UIImage imageNamed:@"HAO-0"]];
        cell.nameLabel.text = [GODUserTool isLogin] ? user.user_name : @"登录";
        [cell.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [cell.avatarButton addTarget:self action:@selector(avatar) forControlEvents:UIControlEventTouchUpInside];
        cell.joinLabel.text = [GODUserTool isLogin] ? [NSString stringWithFormat:@"join in %@", [self formatFromTS:user.create_date]] : @"";
        return cell;
    }
    else if (indexPath.section == 1) {
        ZDDGODPersonSettingTableViewCell *cell = [[ZDDGODPersonSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting"];
        cell.textLabel.text = self.funcList[indexPath.row];
        return cell;
    }
    
    return [[ZDDFuckPersonLogoutTableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 80;
    }
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!section) {
        return CGFLOAT_MIN;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([MFHUDManager isShowing]) {
        return;
    }
    if (indexPath.section == 1) {
        if (!indexPath.row) {
            if ([GODUserTool isLogin]) {
                FUCKNoteViewController *fuck = [[FUCKNoteViewController alloc] init];
                fuck.flag = 1;
                
                [self.navigationController pushViewController:fuck animated:YES];
            }
            else {
                [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
            }
        }else if (indexPath.row == 1) {
            if ([GODUserTool isLogin]) {
                ABCMyCollectionViewController *fuck = [[ABCMyCollectionViewController alloc] init];
                [self.navigationController pushViewController:fuck animated:YES];
            }
            else {
                [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
            }
        }else {
            [self contact];
        }
    }
    else if (indexPath.section == 2) {
        [[GODUserTool shared] clearUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:FBSuccessNotification object:nil];
        [self reloadCustomInfo];
    }
    
}

- (void)contact {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"Shmily_liuyy";
    [MFHUDManager showSuccess:@"作者微信号已成功复制到剪切板！"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURL * url = [NSURL URLWithString:@"weixin://"];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        if (canOpen) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }
    });
}

- (void)login {
    if ([MFHUDManager isShowing]) {
        return;
    }
    if ([GODUserTool isLogin]) {
        //改名
        [self presentAlertController];
    }else {
        //login
        [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
    }
}

- (void)avatar {
    if ([MFHUDManager isShowing]) {
        return;
    }
    if ([GODUserTool isLogin]) {
        //改avatar
        [self presentAlbumViewControllerWithTitle:@"请选择头像"];
    }else {
        //login
        [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
    }
}

- (void)presentAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入要修改的用户名" preferredStyle:UIAlertControllerStyleAlert];
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tintColor = theme.selectTabColor;
    }];
    __weak typeof(alert) weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakAlert) strongAlert = weakAlert;
        [self startLoadingWithText:@"修改中..."];
        NSString *user_name = strongAlert.textFields[0].text;
        [MFNETWROK post:@"http://120.78.124.36:10005/User/ChangeUserInfo"
                 params:@{
                          @"userId": [GODUserTool shared].user.user_id,
                          @"userName": user_name,
                          @"gender": @"m"
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                    NSLog(@"%@", result);
                    if ([result[@"resultCode"] isEqualToString:@"0"]) {
                        GODUserModel *user = [GODUserModel yy_modelWithJSON:result[@"user"]];
                        [GODUserTool shared].user = user;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopLoading];
                            [self reloadCustomInfo];
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showErrorWithText:@"修改失败！"];
                        });
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self stopLoading];
                        });
                    }
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorWithText:@"修改失败！"];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self stopLoading];
                    });
                }];
    }];
    [cancel setValue:[UIColor zdd_blueColor] forKey:@"_titleTextColor"];
    [ensure setValue:[UIColor zdd_blueColor] forKey:@"_titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:ensure];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = title;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    [albumViewController pickLastAlbumGroupDirectlyIfCan];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.allowsMultipleSelection = NO;
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset afterImagePickerPreviewViewControllerUpdate:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController {
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLoadingWithText:@"上传图片..."];
    });
    [MFNETWROK upload:@"http://120.78.124.36:10005/User/ChangeUserAvater" params:@{@"userId": [GODUserTool shared].user.user_id} name:@"pictures" images:@[imageAsset.previewImage] imageScale:0.1 imageType:MFImageTypePNG progress:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        NSLog(@"%@", result);
        if ([result[@"resultCode"] isEqualToString:@"0"]) {
            GODUserModel *user = [GODUserModel yy_modelWithJSON:result[@"user"]];
            [GODUserTool shared].user = user;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopLoading];
                [self reloadCustomInfo];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showErrorWithText:@"上传失败！"];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopLoading];
            });
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showErrorWithText:@"上传失败！"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopLoading];
        });
    }];
    //    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
    //        [MFNETWROK upload:@"User/ChangeUserAvater"
    //                   params:@{
    //                            @"userId": [ZDDUserTool shared].user.user_id
    //                            }
    //                     name:@"pictures"
    //               imageDatas:@[imageData]
    //                 progress:nil
    //                  success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
    //                      NSLog(@"%@", result);
    //                      if ([result[@"resultCode"] isEqualToString:@"0"]) {
    //                          ZDDUserModel *user = [ZDDUserModel yy_modelWithJSON:result[@"user"]];
    //                          [ZDDUserTool shared].user = user;
    //                          dispatch_async(dispatch_get_main_queue(), ^{
    //                              [self stopLoading];
    //                              [self reloadCustomInfo];
    //                          });
    //                      }else {
    //                          dispatch_async(dispatch_get_main_queue(), ^{
    //                              [self showErrorWithText:@"上传失败！"];
    //                          });
    //                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                              [self stopLoading];
    //                          });
    //                      }
    //                  }
    //                  failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        [self showErrorWithText:@"上传失败！"];
    //                    });
    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                        [self stopLoading];
    //                    });
    //                  }];
    //    }];
}

- (void)startLoadingWithText:(NSString *)text {
    //    [QMUITips showLoading:text inView:self.view];
    //    [self.tips showLoading:text];
    [MFHUDManager showLoading:text];
}

- (void)showErrorWithText:(NSString *)text {
    //    [self.tips showError:text];
    [MFHUDManager showError:text];
}

- (void)showSuccessWithText:(NSString *)text {
    //    [self.tips showSucceed:text];
    [MFHUDManager showSuccess:text];
    
}

- (void)stopLoading {
    //    [QMUITips hideAllToastInView:self.view animated:YES];
    //    [self.tips hideAnimated:YES];
    [MFHUDManager dismiss];
}

- (NSString *)formatFromTS:(NSInteger)ts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"%@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
}


@end
