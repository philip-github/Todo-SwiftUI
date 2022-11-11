//
//  ThemeSettings.swift
//  Todo App
//
//  Created by Philip Al-Twal on 11/3/22.
//

import SwiftUI

//MARK: - THEME CLASS

class ThemeSettings: ObservableObject {
    static let shared = ThemeSettings()
    private init(){}
    
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet{
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
            }
        }
    }
}
