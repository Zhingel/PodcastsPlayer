//
//  UIAplication.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 26.09.2021.
//

import Foundation
import UIKit

extension UIApplication {
    static func mainTabBarController()  -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
