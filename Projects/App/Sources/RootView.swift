//
//  RootView.swift
//  Pumping
//
//  Created by 박현우 on 2023/06/07.
//

import SwiftUI
import ComposableArchitecture
import Feature

struct RootView: View {
    public let store: StoreOf<RootStore>
    
    public init(store: StoreOf<RootStore>) {
        self.store = store
    }
    
    var body: some View {
        SwitchStore(self.store) { initialState in
            switch initialState {
            case .onboarding:
                CaseLet(/RootStore.State.onboarding, action: RootStore.Action.onboarding) {
                    OnboardingRootView(store: $0)
                }
            case .mainTab:
                CaseLet(/RootStore.State.mainTab, action: RootStore.Action.mainTab) {
                    MainTabView(store: $0)
                }
            }
        }
    }
}
