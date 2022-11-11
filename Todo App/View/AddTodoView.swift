//
//  AddTodoView.swift
//  Todo App
//
//  Created by Philip Al-Twal on 11/1/22.
//

import SwiftUI

struct AddTodoView: View {
    
    //MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    
    let priorities: [String] = ["High", "Normal", "Low"]
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    @State private var showingError: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    
    // THEME
    @ObservedObject var theme = ThemeSettings.shared
    var themes : [Theme] = themeData
    
    //MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .center, spacing: 20) {
                    //MARK: - TODO NAME
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24,
                                      weight: .bold,
                                      design: .default))
                    
                    //MARK: - PRIORITY
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }//: LOOP
                    }//: PICKER
                    .pickerStyle(.segmented)
                    
                    //MARK: - SAVE BUTTON
                    Button {
                        if name != "" && !name.isEmpty {
                            let todo = Todo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            do{
                                try self.managedObjectContext.save()
                            }catch{
                                print("Error [      ] Failed to save todo \(error)")
                            }
                        } else {
                            showingError = true
                            errorTitle = "Invalid Name"
                            errorMessage = "Make sure to enter something for\nthe new todo item."
                            return
                        }//: CONDITIONAL STATEMENT
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.system(size: 24,
                                          weight: .bold,
                                          design: .default))
                            .padding()
                            .frame(minWidth: 0,
                                   maxWidth: .infinity)
                            .background(themes[theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    }//: SAVE BUTTON
                }//: VSTACK
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
            }//: VSTACK
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }//: CLOSE BUTTON
                }//: TOOL BAR ITEM
            }//: TOOLBAR
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))
            }//: ALERT
        }//: NAVIGATION VIEW
        .accentColor(themes[theme.themeSettings].themeColor)
    }//: BODY
}

//MARK: - PREVIEW

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
