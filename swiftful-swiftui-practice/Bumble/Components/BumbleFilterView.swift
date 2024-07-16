//
//  BumbleFilterView.swift
//  swiftful-swiftui-practice
//
//  Created by Andres Rechimon on 10/06/2024.
//

import SwiftUI

struct BumbleFilterView: View {
    @Namespace private var namespace
    @Binding var selection: String
    var options: [String] = ["Everyone", "Trending"]
    
    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            ForEach(options, id: \.self) { option in
                VStack(spacing: 8) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if selection == option {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(height: 1.5)
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                }
                .padding(.top, 8)
                .foregroundStyle(selection == option ? .bumbleBlack : .bumbleGray)
                .onTapGesture {
                    selection = option
                }
            }
        }
        .animation(.smooth, value: selection)
    }
}

fileprivate struct BumbleFilterViewPreview: View {
    
    var options: [String] = ["Everyone", "Trending"]
    @State private var selection = "Everyone"
    
    var body: some View {
        BumbleFilterView(selection: $selection, options: options)
    }
}

#Preview {
    BumbleFilterViewPreview()
        .padding()
}
