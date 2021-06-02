//
//  ContentView.swift
//  SrtMixOld
//
//  Created by WeIHa'S on 2021/5/30.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var ViewModel: Mix
    var body: some View {
        VStack{
            Spacer()
            Spacer()
            GroupBox(label: Text("Tab the right button to choose")) {
                HStack{
                    Spacer()
                    TextField("Choose a Chinese File", text: $ViewModel.fileName1)
                    Button {
                        ViewModel.showChoosePanel(isTheFirstFile: true)
                    }label: {
                        Text("中")
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    TextField("Choose an English File", text: $ViewModel.fileName2)
                    Button(" E "){
                        ViewModel.showChoosePanel(isTheFirstFile: false)
                    }
                    Spacer()
                }
            }
            Spacer()
            Button("Mix&Save") {
                ViewModel.Mix()
            }
            .padding()
            Spacer()
            MyProgress1(ViewModel: ViewModel)
                .frame(width: 295, height: 5, alignment: .top)
                .padding(3)
        }
        .frame(width: 300, height: 200, alignment: .center)
    }
}


struct MyProgress1: View {
    @ObservedObject var ViewModel : Mix
    var body: some View {
        VStack{
            ZStack {
                Capsule()
                    .frame(alignment: .center)
                    .foregroundColor(Color.white)
                    .opacity(0.4)
                Capsule()
                    .clipShape(RectBand(from: CGFloat(ViewModel.progress), to: 1))
                    .frame(alignment: .center)
                    .foregroundColor(Color.blue)
                    .animation(.easeIn)

            }
        }
    }
}

struct RectBand: Shape {
    var from: CGFloat
    var to: CGFloat
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addRect(CGRect(
                x: rect.origin.x,
                y: rect.origin.y,
                width: from * rect.size.width,
                height: rect.size.height
            ))
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ViewModel: previewmodel)
    }
}
