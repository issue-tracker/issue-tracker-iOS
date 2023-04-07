# issue-tracker-iOS

<img src="https://user-images.githubusercontent.com/29879110/188896648-bceb2ec8-8f58-4648-b360-1e1d614d2ca9.png" style="width: 50%; height=50%" alt="logo-issue-tracker"/>

<table>
  <tr>
    <td><img src="https://img.shields.io/badge/-Swift-red"/></td>
    <td><img src="https://img.shields.io/badge/UI-SnapKit-yellowgreen"/></td>
    <td><img src="https://img.shields.io/badge/UI-FlexLayout-yellowgreen"></td>
    <td><img src="https://img.shields.io/badge/Test-XCTest-brightgreen"></td>
    <td><img src="https://img.shields.io/badge/Test-TestFlight-blue"></td>
    <td><img src="https://img.shields.io/badge/Logic-RxSwift-critical"></td>
    <td><img src="https://img.shields.io/badge/Logic-RxCocoa-critical"></td>
    <td><img src="https://img.shields.io/badge/Logic-RxRelay-critical"></td>
  </tr>
</table>

이슈트래커 iOS 버전 클라이언트 프로젝트 입니다.

## 📝 Introduce Our Project

> 프로젝트의 이슈 생성 및 관리를 쉽게 도와주는 어플리케이션입니다.<br/>
> Current Brach = feature/settingApplying

포트폴리오를 위한 프로젝트입니다. SnapKit+FlexLayout 조합으로 유연한 UI 코드 작성, ReactorKit 으로 유지보수성 높은 프로젝트 구성, UI+Unit-Test 작성 등을 진행하였습니다.

## 📚 Libraries

라이브러리를 사용하는 것 만큼이나 채택하게 된 이유가 중요하다고 생각합니다. 아래는 각 라이브러리를 선정하게 된 이유들을 정리해 놓았습니다.

* SnapKit = AutoLayout 을 사용하기 위해서 입니다.

<table>
  <tr>
    <th>이름</th>
    <th>설명</th>
  </tr>
  <tr>
    <td>SnapKit</td>
    <td>CodeBased-UI 에서 쉽게 AutoLayout 을 사용하기 위해서 입니다. NSLayoutConstraint, NSLayoutAnchor, Storyboard 3 가지 방법이 있지만 코드 가독성이 떨어진다는 문제점이 있었습니다.</td>
  </tr>
  <tr>
    <td>FlexLayout</td>
    <td>CodeBased-UI 에서 많은 subview 의 Constraint 를 정의하기 위해서 입니다. 대부분의 View 들이 Grid-Layout 으로 정의되는데, FlexLayout 을 이용하여 간단히 구성할 수 있었습니다.</td>
  </tr>
  <tr>
    <td>RxSwift</td>
    <td>Concurrency 를 빠르고 효율적으로 구현하기 위해서 입니다. 러닝커브가 심한 것은 사실이지만 우선 웹 상에 자료가 많고 RxSwift 를 활용한 ReactorKit, RIBs 등을 고려해보면 아주 좋은 옵션이라고 생각하였습니다.</td>
  </tr>
  <tr>
    <td>ReactorKit</td>
    <td>기존 MVC 패턴의 문제점을 보완하기 위해 도입하였습니다.</td>
  </tr>
</table>

---

## 👨‍👩‍👧‍👦 Introduce Our Team

