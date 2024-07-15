//
//  OtpView.swift
//  OTPDemo
//
//  Created by The Clean Coder on 15/07/24.
//

import SwiftUI
import UIKit

struct OtpView: View {
    @State private var pinOne = ""
    @State private var pinTwo = ""
    @State private var pinThree = ""
    @State private var pinFour = ""
    @FocusState private var pinOneFocused: Bool
    @FocusState private var pinTwoFocused: Bool
    @FocusState private var pinThreeFocused: Bool
    @FocusState private var pinFourFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            OtpField(pin: $pinOne, isFocused: _pinOneFocused, nextFocus: $pinTwoFocused, previousFocus: nil)
            OtpField(pin: $pinTwo, isFocused: _pinTwoFocused, nextFocus: $pinThreeFocused, previousFocus: $pinOneFocused)
            OtpField(pin: $pinThree, isFocused: _pinThreeFocused, nextFocus: $pinFourFocused, previousFocus: $pinTwoFocused)
            OtpField(pin: $pinFour, isFocused: _pinFourFocused, previousFocus: $pinThreeFocused)
        }
        .padding()
    }
}

struct OtpField: View {
    @Binding var pin: String
    @FocusState var isFocused: Bool
    var nextFocus: FocusState<Bool>.Binding?
    var previousFocus: FocusState<Bool>.Binding?

    @State private var hasReachedLimit = false // Track if the text limit is reached

    private let textLimit = 1

    var body: some View {
        VStack {
            DeleteDetectingTextFieldRepresentable(text: $pin, onDelete: {
                if pin.isEmpty {
                    previousFocus?.wrappedValue = true
                }
            })
            .focused($isFocused)
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1)
            )
            .onChange(of: pin) { newVal in
                limitText(textLimit)
                // Check if the text limit is reached and update the focus once
                if pin.count == textLimit && !hasReachedLimit {
                    nextFocus?.wrappedValue = true
                    hasReachedLimit = true // Avoid triggering onChange again
                } else {
                    hasReachedLimit = false // Reset flag if pin count changes
                }
            }
        }
    }

    private func limitText(_ upper: Int) {
        if pin.count > upper {
            pin = String(pin.prefix(upper))
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
 

struct DeleteDetectingTextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    var onDelete: () -> Void

    func makeUIView(context: Context) -> DeleteDetectingTextField {
        let textField = DeleteDetectingTextField()
        textField.delegate = context.coordinator
        textField.onDelete = onDelete
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        return textField
    }

    func updateUIView(_ uiView: DeleteDetectingTextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DeleteDetectingTextFieldRepresentable

        init(_ parent: DeleteDetectingTextFieldRepresentable) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}


class DeleteDetectingTextField: UITextField {
    override func deleteBackward() {
        super.deleteBackward()
        onDelete?()
    }

    var onDelete: (() -> Void)?
}
