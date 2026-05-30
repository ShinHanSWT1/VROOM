# VROOM API 명세서

## 1. 공통 규칙

### Base URL

```text
http://{host}:{port}
```

### 인증 방식

현재 프로젝트는 세션 기반 인증을 사용한다.

| 세션 키 | 설명 |
| --- | --- |
| `loginSess` | 일반 사용자/부리미 로그인 정보 |
| `viewMode` | 현재 화면 모드 |
| `loginAdmin` | 관리자 로그인 정보 |

로그인이 필요한 API에서 세션이 없으면 `401`, 실패 응답 Map, 빈 목록, 또는 로그인 페이지 redirect가 반환된다. 컨트롤러별 구현 방식이 다르므로 각 API의 응답 형식을 참고한다.

### 공통 응답 패턴

JSON API는 주로 아래 형태를 사용한다.

```json
{
  "success": true,
  "message": "처리 결과 메시지",
  "data": {}
}
```

일부 API는 `ResponseEntity`, `Map`, `List`, VO 객체를 직접 반환한다.

### 주요 HTTP 상태

| 상태 코드 | 의미 |
| --- | --- |
| `200 OK` | 정상 처리 |
| `201 Created` | 생성 성공 |
| `400 Bad Request` | 요청 값 오류 |
| `401 Unauthorized` | 로그인 필요 |
| `403 Forbidden` | 권한 없음 |
| `409 Conflict` | 이미 매칭됨 등 상태 충돌 |
| `500 Internal Server Error` | 서버 오류 |

## 2. 인증 API

### 2.1 회원가입 화면

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/auth/signup` |
| Auth | 불필요 |
| Response | `user/signup` JSP |

### 2.2 회원가입 처리

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/auth/signup` |
| Content-Type | `multipart/form-data` |
| Auth | 불필요 |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `UserVO` fields | form | Y | 이메일, 비밀번호, 닉네임 등 회원 정보 |
| `profile` | file | N | 프로필 이미지 |

Response

```json
{
  "success": true,
  "message": "회원가입 완료"
}
```

### 2.3 로그인 화면

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/auth/login` |
| Response | `user/login` JSP |

### 2.4 로그인 처리

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/auth/login` |
| Content-Type | `application/x-www-form-urlencoded` |
| Response | `common/return` JSP |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `email` | string | Y | 이메일 |
| `password` | string | Y | 비밀번호 |

성공 시 세션에 `loginSess`, `viewMode=USER` 저장.

### 2.5 로그아웃

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/auth/logout` |
| Auth | 필요 |
| Response | `common/return` JSP |

### 2.6 중복 검사

| Method | URL | Query | Response |
| --- | --- | --- | --- |
| `GET` | `/auth/check-email` | `email` | `boolean` |
| `GET` | `/auth/check-phone` | `phone` | `boolean` |
| `GET` | `/auth/check-nickname` | `nickname` | `boolean` |

### 2.7 카카오 로그인

| Method | URL | 설명 |
| --- | --- | --- |
| `GET` | `/auth/kakao/login` | 카카오 인증 URL로 redirect |
| `GET` | `/auth/kakao/callback?code={code}` | 인가 코드 처리 후 로그인 또는 추가 가입 페이지로 redirect |

## 3. 메인/지역 API

### 3.1 메인 심부름 목록

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/api/main/errands` |
| Query | `guName` optional |
| Response | `List<ErrandListVO>` |

### 3.2 메인 인기 커뮤니티 글

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/api/main/posts` |
| Query | `guName` optional |
| Response | `List<CommunityPostVO>` |

### 3.3 구/군 기준 동 목록

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/location/getDongs` |
| Query | `gunguName` required |
| Response | `List<LegalDongVO>` |

## 4. 심부름 API

### 4.1 심부름 목록 화면

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/errand/list` |
| Response | `errand/errand_list` JSP |

Query

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `q` | string | N | 검색어 |
| `categoryId` | number | N | 카테고리 ID |
| `dongCode` | string | N | 법정동 코드 |
| `sort` | string | N | 정렬 조건 |
| `page` | number | N | 기본값 `1` |

### 4.2 심부름 상세 화면

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/errand/detail` |
| Query | `errandsId` required |
| Response | `errand/errand_detail` JSP |

