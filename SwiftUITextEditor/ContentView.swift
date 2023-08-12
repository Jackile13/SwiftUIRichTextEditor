//
//  ContentView.swift
//  SwiftUITextEditor
//
//  Created by Jack Allie on 4/5/2022.
//

import SwiftUI

struct ContentView: View {
    
//    let attributes: [NSAttributedString.Key: Any] =
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("My rich swiftui text editor")
            
            HStack {
                Button {
                    print(viewModel.selectedRange)
                    viewModel.ToggleBold()
                } label: {
                    Image(systemName: "bold")
                }
                
                Button {
                    viewModel.ToggleUnderline()
                } label: {
                    Image(systemName: "underline")
                }
                
                Button {
                    viewModel.ToggleItalic()
                } label: {
                    Image(systemName: "italic")
                }
                
            }
            .padding(.bottom, 50)
            
            RichTextBox(text: $viewModel.text, selectedRange: $viewModel.selectedRange, typingAttributes: $viewModel.typingAttributes,  fontSize: 32) { isEditing in
                if isEditing {
                    print("Editing...")
                } else {
                    print("Done editing.")
                }
            }
            .padding(5)
            .background {
                Color.gray.opacity(0.3)
            }
            .cornerRadius(10)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
