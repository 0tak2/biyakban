//
//  ContentView.swift
//  biyakban
//
//  Created by 임영택 on 3/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var xPos: Int = 0
    @State private var yPos: Int = 0
    @State private var timer: Timer?
    @State private var isLookingLeft: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                headerView
                
                Spacer()
                
                Image("Monster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .foregroundStyle(.tint)
                    .shadow(radius: 8)
                    .scaleEffect(x: isLookingLeft ? 1 : -1, y: 1)
                    .offset(.init(width: xPos, height: yPos))
                
                Spacer()
                
                let buttonWidth = geometry.size.width / 3 - 24
                let buttonHeigh = buttonWidth / 1.5
                moveButtonsKeyPad(widthForEachButton: buttonWidth, heightForEachButton: buttonHeigh)
            }
            .frame(maxWidth: .infinity)
            .background(Color.green)
        }
    }
    
    var headerView: some View {
        VStack {
            Text("야생의 Monster가 나타났다!")
                .font(.system(size: 30, weight: .bold))
            
            Spacer()
                .frame(height: 48)
            
            Text("x 좌표: \(xPos)")
            Text("y 좌표: \(yPos)")
        }
        .foregroundStyle(Color.black)
    }
    
    private func moveButtonsKeyPad(widthForEachButton width: CGFloat, heightForEachButton height: CGFloat) -> some View {
        VStack(spacing: 8) {
            HStack {
                moveButtonView(for: .up, width: width, height: height)
            }
            
            HStack(spacing: 18) {
                moveButtonView(for: .left, width: width, height: height)
                moveButtonView(for: .down, width: width, height: height)
                moveButtonView(for: .right, width: width, height: height)
            }
        }
    }
    
    @ViewBuilder
    private func moveButtonView(for direction: MoveDirection, width: CGFloat = 48, height: CGFloat = 36) -> some View {
        let imageName = direction.getImageName()
        let (xd, yd) = direction.getDifference()
        
        Button {
            withAnimation(.bouncy(duration: 0.2)) {
                move(forX: xd, forY: yd)
            }
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundStyle(.white)
        }
        .onLongPressGesture(minimumDuration: 0.1, perform: { }, onPressingChanged: { isPressing in
            if isPressing {
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {_ in
                    withAnimation(.bouncy(duration: 0.2)) {
                        move(forX: xd, forY: yd)
                    }
                }
                print("Timer started")
                return
            }
            
            timer?.invalidate()
            print("Timer invalidated")
        })
        .frame(width: width, height: height)
        .background(Color.orange)
//        .cornerRadius(8) // Deprecated
        .clipShape(.rect(cornerSize: .init(width: 8, height: 8)))
    }
    
    private func move(forX xDiff: Int, forY yDiff: Int) {
        // haptic
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        
        // move image pos
        xPos += xDiff
        yPos += yDiff
        
        // flip image
        if yDiff != 0 {
            return
        }
        
        if xDiff > 0 {
            isLookingLeft = false
        } else {
            isLookingLeft = true
        }
    }
    
    enum MoveDirection: Int {
        case up = 0
        case left
        case down
        case right
        
        private static let xDifferences = [0, -20, 0, 20]
        private static let yDifferences = [-20, 0, 20, 0]
        
        func getImageName() -> String {
            switch self {
            case .up:
                "chevron.up"
            case .left:
                "chevron.left"
            case .down:
                "chevron.down"
            case .right:
                "chevron.right"
            }
        }
        
        /**
        @return (xPosDifference, yPosDifference)
         */
        func getDifference() -> (Int, Int) {
            let index = self.rawValue
            guard index <= 3 else {
                return (0, 0)
            }
            
            return (
                MoveDirection.xDifferences[index],
                MoveDirection.yDifferences[index]
            )
        }
    }
}



#Preview {
    ContentView()
}
