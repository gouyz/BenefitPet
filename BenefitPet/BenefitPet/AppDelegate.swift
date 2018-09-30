//
//  AppDelegate.swift
//  BenefitPet
//
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// 检测网络状态
        networkManager?.startListening()
        
        /// 设置键盘控制
        setKeyboardManage()
        
        //微信注册
        //        WXApi.registerApp(kWeChatAppID)
        
        #if DEBUG
        JMessage.setupJMessage(launchOptions, appKey: kJChatAppKey, channel: nil, apsForProduction: false, category: nil, messageRoaming: true)
        #else
        JMessage.setupJMessage(launchOptions, appKey: kJChatAppKey, channel: nil, apsForProduction: true, category: nil, messageRoaming: true)
        #endif
        _setupJMessage()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = kWhiteColor
        
        //如果未登录进入登录界面，登录后进入首页
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            window?.rootViewController = GYZMainTabBarVC()
        }else{
            window?.rootViewController = GYZBaseNavigationVC(rootViewController: BPLoginVC())
        }
//        window?.rootViewController = GYZMainTabBarVC()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JMessage.registerDeviceToken(deviceToken)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        resetBadge(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        resetBadge(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - private func
    private func _setupJMessage() {
        JMessage.add(self, with: nil)
        //        JMessage.setLogOFF()
        JMessage.setDebugMode()
        if #available(iOS 8, *) {
            JMessage.register(
                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
                    UIUserNotificationType.sound.rawValue |
                    UIUserNotificationType.alert.rawValue,
                categories: nil)
        } else {
            // iOS 8 以前 categories 必须为nil
            JMessage.register(
                forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
                    UIRemoteNotificationType.sound.rawValue |
                    UIRemoteNotificationType.alert.rawValue,
                categories: nil)
        }
    }
    private func resetBadge(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
        JMessage.resetBadge()
    }
    
    /// 设置键盘控制
    func setKeyboardManage(){
        //控制自动键盘处理事件在整个项目内是否启用
        IQKeyboardManager.sharedManager().enable = true
        //点击背景收起键盘
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        //隐藏键盘上的工具条(默认打开)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }

}

//MARK: - JMessage Delegate
extension AppDelegate: JMessageDelegate {
    func onDBMigrateStart() {
        MBProgressHUD.showAutoDismissHUD(message: "数据库升级中")
    }
    
    func onDBMigrateFinishedWithError(_ error: Error!) {
       
        MBProgressHUD.showAutoDismissHUD(message: "数据库升级完成")
    }
    
    func onReceive(_ event: JMSGNotificationEvent!) {
        switch event.eventType {
        case .receiveFriendInvitation, .acceptedFriendInvitation, .declinedFriendInvitation:
            cacheInvitation(event: event)
        case .loginKicked, .serverAlterPassword, .userLoginStatusUnexpected:
            _logout()
        case .deletedFriend, .receiveServerFriendUpdate:
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        default:
            break
        }
    }
    
    private func cacheInvitation(event: JMSGNotificationEvent) {
        let friendEvent =  event as! JMSGFriendNotificationEvent
        let user = friendEvent.getFromUser()
        let reason = friendEvent.getReason()
        let info = JCVerificationInfo.create(username: user!.username, nickname: user?.nickname, appkey: user!.appKey!, resaon: reason, state: JCVerificationType.wait.rawValue)
        switch event.eventType {
        case .receiveFriendInvitation:
            info.state = JCVerificationType.receive.rawValue
            JCVerificationInfoDB.shareInstance.insertData(info)
        case .acceptedFriendInvitation:
            info.state = JCVerificationType.accept.rawValue
            JCVerificationInfoDB.shareInstance.updateData(info)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        case .declinedFriendInvitation:
            info.state = JCVerificationType.reject.rawValue
            JCVerificationInfoDB.shareInstance.updateData(info)
        default:
            break
        }
        if userDefaults.object(forKey: kUnreadInvitationCount) != nil {
            let count = userDefaults.object(forKey: kUnreadInvitationCount) as! Int
            userDefaults.set(count + 1, forKey: kUnreadInvitationCount)
        } else {
            userDefaults.set(1, forKey: kUnreadInvitationCount)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateVerification), object: nil)
    }
    
    func _logout() {
        JCVerificationInfoDB.shareInstance.queue = nil
        userDefaults.removeObject(forKey: kCurrentUserName)
        
        let alertView = UIAlertView(title: "您的账号在其它设备上登录", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "重新登录")
        alertView.show()
    }
}

extension AppDelegate: UIAlertViewDelegate {
    
    private func pushToLoginView() {
        userDefaults.removeObject(forKey: kCurrentUserPassword)
        if let appDelegate = UIApplication.shared.delegate,
            let window = appDelegate.window {
            window?.rootViewController = GYZBaseNavigationVC(rootViewController: BPLoginVC())
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            guard let username = userDefaults.object(forKey: kLastUserName) as? String  else {
                pushToLoginView()
                return
            }
            guard let password = userDefaults.object(forKey: kCurrentUserPassword) as? String else {
                pushToLoginView()
                return
            }
            MBProgressHUD.showAutoDismissHUD(message: "登录中")
            
            JMSGUser.login(withUsername: username, password: password) { (result, error) in
                if error == nil {
                    UserDefaults.standard.set(username, forKey: kLastUserName)
                    UserDefaults.standard.set(username, forKey: kCurrentUserName)
                    UserDefaults.standard.set(password, forKey: kCurrentUserPassword)
                } else {
                    self.pushToLoginView()
//                    MBProgressHUD.showAutoDismissHUD(message: "\(String.errorAlert(error! as NSError))")
                }
            }
        } else {
            pushToLoginView()
        }
    }
}