### 4.3 심부름 작성 화면

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/errand/create` |
| Auth | 사용자 로그인 필요 |
| Query | `dongCode` optional |
| Response | `errand/errand_create` JSP |

### 4.4 심부름 작성 처리

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/create` |
| Auth | 사용자 로그인 필요 |
| Content-Type | `multipart/form-data` |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `ErrandCreateVO` fields | form | Y | 제목, 내용, 금액, 지역, 카테고리 등 |
| `imageFiles` | file[] | N | 심부름 이미지 |

처리

- 로그인 사용자 ID를 `userId`로 설정
- VroomPay 가용 잔액이 보상금+비용보다 적으면 `/member/vroomPay`로 redirect
- 이미지 파일은 S3 업로드 후 저장

Response

```text
redirect:/errand/detail?errandsId={errandsId}
```

## 5. 심부름 매칭/채팅 API

### 5.1 채팅 시작 요청

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/assign/request` |
| Auth | 부리미 로그인 필요 |
| Content-Type | `application/x-www-form-urlencoded` |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `errandsId` | number | Y | 심부름 ID |

Response

```text
redirect:/errand/chat/room?roomId={roomId}
```

### 5.2 완료 증빙 업로드

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/chat/assign/complete-proof` |
| Auth | 로그인 필요 |
| Content-Type | `multipart/form-data` |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `errandsId` | number | Y | 심부름 ID |
| `roomId` | number | Y | 채팅방 ID |
| `file` | file | Y | 완료 증빙 파일 |

Response

```json
{
  "success": true,
  "imageUrl": "https://..."
}
```

### 5.3 채팅방 화면

| Method | URL | Query | Response |
| --- | --- | --- | --- |
| `GET` | `/errand/chat` | `errandsId` | `errand/errand_chat` JSP 또는 redirect |
| `GET` | `/errand/chat/room` | `roomId` | `errand/errand_chat` JSP |
| `GET` | `/errand/chat/enter` | `errandsId` | 채팅방 redirect |

### 5.4 메시지 전송 REST

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/chat/send` |
| Auth | 로그인 필요 |
| Content-Type | `application/json` |

Request

```json
{
  "roomId": 1,
  "content": "메시지 내용",
  "messageType": "TEXT"
}
```

Response

```json
{
  "success": true,
  "message": {}
}
```

### 5.5 메시지 목록 조회

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/errand/chat/messages` |
| Auth | 로그인 필요 |
| Query | `roomId` required |

Response

```json
{
  "success": true,
  "messages": []
}
```

### 5.6 심부름 수락

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/chat/accept` |
| Auth | 작성자 권한 필요 |
| Content-Type | `application/json` |

Request

```json
{
  "errandsId": 1,
  "roomId": 10
}
```

Response

```json
{
  "success": true,
  "message": "accepted"
}
```

STOMP broadcast

```json
{
  "messageType": "STATUS",
  "status": "CONFIRMED1",
  "errandsId": 1,
  "roomId": 10
}
```

### 5.7 심부름 거절

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/chat/reject` |
| Auth | 작성자 권한 필요 |
| Content-Type | `application/json` |

Request

```json
{
  "errandsId": 1,
  "roomId": 10,
  "erranderUserId": 2
}
```

### 5.8 완료 확인

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/chat/assign/complete-confirm` |
| Auth | 작성자 권한 필요 |
| Content-Type | `application/json` |

Request

```json
{
  "errandsId": 1,
  "roomId": 10
}
```

Response

```json
{
  "success": true,
  "status": "CONFIRMED2"
}
```

### 5.9 리뷰 작성

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errand/chat/review` |
| Auth | 작성자 로그인 필요 |
| Content-Type | `application/x-www-form-urlencoded` |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `errandsId` | number | Y | 심부름 ID |
| `rating` | number | Y | 평점 |
| `comment` | string | N | 리뷰 내용 |

