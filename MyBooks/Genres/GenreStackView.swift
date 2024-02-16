//
//  GenreStackView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/16/24.
//

import SwiftUI

struct GenreStackView: View {
    
    var genres: [Genre]
    
    var body: some View {
        HStack {
            ForEach(genres.sorted(using: KeyPathComparator(\Genre.name))) { genre in
                let style = foregroundStyleFor(hex: genre.hexColor.toHexString()!)
                Text(genre.name)
                    .font(.caption)
                    .foregroundStyle(style)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(genre.hexColor)
                    )
                    .border(style)
            }
        }
    }
    
    func hexToRGB(_ hex: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return (red: red, green: green, blue: blue)
    }
    
    func brightnessOf(color: (red: CGFloat, green: CGFloat, blue: CGFloat)) -> CGFloat {
        return (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue)
    }
    
    func foregroundStyleFor(hex: String) -> Color {
        guard let rgb = hexToRGB(hex) else { return .primary }
        let brightness = brightnessOf(color: rgb)
        return brightness > 0.5 ? .black : .white // Adjust the threshold as needed
    }
}

#Preview {
    SwiftDataViewer(preview: PreviewContainer(models: [Book.self])) {
        GenreStackView(genres: Genre.sampleGenres)
    }
}
