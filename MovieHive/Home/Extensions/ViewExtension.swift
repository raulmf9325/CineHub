//
//  ViewExtension.swift
//  MovieHive
//
//  Created by Raul Mena on 5/19/24.
//

import Combine
import SwiftUI

extension View {
    @ViewBuilder
    func threeDotLoadingIndicator(isLoading: AnyPublisher<Bool, Never>) -> some View {
        modifier(ThreeDotsLoadingIndicator(isLoading))
    }
}

struct ThreeDotsLoadingIndicator: ViewModifier {
    var isLoading: AnyPublisher<Bool, Never>
    
    @State private var shouldShowIndicator = false
    
    init(_ isLoading: AnyPublisher<Bool, Never>) {
        self.isLoading = isLoading
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(overlay)
            .onReceive(isLoading, perform: { loading in
                withAnimation {
                    shouldShowIndicator = loading
                }
            })
    }
    
    @ViewBuilder var overlay: some View {
        if shouldShowIndicator {
            ZStack {
                Color.black.opacity(0.6).ignoresSafeArea()
                ThreeDotsBouncingView()
            }
        }
    }
}
