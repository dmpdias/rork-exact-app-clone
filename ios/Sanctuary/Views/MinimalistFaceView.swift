import SwiftUI

struct MinimalistFaceView: View {
    let expression: Expression
    let isSelected: Bool

    enum Expression {
        case hopeful
        case moved
        case inspired
        case grateful
    }

    private var faceColor: Color {
        isSelected ? Theme.goldDark : Theme.textLight
    }

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let r = min(size.width, size.height) / 2

            let circleRect = CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2)
            context.stroke(
                Circle().path(in: circleRect),
                with: .color(faceColor.opacity(0.3)),
                lineWidth: 1.5
            )

            let eyeY = center.y - r * 0.12
            let eyeSpacing = r * 0.28
            let eyeRadius: CGFloat = 1.8

            switch expression {
            case .hopeful:
                let leftEye = CGRect(x: center.x - eyeSpacing - eyeRadius, y: eyeY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2)
                let rightEye = CGRect(x: center.x + eyeSpacing - eyeRadius, y: eyeY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2)
                context.fill(Circle().path(in: leftEye), with: .color(faceColor))
                context.fill(Circle().path(in: rightEye), with: .color(faceColor))

                var smile = Path()
                let smileY = center.y + r * 0.22
                smile.move(to: CGPoint(x: center.x - r * 0.22, y: smileY))
                smile.addQuadCurve(
                    to: CGPoint(x: center.x + r * 0.22, y: smileY),
                    control: CGPoint(x: center.x, y: smileY + r * 0.18)
                )
                context.stroke(smile, with: .color(faceColor), lineWidth: 1.5)

            case .moved:
                let leftEye = CGRect(x: center.x - eyeSpacing - eyeRadius, y: eyeY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2)
                let rightEye = CGRect(x: center.x + eyeSpacing - eyeRadius, y: eyeY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2)
                context.fill(Circle().path(in: leftEye), with: .color(faceColor))
                context.fill(Circle().path(in: rightEye), with: .color(faceColor))

                var mouth = Path()
                let mouthY = center.y + r * 0.25
                mouth.move(to: CGPoint(x: center.x - r * 0.1, y: mouthY))
                mouth.addLine(to: CGPoint(x: center.x + r * 0.1, y: mouthY))
                context.stroke(mouth, with: .color(faceColor), lineWidth: 1.5)

                let tearX = center.x + eyeSpacing
                let tearStartY = eyeY + r * 0.08
                var tear = Path()
                tear.move(to: CGPoint(x: tearX, y: tearStartY))
                tear.addLine(to: CGPoint(x: tearX, y: tearStartY + r * 0.14))
                context.stroke(tear, with: .color(faceColor.opacity(0.5)), lineWidth: 1.2)

            case .inspired:
                let leftEye = CGRect(x: center.x - eyeSpacing - eyeRadius, y: eyeY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2)
                let rightEye = CGRect(x: center.x + eyeSpacing - eyeRadius, y: eyeY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2)
                context.fill(Circle().path(in: leftEye), with: .color(faceColor))
                context.fill(Circle().path(in: rightEye), with: .color(faceColor))

                var bigSmile = Path()
                let smileY = center.y + r * 0.18
                bigSmile.move(to: CGPoint(x: center.x - r * 0.26, y: smileY))
                bigSmile.addQuadCurve(
                    to: CGPoint(x: center.x + r * 0.26, y: smileY),
                    control: CGPoint(x: center.x, y: smileY + r * 0.26)
                )
                context.stroke(bigSmile, with: .color(faceColor), lineWidth: 1.5)

                let sparkleX = center.x + r * 0.55
                let sparkleY = center.y - r * 0.5
                let sparkSize: CGFloat = r * 0.1
                var sparkle = Path()
                sparkle.move(to: CGPoint(x: sparkleX, y: sparkleY - sparkSize))
                sparkle.addLine(to: CGPoint(x: sparkleX, y: sparkleY + sparkSize))
                sparkle.move(to: CGPoint(x: sparkleX - sparkSize, y: sparkleY))
                sparkle.addLine(to: CGPoint(x: sparkleX + sparkSize, y: sparkleY))
                context.stroke(sparkle, with: .color(faceColor.opacity(0.5)), lineWidth: 1.0)

            case .grateful:
                var leftEyeClosed = Path()
                leftEyeClosed.move(to: CGPoint(x: center.x - eyeSpacing - r * 0.08, y: eyeY))
                leftEyeClosed.addQuadCurve(
                    to: CGPoint(x: center.x - eyeSpacing + r * 0.08, y: eyeY),
                    control: CGPoint(x: center.x - eyeSpacing, y: eyeY - r * 0.06)
                )
                context.stroke(leftEyeClosed, with: .color(faceColor), lineWidth: 1.5)

                var rightEyeClosed = Path()
                rightEyeClosed.move(to: CGPoint(x: center.x + eyeSpacing - r * 0.08, y: eyeY))
                rightEyeClosed.addQuadCurve(
                    to: CGPoint(x: center.x + eyeSpacing + r * 0.08, y: eyeY),
                    control: CGPoint(x: center.x + eyeSpacing, y: eyeY - r * 0.06)
                )
                context.stroke(rightEyeClosed, with: .color(faceColor), lineWidth: 1.5)

                var gentleSmile = Path()
                let smileY = center.y + r * 0.2
                gentleSmile.move(to: CGPoint(x: center.x - r * 0.2, y: smileY))
                gentleSmile.addQuadCurve(
                    to: CGPoint(x: center.x + r * 0.2, y: smileY),
                    control: CGPoint(x: center.x, y: smileY + r * 0.15)
                )
                context.stroke(gentleSmile, with: .color(faceColor), lineWidth: 1.5)
            }
        }
    }
}
