# issue-tracker-iOS

<img src="https://user-images.githubusercontent.com/29879110/188896648-bceb2ec8-8f58-4648-b360-1e1d614d2ca9.png" style="width: 50%; height=50%" alt="logo-issue-tracker"/>

이슈트래커 iOS 버전 클라이언트 프로젝트 입니다.

## 📝 Introduce Our Project

> 프로젝트의 이슈 생성 및 관리를 쉽게 도와주는 어플리케이션입니다.<br/>
> 사용자 경험을 중시하여 여러 기술적인 도전을 수행하고 있습니다.

---

## 👨‍👩‍👧‍👦 Introduce Our Team

|                                          BE                                           |                                           BE                                           |                                          iOS                                          |                                           FE                                           |                                           FE                                            |
|:-------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------:|
| <img src="https://avatars.githubusercontent.com/u/68011320?v=4" width=400px alt="후"/> | <img src="https://avatars.githubusercontent.com/u/29879110?v=4" width=400px alt="아더"/> | <img src="https://avatars.githubusercontent.com/u/65931336?v=4" width=400px alt="벡"/> | <img src="https://avatars.githubusercontent.com/u/85747667?v=4" width=400px alt="도비"/> | <img src="https://avatars.githubusercontent.com/u/92701121?v=4" width=400px alt="도토리"/> |
|                           [Hoo](https://github.com/who-hoo)                           |                           [Ader](https://github.com/ak2j38)                            |                        [Beck](https://github.com/SangHwi-Back)                        |                        [Dobby](https://github.com/JiminKim-dev)                        |                          [Dotori](https://github.com/mogooee)                           |

---

## 💻 Tech Stack

<img src="https://img.shields.io/badge/-Swift-red"/> <img src="https://img.shields.io/badge/UI-SnapKit-yellowgreen"/><img src="https://img.shields.io/badge/UI-FlexLayout-yellowgreen"> <img src="https://img.shields.io/badge/Test-XCTest-brightgreen"> <img src="https://img.shields.io/badge/Test-TestFlight-blue"> <img src="https://img.shields.io/badge/Logic-RxSwift-critical"> <img src="https://img.shields.io/badge/Logic-RxCocoa-critical"> <img src="https://img.shields.io/badge/Logic-RxRelay-critical">

---

## 📔 Notion Page

https://sphenoid-fight-243.notion.site/1f7abecd77004e76b4adefff2db3624a

---

## 🛠 Architecture

### ReactorKit

MVC 패턴을 적용하였으나, Test 코드 작성이 힘든 점 / 유지보수성이 어려운 점 / 객체 간 Coupling 이 너무 두드러진 점 / 각 객체의 크기가 너무 커지는 점 / 코드 재사용성이 떨어지는 점 때문에 양방향 구조에서 단방향 구조로 변경.



---

## ❗️ Achievements

<p>
    <image src="https://user-images.githubusercontent.com/65931336/191487494-0c2a5152-9454-46bb-8f73-bf3e01222d94.gif" alt="SignIn-Login-DetailView-UITest"/>
    <em>UI-Test 로 회원가입 후 로그인하여 데이터 출력되는지 확인하는 중</em>
</p>

* XCTest 를 통한 버그 및 개발 간소화.
* 타입 확장을 통한 개발 효율 증대.
* FlexLayout(Frame-Based Layout), SnapKit(AutoLayout) 조합으로 효과적인 Code-Base UI 작성.
* RxSwift, RxCocoa 등을 이용하여 복잡한 로직을 간소화.
* Localization 적용
* Universal-Link 적용
  - https://back.issue-tracker.link/openApp

---

## ❗️ Challenge

* 높은 Test-Coverage 달성!
* 좋은 테스트 코드를 준비해둔 상태로 GitHub Action 을 이용한 CI/CD 적용.
