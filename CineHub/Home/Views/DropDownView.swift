//
//  DropDownView.swift
//  CineHub
//
//  Created by Raul Mena on 5/9/24.
//

import SwiftUI

struct DropDownView: View {
    var options: [String]
    var anchor: Anchor = .bottom
    var background: Color = .white
    var maxWidth: CGFloat = 180
    var cornerRadius: CGFloat = 15
    @Binding var selection: String
    @State private var showOptions = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                if showOptions && anchor == .top {
                    OptionsView()
                }
                
                HStack(spacing: 0) {
                    Text(selection)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(background)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        showOptions.toggle()
                    }
                }
                .zIndex(10)
                
                if showOptions && anchor == .bottom {
                    OptionsView()
                }
            }
            .clipped()
            .background(RoundedRectangle(cornerRadius: 12).fill(background.opacity(0.85)))
            .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
        }
        .frame(width: maxWidth, height: 50)
    }
    
    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 10) {
            ForEach(options, id: \.self) { option in
                HStack(spacing: 0) {
                    Text(option)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "checkmark")
                        .font(.callout)
                        .opacity(selection == option ? 1 : 0)
                        .foregroundStyle(.white)
                }
                .foregroundStyle(.white)
                .animation(.none, value: selection)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        showOptions = false
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .transition(.move(edge: .top))
    }
    
    enum Anchor {
        case top, bottom
    }
}

private struct DropDownPreview: View {
    @State private var selection = "apple"
    
    var body: some View {
        DropDownView(options: ["apple", "pear", "banana", "strawberry"],
                     selection: $selection)
    }
}

#Preview {
    DropDownPreview()
}
