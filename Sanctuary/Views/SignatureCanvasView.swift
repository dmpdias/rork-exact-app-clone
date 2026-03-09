import SwiftUI
import PencilKit

struct SignatureCanvasView: UIViewRepresentable {
    @Binding var hasDrawn: Bool
    let inkColor: UIColor
    let lineWidth: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(hasDrawn: $hasDrawn)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: inkColor, width: lineWidth)
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.overrideUserInterfaceStyle = .light
        canvas.delegate = context.coordinator
        canvas.isScrollEnabled = false
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var hasDrawn: Binding<Bool>

        init(hasDrawn: Binding<Bool>) {
            self.hasDrawn = hasDrawn
        }

        nonisolated func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let isEmpty = canvasView.drawing.strokes.isEmpty
            Task { @MainActor in
                hasDrawn.wrappedValue = !isEmpty
            }
        }
    }
}
