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
    
    let meal:Meal;

    var body: some View {
        let meal = viewModel.getMealFor(meal.id)!
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.MealPictureNameRatingView(
                        picture: viewModel.getMealImageFor(meal),
                        rating: meal.rating,
                        venue: meal.venue)
                    DateSubViews.DateSection(meal.date)
                    if (!meal.cuisines.isEmpty) {
                        CuisineSubViews.CuisineViewSection(
                            cuisines:meal.cuisines
                        )
                    }
                    if !meal.notes.isEmpty {
                        NotesSubViews.NotesSection(
                            title:SectionTitle.notes,
                            note: meal.notes
                        )
                    }
                    if viewModel.checkShow(meal.menu) {
                        PictureSubViews.PictureAndNotesViewSection(title: SectionTitle.menus, data:meal.menu)
                    }
                    if !meal.courses.isEmpty {
                        CourseSubViews.CoursesViewSection(courses:meal.courses)
                    }
                }
                PrimaryButtonSubViews.MealViewPrimaryButtons(
                    backClosure: {
                        viewModel.triggerRefresh()
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editMealDest: MealEditView(
                        meal: Binding<Meal>(
                            get: { viewModel.getMealFor(meal.id)! },
                            set: { viewModel.saveEditedMealFor($0) }
                            )
                    ),
                    createCourseDest: CourseCreateView(
                        mealId: meal.id
                    )
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: StyledTitleText(ViewTitle.viewMeal),
                trailing: ShareLink(
                    item: "",
                    subject: Text("Notes about my meal at \(meal.venue.name) on \(meal.date.formatted(date: .complete, time: .omitted))"),
                    message: Text(ModelIOService.exportAsString(meal)),
                    preview: SharePreview(
                        "Notes about my meal at \(meal.venue.name) on \(meal.date.formatted(date: .complete, time: .omitted))",
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