## 6. WebSocket API

### 6.1 연결

| 항목 | 내용 |
| --- | --- |
| Endpoint | `/ws` |
| Protocol | SockJS + STOMP |
| Publish Prefix | `/app` |
| Subscribe Prefix | `/topic` |

### 6.2 채팅 메시지 발행

| 항목 | 내용 |
| --- | --- |
| Client Send | `/app/chat.send` |
| Server Broadcast | `/topic/room.{roomId}` |

Payload

```json
{
  "roomId": 10,
  "senderUserId": 2,
  "messageType": "TEXT",
  "content": "안녕하세요"
}
```

서버는 채팅방 접근 권한을 확인하고 DB 저장 후 같은 방 구독자에게 메시지를 전송한다.

## 7. VroomPay API

### 7.1 지갑 상태 조회

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/api/vroompay/status` |
| Auth | 로그인 필요 |

Response

```json
{
  "success": true,
  "linked": true,
  "account": {}
}
```

### 7.2 지갑 계좌 생성/연결

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/api/vroompay/create` |
| Auth | 로그인 필요 |

성공 시 외부 VroomPay 계좌 정보를 로컬 `WALLET_ACCOUNTS`에 저장한다.

### 7.3 충전

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/api/vroompay/charge` |
| Auth | 로그인 필요 |
| Content-Type | `application/json` |

Request

```json
{
  "amount": 10000,
  "memo": "충전"
}
```

성공 시 `CHARGE` 거래 내역 저장 및 로컬 잔액 갱신.

### 7.4 출금

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/api/vroompay/withdraw` |
| Auth | 로그인 필요 |
| Content-Type | `application/json` |

Request

```json
{
  "amount": 10000,
  "memo": "출금"
}
```

검증

- 금액 필수
- 금액은 0보다 커야 함
- 현재 잔액보다 큰 금액 출금 불가

### 7.5 거래 내역

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/api/vroompay/transactions` |
| Auth | 로그인 필요 |
| Query | `page` default `1`, `size` default `10` |

Response

```json
{
  "success": true,
  "transactions": [],
  "totalCount": 0,
  "totalPages": 0,
  "currentPage": 1
}
```

### 7.6 결제 주문 생성

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/api/vroompay/payment/order` |
| Content-Type | `application/json` |

Request

```json
{
  "amount": 30000,
  "errandsId": 1,
  "userId": 5
}
```

처리

- `merchantUid = ORDERS_{errandsId}_{now}` 생성
- 결제 주문 생성 및 금액 보류 처리

### 7.7 테스트 정산

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/api/vroompay/test/settle` |
| 설명 | 개발/테스트용 수동 정산 호출 |

## 8. 사용자 프로필 API

### 8.1 내 프로필 조회

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/api/profile` | 로그인 필요 | `UserProfileVO` |

### 8.2 닉네임 수정

| Method | URL | Auth | Content-Type |
| --- | --- | --- | --- |
| `PUT` | `/api/profile/nickname` | 로그인 필요 | `application/json` |

Request

```json
{
  "nickname": "새닉네임"
}
```

### 8.3 프로필 이미지 수정

| Method | URL | Auth | Content-Type |
| --- | --- | --- | --- |
| `POST` | `/api/profile/image` | 로그인 필요 | `multipart/form-data` |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `file` | file | Y | 이미지 파일 |

