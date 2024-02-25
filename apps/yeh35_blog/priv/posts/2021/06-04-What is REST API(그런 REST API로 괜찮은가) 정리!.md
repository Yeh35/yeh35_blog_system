%{
title: "What is REST API(그런 REST API로 괜찮은가) 정 01c3a99b00254297a034d979d59a897d.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# What is REST API(그런 REST API로 괜찮은가) 정리!

게시: Yes
생성일자: 2021년 6월 4일 오전 11:01
수정일자: 2021년 6월 4일 오전 11:17
태그: Develop, 후기

<aside>
🗣 이응준님의 [“그런 REST API로 괜찮은가”](https://www.youtube.com/watch?v=RP_f5dMoHFc) 발표를 보고 정리한 내용이다.

</aside>

# **REST API란?**

- REpresentational State Transfer
- REST 아키텍처를 따르는 API
- 인터넷 상의 시스템 간의 상호 운용성(interoperabiliy)을 제공하는 방법중 하나
- 시스템 제각각의 독립적인 진화를 보장하기 위한 방법

## **REST 아키택처 스타일란?**

- client-server
- stateless
- cache
- **uniform interface**
- layered system
- code-on-demand (optional)

(아키택처 스타일이란 제약조건의 집합)나머지는 잘 지켜지지만 **uniform interface**는 쉽게 지켜지지 않는다..

### **Uniform Interface의 제약 조건**

- Identification or resource : 리소스가 URL로 식별되면 된다.
- Manipulation or resources through representations: representations 전송을 통해 resources를 조작해야한다.
    - representations는 HTTP 메소드(PUT, DELETE, GET, POST,등)를 뜻한다.
- **self-descriptive messages** : 메시지는 스스로를 설명해야한다.
- **hypermedia as the engine of application state (HATEOAS)** 애플리케이션의 상태는 Hyperlink를 이용해서 전이가 되야한다.

요즘 자칭 REST API라는 API들이 아래 두개의 제약조건을 못 지키고 있다.

### **self-descriptive messages 규칙을 지킨다는 건**

- 요청의 경우
    
    ![/images/posts/3382b652-c73e-47de-944a-67d69c749b81.PNG](/images/posts/3382b652-c73e-47de-944a-67d69c749b81.PNG)
    
    ![/images/posts/9c1c0f17-25de-48d0-a959-0ceaa3778217.PNG](/images/posts/9c1c0f17-25de-48d0-a959-0ceaa3778217.PNG)
    
- 응답의 경우
    - 해당 응답을 보고 Client가 어떤 문법으로 작성된 것인지 모른다..
        
        ![/images/posts/a2e1be5d-9eec-4bf3-9c97-7ad4f70146e5.PNG](/images/posts/a2e1be5d-9eec-4bf3-9c97-7ad4f70146e5.PNG)
        
    - Content-Type을 추가함으로써 어떤식으로 해석해야 하는지 알려줘야한다.
        
        ![/images/posts/800af814-91c8-41bd-953f-771da58e78eb.PNG](/images/posts/800af814-91c8-41bd-953f-771da58e78eb.PNG)
        
    - 그렇지만 “op"가 뭔지, “path"가 뭔지 모름으로 “java-patch+json"이라는 명세를 추가해서 어떤 뜻으로 이해햐아하는지 완전한 해석방법을 제공해줘야한다.
        
        ![/images/posts/981d1640-b7eb-4212-9cd7-93cbac1d3abd.PNG](/images/posts/981d1640-b7eb-4212-9cd7-93cbac1d3abd.PNG)
        

이런식으로 메시지만 보고서 완전하게 해석할 수 있어야 한드는 뜻이다.

### **HATEOAS 규칙을 지킨다는 건**

- 애플리케이션 상태를 전의는  이런식으로 다른 페이지로 넘어가는 것을 뜻한다.
    
    ![/images/posts/7013d19b-4587-424a-bae4-a8a74d3cddc1.PNG](/images/posts/7013d19b-4587-424a-bae4-a8a74d3cddc1.PNG)
    
- HTML같은 경우 HATEOAS를 만족한다.
    
    ![/images/posts/a7f53fe5-9e8d-4a2b-91cc-b1f12e2e7876.PNG](/images/posts/a7f53fe5-9e8d-4a2b-91cc-b1f12e2e7876.PNG)
    
- Json으로 표현해도 만족 할 수 있다. Link라는 해더를 사용해서 다른 리소르를 가리켜준다면
    
    ![/images/posts/650af677-dc92-4cfa-96e3-b2456cd7353f.PNG](/images/posts/650af677-dc92-4cfa-96e3-b2456cd7353f.PNG)
    

### **왜? Uniform Interface가 필요하냐?**

### **동립적 진화를 위해**

- 서버와 클라이언트가 각각 독립적으로 진화한다.
- 서버의 기능이 변경되어도 클라이언트를 업데이트할 필요가 없다.
- REST를 만들게 된 계기: How do i improve HTTP without breaking the Web.

### **실제로 지켜지는 곳은 어디인가?**

### **바로 웹!**

- 웹 페이지를 변경했다고 웹 브라우저를 업데이트할 필요는 없다.
- 웹 브라우저를 업데이트했다고 웹 페이지를 변경할 필요도 없다.
- HTTP 명세서가 변경되어도 웹은 잘 동작한다.
- HTML 명세서가 변경되었어도 웹은 잘 동작한다. 물론 디자인이 깨질 수 있지만 동작은 한다!
    
    ![/images/posts/f411ecb3-5de7-47e4-9f07-3f2857fe8e75.PNG](/images/posts/f411ecb3-5de7-47e4-9f07-3f2857fe8e75.PNG)
    

## **어떻게 이런걸 한걸까?**

- 마법같은건 없다. 피땀흘리며 노력의 결과물

### **이런분들**

- W3C Working groupsHTML5 첫 초안에서 권고안 나오는데까지 6년..
- IETF Working groups HTTP/1.1 명세 개정판 작업하는데 7년..
    - 엄청난 기능이 추가됬느냐? (X)
    - 하위 호환성을 위해 거의 문서를 다듬기만 했다. (O)
- 웹 브라우저 개발자들
- 웹 서버 개발자들

### **상호운용성(interoperability)에 대한 집착**

- Refere 오타지만 안 고침 (30년전에 오타)
- charset 잘못 지은 이름이지만 안 고침 (encoding이라고 지었어야함)
- HTTP 상태 코드 416 포기함 (잘못만든 코드)
- HTTP/0.9 아직도 지원 (크롬, 파이어폭스)

### **이런 노력을 안하게 되면…**

![/images/posts/5b79e6b8-0cec-4969-94bf-fef02e0b2089.PNG](/images/posts/5b79e6b8-0cec-4969-94bf-fef02e0b2089.PNG)

이런 메시지를 매일 매일 봐아할 것이다.

### **이 어려운 REST API 따라야 하는가?**

![/images/posts/2a635e88-209a-4736-b48c-53ef51d32f51.PNG](/images/posts/2a635e88-209a-4736-b48c-53ef51d32f51.PNG)

REST API를 포기하고 HTTP API를 사용한다.

## **API는 Web과 다르게 REST가 잘 안될까?**

![/images/posts/54247c94-8e60-4c21-8f12-b84a1b357393.PNG](/images/posts/54247c94-8e60-4c21-8f12-b84a1b357393.PNG)

- 문제가 JSON 이겠다는 느낌이 든다.
    
    ![/images/posts/4715875a-e642-4b5e-bd1a-b3af973ee2a7)%20%E1%84%8C%E1%85%A5%E1%86%BC%2001c3a99b00254297a034d979d59a897d/Untitled.png](/images/posts/4715875a-e642-4b5e-bd1a-b3af973ee2a7)%20%E1%84%8C%E1%85%A5%E1%86%BC%2001c3a99b00254297a034d979d59a897d/Untitled.png)
    
    - 문법 해석은 가능하지만, 의미를 해석하려면 별도로 문서(API명세등)이 필요하다

