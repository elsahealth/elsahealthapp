//
//  PrescriptionViewYesScan.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-17.
//

import SwiftUI

struct CaptureImageView {
    // TODO: be able to view the prescriptions from your storage instead of the gallery
    
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    func makeCoordinator() -> PrescriptionCoordinator {
        return PrescriptionCoordinator(isShown: $isShown, image: $image)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

struct PrescriptionViewYesScan: View {
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.showCaptureImageView.toggle()
                }) {
                    Text("Choose photos")
                }
                // TODO: modify so that you get a whole screen view of the photo
                image?.resizable()
                    .frame(width: 250, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                }
                if (showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView, image: $image)
            }
        }
    }
}

struct PrescriptionViewYesScan_Previews: PreviewProvider {
    static var previews: some View {
        PrescriptionViewYesScan()
    }
}
