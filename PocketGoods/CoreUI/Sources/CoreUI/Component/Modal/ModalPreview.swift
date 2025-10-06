//
//  ModalPreview.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//
import SwiftUI

private struct Form: View {
    @EnvironmentObject
    var modalController: ModalController

    @State
    private var text = ""

    @State
    private var showError = false

    @State
    private var isLoading = false

    @Binding
    private var formType: FormType

    init(formType: Binding<FormType>) {
        _formType = formType
    }

    var body: some View {
        VStack(spacing: 20) {

            Text(formType == .login ? "Login" : "Regiter")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.theme().primary)
                .foregroundColor(.theme().onPrimary)

            TextField("Enter text", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button(action: {
                formType = .register
            }) {
                Text("Register")
            }

            if showError {
                VStack {

                    if isLoading {
                        ProgressView()
                    }

                    Text("Please enter something")
                        .foregroundColor(.red)
                        .padding()
                }
            }

            HStack {
                Button("Cancel") {
                    modalController.dismiss()
                }

                Spacer()

                Button("Submit") {
                    isLoading.toggle()

                    if text.isEmpty {
                        showError = true
                    } else {
                        modalController.dismiss()
                    }
                }
            }
            .padding()
        }
    }
}

private enum FormType {
    case login, register
}

private struct ModalPreview: View {
    @StateObject
    var modalController = ModalController()

    @State
    private var formType: FormType = .login

    var body: some View {
        VStack {
            Button("Show form") {
                modalController.show {
                    Form(formType: $formType)
                }
            }
        }
        .modalHost()
        .environmentObject(modalController)
    }
}

#Preview {
    ModalPreview()
}
