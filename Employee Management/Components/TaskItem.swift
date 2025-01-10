//
//  TaskItem.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 09/12/2024.
//

import Foundation
import SwiftUI
import PhotosUI

struct TaskItem: View {
    @Binding var task: TaskDTO
    var onComplete: (UIImage?) -> Void  
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        HStack {
            Button(action: {
                if !task.isDone {
                    if task.requiresImage {
                        showImagePicker = true
                    } else {
                        onComplete(nil)  // No image required
                    }
                }
            }) {
                Circle()
                    .stroke(AppColors.secondary, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(AppColors.secondary)
                            .frame(width: 16, height: 16)
                            .opacity(task.isDone ? 1 : 0)
                    )
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.subheadline)
                    .foregroundColor(task.isDone ? .gray : .black)
                    .strikethrough(task.isDone)
                if let time = task.time {
                    Text("(\(time))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
            if task.requiresImage {
                Image(systemName: "camera.fill")
                    .foregroundColor(AppColors.secondary)
                    .onTapGesture {
                        showImagePicker = true
                    }
            }
        }
        .padding()
        .background(task.isDone ? Color(UIColor.systemGray6) : Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, onImagePicked: { image in
                onComplete(image)
            })
        }
    }
}

