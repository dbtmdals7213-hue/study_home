
-- 한줄 주석

# 한줄 주석

/*
 여러 줄 주석
 여러 줄 주석 
*/
--  현재 MySQL DBMS 서버에 만들어져 있는 데이터베이스 목록 보기 명령
show databases;

--  사용할 데이터베이스 선택 명령
-- 작성 문법 :    use 사용할데이터베이스명;
use world;

/*
	특정 테이블에 저장된 모든 열의 데이터들을 조회(검색)
    
	문법
		select 조회할데이터가_저장된_열명1, 열명2, 열명3
        from 조회할_테이블명;
	
    문법
		select *
        from 조회할_테이블명;
        
	문법 
		select *
        from 조회할_테이블명
        where 조건값이_저장된_열명 = 조건값; 
		
    요약 : member 테이블(표)에 저장된 member_id, member_addr 열 세로 방향의 각칸에 저장된 값 조회
*/
-- 풀이  : member테이블에 저장된 데이터들 중에서 
--        member_id열 방향(세로 방향)에 저장된 데이터와 
--        member_addr열 방향(세로 방향)에 저장된 데이터 들만 모두 조회
		  select member_id, member_addr
          from member;

-- 풀이   :  member 테이블에 저장된 모든 열의 데이터들 조회
		  select  *
          from member;

-- 풀이   : member_name열 방향(세로 방향)에 저장된 이름들 중에서 "아이유"가 저장된 행 위치의 모든 열의 값 조회
-- 요약   : 이름이 아이유인 회원의 모든 열 데이터 조회 
		  select *
          from member
          where member_name = '아이유';

-- 맛보기 끝 

-- ---------------------------------------------------------------------------------------------
/*
	개체(객체) ?  데이터로 표현하고자 하는 데이터베이스의 구성요소
    
    개체 종류 : 테이블 ,  인덱스,  뷰, 스토어드프로시저, 트리거, 함수, 커서 등.......

	1.인덱스(index) 개체 
    - 데이터베이스 테이블에 저장된 데이터의 검색 속도를 향상시키기 위한 개체 
*/
-- 인덱스 개체를 생성해서 사용하지 않고 
-- member테이블에 저장되어 있는 이름이 아이유인 한사람의 정보 조회
select  * from  member
where member_name = '아이유';

/*
	인덱스 객체 만들기 문법
		CREATE INDEX 생성할인덱스개체명 ON 테이블명(열명);
*/
-- member 테이블의 member_name열에 대한 빠른속도로 데이터를 조회 하기 위해 인덱스 개체를 생성하자.
CREATE INDEX idx_member_name ON member(member_name);

-- 인덱스 개체를 idx_member_name 을 생성하고 나서 
-- member테이블에 저장되어 있는 이름이 아이유인 한사람의 정보를 조회 
select * from member
where member_name = '아이유';

-- ------------------------------------------------------------------------------
/*
	뷰 개체  :   가상의 테이블(가짜 테이블)
    
    뷰 개체 생성 문법
		
			create view 생성할뷰명
            as select * from 조회할_실제_테이블명;
*/
-- member 테이블에 저장된 모든 열 정보 조회 
select * from member;

-- member 테이블과 연결되는 회원뷰 개체(member_view) 생성
create view member_view
as select * from member;

-- member 테이블명이 아닌~~~ 회원뷰 개체(member_view)명으로 
-- member 테이블의 정보를 조회 할수 있다.
select * from member_view;


-- 조회시 테이블을 사용하지 않고 굳이 뷰를 사용하여 조회한 이유는?
-- 1. member테이블을 조작하면 데이터가 변경되거나 삭제 될수 있어 보안에 좋지 않음
--    그래서 뷰명으로 조회 하면 member테이블을 직접 만져서 조회하지 않기떄문에 보안에 좋음
-- 2. 긴 조회 SELECT SQL문을 간략하게 만들수도 있다.
-- ---------------------------------------------------------------------------

/*
	스토어드 프로시저 개체 :  프로그램 코드를 묶어 놓은 함수와 같은 개체 
*/
-- 회원테이블(member)에 저장된 데이터들 중에서 member_name열에 저장된 값이 '나훈아'인
-- 행 에 관한 모든 열의 해당되는 값들을 조회 
select * from member where member_name = '나훈아';

-- 상품테이블(product)에 저장된 데이터들 중에서 product_name열에 저장된 값이 '삼각김밥'인
-- 행 에 관한 모든 열의 해당되는 값들을 조회 
select * from product where product_name = '삼각김밥';

