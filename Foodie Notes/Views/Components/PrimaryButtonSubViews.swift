//
//  PrimaryButtonSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import SwiftUI

struct PrimaryButtonSubViews {
    private static let buttonSize:CGFloat = 56.0
    private static let buttonSpace:CGFloat = 30.0

    
    private struct ButtonSpace: View {
        var body: some View {
            Spacer()
                .frame(width:buttonSpace)
        }
    }
    
    private struct BackButton: View {
        let backClosure:(() -> Void)

        var body: some View {
            Button(
                action: backClosure,
                label: {
                    Image(systemName: "arrowshape.backward.circle.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                        .background(Color.white)
                        .clipShape(Circle())
                        .foregroundColor(.gray)
                    
                }
            )
        }
    }
    
    private struct EditButton<Destination>: View where Destination : View {
        let editDest: Destination
        
        var body: some View {
            NavigationLink(destination: editDest) {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.white)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
            }
        }
    }
    
    struct MealViewPrimaryButtons<EditDestination, CreateDestination>: View where EditDestination : View, CreateDestination: View {
        let backClosure:(() -> Void)
        let editMealDest: EditDestination
        let createCourseDest: CreateDestination
        
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    BackButton(backClosure: backClosure)
                    ButtonSpace()
                    EditButton(editDest: editMealDest)
                    ButtonSpace()
                    NavigationLink(destination: createCourseDest) {
                        ZStack {
                            Image(systemName: "fork.knife.circle.fill")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.green)
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .background(Color.green)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
    
    struct CourseViewPrimaryButtons<EditDestination>: View where EditDestination : View {
        let backClosure:(() -> Void)
        let editCourseDest: EditDestination
        
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    BackButton(backClosure: backClosure)
                    ButtonSpace()
                    EditButton(editDest: editCourseDest)
                }
            }
        }
    }

    struct EditViewPrimaryButtons : View {
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
                                .frame(width: buttonSize, height: buttonSize)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.red)
                        }
                    )
                    ButtonSpace()
                    Button(
                        action: saveFunc,
                        label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
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
    
    struct MealListViewPrimaryNewButtonImage: View {
        var body: some View {
            Image(systemName: "plus")
                .resizable()
                .padding(10)
                .frame(width: buttonSize, height: buttonSize)
                .background(Color.blue)
                .clipShape(Circle())
                .foregroundColor(.white)
        }
    }
}
