# 작업 일지 (4일, 총 18시간)

## 진행 요약 (Amplify/카카오 로그인 설정)
- 모노레포 구성: FE 레포에 `amplify/` 백엔드 포함, Option B 정책 적용(`lib/amplifyconfiguration.dart` 비커밋)
- Amplify 세팅: dev 환경 `amplify init` → `add auth`/`add api` → `push` 완료(AppSync/Cognito/DynamoDB 생성)
- Hosted UI 기본 설정: 도메인 프리픽스(yuno-dev-social), OAuth(code, openid/email/profile), 콜백은 CLI 제약으로 `http://localhost/` 우회 설정(콘솔에서 딥링크 추가 예정)
- 카카오(OIDC) 연동 가이드 작성 및 Flutter 연동: `AuthProvider.oidc('kakao')` 호출 연결
- 문서/가드레일: `AGENTS.md`, `docs/amplify-monorepo-setup.md`, `.github/CODEOWNERS`, PR 템플릿 추가

## 작업 내역 표

| 날짜 | 내용 | 시작 | 종료 |
| --- | --- | --- | --- |
| 09.08 (월) | 공공데이터 포털 API/크롤러 연동을 설계하고 수집 가능성·요율 제한·라이선스 준수 기준을 점검, 수집 모듈·스케줄러·저장소 구조를 정의하여 초기 데이터 확보 방안을 마련함. | 16:00 | 21:00 |
| 09.09 (화) | 수집 데이터의 표준 스키마를 정의하고 유효성 검증·결측·중복 처리 로직을 ETL 파이프라인으로 구현, 불필요 컬럼 정리와 데이터 버전관리·품질 지표 수집 체계를 구축해 학습/서비스에 적합한 데이터 기반을 마련함. | 13:00 | 18:00 |
| 09.10 (수) | 정책 데이터 수집→AI 요약/추천 서비스 호출→앱 응답까지의 엔드투엔드 백엔드 아키텍처(게이트웨이, 인증/인가, 큐·배치 워커, 캐시, 오류 처리)를 설계하고, Flutter 연동을 위한 API 계약(Swagger/OpenAPI)과 응답 포맷을 정의함. | 16:00 | 21:00 |
| 09.11 (목) | 관계형 DB 스키마와 관계·인덱스·ERD를 설계하고 ORM/마이그레이션·트랜잭션 전략을 수립, REST/GraphQL API 설계와 권한·속도제한·로깅·모니터링·CI/CD 배포 고려사항을 문서화하여 안정적인 서비스 구현 기반을 마련함. | 09:00 | 12:00 |

