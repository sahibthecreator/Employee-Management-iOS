//
//  LaunchScreenView.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 08/01/2025.
//

import Foundation
import SwiftUI

struct LaunchScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIStoryboard(name: "Launch Screen", bundle: nil)
            .instantiateInitialViewController() ?? UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
