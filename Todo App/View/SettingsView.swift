//
//  SettingsView.swift
//  Todo App
//
//  Created by Philip Al-Twal on 11/2/22.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    //MARK: - PROPERTIES
    @State private var isThemeChanged: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var iconSettings: IconNames
    
    // THEME
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    
    //MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                //MARK: - FORM
                Form {
                    //MARK: - SECTION 1
                    Section("Choose the app icon.") {
                        Picker(selection: $iconSettings.currentIndex) {
                            ForEach (0..<iconSettings.iconNames.count, id:\.self) { index in
                                HStack{
                                    Image(uiImage: UIImage(named: iconSettings.iconNames[index] ?? "Blue")
                                          ?? UIImage())
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 38, height: 38)
                                    .cornerRadius(9)
                                    
                                    Spacer().frame(width: 8)
                                    Text(iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }//: HSTACK
                            }//: LOOP
                        } label: {
                            HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(.primary, lineWidth: 2)
                                    
                                    
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 28,
                                                      weight: .regular,
                                                      design: .default))
                                        .foregroundColor(.primary)
                                }//: ZSTACK
                                .frame(width: 44,
                                       height: 44)
                                Text("App Icons".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }//: HSTACK
                        }//: PICKER VIEW
                        .pickerStyle(.inline)
                        .onReceive([iconSettings.currentIndex].publisher, perform: { value in
                            guard let index = iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) else { return }
                            if index != value {
                                UIApplication.shared.setAlternateIconName(iconSettings.iconNames[value]) { error in
                                    if error != nil {
                                        print("Error [  ] Failed to change app icon")
                                    }else{
                                        print("App Icon chnaged succesfully")
                                    }
                                }
                            }//: CONDITIONAL
                        })//: ON RECEIVE
                    }//: SECTION 1
                    .padding(.vertical, 3)
                    
                    //MARK: - SECTION 2
                    Section(header:
                    HStack {
                        Text("Choose the app theme")
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10,
                                   height: 10)
                            .foregroundColor(themes[theme.themeSettings].themeColor)
                    }) {
                        List(themes, id: \.id) { item in
                            Button {
                                DispatchQueue.main.async {
                                    self.theme.themeSettings = item.id
                                }
//                                UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                isThemeChanged.toggle()
                            } label: {
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(item.themeColor)
                                    Text(item.themeName)
                                }//: HSTACK
                            }//: BUTTON
                            .accentColor(.primary)
                        }//: LIST
                    }//: SECTION 2
                    .padding(.vertical, 3)
                    .alert(isPresented: $isThemeChanged) {
                        Alert(title: Text("Success"),
                              message: Text("App has been changed to the \(themes[theme.themeSettings].themeName)"),
                              dismissButton: .default(Text("OK")))
                    }
                    
                    //MARK: - section 3
                    Section("Follow us on social media") {
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: .blue, text: "Twitter", link: "https://twitter.com/robertpetras")
                        FormRowLinkView(icon: "play.rectangle", color: .green, text: "Courses", link: "https://www.udemy.com/user/robertpetras")
                    }//: SECTION 3
                    .padding(.vertical, 3)
                    
                    //MARK: - SECTION 4
                    Section("About the Application") {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility ", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Philip Al-Twal")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer ", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }//: SECTION 4
                    .padding(.vertical, 3)
                }//: FORM
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                //MARK: - FOOTER
                Text("Copyright © All rights reserved.\nBetter Apps ♡ Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            }//: VSTACK
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }//: DISMISS BUTTON
                }//: TOOL BAR ITEM
            })//: TOOLBAR
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
        }//: NAVIGATION VIEW
        .accentColor(themes[theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }//: BODY
}

//MARK: - PREVIEW

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNames())
    }
}
