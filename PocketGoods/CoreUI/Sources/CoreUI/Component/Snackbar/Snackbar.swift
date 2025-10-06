//
//  Snackbar.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import SwiftUI

public struct Snackbar: View {

    @Binding
    private var data: SnackbarData

    private let cornerRadius: CGFloat

    private let font: Font

    private let maxWidth: CGFloat

    private let onClose: () -> Void

    public init(
        data: Binding<SnackbarData>,
        cornerRadius: CGFloat = 4,
        font: Font = .system(size: 14),
        maxWidth: CGFloat = .infinity,
        onClose: @escaping () -> Void
    ) {
        _data = data
        self.cornerRadius = cornerRadius
        self.font = font
        self.maxWidth = maxWidth
        self.onClose = onClose
    }

    private var paddingBottom: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first
            as? UIWindowScene
        {
            return windowScene.windows.first?.safeAreaInsets.bottom ?? 16
        }
        return 16
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {

                Spacer()

                HStack(alignment: .top, spacing: 12) {
                    Image(
                        data.icon.rawValue,
                        bundle: .module
                    )
                    .resizable()
                    .foregroundColor(
                        .snackbarOnBackgroundColor(data.severity)
                    )
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)

                    Text(data.message)
                        .foregroundColor(
                            .snackbarOnBackgroundColor(data.severity)
                        )
                        .font(font)
                        .frame(alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Color.snackbarBackgroundColor(data.severity)
                )
                .cornerRadius(cornerRadius)
                .shadow(
                    color: Color.black.opacity(0.2),
                    radius: 2,
                    x: 0,
                    y: 5
                )
                .padding(.horizontal, 16)
                .padding(.bottom, paddingBottom)
                .offset(
                    y: data.isVisible ? 0 : geometry.size.height + paddingBottom
                )
                .animation(.easeInOut(duration: 0.3), value: data.isVisible)
            }
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.bottom)
            .onChange(of: data.isVisible) { visible in
                if visible {
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + data.duration
                    ) {
                        onClose()
                    }
                }
            }
        }
    }
}

struct SnackbarModifier: ViewModifier {

    @Binding
    private var data: SnackbarData

    private let cornerRadius: CGFloat

    private let font: Font

    private let maxWidth: CGFloat

    private let onClose: () -> Void

    public init(
        data: Binding<SnackbarData>,
        cornerRadius: CGFloat = 4,
        font: Font = .system(size: 14),
        maxWidth: CGFloat = .infinity,
        onClose: @escaping () -> Void
    ) {
        _data = data
        self.cornerRadius = cornerRadius
        self.font = font
        self.maxWidth = maxWidth
        self.onClose = onClose
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            Snackbar(
                data: $data,
                cornerRadius: cornerRadius,
                font: font,
                maxWidth: maxWidth,
                onClose: onClose
            )

        }
    }
}

extension View {

    public func snackbarHost(
        data: Binding<SnackbarData>,
        cornerRadius: CGFloat = 4,
        font: Font = .system(size: 14),
        maxWidth: CGFloat = .infinity,
        onClose: @escaping () -> Void
    ) -> some View {
        self.modifier(
            SnackbarModifier(
                data: data,
                cornerRadius: cornerRadius,
                font: font,
                maxWidth: maxWidth,
                onClose: onClose
            )
        )
    }
}

private struct SnackbarPreview: View {

    @StateObject
    private var snackbarController = SnackbarController()

    var body: some View {
        ZStack {
            VStack(spacing: 26) {
                Button(
                    "Show Success snackbar",
                    action: {
                        snackbarController.show(
                            message: "Success Snackbar",
                            severity: .success
                        )
                    }
                )
                .padding()

                Button(
                    "Show Error snackbar",
                    action: {
                        snackbarController.show(
                            message: "Error Snackbar",
                            severity: .error
                        )
                    }
                )
                .padding()
            }
        }
        .snackbarHost(
            data: $snackbarController.data,
            font: .bodyMedium,
            onClose: {
                snackbarController.dismiss()
            }
        )
        .environmentObject(snackbarController)
    }
}

#Preview {
    SnackbarPreview()
}
