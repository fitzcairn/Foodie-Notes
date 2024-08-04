//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
import UIKit.UIImage

struct MealView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @ObservedObject private var meal:WrappedStruct<Meal>;
    
    init(meal:Meal) {
        self.meal = WrappedStruct(withItem:meal)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.MealPictureNameRatingView(meal: meal.item)
                    
                    DateSubViews.DateSection(meal.item.date)
                    
                    if (!meal.item.cuisines.isEmpty) {
                        CuisineSubViews.CuisineViewSection(
                            cuisines:meal.item.cuisines
                        )
                    }
                    
                    if !meal.item.notes.isEmpty {
                        NotesSubViews.NotesSection(
                            title:SectionTitle.notes,
                            note: meal.item.notes
                        )
                    }
                    
                    if viewModel.checkShow(meal.item.menu) {
                        PictureSubViews.PictureAndNotesViewSection(title: SectionTitle.menus, data:meal.item.menu)
                    }
                    
                    if !meal.item.courses.isEmpty {
                        CourseSubViews.CoursesViewSection(courses:meal.item.courses)
                    }
                }
                PrimaryButtonSubViews.MealViewPrimaryButtons(
                    backClosure: {
                        viewModel.saveEditedMealFor(meal.item)
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editMealDest: MealEditView(
                        meal:meal.item
                    ),
                    createCourseDest: CourseCreateView(
                        mealId: meal.item.id
                    )
                )
            }
            .onAppear() {
                meal.item = viewModel.getMealFor(meal.item.id) ?? Meal()
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: StyledTitleText(ViewTitle.viewMeal),
                trailing: ShareLink(
                    item: "",
                    subject: Text("Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))"),
                    message: Text(ModelIOService.exportAsString(meal.item)),
                    preview: SharePreview(
                        "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))",
                        image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    )
                ) {
                    Image(systemName: "square.and.arrow.up.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
            )
        }
    }
}
