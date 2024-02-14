//
//  RatingsView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import SwiftUI

struct RatingsView: View {
    
    @Binding var currentRating: Int?
    
    var maxRating: Int
    var width: Int
    var color: UIColor
    var sfSymbol: String
    
    init(maxRating: Int, currentRating: Binding<Int?>, width: Int = 20, color: UIColor = .systemYellow, sfSymbol: String = "star") {
        self.maxRating = maxRating
        self._currentRating = currentRating
        self.width = width
        self.color = color
        self.sfSymbol = sfSymbol
    }
    
    var body: some View {
        HStack {
          Image(systemName: sfSymbol)
                .resizable()
                .scaledToFit()
                .symbolVariant(.slash)
                .foregroundStyle(Color(color))
                .onTapGesture {
                    withAnimation {
                        currentRating = nil
                    }
                }
                .opacity(currentRating == nil ? 0 : 1)
            
            ForEach(1...maxRating, id: \.self) { rating in
                Image(systemName: sfSymbol)
                      .resizable()
                      .scaledToFit()
                      .fillImage(correctImage(for: rating))
                      .foregroundStyle(Color(color))
                      .onTapGesture {
                          withAnimation {
                              currentRating = rating + 1
                          }
                      }
            }
        }
        .frame(width: CGFloat(maxRating * width))
    }
    
    func correctImage(for rating: Int) -> Bool {
        if let currentRating, rating < currentRating {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var currentRating: Int? = 0
        
        var body: some View {
            RatingsView(maxRating: 5, currentRating: $currentRating, width: 30, color: .red, sfSymbol: "heart")
        }
    }
    return PreviewWrapper()
}

struct FillImage: ViewModifier {
    let fill: Bool
    
    func body(content: Content) -> some View {
        if fill {
            content
                .symbolVariant(.fill)
        } else {
            content
        }
    }
}

extension View {
    func fillImage(_ fill: Bool) -> some View {
        modifier(FillImage(fill: fill))
    }
}
