//
//  RichTextBox.swift
//  SwiftUITextEditor
//
//  Created by Jack Allie on 4/5/2022.
//

import SwiftUI

struct RichTextBox: UIViewRepresentable {
    
    @Binding var text: NSMutableAttributedString
    @Binding var selectedRange: NSRange
    @Binding var typingAttributes: [NSAttributedString.Key : Any]
    var fontSize = UIFont.systemFontSize
    
    var onEditChange: (_ isEditing: Bool) -> Void

    func makeUIView(context: Context) -> UITextView {
        let textEditor = UITextView()

        textEditor.isSelectable = true
        textEditor.isEditable = true
        textEditor.autocapitalizationType = .sentences
        textEditor.allowsEditingTextAttributes = true
        textEditor.dataDetectorTypes = .link
        textEditor.backgroundColor = .clear
        textEditor.textColor = .label
        
        textEditor.attributedText = text
        textEditor.typingAttributes = typingAttributes
        
        textEditor.delegate = context.coordinator

        return textEditor
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = self.text
        uiView.selectedRange = self.selectedRange
        uiView.typingAttributes = self.typingAttributes
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator($text, $selectedRange, onEditChange, $typingAttributes)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<NSMutableAttributedString>
        var selectedRange: Binding<NSRange>
        var onEditChange: (_ isEditing: Bool) -> Void
        var typingAttributes: Binding<[NSAttributedString.Key : Any]>

        init(_ text: Binding<NSMutableAttributedString>, _ selectedRange: Binding<NSRange>, _ onEditChange: @escaping (_ isEditing: Bool) -> Void, _ typingAttributes: Binding<[NSAttributedString.Key : Any]>) {
            self.text = text
            self.selectedRange = selectedRange
            self.onEditChange = onEditChange
            self.typingAttributes = typingAttributes
        }
        
        // Set the text property from text view
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue.setAttributedString(textView.attributedText)
        }
        
        // Call editing handler
        func textViewDidBeginEditing(_ textView: UITextView) {
            self.onEditChange(true)
        }
        
        // Call editing handler
        func textViewDidEndEditing(_ textView: UITextView) {
            self.onEditChange(false)
        }
        
        // Updated selected range on text view and update typing attributes
        func textViewDidChangeSelection(_ textView: UITextView) {
            print("selection changed")
            self.selectedRange.wrappedValue = textView.selectedRange
            self.typingAttributes.wrappedValue = textView.typingAttributes
        }
    }
}
