//
//  SelectionButtonsView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/2/25.
//

import SwiftUI

struct SelectionButtonsView: View {
    let options: [String]
    let multiSelect: Bool
    
    @State private var selectedOptions: Set<String> = []
    @State private var selectedOption: String? = nil

    var body: some View {
        HStack(spacing: 10) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    handleSelection(option)
                }) {
                    Text(option)
                        .padding()
                        .frame(minWidth: 60)
                        .background(isSelected(option) ? Color.gray.opacity(0.5) : Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private func handleSelection(_ option: String) {
        if multiSelect {
            if selectedOptions.contains(option) {
                selectedOptions.remove(option)
            } else {
                selectedOptions.insert(option)
            }
        } else {
            selectedOption = (selectedOption == option) ? nil : option
        }
    }
    
    private func isSelected(_ option: String) -> Bool {
        return multiSelect ? selectedOptions.contains(option) : selectedOption == option
    }
}

struct SelectionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Single Selection")
            SelectionButtonsView(options: ["15 min", "30 min", "1 hr", "2 hr", "Custom"], multiSelect: false)
            
            Text("Multi Selection")
            SelectionButtonsView(options: ["15 min", "30 min", "1 hr", "2 hr", "Custom"], multiSelect: true)
        }
        .padding()
    }
}
