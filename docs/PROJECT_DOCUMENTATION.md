# VROOM 프로젝트 문서

## 1. 프로젝트 개요

VROOM은 동네 기반 심부름 중개 플랫폼이다. 사용자는 심부름을 등록하고, 부리미는 등록된 심부름에 지원해 채팅으로 조건을 확인한 뒤 수행한다. 서비스는 일반 사용자, 부리미, 관리자 역할을 분리하며 심부름 등록, 매칭, 채팅, 완료 인증, 리뷰, 정산, 커뮤니티, 신고/공지 관리까지 포함한다.

### 핵심 목표

- 지역 기반 심부름 게시 및 탐색
- 사용자와 부리미 간 실시간 채팅 기반 매칭
- VroomPay 지갑을 통한 충전, 출금, 결제 보류, 정산 처리
- 커뮤니티 게시글, 댓글, 좋아요 기능 제공
- 관리자 페이지를 통한 회원, 부리미 승인, 심부름, 이슈, 정산, 공지 관리
- 정산 대상 자동 처리 배치 운영

## 2. 사용자 역할

| 역할 | 설명 | 주요 기능 |
| --- | --- | --- |
| 비회원 | 로그인 전 사용자 | 메인 화면, 공개 게시글/공지 일부 조회 |
| 일반 사용자 | 심부름 요청자 | 회원가입/로그인, 심부름 등록, 채팅, 결제, 완료 확인, 리뷰, 커뮤니티, 신고 |
| 부리미 | 심부름 수행자 | 부리미 등록/승인, 심부름 매칭, 채팅, 완료 인증 업로드, 수익/리뷰 조회 |
| 관리자 | 서비스 운영자 | 대시보드, 회원 관리, 부리미 승인, 심부름 배정, 이슈/공지/정산 관리 |

## 3. 기술 스택

### Backend

| 영역 | 기술 |
| --- | --- |
| Language | Java 11 |
| Framework | Spring Framework 5.2.25, Spring MVC |
| View | JSP, JSTL |
| Build | Maven, WAR packaging |
| Persistence | MyBatis, MyBatis-Spring |
| Database | MariaDB |
| Connection Pool | HikariCP |
| Transaction | Spring Transaction |
| Realtime | Spring WebSocket, STOMP, SockJS |
| Batch | Spring Batch 4.3.10 |
| File Upload | Commons FileUpload, AWS S3 SDK |
| JSON | Jackson Databind |
| Logging | SLF4J, Log4j, log4jdbc |
| Test Dependency | JUnit, Spring Test, Mockito |

### Frontend

| 영역 | 기술 |
| --- | --- |
| Template | JSP |
| Styling | CSS |
| Client Logic | JavaScript, Fetch/AJAX |
| Static Assets | `/static/**` 리소스 매핑 |

### External / Integration

| 영역 | 설명 |
| --- | --- |
| Kakao OAuth | 카카오 로그인 및 추가 회원가입 플로우 |
| AWS S3 | 심부름/커뮤니티/부리미 서류 등 이미지 및 파일 업로드 |
| VroomPay | 지갑 계좌 생성, 충전, 출금, 결제 보류, 정산 |

## 4. 프로젝트 구조

