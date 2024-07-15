//
//  ContentView.swift
//  OTPDemo
//
//  Created by The Clean Coder on 15/07/24.
//

import SwiftUI
import Combine
 
struct OTPScreen: View {
    //MARK -> PROPERTIES

    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }

    @State private var navigateToNextScreen = false
   
    //MARK -> BODY
    var body: some View {
            VStack {

                Text("Verify your Email Address")
                    .font(.title2)
                    .fontWeight(.semibold)


                Text("Enter 4 digit code we'll text you on Email")
                    .font(.caption)
                    .fontWeight(.thin)
                    .padding(.top)

                OtpView()
                .padding(.vertical)
                

                Button(action: {
                    
                }, label: {
                    Spacer()
                    Text("Verify")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                })
                .padding(15)
                .background(Color.blue)
                .clipShape(Capsule())
                .padding()
            }

    }
}

struct OTPScreenPreviews: PreviewProvider {
    static var previews: some View {
        OTPScreen()
    }
}
 
struct CustomButton: View {
    let title: String
    let action: () -> Void
    var width: CGFloat = 220
    var height: CGFloat = 50
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    var font: Font = .headline
    var cornerRadius: CGFloat = 10

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(foregroundColor)
                .padding()
                .frame(width: width, height: height)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}
