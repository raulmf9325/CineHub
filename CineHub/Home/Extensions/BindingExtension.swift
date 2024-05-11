//
//  BindingExtension.swift
//  CineHub
//
//  Created by Raul Mena on 5/11/24.
//

import SwiftUI

extension Binding where Value: RawRepresentable, Value.RawValue == String {
    func toStringBinding() -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue.rawValue },
            set: { newValue in
                self.wrappedValue = Value(rawValue: newValue) ?? self.wrappedValue
            }
        )
    }
}
