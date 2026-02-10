//
//  WorkoutHomeView.swift
//  FeatureWorkoutInterface
//
//  Created by 송영모 on 2023/06/06.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import SharedDesignSystem

public struct WorkoutHomeView : View {
    public let store: StoreOf<WorkoutHomeStore>
    @State private var sleepHours: Double = 7.0
    @State private var energyLevel: Double = 3.0
    
    public init(store: StoreOf<WorkoutHomeStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    titleView()

                    recoveryInsightView()
                        .padding(.horizontal)
                        .padding(.bottom, 28)
                    
                    workoutCategoryListView(viewStore: viewStore)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    PumpingSubmitButton(title: "다음", isEnable: !viewStore.selectedWorkoutCategoryIdentifiers.isEmpty, completion: {
                        viewStore.send(.startButtonTapped)
                    })
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.colorGrey100)
        }
    }
    
    private func titleView() -> some View {
        VStack(spacing: .zero) {
            HStack {
                Text("어떤 운동을 할 예정인가요?")
                    .font(.pretendard(size: 24, type: .bold))
                    .foregroundColor(PumpingColors.colorGrey900.swiftUIColor)
                
                Spacer()
            }
            .padding(.top, 48)
            .padding(.horizontal)
            .padding(.bottom, 12)
            
            HStack {
                Text("오늘 할 운동을 모두 선택해 주세요")
                    .font(.pretendard(size: 15, type: .medium))
                    .foregroundColor(.colorGrey600)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }

    private func recoveryInsightView() -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY'S REFLECTION")
                        .font(.pretendard(size: 11, type: .bold))
                        .foregroundColor(.colorGrey600)

                    Text("몸 상태를 먼저 확인해요")
                        .font(.pretendard(size: 18, type: .bold))
                        .foregroundColor(PumpingColors.colorGrey900.swiftUIColor)
                }

                Spacer()

                Text(recoveryStatusTitle)
                    .font(.pretendard(size: 12, type: .bold))
                    .foregroundColor(recoveryStatusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(recoveryStatusColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            VStack(spacing: 16) {
                metricSlider(
                    title: "지난밤 수면",
                    valueText: String(format: "%.1f시간", sleepHours),
                    value: $sleepHours,
                    range: 3...10,
                    step: 0.5
                )

                metricSlider(
                    title: "현재 에너지",
                    valueText: "\(Int(energyLevel))/5",
                    value: $energyLevel,
                    range: 1...5,
                    step: 1
                )
            }

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(recoveryStatusColor)
                    .padding(.top, 2)

                Text(recoveryMessage)
                    .font(.pretendard(size: 13, type: .medium))
                    .foregroundColor(.colorGrey700)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.65))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(18)
        .background(Color.colorGrey200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func metricSlider(
        title: String,
        valueText: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double
    ) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.pretendard(size: 13, type: .medium))
                    .foregroundColor(.colorGrey700)

                Spacer()

                Text(valueText)
                    .font(.pretendard(size: 13, type: .bold))
                    .foregroundColor(PumpingColors.colorGrey900.swiftUIColor)
            }

            Slider(value: value, in: range, step: step)
                .tint(recoveryStatusColor)
        }
    }

    private var recoveryScore: Double {
        let sleepScore = min(max((sleepHours - 4.0) / 4.0, 0), 1)
        let energyScore = min(max((energyLevel - 1.0) / 4.0, 0), 1)
        return (sleepScore * 0.55) + (energyScore * 0.45)
    }

    private var recoveryStatusTitle: String {
        switch recoveryScore {
        case 0.72...:
            return "READY"
        case 0.45..<0.72:
            return "BALANCED"
        default:
            return "RECOVER"
        }
    }

    private var recoveryStatusColor: Color {
        switch recoveryScore {
        case 0.72...:
            return .green
        case 0.45..<0.72:
            return .orange
        default:
            return .red
        }
    }

    private var recoveryMessage: String {
        switch recoveryScore {
        case 0.72...:
            return "수면과 에너지 상태가 안정적이에요. 평소 강도로 운동하되, 첫 세트의 체감 난이도로 최종 강도를 조절해 보세요."
        case 0.45..<0.72:
            return "오늘은 기록 갱신보다 꾸준함에 초점을 맞추는 편이 좋아 보여요. 세트 수나 중량을 평소보다 조금 낮춰도 충분합니다."
        default:
            return "회복 신호가 낮아요. 가벼운 유산소, 스트레칭 또는 낮은 강도의 운동을 선택하고 몸 상태가 불편하면 휴식을 우선해 주세요."
        }
    }
    
    private func workoutCategoryListView(viewStore: ViewStoreOf<WorkoutHomeStore>) -> some View {
        VStack(spacing: .zero) {
            ForEach(Array(viewStore.state.workoutCategoryCellZip.keys), id: \.self) { type in
                HStack {
                    Text(type.title)
                    
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    ForEachStore(self.store.scope(state: { $0.workoutCategoryCellZip[type] ?? [] }, action: WorkoutHomeStore.Action.workoutCategoryCell(id:action:))) {
                        WorkoutCategoryCellView(store: $0)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
        }
    }
}
