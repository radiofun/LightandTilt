//
//  ContentView.swift
//  LightandTilt
//
//  Created by Minsang Choi on 8/7/25.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    
    @State private var a : CGFloat = 0.57
    @State private var b : CGFloat = 3.8
    @State private var dragp : CGPoint = .zero //drag to test in preview
    @State private var tilt : CGPoint = .zero
        
    
    @State private var isTilt : Bool = false
    
    private let motionManager = CMMotionManager()
    
    var body: some View {
        
        ZStack {
            ZStack{
                LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing)
                    .blur(radius: 20)
                    .layerEffect(ShaderLibrary.shine(.boundingRect,.float2(isTilt ? tilt : dragp),.float(a), .float(b)), maxSampleOffset: .zero)
            }
            .frame(width:380,height:380)
            .cornerRadius(40)
            .shadow(radius: 20)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragp = value.location
                    }
            )
            
            
            VStack{
                Spacer()
                Toggle("Use tilt?", isOn: $isTilt)
                    .padding()
                HStack{
                    Text("\(a, specifier: "%.3f")")
                    Slider(value: $a, in:0...1)
                    
                }
                HStack{
                    Text("\(b, specifier: "%.3f")")
                    Slider(value: $b, in:0...1)
                    
                }
            }
            .tint(.primary)
            .font(.system(size: 12, design: .monospaced))
            .padding()
        }
        .onAppear {
            
            
            motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
                guard let motion = motion else { return }
                let x = motion.attitude.roll
                let y = motion.attitude.pitch
                tilt = CGPoint(x: 160 + CGFloat(x) * 400, y: -200 + CGFloat(y) * 400)
            }
        }
    }
}

#Preview {
    ContentView()
}
