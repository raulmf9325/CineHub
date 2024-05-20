//
//  SlideDownAlert.swift
//  MovieHive
//
//  Created by Raul Mena on 5/19/24.
//

import SwiftUI

struct SlideDownAlert: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(
                Color.black.opacity(0.2).clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 3))
            )
            .padding()
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    SlideDownAlert(message: "An error has occurred")
}
