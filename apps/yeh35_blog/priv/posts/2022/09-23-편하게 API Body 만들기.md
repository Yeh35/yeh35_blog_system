%{
title: "편하게 API Body 만들기 b61f8df4d60a4de18c640d246b1b12c7.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# 편하게 API Body 만들기

게시: No
생성일자: 2022년 9월 23일 오전 10:52
수정일자: 2022년 12월 14일 오후 9:05

[[Jackson]Custom Serializer, Deserializer 를 만들어 사용하기!](https://akageun.github.io/2020/01/02/java-jackson-custom-serialize.html)

[How to configure jackson with spring globally?](https://stackoverflow.com/questions/37492249/how-to-configure-jackson-with-spring-globally)

`@JsonComponent`

[[RabbitMQ] Jackson2JsonMessageConvertor](https://minholee93.tistory.com/entry/RabbitMQ-Jackson2JsonMessageConvertor)

## `@JsonComponent`이 안먹히는 경우

[spring boot Jackson2ObjectMapperBuilderCustomizer not working](https://stackoverflow.com/questions/72891664/spring-boot-jackson2objectmapperbuildercustomizer-not-working)

```html
@Configuration
@EnableWebMvc <- 때문에 기본 설정이 다 날라감
public class WebConfiguration implements WebMvcConfigurer {
```

[권남](https://kwonnam.pe.kr/wiki/springframework/springboot/json#jsoncomponent)