## **해결 방법**

### **self-descriptive messages**

- 방법1
    
    ![/images/posts/4715875a-e642-4b5e-bd1a-b3af973ee2a7)%20%E1%84%8C%E1%85%A5%E1%86%BC%2001c3a99b00254297a034d979d59a897d/Untitled%201.png](/images/posts/4715875a-e642-4b5e-bd1a-b3af973ee2a7)%20%E1%84%8C%E1%85%A5%E1%86%BC%2001c3a99b00254297a034d979d59a897d/Untitled%201.png)
    

- 방법2
    
    ![/images/posts/c1e2c5b9-c525-4d42-8dcc-7c3b845217d6.PNG](/images/posts/c1e2c5b9-c525-4d42-8dcc-7c3b845217d6.PNG)
    

### **HATEOAS**

- 방법1
    
    ![/images/posts/4715875a-e642-4b5e-bd1a-b3af973ee2a7)%20%E1%84%8C%E1%85%A5%E1%86%BC%2001c3a99b00254297a034d979d59a897d/Untitled%202.png](/images/posts/4715875a-e642-4b5e-bd1a-b3af973ee2a7)%20%E1%84%8C%E1%85%A5%E1%86%BC%2001c3a99b00254297a034d979d59a897d/Untitled%202.png)
    
- 방법2
    
    ![/images/posts/d693d56e-9d75-4aa2-b9ec-4a315e3ac4d2.PNG](/images/posts/d693d56e-9d75-4aa2-b9ec-4a315e3ac4d2.PNG)
    

![/images/posts/fc34674c-9fd3-4909-9474-29190614bba7.png](/images/posts/fc34674c-9fd3-4909-9474-29190614bba7.png)

## **참고**

- 그런 REST API로 괜찮은가-이응준 ([https://www.youtube.com/watch?v=RP_f5dMoHFc](https://www.youtube.com/watch?v=RP_f5dMoHFc))