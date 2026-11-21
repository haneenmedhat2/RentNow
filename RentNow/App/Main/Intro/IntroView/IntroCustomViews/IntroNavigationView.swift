//
//  IntroNavigationView.swift
//  RentNow
//
//  Created by Claude on 22/01/2026.
//

import SwiftUI

struct IntroNavigationView: View {
    let currentIndex: Int
    let totalPages: Int
    let isLastPage: Bool
    var onPrevious: () -> Void
    var onNext: () -> Void
    var onStart: () -> Void

    private var isFirstPage: Bool {
        currentIndex == 0
    }

    var body: some View {
        VStack {
            Spacer()

            if isLastPage {
                HStack(spacing: 12) {
              

                 

                    // Arrow button - goes back to previous screen
                    Button(action: onPrevious) {
                        Image(Language.isRTL() ? "rightButton" : "leftButton" )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                        
                        
                        // Start Now button
                        Button(action: onStart) {
                            Text("Start Now".localized)
                                .expoSystemFont(size: 16, weight: .bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(.main)
                                )
                        }
                        
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }else if isFirstPage {
                // Arrow navigation for non-last pages
                HStack(spacing: 12) {
                 
                    // Left arrow (previous)
                    IntroArrowButton(direction: .left, isEnabled: true, action: onNext)
                  

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
            
            
            
            else {
                // Arrow navigation for non-last pages
                HStack(spacing: 12) {
                    // Right arrow (next)
                    IntroArrowButton(direction: .right, isEnabled: true, action: onPrevious)
                    // Left arrow (previous)
                    IntroArrowButton(direction: .left, isEnabled: true, action: onNext)
                  

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
        }
    }
}

// MARK: - Arrow Button Component
struct IntroArrowButton: View {
    enum Direction {
        case left, right
    }

    let direction: Direction
    let isEnabled: Bool
    var action: () -> Void

    // Flip arrows based on language
    private var imageName: String {
        let isRTL = Language.isRTL()
        if direction == .right {
            // Next button: right in English, left in Arabic
            return isRTL ?   "rightButton" : "leftButton"
        } else {
            // Previous button: left in English, right in Arabic
            return isRTL ? "leftButton" : "rightButton"
        }
    }

    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
        }
        .disabled(!isEnabled)
    }
}
