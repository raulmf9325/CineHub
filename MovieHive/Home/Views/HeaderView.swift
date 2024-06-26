//
//  HeaderView.swift
//  CineHub
//
//  Created by Raul Mena on 5/12/24.
//

import SwiftUI

enum GridLayout {
    case two
    case three
}

struct HeaderView: View {
    @Binding var gridLayout: GridLayout
    @Binding var selection: String
    @Binding var text: String
    @Binding var isSearching: Bool
    
    @FocusState private var focus: FocusTextField?
    
    var body: some View {
        if isSearching {
            SearchView()
        } else {
            MovieListView()
        }
    }
}

extension HeaderView {
    enum FocusTextField {
        case searchMovie
    }
    
    func MovieListView() -> some View {
        HStack {
            GridLayoutButton()
            Spacer()
            MovieListDropDown()
            Spacer()
            SearchButton()
        }
        .frame(height: 60)
        .zIndex(2)
    }
    
    func SearchView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
                .font(.title2)
                .padding(.leading, 30)
            
            Spacer()
            
            TextField("Search Movie", text: $text, prompt: Text("Search Movie").foregroundStyle(.gray))
                .focused($focus, equals: .searchMovie)
                .padding(10)
                .background(Color.white)
                .foregroundStyle(.black)
                .font(AppTheme.Typography.helvetica15)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            
            Spacer()
            
            Button(action: {
                focus = nil
                text = ""
                isSearching = false
                triggerHapticFeedback()
            }, label: {
                Text("Cancel")
                    .foregroundStyle(.white)
                    .font(AppTheme.Typography.helvetica17)
                    .padding(.trailing, 30)
            })
        }
        .frame(height: 60)
        .onAppear {
            focus = .searchMovie
        }
    }
    
    func GridLayoutButton() -> some View {
        Button(action: {
                switch gridLayout {
                case .two:
                    gridLayout = .three
                case .three:
                    gridLayout = .two
                }
            
            triggerHapticFeedback()
        }, label: {
            Image(systemName: gridLayout == .three ? "square.grid.3x3.fill" : "square.grid.2x2.fill")
                .foregroundStyle(.white)
                .font(.title2)
                .animation(nil, value: gridLayout)
        })
        .padding(.leading, 30)
    }
    
    func SearchButton() -> some View {
        Button(action: {
            isSearching = true
            triggerHapticFeedback()
        }, label: {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
                .font(.title2)
                .animation(nil, value: gridLayout)
        })
        .padding(.trailing, 30)
    }
    
    func MovieListDropDown() -> some View {
        DropDownView(options: MovieList.allCases.map(\.rawValue),
                     background: .black,
                     selection: $selection)
    }
}

#Preview {
    @State var layout = GridLayout.two
    
    return ZStack {
        Color.black.ignoresSafeArea(.all)
        
        VStack {
            HeaderView(gridLayout: $layout,
                       selection: .constant("Now Playing"),
                       text: .constant(""),
                       isSearching: .constant(false))
            
            Spacer()
        }
        
    }
}
