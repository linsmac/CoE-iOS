//
//  SceneDelegate.swift
//  WhereToGoToday
//
//  Created by Gorgais Yeh on 2024/8/7.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //這個方法在一個新的情境（畫面或窗口）將要連接到應用時調用。
        //這裡通常用來設置和配置新的窗口。
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        //這個方法在情境（畫面或窗口）斷開連接時調用。
        //可以在這裡釋放任何不再需要的資源。
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        //當情境（畫面或窗口）變為活躍狀態時調用。
        //可以在這裡重新啟動暫停的任務。
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        //當情境（畫面或窗口）將要變為不活躍狀態時調用。
        //可以在這裡暫停正在進行的任務。
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        //當情境（畫面或窗口）從後台回到前台時調用。
        //可以在這裡撤銷進入後台時的更改。
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        //當情境（畫面或窗口）進入後台時調用。
        //可以在這裡保存數據和釋放資源。
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

