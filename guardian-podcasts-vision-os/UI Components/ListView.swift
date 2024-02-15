//
//  ListView.swift
//  guardian-podcasts-vision-os
//
//  Created by Usman Nazir on 29/12/2023.
//

import SwiftUI
import Robin

struct ListView: View {
    
    @Environment(\.openWindow) private var openWindow
    
    @EnvironmentObject var navVM: NavigationViewModel
    
    @Binding private var data: [PodcastModel]
    @Binding private var series: PodcastSeries
    
    @ObservedObject var robin: Robin = .shared
    
    init(data: Binding<[PodcastModel]>, series: Binding<PodcastSeries>) {
        self._data = data
        self._series = series
    }
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                Image(series == .allPodcasts ? "Featured" : data.first?.series ?? "Featured")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                HStack {
                    Text(series == .allPodcasts ? "Featured" : data.first?.series ?? "Featured")
                        .font(.custom("GuardianTextEgyptian-Bold", size: 42))
                        .multilineTextAlignment(.leading)
                        .contentTransition(.numericText())
                    Spacer()
                }
                .frame(width: 250)
                Spacer()
            }
            Divider()
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    ForEach(0..<data.count, id: \.self) { i in
                        Cell(data: data[i])
                            .onTapGesture { _ in
                                if !navVM.isShowingMiniplayer {
                                    openWindow(id: "Player")
                                }
                                withAnimation(.spring()) {
                                    navVM.activePodcast = data[i]
                                }
                                robin.loadSingle(source: .init(url: data[i].url!,
                                                               metadata: RobinAudioMetadata(title: data[i].title,
                                                                                            artist: data[i].series)), presentation: .fullWindow)
                            }
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.5)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                                    .scaleEffect(phase.isIdentity ? CGSize(width: 1,height: 1) : CGSize(width: 0.95,height: 0.95))
                            }
                            .contentShape(.hoverEffect, RoundedRectangle(cornerRadius: 8))
                            .hoverEffect()
                        Divider()
                    }
                    Spacer()
                }
                .id(data)
            }
            .id(data)
            .scrollIndicators(.hidden)
            Spacer()
        }
        .padding(.top, 50)
        .padding(.horizontal, 50)
    }
}

#Preview {
    ListView(data: .constant([.sample]), series: .constant(.allPodcasts))
}