```text
VROOM
├─ pom.xml
├─ src/main/java/com/gorani/vroom
│  ├─ admin
│  │  ├─ auth              # 관리자 로그인/로그아웃
│  │  ├─ dashboard         # 관리자 통계 대시보드
│  │  ├─ errand            # 관리자 심부름 관리/배정
│  │  ├─ erranders         # 부리미 승인/상태/메모 관리
│  │  ├─ issue             # 신고/이슈 관리
│  │  ├─ notice            # 공지 관리
│  │  ├─ settlement        # 정산 관리
│  │  └─ users             # 사용자 관리
│  ├─ batch                # 정산 배치 Job, Step, Scheduler
│  ├─ common/util          # S3 업로드, 예외 처리, 관리자 인터셉터 등 공통 유틸
│  ├─ config               # MVC, WebSocket, S3, Encoding 설정
│  ├─ community            # 커뮤니티 게시글/댓글/좋아요
│  ├─ errand
│  │  ├─ assignment        # 매칭, 관리자 배정, 완료 인증
│  │  ├─ chat              # 채팅방, 메시지, 상태 변경
│  │  ├─ chat/ws           # STOMP 메시지 처리
│  │  ├─ post              # 심부름 게시글 등록/목록/상세
│  │  └─ review            # 완료 후 리뷰
│  ├─ errander
│  │  ├─ activity          # 부리미 활동/수익 조회
│  │  └─ profile           # 부리미 등록/프로필/리뷰/정산 요약
│  ├─ location             # 법정동/지역 조회
│  ├─ main                 # 메인 화면 데이터
│  ├─ notification         # 알림 목록/읽음 처리
│  ├─ user
│  │  ├─ auth              # 회원가입, 로그인, 카카오 OAuth
│  │  ├─ activity          # 사용자 활동 VO
│  │  └─ profile           # 마이페이지, 프로필, 신고, 회원탈퇴
│  └─ vroompay             # 지갑, 결제 주문, 충전/출금/정산 연동
├─ src/main/resources
│  ├─ com/gorani/vroom/**  # MyBatis Mapper XML
│  ├─ application.properties
│  ├─ db.properties
│  ├─ log4j.xml
│  └─ log4jdbc.log4j2.properties
└─ src/main/webapp
   ├─ WEB-INF
   │  ├─ spring            # root-context.xml, servlet-context.xml
   │  ├─ views             # JSP 화면
   │  └─ web.xml
   └─ static               # CSS, JS, image
```

## 5. 애플리케이션 아키텍처

```text
Browser
  ├─ JSP 화면 요청
  ├─ Fetch/AJAX API 호출
  └─ STOMP WebSocket 메시지
       ↓
Spring MVC Controller / RestController
       ↓
Service
       ↓
MyBatis Mapper Interface
       ↓
Mapper XML SQL
       ↓
MariaDB

파일 업로드: Controller → S3UploadService → AWS S3
실시간 채팅: Client → /ws SockJS/STOMP → /app/chat.send → /topic/room.{roomId}
정산 배치: Scheduler → Spring Batch Job → VroomPay 정산 API → DB 상태 갱신
```

## 6. 주요 기능

### 6.1 인증 및 사용자

- 일반 회원가입, 로그인, 로그아웃
- 이메일, 전화번호, 닉네임 중복 검사
- 카카오 OAuth 로그인
- OAuth 사용자가 추가 정보 입력 후 최종 가입하는 플로우
- 세션 키 `loginSess`를 기준으로 로그인 사용자 식별
- `viewMode`, `role` 값을 활용한 사용자/부리미 전환

### 6.2 심부름 게시

- 심부름 목록 조회
- 검색어, 카테고리, 동 코드, 정렬, 페이지 필터링
- 심부름 상세 조회
- 관련 심부름 추천
- 로그인 사용자만 심부름 등록 가능
- 심부름 등록 시 보유 VroomPay 가용 잔액 검사
- 이미지 파일은 S3에 업로드하고 URL을 DB에 저장

### 6.3 매칭 및 채팅

- 부리미가 채팅 시작 시 심부름 상태를 `WAITING`에서 매칭 상태로 전환
- 이미 다른 부리미가 매칭된 심부름은 접근 차단
- 작성자와 매칭된 부리미만 채팅방 접근 가능
- REST API와 STOMP WebSocket을 함께 사용
- 작성자는 부리미 요청을 수락/거절할 수 있음
- 부리미는 완료 증빙 파일을 업로드할 수 있음
- 작성자는 완료 확인 및 리뷰를 등록할 수 있음

### 6.4 VroomPay

- 지갑 계좌 연결
- 지갑 상태 조회
- 충전/출금
- 거래 내역 페이지네이션 조회
- 심부름 결제 주문 생성 및 금액 보류
- 심부름 완료 후 정산 API 호출
- 로컬 DB 지갑 계좌 및 거래 내역 동기화

### 6.5 부리미

