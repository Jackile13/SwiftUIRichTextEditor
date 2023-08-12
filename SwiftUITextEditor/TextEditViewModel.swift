//
//  TextEditViewModel.swift
//  SwiftUITextEditor
//
//  Created by Jack Allie on 12/8/2023.
//

import Foundation
import UIKit
import SwiftUI

extension ContentView {
    @MainActor
    class ViewModel : ObservableObject {
        @Published var text = NSMutableAttributedString(string: "")
        @Published var selectedRange = NSRange(0...0)
        @Published var typingAttributes: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        
        
        public func ToggleBold() {
            if (selectedRange.length == 0 || text.length < 1) {
                ToggleBoldTypingAttribute()
                return
            }
            if (text.length < 1) { return }
            
            for i in 0..<selectedRange.length {
                ToggleBoldToChar(index: i + selectedRange.location)
            }
            
            let currentRange = selectedRange
            selectedRange = NSRange(0...0)
            selectedRange = currentRange
        }
        
        public func ToggleUnderline() {
            if (selectedRange.length == 0 || text.length < 1) {
                ToggleUnderlineTypingAttribute()
                return
            }
            if (text.length < 1) { return }
            
            for i in 0..<selectedRange.length {
                ToggleUnderlineToChar(index: i + selectedRange.location)
            }
            
            let currentRange = selectedRange
            selectedRange = NSRange(0...0)
            selectedRange = currentRange
        }
        
        public func ToggleItalic() {
            if (selectedRange.length == 0 || text.length < 1) {
                ToggleItalicTypingAttribute()
                return
            }
            if (text.length < 1) { return }
            
            for i in 0..<selectedRange.length {
                ToggleItalicToChar(index: i + selectedRange.location)
            }
            
            let currentRange = selectedRange
            selectedRange = NSRange(0...0)
            selectedRange = currentRange
        }
        
        
        private func ToggleBoldToChar(index: Int) {
            if let font = text.attribute(.font, at: index, effectiveRange: nil) as? UIFont {
                // Get existing properties to carry through
                let size = font.pointSize
                var traits = font.fontDescriptor.symbolicTraits
                
                // Add or remove bold
                if traits.contains(.traitBold) {
                    traits.remove(.traitBold)
                } else {
                    traits = traits.union(.traitBold)
                }
                
                // New font to apply
                let newFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(traits)!, size: size)
                
                // Apply new font
                text.addAttribute(.font, value: newFont, range: NSRange(location: index, length: 1))
            } else {
                print("Text attribute was nil")
            }
        }
        
        private func ToggleBoldTypingAttribute() {
            print("Toggle bold typing attribute")
            if let font = typingAttributes[.font] as? UIFont {
                // Get existing properties to carry through
                let size = font.pointSize
                var traits = font.fontDescriptor.symbolicTraits
                
                // Add or remove bold
                if traits.contains(.traitBold) {
                    traits.remove(.traitBold)
                    print("Removing bold from type attrtibute")
                } else {
                    traits = traits.union(.traitBold)
                    print("Addinbg bold from type attrtibute")
                }
                
                // New font to apply
                let newFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(traits)!, size: size)
                
                typingAttributes.updateValue(newFont, forKey: .font)
            }
        }
        
        private func ToggleItalicToChar(index: Int) {
            if let font = text.attribute(.font, at: index, effectiveRange: nil) as? UIFont {
                // Get existing properties to carry through
                let size = font.pointSize
                var traits = font.fontDescriptor.symbolicTraits
                
                // Add or remove italic
                if traits.contains(.traitItalic) {
                    traits.remove(.traitItalic)
                } else {
                    traits = traits.union(.traitItalic)
                }
                
                // New font to apply
                let newFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(traits)!, size: size)
                
                // Apply new font
                text.addAttribute(.font, value: newFont, range: NSRange(location: index, length: 1))
            } else {
                print("Text attribute was nil")
            }
        }
        
        private func ToggleItalicTypingAttribute() {
            if let font = typingAttributes[.font] as? UIFont {
                // Get existing properties to carry through
                let size = font.pointSize
                var traits = font.fontDescriptor.symbolicTraits
                
                // Add or remove italics
                if traits.contains(.traitItalic) {
                    traits.remove(.traitItalic)
                } else {
                    traits = traits.union(.traitItalic)
                }
                
                // New font to apply
                let newFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(traits)!, size: size)
                
                typingAttributes.updateValue(newFont, forKey: .font)
            }
        }
        
        private func ToggleUnderlineToChar(index: Int) {
            if let underlineType = text.attribute(.underlineStyle, at: index, effectiveRange: nil) as? Int {
                
                if underlineType == 0 {
                    // char is not underlined -> Go underlined
                    text.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: index, length: 1))
                } else {
                    // char is underlined -> remove underline
                    text.addAttribute(.underlineStyle, value: 0, range: NSRange(location: index, length: 1))
                }
            } else {
                // No underlines found -> go underlined
                text.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: index, length: 1))
            }
        }
        
        private func ToggleUnderlineTypingAttribute() {
            
            var newUnderlineStyle = 0
            if let underlineStyle = typingAttributes[.underlineStyle] as? Int {
                // Change underline style
                if underlineStyle == 0 {
                    newUnderlineStyle = NSUnderlineStyle.single.rawValue
                } else {
                    newUnderlineStyle = 0
                }
            } else {
                // No style found, apply style
                newUnderlineStyle = NSUnderlineStyle.single.rawValue
            }
            typingAttributes.updateValue(newUnderlineStyle, forKey: .underlineStyle)
        }
        
        private func ToggleUnderlineToSelection() {
            if let underlineType = text.attribute(.underlineStyle, at: selectedRange.location, effectiveRange: nil) as? Int {
                
                if underlineType == 0 {
                    // char is not underlined -> Go underlined
                    text.addAttribute(.underlineStyle, value: 1, range: selectedRange)
                } else {
                    // char is underlined -> remove underline
                    text.addAttribute(.underlineStyle, value: 0, range: selectedRange)
                }
            } else {
                // No underlines found -> go underlined
                text.addAttribute(.underlineStyle, value: 1, range: selectedRange)
            }
        }
    }
}
