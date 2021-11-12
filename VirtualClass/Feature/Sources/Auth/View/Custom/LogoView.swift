//
//  LogoView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack {
            Text("Virtual Class")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 10)
                .border(Color.white, width: 5)
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            LogoView()
        }
    }
}