- 부리미 등록 신청
- 신분증/통장 사본 등 승인 서류 S3 업로드
- 승인 상태 확인
- 승인 완료 시 부리미 역할 전환 가능
- 부리미 프로필, 수익 요약, 리뷰 목록 조회
- 일별 수익 및 일별 수행 내역 조회

### 6.6 커뮤니티

- 지역/카테고리/검색어 기반 게시글 목록
- 게시글 상세, 조회수 증가
- 게시글 작성/수정/삭제
- 게시글 이미지 S3 업로드
- 댓글 작성/수정/삭제
- 좋아요 토글
- 주변 인기글 조회

### 6.7 알림

- 읽지 않은 알림 수 조회
- 내 알림 목록 조회
- 알림 읽음 처리

### 6.8 관리자

- 관리자 로그인/로그아웃
- 관리자 경로 인터셉터 적용
- 대시보드 통계 조회
- 회원 검색 및 상태 변경
- 부리미 승인/반려, 활성 상태 변경, 상세 정보 조회, 관리자 메모 저장
- 심부름 검색, 상세/이력 조회, 수동 부리미 배정
- 신고/이슈 검색 및 우선순위 변경
- 공지 등록/수정/삭제/공개 목록 조회
- 정산 목록/상세 조회 및 정산 처리

### 6.9 정산 배치

- Spring Batch 기반 `settlementJob`
- `MyBatisPagingItemReader`로 정산 대상 조회
- `ItemProcessor`에서 VroomPay 정산 API 호출
- `CompositeItemWriter`로 심부름 상태, 배정 상태, 이력 저장
- 스케줄러는 매일 `02:45`에 실행
- 완료 확인 후 8일이 지난 정산 대상을 처리하도록 구성

## 7. 설정 및 인프라

### 7.1 Spring 설정

- `web.xml`에서 `DispatcherServlet`을 `/`에 매핑
- Java Config 기반 `MvcConfig`를 DispatcherServlet 컨텍스트로 사용
- `root-context.xml`에서 DB, MyBatis, 트랜잭션, RestTemplate 설정
- `MvcConfig`에서 컴포넌트 스캔, JSP ViewResolver, 정적 리소스, 업로드 경로, 인터셉터, MultipartResolver 설정

### 7.2 DB 및 MyBatis

- HikariCP DataSource 사용
- DB 설정 값은 `db.properties`에서 로드
- Mapper XML 경로는 `classpath*:/com/gorani/vroom/**/*.xml`
- `mapUnderscoreToCamelCase=true` 설정
- `@Mapper` 인터페이스를 `com.gorani.vroom` 하위에서 스캔

### 7.3 정적 리소스와 업로드

| URL | 매핑 |
| --- | --- |
| `/static/**` | `/static/` |
| `/uploads/profile/**` | `C:/uploads/profile/` |
| `/uploads/errand/**` | `C:/uploads/errand/` |
| `/uploads/community/**` | `C:/uploads/community/` |
| `/uploads/erranderDocs/**` | `C:/uploads/erranderDocs/` |
| `/uploads/proof/**` | `D:/vroom_uploads/proof/` |

현재 주요 업로드 기능은 `S3UploadService`를 통해 AWS S3 URL을 반환하는 방식으로 구현되어 있다.

### 7.4 WebSocket

- 엔드포인트: `/ws`
- SockJS fallback 사용
- Client publish prefix: `/app`
- Broker subscribe prefix: `/topic`
- 채팅 발행: `/app/chat.send`
- 채팅 구독: `/topic/room.{roomId}`

## 8. 기술적으로 구현한 주요 포인트

아래 항목은 프로젝트에서 기술적으로 설명하거나 포트폴리오에 어필하기 좋은 구현 포인트다. 실제 담당 범위가 정해져 있다면 이 섹션에서 본인이 수행한 항목만 남기면 된다.

### 8.1 Spring MVC 기반 역할별 모듈 설계

- 기능별 패키지 분리: `user`, `errand`, `errander`, `admin`, `community`, `vroompay`
- Controller, Service, Mapper, VO 계층을 분리해 유지보수성을 확보
- JSP 화면 요청과 JSON API 요청을 같은 도메인 안에서 역할에 맞게 분리

