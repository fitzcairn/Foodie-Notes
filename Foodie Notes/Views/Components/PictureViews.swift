//
//  PictureViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views related to showing pictures and annotations
struct PictureViews {
    typealias PicturesAndNotes = AppModel.PicturesAndNotes
    typealias Picture = AppModel.Picture

    struct PictureAndNameView : View {
        private let name:String
        private let image:String
        
        init(name: String, image: String) {
            self.name = name
            self.image = image
        }
        
        var body: some View {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                Text(name)
                    .padding(.leading, 10)
                Spacer()
            }
        }
    }
    
    struct PictureAndNameEditView : View {
        @Binding var name: String
        @Binding var picture: Picture
        
        var body: some View {
            HStack {
                EditablePictureView(image: image)
                NameViews.NameEditView(name:$name)
                Spacer()
            }
        }
    }

    struct PictureAndNotesViewSection: View {
        let title:String;
        let data:AppModel.PicturesAndNotes;
        @EnvironmentObject var viewModel:AppViewModel;

        var body: some View {
            let vm:AppViewModel = viewModel;
            Section(header: Text(title)) {
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                            ForEach(data.pictureIds.indices) { i in
                                if let picture = vm.getPictureFor(data.pictureIds[i]) {
                                    Image(systemName: picture.src)
                                        .resizable()
                                        .frame(width: 64.0, height: 64.0)
                                }
                            }
                        }
                    }
                    NotesViews.NotesView(inputText:data.notes)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    struct PictureAndNotesEditSection: View {
        let title:String;
        @EnvironmentObject var viewModel:AppViewModel;
        @Binding var data:AppModel.PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                            ForEach($data.pictureIds.indices) { i in
                                EditablePictureView(data:data, index:i, deleteAction:deletePhoto)
                            }
                            EditablePictureView(data:data)
                        }
                    }
                    NotesViews.NotesEditView(inputText:$data.notes)
                }
            }
        }
        
        // TODO: Implement
        private func deletePhoto() {
            print("DELETE photo!!")
        }
    }
    
    // A Picture that you can click and remove
    struct EditablePictureView: View {
        @EnvironmentObject var viewModel:AppViewModel;
        @Binding var data:AppModel.PicturesAndNotes;
        let index:Int;
        // Allow this to also delete.
        var deleteAction: (() -> Void)? = nil;
        
        init(data: AppModel.PicturesAndNotes, index:Int, deleteAction:(()-> Void)?) {
            self.data = data
            self.index = index;
            self.deleteAction = deleteAction
        }

        // New picture case.
        init(data: AppModel.PicturesAndNotes) {
            self.data = data
            self.index = -1;
        }

        var body: some View {
            let vm:AppViewModel = viewModel;
            ZStack(alignment: .top) {
                if data.pictureIds.count > index {
                    let picture = vm.getPictureFor(data.pictureIds[index])
                    Image(systemName: picture.src)
                        .resizable()
                        .frame(width: 64.0, height: 64.0)
                    HStack {
                        Button(
                            action: deleteAction ?? pickPhoto,
                            label: {
                                if let action = deleteAction {
                                    ZStack {
                                        Image(systemName: "x.circle.fill")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color.red)
                                        Image(systemName: "x.circle")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color.white)
                                    }
                                } else {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .padding(6)
                                        .frame(width: 24, height: 24)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                }
                            }
                        )
                        Spacer()
                            .frame(width: 40)
                    }
                } else {
                    Button(
                        action: pickPhoto,
                        label: {
                            VStack {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 64, height: 64)
                        }
                    )
                }
            }
            .padding(.trailing, 10)
        }

        // TODO: Implement
        private func pickPhoto() {
            print("Pop photo picker!!")
        }

    }
}
