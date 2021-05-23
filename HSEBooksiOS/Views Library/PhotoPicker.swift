//
//  PhotoPicker.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 20.05.2021.
//

import SwiftUI
import PhotosUI

// MARK: - PhotoPicker
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onImport: (UIImage) -> Void
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let itemProvider = results.first?.itemProvider else {
                parent.isPresented = false
                return
            }
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async { [weak self] in
                        if let image = image as? UIImage {
                            self?.parent.onImport(image)
                            self?.parent.isPresented = false
                        }
                    }
                }
            }
        }
    }
}
