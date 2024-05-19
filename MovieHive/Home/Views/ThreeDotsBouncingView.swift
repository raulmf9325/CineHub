//
//  ThreeDotsBouncingView.swift
//  MovieHive
//
//  Created by Raul Mena on 5/19/24.
//

import SwiftUI
import Combine

struct ThreeDotsBouncingView: View {
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let timing: Double
    
    @State var counter = 0
    
    let frame: CGSize
    let primaryColor: Color

    init(color: Color = .white, size: CGFloat = 50, speed: Double = 0.6) {
        timing = speed / 2
        timer = Timer.publish(every: timing, on: .main, in: .common).autoconnect()
        frame = CGSize(width: size, height: size)
        primaryColor = color
    }

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { index in
                Circle()
                    .offset(y: counter == index ? -frame.height / 10 : frame.height / 10)
                    .fill(primaryColor)
            }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onReceive(timer, perform: { _ in
            withAnimation(.easeInOut(duration: timing * 2)) {
                counter = counter == 2 ? 0 : counter + 1
            }
        })
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ThreeDotsBouncingView()
    }
}
