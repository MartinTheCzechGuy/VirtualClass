//
//  ClassDetailView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SharedFeatures
import SwiftUI

struct ClassDetailView: View {
    
    @ObservedObject var viewModel:  ClassesCardOverviewViewModel
    
    var body: some View {
        if let selectedClass = viewModel.selectedClass {
            VStack(spacing: 15) {
                ZStack {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedClass = nil
                                }
                            }
                        
                        Spacer(minLength: 0)
                    }
                    .padding()
                    
                    Text(selectedClass.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 10) {
                    Text(selectedClass.ident)
                        .fontWeight(.semibold)
                    
                    Divider()
                    
                    ClassDetailBodyView(
                        classData: ClassBasicData(
                            about: selectedClass.description,
                            lecturer: "",
                            lessons: "",
                            credits: 6
                        )
                    )
                    
                    VStack {
                        Spacer(minLength: 0)
                        
                        Button(
                            action: { print("pressed completed") },
                            label: {
                                Text("Mark as completed")
                            }
                        )
                            .buttonStyle(AppGoldenButtonStyle())
                        
                        Button(
                            action: { print("pressed remove") },
                            label: {
                                Text("Remove class")
                            }
                        )
                            .buttonStyle(AppRedButtonStyle())
                        
                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
        }
    }
}

struct ClassDetailView_Previews: PreviewProvider {
    
    static var viewModel: ClassesCardOverviewViewModel = {
        let viewModel = ClassesCardOverviewViewModel()
        viewModel.selectedClass = .init(name: "selected class", ident: "ident", description: "blablablablalbalblablalaladsafadfadjhfjdahfdhfjldahfjdshfdshfldshfldashfladshfasdhgadshgladshgladshgashgsafhgiasfhgisajhgiasfjhoirahfgioarwhgoirahgiorahgksdhglsfhgghfghiahgisfh", nextClass: Date(), room: "room", faculty: "faculty", currentlyStudied: true)
        
        return viewModel
    }()
    
    static var previews: some View {
        Group {
            ClassDetailView(viewModel: viewModel)
                .previewDevice("iPhone 13")
            ClassDetailView(viewModel: viewModel)
                .previewDevice("iPhone 8")
        }
    }
}
