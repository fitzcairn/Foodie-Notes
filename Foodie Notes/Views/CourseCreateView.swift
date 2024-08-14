//
//  CourseCreateView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import SwiftUI

struct CourseCreateView: View {
    @Binding var course:Course;
    
    var body: some View {
        CourseView(course:course)
    }
}

