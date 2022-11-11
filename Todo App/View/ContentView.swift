//
//  ContentView.swift
//  Todo App
//
//  Created by Philip Al-Twal on 10/31/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var iconSettings: IconNames
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)])
    var todos: FetchedResults<Todo>
    
    @State private var showingSettingsView: Bool = false
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    
    //THEME
    @ObservedObject var theme = ThemeSettings.shared
    var themes : [Theme] = themeData
    
    //MARK: - FUNCTIONS
    private func deleteTodo(at offsets: IndexSet) {
        for offset in offsets {
            let todo = todos[offset]
            managedObjectContext.delete(todo)
            do{
                try managedObjectContext.save()
            }catch{
                print("Error [      ] failed to delete todo item")
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
    
    //MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos, id:\.self) { item in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: item.priority ?? "Normal"))
                            Text(item.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(item.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(uiColor: .systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule()
                                        .stroke(Color(uiColor: .systemGray2),
                                                lineWidth: 0.75)
                                )
                        }//: HSTACK
                        .padding(.vertical, 10)
                    }//: LOOP
                    .onDelete(perform: deleteTodo(at:))
                }//: LIST
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .accentColor(themes[theme.themeSettings].themeColor)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingSettingsView.toggle()
                        } label: {
                            Image(systemName: "paintbrush")
                                .imageScale(.large)
                                .accentColor(themes[theme.themeSettings].themeColor)
                        }//: ADD BUTTON
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView()
                                .environmentObject(self.iconSettings)
                        }//: SHEET
                    }//: TOOL BAR ITEM
                }//: TOOL BAR
                
                //MARK: - NO TODO ITEMS
                if todos.count == 0{
                    EmptyListView()
                }
            }//: ZSTACK
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView()
                    .environment(\.managedObjectContext,
                                  self.managedObjectContext)
            }//: SHEET
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 68,
                                   height: 68,
                                   alignment: .center)
                        Circle()
                            .fill(themes[theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.15 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 88,
                                   height: 88,
                                   alignment: .center)
                    }//: GROUP
                    .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: animatingButton)
                    Button(action: {
                        showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48,
                                   height: 48,
                                   alignment: .center)
                    })//: ADD BUTTON
                    .accentColor(themes[theme.themeSettings].themeColor)
                    .onAppear {
                        animatingButton.toggle()
                    }
                }//: ZSTACK
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )//: OVERLAY
        }// NAVIGATION VIEW
        .navigationViewStyle(StackNavigationViewStyle())
    }//: BODY
}


//MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
