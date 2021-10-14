//
//  SceneDelegate.swift
//  App
//
//  Created by Andreas Pfurtscheller on 10.04.21.
//

import UIKit
import Combine

enum PlayerType: String {
    case video
    case audio
    
    var viewController: UIViewController {
        switch self {
        case .audio: return AudioViewController()
        case .video: return VideoViewController()
        }
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var viewController: UIViewController? {
        didSet {
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        
        UserDefaults.standard.publisher(for: \.playerType)
            .map({ $0.flatMap({ PlayerType(rawValue: $0) }) })
            .replaceNil(with: .video)
            .receive(on: DispatchQueue.main)
            .map({ Optional($0.viewController) })
            .assign(to: \.viewController, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceDidShake(_:)),
            name: .DeviceDidShake,
            object: nil
        )
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
        }
        
        if let accentColor = UIColor(named: "AccentColor") {
            self.window?.tintColor = accentColor
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc private func deviceDidShake(_ notification: Notification) {
        let debugSheet = UIAlertController(title: "Select Player", message: nil, preferredStyle: .actionSheet)
        debugSheet.addAction(UIAlertAction(title: "Video", style: .destructive, handler: { _ in
            self.showPlayer(.video)
        }))
        debugSheet.addAction(UIAlertAction(title: "Audio", style: .destructive, handler: { _ in
            self.showPlayer(.audio)
        }))
        debugSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(debugSheet, animated: true)
    }

    private func showPlayer(_ playerType: PlayerType) {
        UserDefaults.standard.playerType = playerType.rawValue
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

