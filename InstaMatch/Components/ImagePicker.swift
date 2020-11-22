//
//  ImagePicker.swift
//  InstaMatch
//
//  Created by Halil Yuce on 22.11.2020.
//

import SwiftUI
import Combine

struct ImagePickerView : UIViewControllerRepresentable {

    @Binding var model: ImagePickerViewModel

    typealias UIViewControllerType = UIImagePickerController

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIImagePickerController {

        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        controller.allowsEditing = false
        controller.mediaTypes = ["public.image"]
        controller.sourceType = .photoLibrary
        return controller

    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        // run right after making

    }

    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parentView: ImagePickerView

        init(_ parentView: ImagePickerView) {
            self.parentView = parentView
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parentView.model.isPresented = false
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                          didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

            guard let uiImage = info[.originalImage] as? UIImage else { return }

            let image = Image(uiImage: uiImage)
            parentView.model.pickedImagesSubject?.send([image])
            parentView.model.isPresented = false

        }

    }

}

struct ImagePickerViewModel {
    var isPresented: Bool = false
    let pickedImagesSubject: PassthroughSubject<[Image], Never>! = PassthroughSubject<[Image], Never>()
}
