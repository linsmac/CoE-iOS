//
//  AppDelegate.swift
//  WhereToGoToday
//
//  Created by Gorgais Yeh on 2024/8/7.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func appOpen() {
        print("Open success")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //作用：當應用啟動完成後會調用這個方法。在這裡可以執行一些初始化操作，比如設置初始視圖控制器，配置第三方庫等。
        //返回值：true 表示啟動過程成功完成。
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.resignOnTouchOutside = true
        appOpen()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        //作用：當應用需要創建一個新的場景會話（例如新窗口）時會調用這個方法。在這裡，你可以配置並返回一個 UISceneConfiguration 對象來描述新場景的配置。
        //參數：
            //connectingSceneSession：新的場景會話。
            //options：創建場景的選項。
        //返回值：UISceneConfiguration 對象，用來配置新場景。
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        //作用：當用戶丟棄一個或多個場景會話時會調用這個方法。如果應用未運行，這些被丟棄的場景會話會在 application:didFinishLaunchingWithOptions: 調用後調用此方法。在這裡，你可以釋放與這些場景會話相關的資源。
        //參數：
            //sceneSessions：被丟棄的場景會話集合。
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }




}

