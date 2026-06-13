
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

-- 실습6.  관계(비교) 연산자 기호  <=     >=    <    >   =
--         member테이블에서 회원 그룹 평균키들 중에서 
--         데이터가 162이상인 회원그룹의 아이디들, 회원그룹명들  조회 
select mem_id,  mem_name  from member  
where  height  >=  162;

-- 실습 7-1.  관계(비교) 연산자 기호  <=     >=    <    >   =
--           논리 연산자 기호   AND    OR

-- member테이블에서 회원그룹 평균키(height열에 저장된 데이터들)가 165이상이면서!
-- 그룹 인원(mem_number열에 저장된 데이터들)이 6명 초과인 회원그룹의 
-- 회원그룹명(mem_name열에 저장된 데이터들), 
-- 그룹평균키(height열에 저장된 데이터들), 
-- 그룹인원(mem_number열에 저장된 데이터들) 조회!!!!
select mem_name, height, mem_number from member
where height >= 165 and  mem_number > 6;

-- member테이블에서 회원그룹 평균키가  165이상 이거나 또는~ 그룹 인원이 6명 초과인 회원그룹의?
-- 회원그룹명, 회원평균키, 회원그룹인원수 조회!!!!
select mem_name, height,  mem_number  from member
where height >= 165 or  mem_number >  6;

-- 실습 7-1-1. BETWEEN  AND절 미사용한 경우 
-- 회원그룹의 평균키가 163이상 이면서 165이하인 회원그룹의 그룹명,평균키,그룹인원수 조회!!
select mem_name, height,  mem_number from member
where height >= 163  and  height <=  165;

/*
BETWEEN AND 절 작성 문법

   select 열명  from  테이블명
   where 비교할_값들이_저장된_열명 between 범위의최솟값 and 범위의최댓값;
*/
-- 실습 7-1-2. BETWEEN  AND절 사용한 경우 
-- 회원그룹의 평균키가 163이상 이면서 165이하인 회원그룹의 그룹명,평균키,그룹인원수 조회!!  
select mem_name, height,  mem_number from member
where height  between  163  and  165;

-- 실습 8. 회원그룹의 평균키가 165이상이거나 또는 그룹인원이 6명 초과인 
--        회원그룹들의 그룹명, 그룹평균키, 그룹인원수 조회!!!!!!!
select mem_name,  height,  mem_number from member
where height >= 165 or mem_number > 6;

-- 실습 8-1. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 중 한곳이라도 해당되는 그룹의 이름, 주소 조회!!!
--  IN() 절을 사용하지 않고 조회!!!!!!!    
select mem_name, addr  from member
where  addr = '경기' or  addr = '전남' or  addr = '경남';

-- 실습 8-2. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 중 한곳이라도 해당되는 그룹의 이름, 주소 조회!!!
--  IN() 절을 사용해 조회!!!!!!!    
--  문법
--      where 비교할_데이터가_저장된_열명  IN('비교할값1', '비교할값2', '비교할값3');
select mem_name, addr  from member
where  addr in('경기', '전남', '경남');

/*
	Like
    - 문자열 데이터의 일부 글자가 옆의 데이터로 포함되어 있는 행에 대한 열의 값 조회 하는 예약어.
	  예를 들어 회원그룹명의 첫 글자가 '우' 문자로 시작하는 단어를 포함하는 데이터가 저장된 
      행에 관한 열의 데이터를 조회할수 있습니다.
	- 문법
			where  비교할_데이터가_저장된_열명 LIKE '문자%'; 
*/
-- 실습9. member테이블에서 회원그룹명 중에서 '우' 문자로 시작하는 단어가 포함된 데이터가 있으면 
--       그 행에 관한 모든 열의 데이터들 조회
select * from member
where mem_name like '우%';

-- 실습9-1. LIKE절에 _언더바 기호 사용 가능 
--  member테이블에서 회원그룹명 중에서 앞 두글자는 상관없고 뒷 단어가 '핑크'인 
--  회원그룹의 이름이 저장되어 있으면? 이름이 저장된 행에 관한 모든 열의 데이터를 조회
select * from member
where mem_name like '__핑크';

-- 실습9-2. LIKE절에 %단어%  사용 
--  member 테이블에서 회원그룹명 중에서 '마' 단어가 포함하고 있는 그룹명이 저장되어 있으면?
--  그 그룹의 행에 관한 모든 열의 데이터를 조회 
select * from member
where mem_name like '%마%';

-- 실습9-2-1. LIKE절에 '%단어' 사용 
-- member테이블에서 회원그룹명 중에서 '친구' 단어로 끝나는 그룹명이 저장되어 있으면?
-- 그 해당 그룹의 행에 관한 모든 열의 데이터 조회 !!!
select * from member
where mem_name like '%친구';

/*
	서브 쿼리 구문
		-  안쪽 SELECT구문을 이용하여 조회한 결과 데이터들을 
           바깥쪽 SELECT구문을 이용하여 다시 조회하는 전체 구문을 말함.
           
		- 문법
				SELECT * FROM 테이블명
                WHERE 조건열명 > (SELECT * FROM 테이블명
								WHERE 조건열명 = 조건열의 값들과 비교할 값);
*/
-- 실습 10-1. 서브쿼리를 사용하지 않고 두개의 SELECT문장을 사용한 예

