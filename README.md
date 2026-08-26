# Pumping iOS

Pumping은 운동을 선택하고 기록하며 iPhone과 Apple Watch에서 운동 상태를 이어서 확인할 수 있는 iOS/watchOS 애플리케이션입니다.

![Pumping app](.github/assets/portfolio/pumping-restored-home.png)

## 주요 기능

- 운동 종목 탐색 및 선택
- 운동 세션 기록과 상태 관리
- HealthKit 기반 건강·운동 데이터 연동
- WatchConnectivity 기반 iPhone–Apple Watch 통신
- SwiftUI와 TCA를 활용한 단방향 상태 관리

## Architecture

Tuist 기반 Micro Feature Architecture로 기능과 의존성 경계를 분리합니다.

```text
Projects/
├── App
├── Feature
├── Domain
├── Core
├── Shared
└── WatchShared
```

Feature, Domain, Core 모듈은 interface와 implementation 계층을 나누며 iOS 앱과 watchOS extension은 공용 계층을 통해 연결됩니다.

## Stack

- Swift / SwiftUI
- The Composable Architecture
- HealthKit
- WatchConnectivity
- Tuist
- iOS / watchOS

## 시작하기

```bash
tuist install
tuist generate --no-open
```

시뮬레이터 빌드 예시:

```bash
xcodebuild \
  -workspace Pumping.xcworkspace \
  -scheme Pumping \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

HealthKit과 Apple Watch 기능을 사용하려면 실행 대상의 capability와 signing 설정이 필요합니다.
