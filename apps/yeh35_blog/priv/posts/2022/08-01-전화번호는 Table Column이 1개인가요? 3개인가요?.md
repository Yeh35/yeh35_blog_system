%{
title: "전화번호는 Table Column이 1개인가요 3개인가요 e657f8247c58497ca0861a8e232a0408.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# 전화번호는 Table Column이 1개인가요? 3개인가요?

게시: Yes
생성일자: 2022년 8월 1일 오후 5:27
수정일자: 2023년 1월 23일 오전 1:29
태그: DB, Develop, 삽질, 암호화

<aside>
📌 지금은 생각이 바뀌어서 전화번호를 하나의 컬럼에 저장하는게 맞다고 생각한다.
하지만 이 글을 적을 당시에 생각의 흐름을 기억하고 싶어서 글을 따로 수정하지 않았다.

</aside>

# 전화번호는 Table의 컬럼이 1개여야 할까? 3개여야 할까?

대부분의 환경에서는 어느 것을 쓰든 상관없다. 하지만 개인적으로는 010 / 1234 / 5678로 쪼개길 추천한다.
주변 개발자 7명에게 물어보니 5명은 하나라고 답하고, 한명은 모르겠다고 답하였다 그리고 마지막 한명은 생각하지도 못한 답변을 줬다. 

![답은 영로다 ㅋㅋㅋ](/images/posts/0a740421-65a1-4e67-a12a-20a9e0f9f23c.png)

답은 영로다 ㅋㅋㅋ

잠만 국가코드,통신사 까지 넣는다면 5개인거 같다.

## 왜 컬럼을 하나로 해야하나?

한개라고 대답한 이유를 들어보니 몇가지 공통된 내용이 있었다. 

1. 그냥 하나의 데이터고 굳이 쪼개서 저장해야하는가?
2. 3개로 하면 용량을 더 사용할거 같다. 
3. 쿼리 작성할때 불편할거 같다.

이 주장에 대해 하나하나 반론하며 나아갈 것이고 3개로 할 수 밖에 없는 이유가 있다. 

## 테스트 환경 세팅

테스트 환경은 클라우드 띄우기 귀찮으니 집 PC에서 진행하겠다.

1. 테이블을 생성한다.
    
    ```sql
    DROP TABLE IF EXISTS call_number_one_column;
    CREATE TABLE call_number_one_column(
       id INT(11) NOT NULL AUTO_INCREMENT,
       call_number VARCHAR(20) NOT NULL,
       CONSTRAINT call_number_one_column_PK PRIMARY KEY(id)
    );
    
    DROP TABLE IF EXISTS call_number_three_column;
    CREATE TABLE call_number_three_column(
       id INT(11) NOT NULL AUTO_INCREMENT,
       call_number_1 varchar(20) NOT NULL,
       call_number_2 varchar(20) NOT NULL,
       call_number_3 varchar(20) NOT NULL,
       CONSTRAINT call_number_three_column_PK PRIMARY KEY(id)
    );
    ```
    
2. 대충 더미 데이터 생성하는 프로세스 작성하고
    
    ```sql
    # 1개 컬럼 더미 데이터 넣기
    DROP  PROCEDURE IF EXISTS PROC_ONE_COLUMN_DUMMY;
    CREATE PROCEDURE PROC_ONE_COLUMN_DUMMY()
    BEGIN
        DECLARE i int DEFAULT 0;
        WHILE i <= 200000 DO
                INSERT INTO call_number_one_column (id, call_number)
                    VALUES (NULL, CONCAT('010', ROUND(RAND() * (9999-1000) + 1000), ROUND(RAND() * (9999-1000) + 1000)));
                SET i = i + 1;
            END WHILE;
    END;
    
    # 3개 컬럼 더미 데이터 넣기
    DROP  PROCEDURE IF EXISTS PROC_THREE_COLUMN_DUMMY;
    CREATE PROCEDURE PROC_THREE_COLUMN_DUMMY()
    BEGIN
        DECLARE i int DEFAULT 0;
        WHILE i <= 200000 DO
                INSERT INTO call_number_three_column (id, call_number_1, call_number_2, call_number_3)
                    VALUES (NULL, '010', ROUND(RAND() * (9999-1000) + 1000), ROUND(RAND() * (9999-1000) + 1000));
                SET i = i + 1;
            END WHILE;
    END;
    
    CALL PROC_ONE_COLUMN_DUMMY();
    CALL PROC_THREE_COLUMN_DUMMY();
    ```
    
    <aside>
    🙃 1분에 3만 insert가 되는데 40만을 넣어야하니… 13분간 놀고 있어야겠다.
    
    </aside>
    
3. 잘 들어갔는지 확인
    
    ```sql
    # 잘 들어갔는지 확인
    SELECT * FROM call_number_one_column LIMIT 10;
    SELECT count(*) FROM call_number_one_column;
    
    SELECT * FROM call_number_three_column LIMIT 10;
    SELECT count(*) FROM call_number_three_column;
    ```
    
    ![Untitled](/images/posts/e0caff1e-1128-4418-b2ce-4125de6670e2.png)
    

# 1개파의 주장

1개파를 자처한 다섯 개발자의 주장을 하나하나 반박해보려고한다. 

### 1개파의 주장 : 3개로 하면 용량을 더 사용할거 같다.

이것도 이미 정답이 있지만 그래도 모르니 테스트를 해보면 된다.

```sql
# 테이블 크기 확인
SELECT TABLE_NAME AS `Table`,
       ROUND((DATA_LENGTH + INDEX_LENGTH)) AS `Size (B)`
FROM information_schema.TABLES
WHERE TABLE_NAME like 'call_number%'
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;
```

![Untitled](/images/posts/c8501608-4f8c-48c0-8a4a-403341b82d2f.png)

결과는 짜라잔 동일하다. 분명 call_number_three_column에서 컬럼을 더 사용했는데도 왜 동일할까? 그 비밀은 varchar라는 자료형에 있다. 

![[/images/posts/825e1d0b-daae-4309-a299-355d2fa6e766.html](/images/posts/825e1d0b-daae-4309-a299-355d2fa6e766.html)](%E1%84%8C%E1%85%A5%E1%86%AB%E1%84%92%E1%85%AA%E1%84%87%E1%85%A5%E1%86%AB%E1%84%92%E1%85%A9%E1%84%82%E1%85%B3%E1%86%AB%20Table%20Column%E1%84%8B%E1%85%B5%201%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%80%E1%85%A1%E1%84%8B%E1%85%AD%203%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%80%E1%85%A1%E1%84%8B%E1%85%AD%20e657f8247c58497ca0861a8e232a0408/Untitled%203.png)

[/images/posts/825e1d0b-daae-4309-a299-355d2fa6e766.html](/images/posts/825e1d0b-daae-4309-a299-355d2fa6e766.html)

mysql 공식 문서에서 가져온 표를 보면 varchar는 사용한 만큼 Storage를 잡아 먹는다.

### 1개파의 주장 : 쿼리 작성할때 불편할거 같다.

```sql
# 두개는 같은 쿼리!
SELECT call_number FROM call_number_one_column limit 10;
SELECT CONCAT(call_number_1, call_number_2, call_number_3) FROM call_number_three_column limit 10;
```

이것은 한개 파의 주장에 어느 경우에는 맞다. 바로 쿼리를 직접 작성하던 대 mybatis 시대에나 맞는 이야기이다. 
요즘 백엔드 앱을 구축할 때 ORM을 많이 사용하는데 ORM을 사용하면 아주 쉽게 이 문제가 해결된다. Spring Data Jpa의 경우 `@Embedded`를 통해 컬럼이 나눠진 것을 느끼지도 못하고 사용할 수 있다.

# 컬럼 3개를 사용할 수 밖에 없는 이유

여기까지 오려고 빌드업이 참 길었다. 이제 본격적으로 컬럼을 3개로 나눠야하는지 이야기 해보겠다.
사실 전화번호를 3개로 쪼개는 이유는 전부 성능 때문이다. Table에 데이터가 얼마 없고, 그렇게 자주 호출되지 않는다면 컬럼을 하나로 써도 문제가 없다.  하지만! 서비스가 커지다보면 고객도 많아지고, DB를 자주 호출하게 된다.

## 인덱스 최적화

Query에서 Where에 자주 나오는 컬럼이 있다며 우린 그걸 index로 잡는다.
전화번호에서 가장 많이 검색되는 것이 무엇을까? 바로 뒷 4자리이다. 

그럼 이걸로 인덱스를 생성해보자

```sql
# 인덱스를 생성
CREATE INDEX idx_one_column ON call_number_one_column ( call_number );
CREATE INDEX idx_three_column_call_3 ON call_number_three_column ( call_number_3 );
```

4자리를 SELECT 해보면 call_number_one_column의 경우 index의 도움을 못 받고, call_number_three_column는 인덱스의 도움을 받는다.

```sql
# 뒷 4자리 조회
SELECT * FROM call_number_one_column WHERE call_number like '%1234'; #Index 적용X 60ms
SELECT * FROM call_number_three_column WHERE call_number_3 = '1234'; #Index 적용  26ms
```

index의 도움을 못 받는다는 것은 Full Scan을 하고 있다는 뜻이고, 20만건에서 벌써 2배 차이가 발생한다.

<aside>
📌 인덱스는 보통 memory에 올라가는데 DB Memory에 최소한으로 넣을 수 있다면 그거 자체로도 의의가 있다.

</aside>

## 암호화시 Like 조회

전화번호는 2급 개인정보에 속해서 실무에서는 암호화 하는 것이 원칙이다.
AES-256으로 암호화 했을 경우 복호화 하지 않고 Like 검색을 할 수 없다.

call_number_one_column의 경우 결국 DB상에서 복호화를 해줘야한다.

```sql
SELECT * FROM call_number_one_column WHERE AES_DECRYPT(UNHEX(call_number), 'key') like '%1234'; 
```

이럴 경우 2가지 치명적인 문제가 있다. 

1. 암호화 KEY가 DB Log에 남을 수 있다. 
2.  복호화를 App Server가 아니라 DB에 시키는 경우 부하에 원인이 된다. (심지어 풀스캔, 풀 복호화..)

컬럼을 나눈 call_number_three_column의 경우 App Server에서 암호화해서 쿼리를 날려주면 쉽게 찾아올 수 있다.

```sql
SELECT * FROM call_number_three_column WHERE call_number_3 = '암호화된 뒷 4자리';
```

## 결론

앞서 이야기 했지만 이미 하나로 되어 있고, 성능상 이슈가 없다면 굳이 3개로 나누는 일을 할 필요는 없다. 
하지만 이제 시작하는 프로젝트라면 컬럼 3개로 나누는 것을 추천한다.

# 자료

[AES 암호화 모드 (CBC ECB CTR OCB CFB)를 선택하는 방법](https://rateye.tistory.com/1035)

[ECB 설명 및 취약점](https://lactea.kr/entry/ECB-%EC%84%A4%EB%AA%85-%EB%B0%8F-%EC%B7%A8%EC%95%BD%EC%A0%90)

[](https://yurimkoo.github.io/db/2020/03/14/db-index.html)