/*
	스토어드 프로시저 개체 생성 문법
    
			DELIMITER //
			CREATE PROCEDURE 생성할스토어드프로시저명() 
			BEGIN
					프로그래밍할 SQL문장1;
                    프로그래밍할 SQL문장2; ..........
			END //
			DELIMITER ;
            
	  참고. 위 첫 행과 마지막 행에 구분 문자라는 의미의 DELIMITER // 와 
           DELIMITER; 문을 작성 하였는데...
           일단 이것은 스토어드 프로시저를 만들기 위해 묶어 주는 약속의 문법 이라고 생각 하면됩니다.    
            
*/
--  위 두 SELECT 문을 하나의 기능인 스토어드 프로시저 개체로 만들어 보겠습니다.
DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
		select * from member where member_name = '나훈아';
        select * from product where product_name = '삼각김밥';
END //
DELIMITER ;

-- 바로 위에서 만든 myProc라는 이름의 스토어드프로시저 개체를 호출해서 실행하기 위한 문법
--   CALL 호출할프로시저명();
CALL myProc();
CALL myProc();
CALL myProc();

-- -------------------------------------------------------------------------------
-- 주제 : 기본 조회문  SELECT ~ FROM 절 배우기 

/*
		USE 문
		- SELECT문으로 테이블에 저장된 데이터를 조회하기 전에 ~~~~~
          먼저 사용할 데이터베이스를 선택할때 이용하는 예약어.
          
		- 사용 문법
			USE 사용할데이터베이스명;
*/
use market_db;

/*
	SELECT 문?
		- 특정 테이블 표에 저장되어 있는 데이터를 조회하여 가져올때 사용되는 SQL구문.
        
    SELECT문 전체 작성 문법
		
		 SELECT 조회할_데이터가_저장되어있는_열명
         FROM   조회할_데이터가_저장되어있는_테이블명
         WHERE  조건열명 = 조건값
         GROUP BY 그룹으로_묶을_데이터들이_저장된_열명
         HAVING  조건식
         ORDER BY 정렬할_데이터가_저장된_열명 ASC 또는 DESC
         LIMIT 숫자;
			
	----------------------------------------------------
    
		SELECT 핵심 문법1.
        
		 SELECT 조회할_데이터가_저장되어있는_열명
         FROM   조회할_데이터가_저장되어있는_테이블명
         WHERE  조건열명 = 조건값;					
*/
-- 실습0. member테이블에 저장된 모든 열의 값 조회 
select mem_id, mem_name, mem_number, addr, phone1, phone2, height, debut_date
from member;

-- select -> 테이블에서 데이터를 조회 해서 가져올때 사용되는 예약어.
-- * -> 조회해 올 데이터가 저장된 모든열명.
-- from -> 테이블에서 데이터를 조회해 온다는 의미의 예약어. 
-- member -> 조회할 데이터가 저장된 테이블명.
select *
from member;
-- 풀어서 해석하면? member테이블에 저장된 모든 열의 데이터들을 조회해서 가져오라~ 의미 

-- 실습1. 회원테이블(member)에 그룹이름이 저장된 mem_name열의 데이터들만 조회 
-- 작성 문법
--          select 조회할_데이터가_저장된_열명  from  조회할_테이블명;
select mem_name from member;

--  실습2. 회원테이블(member)에 주소addr, 입사년도debut_date, 그룹이름mem_name열의 데이터들만 조회
select addr, debut_date, mem_name from member;

-- 실습3. 회원테이블(member)에 조회할 열명 대신 별칭을 지어서 조회된 결과창에 보여주기 위해서는 
--       아래의 문법을 사용하자.
--        select 조회할_열명1 as 별칭명1,   조회할_열명2  as 별칭명2
--        from  조회할테이블명;
-- 또는
--        select 조회할_열명1   별칭명1,    조회할_열명2   별칭명2
--        from  조회할테이블명;
select addr as "주소", debut_date as "데뷔일자", mem_name  "그룹명" from member;

-- 실습4. 회원테이블(member)에서 회원그룹이름(mem_name열에 저장되어 있는 데이터들)이 
--       '블랙핑크'가 저장되어 있는 위치의 행이 있는 모든 열의 데이터를 조회
-- 		 요약 : 회원그룹이름이 '블랙핑크' 인 모든 열의 값들 조회!

-- 문법 
--      select 조회할_데이터가_저장된_열명
--      from   조회할_테이블명
--      where  조건에서_사용할_데이터들이_저장된_열명  = 비교할_조건값;
select *
from member
where mem_name = '블랙핑크';

-- 실습5. member테이블에서 회원그룹인원(mem_number열의 데이터)이 4명인 그룹의 모든 열의 데이터 조회
select * 
from member
where mem_number = 4;


 






