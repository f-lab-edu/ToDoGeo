# ToDoGeo 앱

## 프로젝트 소개
할 일과 알림을 받을 위치를 등록 후 등록된 위치 근처에 접근했을 때 알림을 받을 수 있는 앱

## 사용기술
![제목 없음-2024-05-07-1453](https://github.com/user-attachments/assets/f522e43b-f4e5-48c6-a8d8-574f8be0fd42)
### Clean Architecture
Data Layer
- Repository 구현부
  - 외부 Server나 DB로 데이터 요청
- Nerwork
  - 외부 Server와 통신 역할
  - 네트워크 시퀀스 다이어그램
<img width="1395" alt="image" src="https://github.com/f-lab-edu/ToDoGeo/assets/72551674/dd940c48-1eee-4a4e-bb43-bce7ba4a4da0">

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