|                                          BE                                           |                                           BE                                           |                                          iOS                                          |                                           FE                                           |                                           FE                                            |
|:-------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------:|
| <img src="https://avatars.githubusercontent.com/u/68011320?v=4" width=400px alt="후"/> | <img src="https://avatars.githubusercontent.com/u/29879110?v=4" width=400px alt="아더"/> | <img src="https://avatars.githubusercontent.com/u/65931336?v=4" width=400px alt="벡"/> | <img src="https://avatars.githubusercontent.com/u/85747667?v=4" width=400px alt="도비"/> | <img src="https://avatars.githubusercontent.com/u/92701121?v=4" width=400px alt="도토리"/> |
|                           [Hoo](https://github.com/who-hoo)                           |                           [Ader](https://github.com/ak2j38)                            |                        [Beck](https://github.com/SangHwi-Back)                        |                        [Dobby](https://github.com/JiminKim-dev)                        |                          [Dotori](https://github.com/mogooee)                           |

---

## 📔 Notion Page

https://sphenoid-fight-243.notion.site/1f7abecd77004e76b4adefff2db3624a

---

## 🛠 Architecture

### MVC

클린 소프트웨어에서 가장 좋아하는 구절인 "작게 시작하라" 는 말을 따라 MVC 패턴부터 시작해보기로 하였습니다.

논란이 많은 디자인 패턴임을 잘 알고 있었으나 실제 구현해보지 않으면 알 수 없다는 생각에 직접 구현해보면서 아래와 같은 문제점을 발견할 수 있었습니다.

* Test 코드 작성이 힘들었습니다. 많은 객체가 Test Target 으로 설정되면서 반복적인 테스트 코드만 늘어갈 뿐이었습니다.
* 객체 간 Coupling 이 너무 두드러지고 있었습니다. 소스 코드를 수정할 때 많은 불편함이 있었습니다.
* Coupling 으로 인해 객체 자체가 너무 커지는 경우가 있었습니다.
* 코드 재사용성이 떨어졌습니다.  

### ReactorKit

좋은 구조를 고민하던 중 코드스쿼드 마스터즈 코스에서 배운 단방향 아키텍처 Flux 를 떠올리게 되었습니다. Flux, Redux 를 iOS 개발에서 사용한 예시를 찾아보다 ReactorKit 을 적용하기로 결심하였습니다. 결심하게 된 계기는 다음과 같습니다.

* 많은 기업에서 사용중인 점이 인상적이었습니다.
* 문서화가 잘 되어 있었기 때문에 단방향 아키텍처를 체험해보기 좋다고 생각하였습니다.
* RxSwift 에 대한 의존성을 가지고 있기 때문에 필연적으로 RxSwift 를 적용해야 합니다. RxSwift 는 여러번 사용해 본 경험이 있습니다. 

```none
┌──────────────────┐   1:N    ┌───────────┐   1:N    ┌─────────┐    CRUD    ┌──────────────────┐
│  ViewController  | ───────▶ |  Reactor  | ───────▶ |  Model  | ◀────────▶ |    Persistent    |
└────────┬─────────┘          └─────┬─────┘          └────┬────┘            |                  |
         |       ▲                  |              Mutate |                 |    AWS Server    |
   ┌─────┴─────┐ |    Bind      ┌───┴───┐          Reduce |                 |   (issue Data)   |
   | @IBOutlet | └───────────── | State | ◀───────────────┘                 |                  |
   └───────────┘   (Reactive)   └───┬───┘             (Reactive)            |    Core Data     |
        ...                         |                                       |  (Setting Data)  |
                             ┌──────▼──────┐                                └──────────────────┘
                             |  Entity(s)  |
                             └─────────────┘
                                   ...
```

물론 프로젝트 전체를 단방향 패턴인 ReactorKit 으로 프로젝트 구조를 전부 변경하는 것은 굉장히 많은 작업량을 소모하게 됩니다. 하지만 반드시 해야 할 일이라고 생각했습니다.

Technical Debt (기술 부채) 라는 말을 들은 적이 있습니다. 제가 이해한 바로는 "현 시점의 Task 에 대해 쉬운 솔루션을 택하는 대신 나중에 기술적으로 해결해야 될 요소로 남겨두는 것" 을 뜻하는 것으로 이해하고 있습니다.

즉, MVC 로 진 빚을 갚을 때가 된 것입니다.

<image style="width: 40%" src="https://user-images.githubusercontent.com/65931336/230533382-127372dc-31a9-4e37-b9ab-b2ac1de40858.jpg" alt="Commit Histories"/>

이러한 과정을 통해 다음의 효과를 얻을 수 있었습니다.

* 더욱 Testable 한 코드 작성이 가능해졌습니다.
* 유지보수 비용이 많이 절감되었습니다. 여러 개의 화면을 만드는 상황에도 비슷한 로직으로 기능 구현을 할 수 있었기 때문입니다.
* 객체의 역할이 더욱 명확해져서 추상화가 용이해 졌습니다. 많은 Duplicate 를 제거할 수 있었습니다.

## 👨‍🎨 SnapKit + FlexLayout

### SnapKit

UILabel 처럼 컨텐츠 크기에 따라 뷰의 레이아웃이 변경되는 경우 SnapKit 을 통한 AutoLayout 을 정의해 놓을 시 Dynamic 한 뷰를 작성하는 것이 굉장히 용이합니다. 

```swift
func makeUI() {
  contentView.addSubview(titleLabel)
  contentView.addSubview(valueSwitch)
  
  titleLabel.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.defaultLow.rawValue
  titleLabel.snp.makeConstraints { make in
    make.leading.equalToSuperview().offset(20)
    make.top.equalToSuperview().offset(8)
    make.bottom.equalToSuperview().inset(8)
  }
}
```

### FlexLayout

고정된 크기와 높이를 가진 UITableViewCell 은 내부를 Frame-Based UI 로 구성하는 것이 유지보수 및 가독성 측면에서 유리합니다.

```swift
final class IssueListTableViewCell: MainListTableViewCell {
  override func makeUI() {
    super.makeUI()

    let isBigSizeScreen = ["13","12","11","X"].reduce(
      false, 
      {
        $0 || (UIDevice.modelName.contains($1)) 
      }
    )

    let padding: CGFloat = isBigSizeScreen ? 4 : 2
    contentsLabel.numberOfLines = isBigSizeScreen ? 3 : 2

    [titleLabel, dateLabel, contentsLabel].forEach({ label in 
      label.textAlignment = .natural
    })

    contentView.flex.paddingVertical(padding).define { contentsFlex in
      contentsFlex.addItem(paddingView).padding(padding).define { flex in
        flex.addItem().direction(.row).height(50%)
          .marginHorizontal(padding).define { flex in
            flex.addItem().width(65%).define { flex in
              flex.addItem(titleLabel).height(75%)
              flex.addItem(dateLabel).height(25%)
            }
            flex.addItem(profileView)
              .width(35%)
              .paddingTop(padding).paddingHorizontal(padding)
              .justifyContent(.center)
          }
      
        flex.addItem(contentsLabel).height(50%)
          .marginHorizontal(padding)
      }
    }
  }
}
```

### SnapKit+FlexLayout

UIScrollView 를 superview 와 일치시키는 것은 SnapKit 을 이용하고, subview 에 Grid Layout 을 구성하는 것은 FlexLayout 으로 간편히 적용할 수 있었습니다.

FlexLayout 은 AutoLayout 이 적용된 superview 를 기반으로 정의하였기 때문에 viewDidApplear(_:) 내에서 레이아웃 되도록 하였습니다.

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  
  emailArea.textField?.isUserInteractionEnabled = false
  emailArea.textField?.backgroundColor = .lightGray
  
  view.addSubview(_containerView)
  
  _containerView.flex.alignContent(.stretch).paddingHorizontal(padding).define { flex in
    flex.addItem(titleLabel).height(60)
    flex.addItem().define { flex in
      flex.addItem(emailArea)
      flex.addItem(nicknameArea)
    }
    flex.addItem(acceptButton).height(60)
  }
  
  _containerView.snp.makeConstraints { make in
    make.edges.equalTo(view.safeAreaInsets)
  }
  
  _containerView.layoutIfNeeded()
  _containerView.flex.layout()
  _containerView.reloadContentSizeHeight()
  
  acceptButton.setCornerRadius()
}
```

## 🧪 UI+Unit Test 작성 요령

<p>
    <image src="https://user-images.githubusercontent.com/65931336/191487494-0c2a5152-9454-46bb-8f73-bf3e01222d94.gif" alt="SignIn-Login-DetailView-UITest"/>
    <em>UI-Test 로 회원가입 후 로그인하여 데이터 출력되는지 확인하는 중</em>
</p>

### 프로젝트 내 테스트 작성 원칙

* Unit-Test
  1. 모든 Model, Reactor 클래스는 테스트 대상으로서 분류합니다.
  2. Unit-Test 를 진행하는 이유는 버그율 감소, Model 동작 여부 확인 후 View/Controller 개발에 집중하기 위함입니다.
  3. Stress 테스트 등을 진행하지는 않고, 기능 동작 여부만을 미리 테스트합니다.

* UI-Test
  1. Visible-Test(UI 가 의도한 대로 렌더링 되는가), Function-Test(UI 에 대한 Response 가 의도한 대로인가) 를 진행합니다.
  2. ViewController 를 초기화하는 것이 아닌, UIApplication 을 동작시켜서 테스트를 진행합니다.
  3. UI-Test 를 진행하는 이유는 시뮬레이터 실행 빈도를 줄이고 빠르게 테스트를 진행하는 것입니다.
  4. 각 Test-Case 당 테스트를 실행시키는 것이 아닌 사용자의 Scenario 를 진행시키도록 합니다.

### 테스트 관련 개선사항

1. Test-Coverage 가 증가해야 합니다.
2. UI 테스트의 UI 요소를 식별하는 기준으로 staticText 는 적합하지 않습니다. 현재 고려하고 있는 후보는 다국어 적용 시 사용될 키 값입니다.
3. Unit 테스트의 Unit 에 대한 정의를 다시 내릴 필요가 있습니다. 추상화된 객체만 테스트하는 것으로 충분하다면 구체 타입의 클래스들은 Unit-Test 의 Target 으로 정의될 필요가 없습니다.

## Technical Challenge

### Localization

> 다음의 블로그 게시글([[Medium]iOS에서 언어를 localization하는 Gorgeous 한 방법](https://trilliwon.medium.com/ios%EC%97%90%EC%84%9C-localization%ED%95%98%EB%8A%94-gorgeous-%ED%95%9C-%EB%B0%A9%EB%B2%95-f82ac29d2cfe))을 참고하였습니다

Issue 를 단순히 나열하는 것과 달리 설정 기능의 항목들은 다국어(Localization) 적용이 필요하였습니다. 

Localizable.strings 파일을 통해 정적인 객체를 만든다는 아이디어가 Human Error 를 줄일 수 있을 것이라고 생각하였습니다

하지만 새로운 기술 구현에 따른 부담 말고도 설정 목록을 저장함에 있어 Trade-Off 이슈가 발생하였습니다

- Localization 된 문자열을 저장 → 국가 설정을 바꾸면 대응 불가, 문자열을 불러올 때 Logic 추가 불필요
- Localization 에 필요한 키 값을 저장 → 국가 설정을 바꿔도 대응 가능, 문자열을 불러올 때 Localization 설정을 적용할 Logic 필요

고민 끝에 Localized 된 문자열을 저장하기로 하였습니다. 개발 과정에서 하나의 이슈라도 줄일 수 있다면 미리 진행하는 것이 기술 부채를 줄이는 길이라고 생각하였습니다.

개발을 비롯한 IT 엔지니어링에는 수많은 Trade-Off 가 항상 따른다는 점을 배웠습니다.

### Universal Link

> 유니버설 링크로 구현된 앱 링크는 다음과 같습니다.
> - https://back.issue-tracker.link/openApp

유니버설 링크는 특히 Back-End 개발자와의 협업이 중요하였습니다.

Back-End 개발자분들께 협업을 요청드렸을 때 “재미있어 보이니 한번 해보자” 라고 답변 주셔서 감사히도 진행이 가능하였습니다. Front-End 개발자 분들은 기능을 하나 더 추가할 수 있어서 테스트에 적극 참여해주셨습니다.

Back-End 개발자분들께는 요청드린 사항은 다음과 같습니다.

1. AASA 파일 업로드
2. AASA 파일을 정해진 URL 로 다운로드 받을 수 있도록 기능 추가
3. https 적용

이는 많은 작업을 요구하기 때문에 프로젝트를 세팅한 후 아래의 과정을 통해 자체 테스트를 진행했습니다.

1. Firebase Dynamic Link 를 통해 앱 링크를 생성([https://sanghwiback.page.link/openApp](https://sanghwiback.page.link/openApp))
2. Issue-tracker 프로젝트 Universal Link 기능 추가 → 앱 실행 성공
3. Test-Flight 에 앱 배포 후 이메일로  링크 테스트 → 앱 실행 성공

여기까지 진행해보니 Back-End 개발자 분들께 작업 요청을 드려도 괜찮겠다고 판단하여 작업 요청을 드리고 기능 구현은 성공적이었습니다.

많은 블로그에서 Universal Link 가 예기치 못한 이슈들을 발생시키는 것을 확인하였습니다(예: 애플 CDN 서버 캐싱 문제 등).

이번 사례를 단순히 기능 구현 성공에만 한정짓고 싶지는 않습니다. 다른 팀과 협업을 해야 할 때 어떠한 자세로 협업하는 것이 도움이 되는지 배웠습니다.
