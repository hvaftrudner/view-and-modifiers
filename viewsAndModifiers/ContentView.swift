//
//  ContentView.swift
//  viewsAndModifiers
//
//  Created by Kristoffer Eriksson on 2021-01-30.
//

import SwiftUI

//custom container
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View{
        VStack{
            ForEach(0 ..< rows){ row in
                HStack{
                    ForEach(0 ..< columns){ column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
    //using custom initializer to implicit an HStack when custom container is used.
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int,Int) -> Content){
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

//creating a custom modifier
struct Title: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
//giving it a own name / making it an extension
extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

struct Watermarked: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing){
            content
            
            Text(text)
                .font(.caption2)
                .foregroundColor(.white)
                .background(Color.black)
                .padding()
        }
    }
}
extension View {
    func watermark(with text: String) -> some View {
        self.modifier(Watermarked(text: text))
    }
}

//using a new struct to use alot of modifiers on several views
struct capsuleText : View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
            .font(.caption2)
        
    }
}

struct ContentView: View {
    
    @State private var toggleColor = false
    
    //properties can be used as views
    let welcome = Text("välkommen hejsan hejsan")
    //using var and some view lets us manipulate the view/property inside
    var welcome2 : some View {Text("Tjena tjena")}
    
    var body: some View {
        VStack{
            //watermark zstack custom modifier example
            Color.red
                .frame(width: 100, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .watermark(with: "krilles watermark")
            //custom view
            GridStack(rows: 4, columns: 4) { col, row in
                Text("C\(col) R\(row)")
            }
            //a view
            Text("Hello, world!")
                .padding()
                //modifiers to maximize a views height and width
                .frame(maxWidth: 200, maxHeight: 200)
                .background(Color.red)
                .edgesIgnoringSafeArea(.all)
                //modifiers stack, therefore order is important
            
            Button("Click me") {
                self.toggleColor.toggle()
            }
            //best way to use conditional based rendering is ternary operator "?"
            .foregroundColor(toggleColor ? Color.red : Color.green)
            
            HStack{
                //using a custom modifier
                Text("tja")
                    .modifier(Title())
                Text("tjena")
                    .titleStyle()
                Text("hej")
                    //overrides environmetal modifier
                    //some modifiers just modifies the modifier for more value (blur etc)
                    .font(.largeTitle)
                Text("hejsan")
                //using a property to clean out the body
                welcome
                    .foregroundColor(.gray)
                // using a struct to use on multiple views
                capsuleText(text: "halloj")
                capsuleText(text: "tjenare")
                    .foregroundColor(.yellow)
            }
            //modifiers on groups of views (stacks) are environmental modifiers,
            //child modifiers gets prioritized if they have any conflicting
            .font(.subheadline)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