### 8.2 세션 기반 인증/인가 흐름

- `loginSess` 세션을 기준으로 로그인 여부 확인
- 사용자 역할 값을 통해 일반 사용자와 부리미 모드를 전환
- 관리자 페이지는 `AdminLoginInterceptor`로 보호
- 각 API에서 로그인 여부와 권한을 직접 검증

### 8.3 실시간 채팅 및 매칭

- Spring WebSocket + STOMP + SockJS 구성
- 채팅 메시지를 DB에 저장한 뒤 `/topic/room.{roomId}`로 브로드캐스트
- 채팅방 접근 권한을 `roomId`, `userId`, 사용자 역할 기준으로 검증
- 심부름 상태와 채팅방 상태를 연동해 중복 매칭을 방지

### 8.4 결제/정산 흐름

- 심부름 등록 전 VroomPay 가용 잔액 검사
- 결제 주문 생성 시 `merchantUid`를 생성하고 금액을 보류
- 충전/출금 성공 시 지갑 거래 내역과 잔액 정보를 로컬 DB에 반영
- 완료 확인 이후 정산 대상이 배치로 처리되도록 구성

### 8.5 파일 업로드

- 심부름 이미지, 커뮤니티 이미지, 부리미 제출 서류를 Multipart로 수신
- UUID 기반 파일명 생성
- AWS S3 업로드 후 접근 가능한 URL을 반환
- 업로드 대상 디렉터리를 `errand`, `community`, `documents` 등으로 구분

### 8.6 관리자 운영 기능

- 대시보드 통계 API 제공
- 회원/부리미/심부름/신고/정산/공지 도메인별 운영 화면 구성
- 부리미 승인/반려 및 관리자 메모 저장
- 관리자 수동 심부름 배정 API 구현

### 8.7 Spring Batch 정산 자동화

- `Reader → Processor → Writer` 구조로 정산 배치 구성
- MyBatis 기반 페이징 Reader와 Batch Writer 사용
- 정산 API 성공 건만 상태 변경과 이력 저장을 수행
- Cron 스케줄 기반 자동 실행

## 9. 주요 상태값

코드에서 확인되는 대표 상태값은 다음과 같다.

### 심부름 상태

| 상태 | 의미 |
| --- | --- |
| `WAITING` | 매칭 대기 |
| `MATCHED` | 부리미 매칭/채팅 진행 |
| `CONFIRMED1` | 작성자가 부리미 수락 |
| `CONFIRMED2` | 완료 확인 |
| `COMPLETED` | 정산 완료 |

### 부리미 승인 상태

| 상태 | 의미 |
| --- | --- |
| `PENDING` | 승인 대기 |
| `APPROVED` | 승인 완료 |
| `REJECTED` | 반려 |

### 거래 유형

| 유형 | 의미 |
| --- | --- |
| `CHARGE` | 충전 |
| `WITHDRAW` | 출금 |

## 10. 실행 및 배포 참고

이 프로젝트는 WAR 패키징을 사용하는 Spring MVC 프로젝트다.

```bash
./mvnw clean package
```

Windows 환경에서는 다음 명령을 사용할 수 있다.

```bat
mvnw.cmd clean package
```

실행에는 다음 외부 설정이 필요하다.

- MariaDB 접속 정보: `db.properties`
- Kakao OAuth 설정: `application.properties`
- AWS S3 접근 키, 시크릿 키, 리전, 버킷: `application.properties`
- VroomPay 연동 설정: 서비스 구현에서 사용하는 외부 API 설정

## 11. 문서 유지보수 기준

- Controller에 엔드포인트를 추가하면 `docs/API_SPECIFICATION.md`를 함께 수정한다.
- DB 테이블 또는 Mapper XML이 변경되면 관련 도메인 설명을 갱신한다.
- 상태값이 추가되면 상태값 표와 관리자/배치 설명을 함께 수정한다.
- 외부 연동 설정 키가 추가되면 실행 및 배포 참고 섹션을 갱신한다.
