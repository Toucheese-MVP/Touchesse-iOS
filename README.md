
# 📷 Touchesse-iOS
> **쉽고 빠르게 원하는 스튜디오를 예약하는 플랫폼 서비스**

<img src = "https://github.com/user-attachments/assets/761a5da6-5824-4de7-866b-b6e4a2be2cff" width="160" height="160" />  

***TOUCH*** 는 셔터 촬영의 순간과 플랫폼을 통해 검색하는 터치의 의미를, <br>
***CHEESE*** 는 촬영 시 모든 이들의 미소를 짓게 하는 마법 같은 의성어를 의미해요.

<br>

## 🧀 앱 특징
### 스튜디오 찾기
> 🔍 터치즈만의 차별화된 검색 기능으로 사용자가 원하는 스튜디오를 쉽게 찾을 수 있어요.

| 스튜디오 컨셉 선택 | 필터링 | 스튜디오 상세 |
|:-:|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/969d2675-1e3c-49b8-a1f2-7013b0474857" width="180" /> | <img src = "https://github.com/user-attachments/assets/db15ec09-862a-4582-99f0-12bb62b47afa" width="180" /> | <img src = "https://github.com/user-attachments/assets/60aa098c-2863-4b3c-8ca9-99c810dd5c97" width="180" /> |

<br>

### 스튜디오 예약
> 📝 원하는 스튜디오를 찾았다면 터치즈를 통해서 간편하게 예약을 할 수 있어요.

| 날짜 선택 | 예약 |
|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/92151fad-73f2-49bb-8b10-f023501059d5" width="180" /> | <img src = "https://github.com/user-attachments/assets/a3739376-9f24-4880-972f-2087faca875d" width="180" /> |

<br>

### 예약 일정 확인
> 🗓️ 예약 일정 및 상태를 확인하고, 원한다면 예약을 취소할 수 있어요.

| 예약 내역 확인 | 예약 취소 |
|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/e374a6e8-4e85-473f-9505-5ae469aee8e6" width="180" /> | <img src = "https://github.com/user-attachments/assets/fca89f69-168d-4a11-a6bf-5fe7a8740aca" width="180" /> |

<br>

### 문의하기
> ❣️ 언제든지 문의 작성이 가능해요, 사진도 등록할 수 있어요!

| 문의 작성 | 사진 등록 |
|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/bd5c81d3-6fa8-4f83-85e0-1cd659358818" width="180" /> | <img src = "https://github.com/user-attachments/assets/e1976267-4122-4797-a748-dc3e462f8cd6" width="180" /> |

<br>

### 개발 환경
- **Client**
  - Xcode 16.0
  - Swift 6.0
  - iOS 16.0+
  - SwiftUI
  - Portrait Only
  - LightMode Only
  - GitHub Actions와 Fastlane을 통한 TestFlight 배포 자동화
- **Database**
  - 서버: AWS EC2에서 Docker로 실행되는 Java 기반 Spring Boot 애플리케이션
  - 저장소: AWS RDS (MySQL) - 주 데이터베이스
  - Redis - 캐시 관리 (디바이스 토큰)
  - AWS S3 - 이미지 파일 스토리지
  - 알림: Firebase FCM을 통한 푸시 알림
  - 배포: GitHub Actions를 통한 CI/CD

### Library
| library | description | version |
| --- | --- | --- |
| **KakaoOpenSDK** | 카카오 로그인 | 2.23.0 |
| **Firebase** | Push 메세지 | 11.6.0 |
| **Alamofire** | 네트워크 작업 | 5.10.2 |
| **Kingfisher** | 이미지 캐싱 처리 | 8.1.3 |

<br>
