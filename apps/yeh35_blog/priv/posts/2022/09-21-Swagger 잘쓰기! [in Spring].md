%{
title: "Swagger 잘쓰기! [in Spring] 780d77d6b22e4424a9c948d096230fe2.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# Swagger 잘쓰기! [in Spring]

게시: No
생성일자: 2022년 9월 21일 오전 11:00
수정일자: 2022년 10월 21일 오후 2:06

[https://github.com/springdoc/springdoc-openapi/issues/946](https://github.com/springdoc/springdoc-openapi/issues/946)

`@Schema`

[Swagger에서 Java8 LocalTime을 문자열로 표시하는 방법은 무엇입니까? (How to show Java8 LocalTime as a string in Swagger?)](https://kr.coderbridge.com/questions/152fbcdd6ab54a8ebdf4110f363ce406)

[](https://www.baeldung.com/spring-swagger-hide-field)

[Spring REST API 문서를 Swagger로 만들자](https://yookeun.github.io/java/2017/02/26/java-swagger/)

[Migrating from Springfox Swagger 2 to Springdoc Open API](https://stackoverflow.com/questions/59291371/migrating-from-springfox-swagger-2-to-springdoc-open-api)

[Springboot에서 API Docs (Springdoc) 사용하는 방법 (2)](https://oingdaddy.tistory.com/272)

[F.A.Q](https://springdoc.org/faq.html)

[Spring Boot Swagger 3.x 적용](https://bcp0109.tistory.com/m/326)

[Spring swagger 3 사용방법(springdoc-openapi-ui)](https://wildeveloperetrain.tistory.com/m/156)

[OpenAPI 3 Library for spring-boot](https://springdoc.org/)

[Swagger Editor](https://editor.swagger.io/)

[OpenAPI 란? (feat. Swagger)](https://gruuuuu.github.io/programming/openapi/)

# 공통 설정

```kotlin
@OpenAPIDefinition(
    info = Info(title = "서버 API 명세서", description = "API 명세서")
)
@Configuration
class OpenApiConfig {

		/**
		 * 공통 설정
  	 */
    @Bean
    fun customGlobalSet() {
        SpringDocUtils.getConfig()
    }

}
```