### 8.4 내가 요청한 심부름 목록

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/api/profile/errands` | 로그인 필요 | `List<ErrandsVO>` |

### 8.5 신고 등록

| Method | URL | Auth | Content-Type |
| --- | --- | --- | --- |
| `POST` | `/api/profile/report` | 로그인 필요 | `application/json` |

Request

```json
{
  "errandId": 1,
  "title": "신고 제목",
  "content": "신고 내용",
  "type": "ERRAND_ISSUE"
}
```

### 8.6 회원 탈퇴

| Method | URL | Auth | Content-Type |
| --- | --- | --- | --- |
| `POST` | `/api/profile/withdraw` | 로그인 필요 | `application/json` |

Request

```json
{
  "password": "password"
}
```

## 9. 부리미 API

### 9.1 부리미 화면

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/errander/mypage/profile` | 로그인 필요 | `errander/profile` JSP |
| `GET` | `/errander/mypage/activity` | 로그인 필요 | `errander/activity` JSP |
| `GET` | `/errander/mypage/pay` | 로그인 필요 | `errander/pay` JSP |
| `GET` | `/errander/mypage/settings` | 로그인 필요 | `errander/settings` JSP |
| `GET` | `/errander/mypage/activity_detail?id={id}` | 로그인 필요 | `errander/activity_detail` JSP |

### 9.2 부리미 등록 화면

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/errander/register` | 로그인 필요 | `errander/register` JSP |

### 9.3 부리미 등록 처리

| 항목 | 내용 |
| --- | --- |
| Method | `POST` |
| URL | `/errander/register` |
| Auth | 로그인 필요 |
| Content-Type | `multipart/form-data` |

Request

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| `ErranderProfileVO` fields | form | Y | 부리미 프로필 정보 |
| `idType` | string | Y | 신분증 종류 |
| `idFile` | file | Y | 신분증 파일 |
| `bankFile` | file | Y | 통장 사본 |

제약

- 각 파일 최대 10MB
- S3 `documents` 경로에 업로드
- 기존 반려 상태면 재신청 처리

### 9.4 부리미 등록/승인 상태 확인

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/errander/check` | 선택 | `{ isRegistered, approvalStatus, hasAccount }` |

### 9.5 부리미 모드 전환

| Method | URL | Auth | Query |
| --- | --- | --- | --- |
| `GET` | `/errander/switch` | 로그인 필요 | `returnUrl` optional |

승인 상태가 `APPROVED`이면 세션 사용자 role을 `ERRANDER`로 변경한다.

### 9.6 부리미 정산 요약

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/errander/api/pay/summary` | 로그인 필요 | `{ settlementWaiting, expectedAmount, thisMonthSettled }` |

### 9.7 부리미 리뷰 목록

| Method | URL | Auth | Query |
| --- | --- | --- | --- |
| `GET` | `/errander/api/reviews` | 로그인 필요 | `page` default `1`, `size` default `10` |

### 9.8 부리미 일별 수익

| Method | URL | Auth | Query |
| --- | --- | --- | --- |
| `GET` | `/errander/mypage/api/daily-earnings` | 로그인 필요 | `year`, `month` |

Response: `List<ErranderActivityVO>`

### 9.9 부리미 일별 상세

| Method | URL | Auth | Query |
| --- | --- | --- | --- |
| `GET` | `/errander/mypage/api/daily-detail` | 로그인 필요 | `date` |

Response: `List<ErrandListVO>`

## 10. 커뮤니티 API

### 10.1 커뮤니티 목록 화면

| Method | URL | Query | Response |
| --- | --- | --- | --- |
| `GET` | `/community` | `dongCode`, `categoryId`, `guName`, `searchKeyword`, `page` | `community/main` JSP |

### 10.2 커뮤니티 상세 화면

| Method | URL | Query | Response |
| --- | --- | --- | --- |
| `GET` | `/community/detail/{postId}` | `dongCode`, `categoryId`, `guName` optional | `community/detail` JSP |

### 10.3 게시글 페이지네이션

| Method | URL | Query | Response |
| --- | --- | --- | --- |
| `GET` | `/community/api/posts/pagination` | `dongCode`, `categoryId`, `searchKeyword`, `page` | `PaginationVO` |

### 10.4 댓글 목록

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/community/api/posts/{postId}/comments` | 선택 | `List<CommunityCommentVO>` |

### 10.5 댓글 작성

| Method | URL | Auth | Content-Type |
| --- | --- | --- | --- |
| `POST` | `/community/api/posts/{postId}/comments` | 로그인 필요 | `application/json` |

