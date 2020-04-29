/*
USE master;
GO
DROP DATABASE SMVN3
*/

/*
0.데이터베이스 생성
*/
USE master;
GO

CREATE DATABASE MANAGEAPP
ON PRIMARY    /* 기본 파일 그룹(Primary Filegroup) */
    (NAME = 'MANAGEAPP',
        FILENAME = 'D:\MANAGEAPP_DB\MANAGEAPP.mdf',
        SIZE = 25MB,
        FILEGROWTH = 1MB),--FILEGROWTH = 1%),
        
FILEGROUP MANAGEAPP_DATA    /* 사용자 정의 파일 그룹(MyNewFileGroup Filegroup) */
    (NAME = 'MANAGEAPP_DATA',
        FILENAME = 'D:\MANAGEAPP_DB\MANAGEAPP.ndf',
        SIZE = 500MB,
        FILEGROWTH = 1MB)

LOG ON    /* 트랜잭션 로그 파일(Transction Log File) */
    (NAME = 'MANAGEAPP_LOG',
        FILENAME = 'D:\MANAGEAPP_DB\MANAGEAPP.ldf',
        SIZE = 25MB,
        MAXSIZE = 2048MB,
        FILEGROWTH = 10MB);
