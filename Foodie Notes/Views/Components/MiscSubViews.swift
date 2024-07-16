//
//  MiscViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI

// Pop an error.
struct ErrorDialog : View {
    let text:String
    @State var showingAlert:Bool = true;
    
    var body: some View {
        EmptyView()
            .alert("Error", isPresented: $showingAlert) {
                Text(text)
                Button("OK", role: .cancel) {
                    showingAlert = false;
                }
            }
    }
}


// Wrap a form with scroll-friendly space at the bottom.
struct ScrollForm<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        Form {
            content
            Section(header:Text("")){ }
                .padding(.bottom, 20)
        }
    }
}

struct ViewScreenPrimaryButtons<Destination>: View where Destination : View {
    let backClosure:(() -> Void)
    let editDest: Destination
    var editClosure:(() -> Void) = {}
    var addCourseClosure:(() -> Void)?

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(
                    action: backClosure,
                    label: {
                        Image(systemName: "arrowshape.backward.circle.fill")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(.gray)

                    }
                )
                Spacer()
                    .frame(width:30)
                NavigationLink(destination: editDest) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .background(Color.white)
                        .clipShape(Circle())
                        .foregroundColor(.blue)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    editClosure()
                })
                if let addCourseClosure = addCourseClosure {
                    Spacer()
                        .frame(width:30)
                    NavigationLink(destination:CourseCreateOrEditView(title: "Create New Course"))
                    {
                        ZStack {
                            Image(systemName: "fork.knife.circle.fill")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.green)
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .background(Color.green)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                //.padding(.trailing, 36)

                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        addCourseClosure()
                    })
                }
            }
        }
    }
}

struct EditScreenPrimaryButtons : View {
    let cancelFunc:(() -> Void)
    let saveFunc:(() -> Void)
    let fieldName:String;
    @Binding var showingAlert:Bool;

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(
                    action: cancelFunc,
                    label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(.red)
                    }
                )
                Spacer()
                    .frame(width:30)
                Button(
                    action: saveFunc,
                    label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(.green)
                    }
                )
                .alert("Oops!", isPresented: $showingAlert) {
                    Text("Please add a \(fieldName).")
                    Button("OK", role: .cancel) { }
                }
            }
        }
    }
}

struct PrimaryNewButtonImage: View {
    var body: some View {
        Image(systemName: "plus")
            .resizable()
            .padding(10)
            .frame(width: 56, height: 56)
            .background(Color.blue)
            .clipShape(Circle())
            .foregroundColor(.white)
    }
}

struct SecondaryAddButtonImage : View {
    var body: some View {
        Image(systemName: "plus.circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.gray)
            .padding(.trailing, -20)
    }
}

struct StyledTextField : View {
    @Binding var inputText:String;

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                TextField("Tap to Add/Edit", text:$inputText, axis:.vertical)
                    .padding(.horizontal, 4)
                    .padding(.top, 3)
                    .padding(.bottom, 1)
                Spacer()
                Button(
                    action: {
                        self.inputText = ""
                    },
                    label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.gray)
                    }
                )
                .padding(.trailing, 2)
                .padding(.top, 2)
                .padding(.bottom, 2)
            }
            .buttonStyle(.plain)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
        }
    }
}

// All views related to showing and editing dates.
struct DateViews {
    private static let title:String = "When Enjoyed"
    private static let prompt:String = "Date/Time:"
    
    struct DatePickerSection: View {
        @Binding var selectedDate:Date
        
        var body: some View {
            Section(title) {
                DatePicker(
                    prompt,
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .bold()
            }
        }
    }
    
    struct DateSection: View {
        let date: Date?
        let dateFormatter: DateFormatter;
        
        init(_ date: Date?) {
            self.date = date
            self.dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
        }
                
        var body: some View {
            Section(title) {
                HStack {
                    Text(dateFormatter.string(from: date ?? Date()))
                }
            }
        }
    }
}
