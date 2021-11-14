//
//  ClassesCardOverviewView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

public struct ClassesCardOverviewView: View {
    
    @ObservedObject var viewModel: ClassesCardOverviewViewModel
    
    init(viewModel: ClassesCardOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Text("Classes overview")
                    .font(.title.bold())
                    .padding()
                
                Divider()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                        ForEach(viewModel.studiedClasses) { data in
                            ClassCardView(
                                name: data.name,
                                ident: data.ident,
                                nextClass: data.nextClass,
                                room: data.room,
                                background: .classCardBlue
                            )
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.classCardTapSubject.send(data)
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
            
            VStack {
                Spacer(minLength: 0 )
                
                Button(action: {
                    viewModel.adddClassSubject.send()
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .font(.largeTitle)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.white)
                        .background(Color.golden)
                        .clipShape(Circle())
                }
                
                Spacer()
                    .frame(height: 50)
            }
        }
    }
}

struct ClassesCardOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClassesCardOverviewView(viewModel: .init())
                .previewDevice("iPhone 13")
                .environmentObject(ClassesCardOverviewViewModel())
            ClassesCardOverviewView(viewModel: .init())
                .previewDevice("iPhone 8")
                .environmentObject(ClassesCardOverviewViewModel())
        }
    }
}
