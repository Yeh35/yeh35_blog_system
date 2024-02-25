%{
title: "실무에서 ID 값으로 UUID 사용하기 with JPA 95288cce411f44f1a91ef7b94ddc7716.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# 실무에서 ID 값으로 UUID 사용하기 with JPA

게시: No
생성일자: 2022년 11월 4일 오전 9:51
수정일자: 2023년 1월 18일 오후 4:48
태그: Spring, UUID, mysql

[https://github.com/olly-love-team/olly_love_backend/issues](https://github.com/olly-love-team/olly_love_backend/issues)

[https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=parkjy76&logNo=221104640333](https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=parkjy76&logNo=221104640333)

[https://dev.mysql.com/blog-archive/storing-uuid-values-in-mysql-tables/](https://dev.mysql.com/blog-archive/storing-uuid-values-in-mysql-tables/)

[https://kwonnam.pe.kr/wiki/java/hibernate/id_generator](https://kwonnam.pe.kr/wiki/java/hibernate/id_generator)

[https://louet.tistory.com/251](https://louet.tistory.com/251)

[https://devs0n.tistory.com/39](https://devs0n.tistory.com/39)

[https://www.percona.com/blog/2014/12/19/store-uuid-optimized-way/#crayon-60fa2fbab27f7557869434](https://www.percona.com/blog/2014/12/19/store-uuid-optimized-way/#crayon-60fa2fbab27f7557869434)

ID 값으로 UUID 사용하기

# **TL;DR**

1. UUID를 DB ID

# 들어가며

프로젝트를 새롭게 설계

```java
public UUID switchTimestamp(UUID originalUuid) {
    assert (originalUuid.version() == 1) : "UUID Version이 1이어야 합니다.";

    long mostSignificantBits = originalUuid.getMostSignificantBits();
    long leastSignificantBits = originalUuid.getLeastSignificantBits();

    long temp;
    long sequencedMostBits = 0;
    //time-height
    temp = mostSignificantBits & 0x0000_0000_0000_0FFFL;
    temp = temp << (13 * 4);
    sequencedMostBits |= temp; // FFF0_0000_0000_0000L

    //time-meddle
    temp = mostSignificantBits & 0x0000_0000_FFFF_0000L;
    temp = temp << (5 * 4);
    sequencedMostBits |= temp; // FFFF_FFF0_0000_0000L

    //time-low 1
    temp = mostSignificantBits & 0xFFFF_F000_0000_0000L;
    temp = temp >> (7 * 4);
    sequencedMostBits |= temp; // FFFF_FFFF_FFFF_0000L

    //version
    temp = mostSignificantBits & 0x0000_0000_0000_F000L;
    sequencedMostBits |= temp; // FFFF_FFFF_FFFF_F000L

    //time-low 2
    temp = mostSignificantBits & 0x0000_0FFF_0000_0000L;
    temp = temp >> (8 * 4);
    sequencedMostBits |= temp; // FFFF_FFFF_FFFF_FFFFL

    return new UUID(sequencedMostBits, leastSignificantBits);
}
```

# 전체 코드

```java
/**
 * JPA ID 생성기
 */
public class SequentialUUIDGenerator implements IdentifierGenerator {
		@Override
    public void configure(Type type, Properties params, ServiceRegistry serviceRegistry) throws MappingException {
        IdentifierGenerator.super.configure(type, params, serviceRegistry);
        //딱히.. 없음!
    }

    @Override
    public void registerExportables(Database database) {
        IdentifierGenerator.super.registerExportables(database);
    }

    @Override
    public void initialize(SqlStringGenerationContext context) {
        IdentifierGenerator.super.initialize(context);
    }

		@Override
    public Serializable generate(SharedSessionContractImplementor session, Object object) throws HibernateException {
        UUID uuid = Generators.timeBasedGenerator().generate();
        return switchTimestamp(uuid);
    }

    @Override
    public boolean supportsJdbcBatchInserts() {
        return IdentifierGenerator.super.supportsJdbcBatchInserts();
    }

    private UUID switchTimestamp(UUID originalUuid) {
        assert (originalUuid.version() == 1) : "UUID Version이 1이어야 합니다.";

        long mostSignificantBits = originalUuid.getMostSignificantBits();
        long leastSignificantBits = originalUuid.getLeastSignificantBits();

        long temp;
        long sequencedMostBits = 0;
        //time-height
        temp = mostSignificantBits & 0x0000_0000_0000_0FFFL;
        temp = temp << (13 * 4);
        sequencedMostBits |= temp; // FFF0_0000_0000_0000L

        //time-meddle
        temp = mostSignificantBits & 0x0000_0000_FFFF_0000L;
        temp = temp << (5 * 4);
        sequencedMostBits |= temp; // FFFF_FFF0_0000_0000L

        //time-low 1
        temp = mostSignificantBits & 0xFFFF_F000_0000_0000L;
        temp = temp >> (7 * 4);
        sequencedMostBits |= temp; // FFFF_FFFF_FFFF_0000L

        //version
        temp = mostSignificantBits & 0x0000_0000_0000_F000L;
        sequencedMostBits |= temp; // FFFF_FFFF_FFFF_F000L

        //time-low 2
        temp = mostSignificantBits & 0x0000_0FFF_0000_0000L;
        temp = temp >> (8 * 4);
        sequencedMostBits |= temp; // FFFF_FFFF_FFFF_FFFFL

        return new UUID(sequencedMostBits, leastSignificantBits);
    }
}
```

```sql
CREATE FUNCTION `ORDERED_UUID`(uuid BINARY(36)) RETURNS binary(16)
DETERMINISTIC
RETURN UNHEX(CONCAT(SUBSTR(uuid, 16, 3), SUBSTR(uuid, 10, 4), SUBSTR(uuid, 1, 5), SUBSTR(uuid, 15, 1), SUBSTR(uuid, 6, 3), SUBSTR(uuid, 20, 4), SUBSTR(uuid, 25)));

CREATE FUNCTION `PRETTY_UUID`(uuid_hex BINARY(32)) RETURNS BINARY(36)
DETERMINISTIC
RETURN (insert( insert( insert( insert(replace(uuid_hex, '-', ''), 9, 0, '-'), 14, 0, '-'), 19, 0, '-'), 24, 0, '-'));

# 테스트 해보기
SET @test_uuid = uuid();
SELECT @test_uuid, HEX(ordered_uuid(@test_uuid)), pretty_UUID(HEX(ordered_uuid(@test_uuid)));
```