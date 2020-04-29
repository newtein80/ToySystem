#### 1. Project 추가 (Class Library)
- ManagementSystem.Domain
- ManagementSystem.Application
- ManagementSystem.Infra

#### 2. Data, Model 이동
- Migration 폴더 삭제
- Data, Model 폴더 이동
(대상 프로젝트: Infra 프로젝트)
	- Namespace, Using package 수정
	- 필요 패키지 설치
		Microsoft.AspNetCore.ApiAuthorization.IdentityServer
		Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore
		Microsoft.AspNetCore.Identity.EntityFrameworkCore
		Microsoft.EntityFrameworkCore.SqlServer
		Microsoft.EntityFrameworkCore.Tools
		Microsoft.EntityFrameworkCore
- Api 프로젝트에 참조 추가
(참조 프로젝트: Infra 프로젝트)
- startup.cs 에 Infra 관련 의존성 추가
- 로그인 의 ApplicationUser 의존성 추가 부분 수정
- Program.cs 수정
- 데이터베이스 생성
(Create_Database.sql 실행, 폴더 확인)
	- `add-migration` 명령어 실행(Identity 모델 관련 테이블 코드 생성 및 초기화)
	- 필수 확인 사항
		- 연결문자열
		(appsettings.json > DefaultConnection)
		- 명령 실행 대상 프로젝트 확인 (기본 프로젝트: ManagementSystem.Infra)
		- add-migration 명령어 실행 위치(경로)
	- `update-database` 명령어 실행(실제 테이블 생성)

#### 3. Domian 작성
- AuditEntity, AssetPrimaryInfo, AssetSubInfo
- Enum 클래스 추가
- Application Project 에 Microsoft.EntityFrameworkCore 패키지 참조 추가
- Application Project 에 ManagementSystem.Domain 프로젝트 참조 추가
- Application Project
	- Interface 작성
	- IApplicationDbContext.cs
	- ICurrentUserService.cs
- Infra 프로젝트의 ApplicationDbContext 의 부모클래스에 IApplicationDbContext 추가 및 인터페이스 구현
- Api 프로젝트에서 사용할 사용자 정보 관련 Service 클래스 작성
- core 프레임워크의 Service에 사용자 정보관련 Service 클래스 등록 (Dependency Injection) - Scope
- infra 프로젝트에서 add-migration AddAssetEntities 실행 (Entities - Database 관련 작업 작성)
- update-migration 실행 (Entities - Database 관련 작업 실행)

#### 4. MediatR and FluentValidation
- Application 프로젝트에 MediatR, FluentValidation 패키지 추가
	- FluentValidation
	- FluentValidation.dependencyinjectionExtensions
	- MediatR.Extensions.Microsoft.DependencyInjections
- Application 프로젝트에 Command 관련 폴더 및 클래스 추가
