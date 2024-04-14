# ToDoGeo 앱

## 프로젝트 소개
할 일과 알림을 받을 위치를 등록 후 등록된 위치 근처에 접근했을 때 알림을 받을 수 있는 앱

## 사용기술
### Clean Architecture
Data Layer
- Repository 구현부
  - 외부 Server나 DB로 데이터 요청
- Nerwork
  - 외부 Server와 통신 역할
- DTO
  - 외부로 부터 받은 데이터를 맵핑하는 객체
 
Domain Layer
- Entity
  - 비즈니스 로직에 필요한 model
- UseCase
  - 비즈니스 로직 수행
- Repository (protocol)
  - Data Layer와의 DIP를 적용

Presenter Layer
- Flow
  - UIViewController에서 화면 이동 로직을 분리하여 처리
- View
  - UI 노출
- Reactor
  - View의 로직을 처리

### ReactorKit
Preserter Layer에서 View의 로직을 게층화 시켜 로직을 처리하고 가독성을 높임

### RxFlow
화면 이동 로직을 수행
