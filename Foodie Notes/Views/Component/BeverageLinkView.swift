//
//  BeverageLinkView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/29/24.
//

import SwiftUI

struct BeverageLinkView : View {
    @EnvironmentObject var viewModel:AppViewModel;
    @Environment(NetworkService.self) private var networkService
    @StateObject var labelRecModel:AsyncLabelRecognitionViewModel = AsyncLabelRecognitionViewModel()

    let course:Course
    
    var body: some View {
        VStack {
            // If we have a link already, use them.
            if let link = course.beveragePairing.infoLink {
                InfoLinkView(link:link)
            } else if networkService.isConnected && !course.beveragePairing.pictures.isEmpty {
                let img = course.beveragePairing.pictures.first?.photo?.full
                // Load link async, and update view.  Only recognize the first picture.
                AsyncRecognizedWineLabelView(
                    source:labelRecModel,
                    img:img!,
                    progressContent: { Searching() },
                    // Can safely unwrap link due to switch statement in AyncGuideLink
                    linkContent: { InfoLinkView(link:InfoLink(name: labelRecModel.name, url:labelRecModel.link)) }
                )
                .onChange(of: labelRecModel.link) {
                    var newCourse = course
                    newCourse.beveragePairing.infoLink = InfoLink(name:labelRecModel.name, url:labelRecModel.link)
                    viewModel.saveEditedCourse(newCourse)
                }
            } else {
                InfoLinkView(link:InfoLink(name: "No Internet Connection", url: URL(string: "")))
            }
        }
    }

    private struct LinkImg: View {
        var body: some View {
            Image(systemName: "link")
                .resizable()
                .scaledToFit()
                .frame(height: 18)
                .foregroundColor(Color.gray)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        }
    }

    private struct InfoLinkView: View {
        let link:InfoLink
        
        var body: some View {
            HStack {
                if let url = link.url, let name = link.name {
                    LinkImg()
                    Link(name, destination:url)
                        .font(.system(size:14, weight: .regular))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                } else {
                    EmptyView()
                }
                Spacer()
            }
        }
    }

    private struct Searching: View {
        var body: some View {
            HStack {
                LinkImg()
                ProgressView()
                    .frame(width: 18, height: 18)
                Spacer()
            }
        }
    }
}
