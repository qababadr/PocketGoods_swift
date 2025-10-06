//
//  NetworkCarousel.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import Foundation
import SwiftUI
import Combine

public struct NetworkCarousel: View {

    private let urls: [URL]
    private let timeout: Double
    private let cornerRadius: CGFloat

    @State
    private var isAutoPlay: Bool
    
    @State
    private var selection = 0
    
    @State
    private var timerSubscription: Cancellable?

    private var timer: Timer.TimerPublisher

    public init(
        urls: [URL],
        timeout: Double = 4,
        cornerRadius: CGFloat = 4,
        isAutoPlay: Bool = true
    ) {
        self.urls = urls
        self.timeout = timeout
        self.cornerRadius = cornerRadius
        self._isAutoPlay = State(initialValue: isAutoPlay)
        self.timer = Timer.publish(
            every: timeout,
            on: .main,
            in: .common
        )
    }

    public var body: some View {
        TabView(selection: $selection) {
            ForEach(Array(urls.enumerated()), id: \.element) { index, url in
                NetworkImage(url: url)
                    .id(url)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear {
            if isAutoPlay {
                timerSubscription  = timer.connect()
            }
        }
        .onDisappear {
            timerSubscription?.cancel()
        }
        .onReceive(timer) { _ in
            withAnimation {
                selection = (selection + 1) % urls.count
            }
        }
    }
}
