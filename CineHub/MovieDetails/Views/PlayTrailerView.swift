//
//  PlayTrailerView.swift
//  CineHub
//
//  Created by Raul Mena on 5/15/24.
//

import SwiftUI
import WebKit

struct PlayTrailerView: View {
    let urlString: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                CloseButton()
                    .padding(.trailing)
            }
            WebView(urlString: urlString)
        }
        .background(Color.black)
    }
    
    func CloseButton() -> some View {
        Button(action: { dismiss() }) {
            Image(systemName: "x.circle")
                .foregroundStyle(.white)
                .font(.title)
        }
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = URL(string: urlString) else { return webView }
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

#Preview {
    PlayTrailerView(urlString: "https://www.youtube.com/embed/Y6Fv5StfAxA")
}