-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다~ 큰~ 그룹회원의 그룹이름과 그룹평균키 조회 하고 싶다.

	-- 순서1. 일단 에이핑크 그룹의 평균키 164 조회 해 오자
	select height from member where mem_name = '에이핑크';
	
	-- 순서2. 에이핑크 그룹의 평균키는 순서1.에서 조회 했으므로 164입니다.
	--       where 조건절의 조건값 자리에 164를 대입해서 164보다 큰~ 그룹의 이름과 평균키를 조회하면 된다.
    select mem_name, height from member
    where height  > 164;

-- 실습 10-2. 서브쿼리 사용
-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다~ 큰~ 그룹회원의 그룹이름과 그룹평균키 조회 하고 싶다.
    select mem_name, height from member
    where height  >  (select height from member 
                      where mem_name = '에이핑크');
-- --------------------------------------------------------------------------------------
-- 연습문제 
--  1번.  회원테이블에서 모든 회원의 ID와 그룹이름을 조회 해라.
select mem_id, mem_name from member;

--  2번.  회원테이블에서 그룹회원의 평균키가 167이상인 그룹회원의 모든 열의 정보 조회 해라.
select * from member
where height >= 167;

--  3번.   회원테이블에서 그룹인원수가 5명 이하인 그룹의 이름과 인원수 조회 해라.
select mem_name,  mem_number from member
where mem_number <= 5;

--  4번.  구매 테이블(buy)에서 상품가격이 100 이상인 구매한 상품의 이름과 가격을 조회 해라.
select prod_name, price from buy
where price >= 100;

--  5번.  회원 테이블에서 주소가 '경기'인 회원그룹의 모든 열정보를 조회 해라.
select * from member
where  addr = '경기';

--  6번.  구매 테이블(buy)에서 '패션' 분류의 상품 이름과 구매수량을 조회 해라.
select prod_name, amount from buy
where group_name = '패션';

--  7번. 회원 테이블에서 '서울'에 사는 그룹회원 이름과 전화번호(국번,뒷번호 모두 포함)해서 조회해라.
select mem_name, phone1, phone2 from member
where  addr =  '서울';

--  8번. 회원 테이블에서 그룹명이 '트와이스'인  그룹 회원의 모든 열정보 조회 해라 .
select  * from member
where  mem_name = '트와이스';

-- 9번. '블랙핑크'라는 이름을 가진 그룹회원이 구매한 모든 제품의 정보(모든열값)를 조회 하시오.
-- 서브쿼리 사용!
select * from buy
where mem_id = (select mem_id from member
				where mem_name = '블랙핑크');


--  10번. 회원 테이블에서 그룹 인원수가 8명인 그룹의 모든 열정보를 조회 하라.

--  11번. 구매 테이블에서 구매한 상품이름에 '지갑'단어가 포함된 상품의 모든 열정보를 조회 하라 
select * from buy
where prod_name like '%지갑%';

--  12번. 회원 테이블에서 평균키가 165cm 이하인 그룹의 이름과 평균키를 조회 하라
select mem_name, height from member
where height <= 165;

--  13번. 회원 테이블에서 '여자친구' 또는 '트와이스' 그룹이름가진 모든 열정보를 조회 하라
select * from member
where mem_name in('여자친구','트와이스');

--  14번. 구매 테이블에서 구매한 제품 수량이 3이상인 
--        구매한그룹의 그룹아이디, 상품의 이름, 가격을 조회하라 
select mem_id, prod_name,  price from buy
where amount >= 3;

--  15번. 회원 테이블에서 사는지역이 '강남'인 회원의 이름과 주소를 조회 하라 
select mem_name, addr from member
where  addr = '강남';
-- 조회 되지 않음! 이유 : 사는 지역이 강남인 회원그룹 없음


--  16번. 구매 테이블에서 '디지털' 분류(group_name열)의 상품 중 가격(price열)이 200이하인 
--        구매한_상품의_이름(prod_name열)을 조회 하라
select prod_name  from buy
where group_name = '디지털' and  price <= 200; 

--  17번. 회원 테이블에서 그룹 평균키가 162cm이상인 그룹의 이름을 조회하라
select mem_name from member
where height >= 162;

-- 18번. 구매 테이블에서 특정그룹('블랙핑크')의 구매 내역에서 
--       가격이 50이상인 구매한_상품의_모든열 정보 조회하라
-- 서브쿼리~~~~~~~~~

select * from buy
where price >= 50  AND mem_id = (select mem_id from member
								  where mem_name = '블랙핑크');
/*
먼저 member테이블에 저장된 블랙핑크 그룹을 식별할 mem_id 열 값을 조회 ! -> 'BLK'
select mem_id from member
where mem_name = '블랙핑크';  -- >>>>>>>>> mem_id --->  BLK
*/