Request: `CommunityCommentVO`

성공: `201 Created`

### 10.6 댓글 수정

| Method | URL | Auth | Content-Type |
| --- | --- | --- | --- |
| `PUT` | `/community/api/comments/{commentId}` | 로그인 필요 | `application/json` |

Request

```json
{
  "content": "수정 댓글"
}
```

### 10.7 댓글 삭제

| Method | URL | Auth |
| --- | --- | --- |
| `DELETE` | `/community/api/comments/{commentId}` | 로그인 필요 |

### 10.8 좋아요 토글

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `POST` | `/community/api/posts/{postId}/like` | 로그인 필요 | `LikeResponseDTO` |

### 10.9 게시글 작성/수정/삭제

| Method | URL | Auth | 설명 |
| --- | --- | --- | --- |
| `GET` | `/community/write` | 로그인 필요 | 작성 화면 |
| `POST` | `/community/write` | 로그인 필요 | 게시글 작성, 이미지 S3 업로드 |
| `GET` | `/community/edit/{postId}` | 작성자 필요 | 수정 화면 |
| `POST` | `/community/edit/{postId}` | 작성자 필요 | 게시글 수정, 이미지 유지/추가 처리 |
| `POST` | `/community/delete/{postId}` | 작성자 필요 | 게시글 삭제 |

## 11. 알림 API

| Method | URL | Auth | Response |
| --- | --- | --- | --- |
| `GET` | `/api/notification/unread` | 로그인 필요 | 읽지 않은 알림 수 `int` |
| `GET` | `/api/notification/list` | 로그인 필요 | `{ list: [...] }` |
| `POST` | `/api/notification/read/{id}` | 로그인 필요 | `"success"` |

## 12. 관리자 API

관리자 화면 경로 `/admin/**`에는 관리자 로그인 인터셉터가 적용된다. `/admin/login`은 제외된다.

### 12.1 관리자 인증

| Method | URL | 설명 |
| --- | --- | --- |
| `GET` | `/admin/login` | 관리자 로그인 화면 |
| `POST` | `/admin/login` | 관리자 로그인 처리 |
| `GET` | `/admin/logout` | 관리자 로그아웃 |

### 12.2 대시보드

| Method | URL | 설명 |
| --- | --- | --- |
| `GET` | `/admin/dashboard` | 대시보드 화면 |
| `GET` | `/api/admin/dashboard/errand-status` | 심부름 상태 통계 |
| `GET` | `/api/admin/dashboard/errand-category` | 카테고리별 심부름 통계 |
| `GET` | `/api/admin/dashboard/errand-region` | 지역별 심부름 통계 |
| `GET` | `/api/admin/dashboard/errand-hourly-trend` | 시간대별 심부름 추이 |
| `GET` | `/api/admin/dashboard/issue-summary` | 이슈 요약 |
| `GET` | `/api/admin/dashboard/settlement-summary` | 정산 요약 |

### 12.3 회원 관리

| Method | URL | Query/Body | 설명 |
| --- | --- | --- | --- |
| `GET` | `/admin/users` | - | 회원 관리 화면 |
| `GET` | `/api/admin/users` | `keyword`, `status`, `role`, `reportCount`, `page` | 회원 검색 |
| `POST` | `/api/admin/users/status` | `{ userId, status }` | 회원 상태 변경 |
| `GET` | `/admin/users/detail` | `id` | 회원 상세 화면 |

### 12.4 부리미 관리

| Method | URL | Query/Body | 설명 |
| --- | --- | --- | --- |
| `GET` | `/admin/erranders` | - | 부리미 관리 화면 |
| `GET` | `/api/admin/erranders` | `keyword`, `approveStatus`, `activeStatus`, `reviewScope`, `page` | 부리미 검색 |
| `GET` | `/api/admin/erranders/resume` | `id` | 승인 요청 상세 |
| `POST` | `/api/admin/erranders/approve` | `{ erranderId, status, reason }` | 승인/반려 |
| `POST` | `/api/admin/erranders/status` | `{ erranderId, activeStatus }` | 활성 상태 변경 |
| `GET` | `/admin/erranders/detail/{id}` | path | 부리미 상세 화면 |
| `POST` | `/api/admin/erranders/detail` | `{ erranderId, limit }` | 상세 정보 조회 |
| `POST` | `/api/admin/erranders/savememo` | `{ erranderId, memo }` | 관리자 메모 저장 |

