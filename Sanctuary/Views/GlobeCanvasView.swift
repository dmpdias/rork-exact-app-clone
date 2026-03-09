import SwiftUI

struct GlobeCanvasView: View {
    let rotation: Double

    private let landColor = Color(red: 0.82, green: 0.68, blue: 0.40)
    private let oceanColor = Color(red: 0.90, green: 0.85, blue: 0.78)
    private let gridColor = Color(red: 0.70, green: 0.58, blue: 0.32)

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 2

            let bgRect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
            let bgCircle = Circle().path(in: bgRect)
            context.fill(bgCircle, with: .color(oceanColor.opacity(0.5)))

            let rotRad = rotation * .pi / 180

            for i in 0..<8 {
                let angle = (Double(i) / 8.0) * .pi + rotRad
                let xOff = cos(angle) * radius
                guard abs(xOff) < radius else { continue }
                var path = Path()
                for step in 0...40 {
                    let t = Double(step) / 40.0
                    let a = -(.pi / 2) + t * .pi
                    let y = center.y + sin(a) * radius
                    let x = center.x + xOff * cos(a)
                    if step == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
                context.stroke(path, with: .color(gridColor.opacity(0.12)), lineWidth: 0.7)
            }

            for i in 1..<6 {
                let fraction = Double(i) / 6.0
                let y = center.y - radius + fraction * radius * 2
                let dy = y - center.y
                let latR = sqrt(max(0, radius * radius - dy * dy))
                guard latR > 2 else { continue }
                let ellipseRect = CGRect(x: center.x - latR, y: y - latR * 0.15, width: latR * 2, height: latR * 0.3)
                let ellipse = Ellipse().path(in: ellipseRect)
                context.stroke(ellipse, with: .color(gridColor.opacity(0.1)), lineWidth: 0.7)
            }

            let landPatches: [(lon: Double, lat: Double, w: Double, h: Double)] = [
                (-20, 20, 35, 40), (10, 10, 30, 50), (30, 45, 50, 25),
                (60, 30, 35, 30), (100, 20, 40, 35), (120, -10, 25, 20),
                (-100, 40, 40, 25), (-70, -10, 30, 35), (-60, 30, 25, 20),
                (80, 55, 60, 18), (140, 30, 20, 20), (-110, 55, 50, 15),
                (-80, 50, 35, 15), (20, -25, 25, 25), (50, 10, 20, 25),
            ]

            for patch in landPatches {
                let adjustedLon = patch.lon + rotation * 180 / .pi
                var lon = adjustedLon.truncatingRemainder(dividingBy: 360)
                if lon > 180 { lon -= 360 }
                if lon < -180 { lon += 360 }
                guard abs(lon) < 85 else { continue }

                let lonRad = lon * .pi / 180
                let latRad = patch.lat * .pi / 180
                let px = center.x + cos(latRad) * sin(lonRad) * radius
                let py = center.y - sin(latRad) * radius

                let dist = sqrt((px - center.x) * (px - center.x) + (py - center.y) * (py - center.y))
                guard dist < radius * 0.95 else { continue }

                let scale = cos(lonRad) * 0.7 + 0.3
                let w = patch.w * scale * radius / 110
                let h = patch.h * scale * radius / 110

                let rect = CGRect(x: px - w / 2, y: py - h / 2, width: w, height: h)
                let shape = Ellipse().path(in: rect)
                let fade = max(0.15, cos(lonRad))
                context.fill(shape, with: .color(landColor.opacity(0.3 * fade)))
            }

            context.stroke(bgCircle, with: .color(gridColor.opacity(0.35)), lineWidth: 1.5)

            let highlightRect = CGRect(x: center.x - radius * 0.7, y: center.y - radius * 0.85, width: radius * 0.9, height: radius * 0.5)
            let highlight = Ellipse().path(in: highlightRect)
            context.fill(highlight, with: .color(Color.white.opacity(0.06)))
        }
        .clipShape(Circle())
    }
}