### 12.5 심부름 관리

| Method | URL | Query/Body | 설명 |
| --- | --- | --- | --- |
| `GET` | `/admin/errands` | - | 심부름 관리 화면 |
| `GET` | `/api/admin/errands/search` | `page`, `keyword`, `gu`, `dong`, `regStart`, `regEnd`, `dueStart`, `dueEnd`, `status` | 심부름 검색 |
| `GET` | `/api/admin/errands/detail` | `id` | 심부름 상세 및 이력 |
| `GET` | `/api/admin/erranders/employees` | - | 배정 가능한 부리미 목록 |
| `POST` | `/api/admin/errands/assign` | `{ errandId, erranderId, adminId, reason }` | 관리자 수동 배정 |

### 12.6 이슈 관리

| Method | URL | Query/Body | 설명 |
| --- | --- | --- | --- |
| `GET` | `/admin/issue` | - | 이슈 관리 화면 |
| `GET` | `/api/admin/issues/search` | `page`, `keyword`, `type`, `status`, `priority`, `regStart`, `regEnd` | 이슈 검색 |
| `POST` | `/api/admin/issues/priority` | `{ id, priority }` | 우선순위 변경 |

### 12.7 공지 관리

| Method | URL | Query/Body | 설명 |
| --- | --- | --- | --- |
| `GET` | `/admin/notice` | - | 공지 관리 화면 |
| `GET` | `/admin/api/notice/list` | `keyword`, `status`, `target` | 관리자 공지 목록 |
| `GET` | `/api/notice/published` | - | 공개 공지 목록 |
| `GET` | `/admin/api/notice/{id}` | path | 공지 상세 |
| `POST` | `/admin/api/notice` | `NoticeVO` | 공지 등록 |
| `PUT` | `/admin/api/notice/{id}` | `NoticeVO` | 공지 수정 |
| `DELETE` | `/admin/api/notice/{id}` | path | 공지 삭제 |

### 12.8 정산 관리

| Method | URL | Query/Body | 설명 |
| --- | --- | --- | --- |
| `GET` | `/admin/settlements` | - | 정산 관리 화면 |
| `GET` | `/api/admin/settlements` | `page`, `keyword`, `status`, `startDate`, `endDate` | 정산 목록 |
| `GET` | `/api/admin/settlements/{id}` | path | 정산 상세 |
| `POST` | `/api/admin/settlements/process` | `{ id, action, memo, amount }` | 정산 처리 |

## 13. 배치/테스트 API

### 13.1 정산 배치 수동 실행

| 항목 | 내용 |
| --- | --- |
| Method | `GET` |
| URL | `/test/batch/settlement` |
| 설명 | 정산 배치 수동 실행용 테스트 엔드포인트 |

## 14. 화면 라우팅 요약

| 영역 | 주요 URL |
| --- | --- |
| 메인 | `/` |
| 인증 | `/auth/signup`, `/auth/login`, `/auth/logout` |
| 사용자 마이페이지 | `/member/myInfo`, `/member/myActivity`, `/member/vroomPay`, `/member/edit` |
| 심부름 | `/errand/list`, `/errand/detail`, `/errand/create`, `/errand/chat` |
| 부리미 | `/errander/register`, `/errander/mypage/profile`, `/errander/mypage/activity`, `/errander/mypage/pay` |
| 커뮤니티 | `/community`, `/community/detail/{postId}`, `/community/write` |
| 관리자 | `/admin/login`, `/admin/dashboard`, `/admin/users`, `/admin/erranders`, `/admin/errands`, `/admin/issue`, `/admin/notice`, `/admin/settlements`, `/admin/settings` |
