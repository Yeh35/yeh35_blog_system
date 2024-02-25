%{
title: "RxJava 끝장내기 80b4acec01174b3eb583e938b2e488cf.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# RxJava 끝장내기

게시: Yes
생성일자: 2021년 5월 28일 오후 4:40
수정일자: 2021년 5월 29일 오전 12:40
태그: Develop, Reactive

- 목차

# 본격적으로 읽기전

최대한 핵심은 앞으로 특정한 기능들은 뒤로 빼려 노력을 하였다. 

하지만 아이러니하게도 실무에서 사용하기 위해서는 모든 내용을 알고 있어야한다.

이 글을 빠르게 읽기 위해서는 

1. 배경 지식을 확실히 익히고 온다.
2. 한번 빠르게 쭈우욱 끝까지 이해가 안되도 일단 넘어가며 읽는다.
3. 다시 처음으로 돌아와서 천천히 그리고 이해하며 읽는다.
4. 실전에서 Flowable과 Observable을 사용하거나, 
사용한 코드들을 보며 소계되지 않은 연산자들을 익힌다.

# 배경 지식

해당 내용을 알고 있다면 굳이 다시 읽을 필요는 없다.

- [람다식](https://www.notion.so/3f6f66f1354d40f8ab1c93f7fb6be7e3?pvs=21)
- [멀티 쓰레딩(비동기처리) With Java ](https://www.notion.so/With-Java-69e20b7b1d0147a7bd811a46c74d6fb7?pvs=21)

<aside>
💡 현재(21.03.25) 기준으로 `RxJava3` 까지 나왔다.
하지만 여기선 개념을 알아보는 것임으로 `RxJava2`를 이용한다.

</aside>

# 리액티브 프로그래밍이란?

**데이터가 통지될 때마다 관련 프로그램이 반응(reaction)해 데이터를 처리하는 프로그래밍 방식**이다.
데이터를 통지라고 했는데 `발행 구독 패턴` 혹은 `Observer 패턴과` 비슷한거라고 생각해도 된다.

중요한 것은 데이터의 흐름의 차이를 아는 것이다.

부가세를 계산하는 프로그램을 만들때 
기존 프로그래밍 방식으로 개발을 하면 `입력 → 행동 → 계산` 일것이다.

![/images/posts/229a8f18-5412-455c-9d57-fc8a13e2fcec.png](/images/posts/229a8f18-5412-455c-9d57-fc8a13e2fcec.png)

리액티브 프로그래밍은 `입력 → 통지 → 계산` 으로 개발을 하게된다.

![/images/posts/f30154a2-043f-4f54-99a5-38f0f54b6236.png](/images/posts/f30154a2-043f-4f54-99a5-38f0f54b6236.png)

기존 방식과의 차이점은 직집 텍스트 박스를 직접 참조하여 값을 읽어와 데이터를 처리했다면 리액티브는 **데이터를 생성하는 측(텍스트박스)에서 데이터를 전달하는 것까지 책임을 지고, 데이터를 소비하는 측에서는 데이터만 잘 처리하면 된다.**

이렇게 될 경우 각각의 프로그램의 책임이 확실히 분리되게 된다.
데이터를 생성하는 측은 소비하는 측을 몰라도 되고 소비하는 측도 생성하는 측을 몰라도 된다.

그럼으로 **데이터를 처리하는 중이라도 다음 데이터를 생성해도 됨으로 비동기 처리를 쉽게 구현**할 수 있다.

# RxJava 개요

.NET 프레임워크의 라이브러리로 `Reactive Extensions`가 2009년 처음 공개되고, 넷플릭스가 Java로 인식한 것이 RxJava이다.

## RxJava가 해결하려는 문제는?

1. **비동기 처리**를 적극적으로 사용하기 위해
자바에서 효율적인 비동기 처리를 하긴 쉽지 않다. 쓰레드들을 잘 관리해줘야하고, 동기화와 교착상태를 잘 관리해줘야한다. 하지만 **함수형 프로그래밍 포용하고, 복잡한 스레드 관리는 RxJava가 하도록 하는 것이다**.
2. **콜백 지옥**으로부터 탈출하기 위해
    
    콜백 지옥은 아래 이미지 하나로 표현이 가능하다.
    
    ![/images/posts/566091f0-9ca8-41e6-a800-97e9a91cc91d.png](/images/posts/566091f0-9ca8-41e6-a800-97e9a91cc91d.png)
    
    비동기 방식으로 동작하는 프로그램의 기본적인 패턴이 콜백이다. 
    이런 무자비한(?) 콜백은 가독성과 디버깅을 어렵게한다. **RxJava는 콜백을 사용하지 않은 방향으로 설계하여 지옥에서 지상으로 올라왔다.**
    

## RxJava1 → RxJava2 올라간 이유?

RxJava1 때는 자바에 `Reactive Extensions`를 이식하는 개발이 이뤄졌다. 

이후, 리액티브 프로그래밍 개념이 널리 퍼지면서 여러 업체와 단체에서 데이터스트림을 비동기로 다루는 여러 프레임워크들이 생겨났고 같은 일을 하는데도 구현이 서로 다 구현이 다른 상황이 발생했다.

이런 차이를 줄이고자, `**Reactive Streams` 라는 프레임워크 상관 없이 데이터 스트림을 비동기로 다룰 수 있는 공통 인터페이스**가 만들어졌다.

RxJava도 `Reactive Streams` 을 지원하기 위해 버전을 올리고, `Reactive Streams` 기준으로 내부 구현을 처음부터 다시 설계하였다.

<aside>
💡 `Reactive Streams` 도 `Reactive Extensions` 영향을 강하게 받아서 근본적인 개념(데이터 스트림, 생산자와 소비자)은 큰 차이가 없다.

</aside>

# Reactive Streams

[reactive-streams/reactive-streams-jvm](https://github.com/reactive-streams/reactive-streams-jvm/)

라이브러리나 프레임워크에 상관 없이 데이터 스트림을 비동기로 다룰 수 있는 공통 메커니즘으로, 이 메커니즘을 편리하게 사용할 수 있는 인터페이스를 제공

즉, Reactive Streams는 인터페이스만 제공하고 구현은 각 라이브러리와 프레임워크에서 한다.

<aside>
💡 바로 RxJava를 보지 않고 `Reactive Streams`을 보는 이유는 RxJava2 이상부터 `Reactive Streams`에 의존할뿐 아니라, 기본적은 Reactive에 흐름을 익히기 위해서이다.

</aside>

## 목표

Github에 있는 Reactive Streams의 목표를 요약했다.

> 비동기 처리를 하면서 가장 중요한 문제는 **데이터 처리가 예측가능한 범위에서 제어할 수 있게 하는 것**이다.
.....
Reactive Stream의 주된 목적은 **비동기의 경계를 명확히하여 스트림 데이터의 교환을 효과적으로 관리하는것**에 있습니다. 즉, **비동기로 데이터를 처리하는 시스템에 어느정도의 data가 들어올 지 예측가능하도록 하는것**입니다
> 

설명을 붙이자면 비동기 처리에서 데이터 처리가 예측 가능한 범위로 제어하기 위해, 데이터를 처리하는 개체끼리의 경계를 명확하게 나누고 각각의 개체 마다 처리 가능한 양의 데이터가 들어갈 수 있도록 제어가 목적이다.

### 이러한 목표를 달성하기 위해서 4가지 표준(사양)을 따른다.

1. 잠재적으로 무한한 숫자의 데이터 처리
2. 순서대로 처리
3. 컴포넌트간에 데이터를 비동기적으로 전달
4. **`backpressure`**를 이용한 데이터 흐름제어

## **backpressure(배압)?**

`backpressure`에 대해서 리엑티브 선언문에서는 다음과 같이 설명을 한다.

> 한 컴포넌트가 부하를 이겨내기 힘들 때, 시스템 전체가 합리적인 방법으로 대응해야 한다. 과부하 상태의 컴포넌트에서 치명적인 장애가 발생하거나 제어 없이 메시지를 유실해서는 안 된다. **컴포넌트가 대처할 수 없고 장애가 발생해선 안 되기 때문에 컴포넌트는 상류 컴포넌트들에 자신이 과부하 상태라는 것을 알려 부하를 줄이도록 해야 한다**. 이러한 배압은 시스템이 부하로 인해 무너지지 않고 정상적으로 응답할 수 있게 하는 중요한 피드백 방법이다. 배압은 사용자에게까지 전달되어 응답성이 떨어질 수 있지만, 이 메커니즘은 부하에 대한 시스템의 복원력을 보장하고 시스템 자체가 부하를 분산할 다른 자원을 제공할 수 있는지 정보를 제공할 것이다. 탄력성 (확장성과 대조) 참조.
> 

하지만 이것만 봤을 때는 그래서 어쩌라는 거지라는 생각이 든다.

간단하게, **데이터를 통지(전달) 받을 양이 처리 가능한 양보다 너무 많으면, 처리하지 못하고 컴포넌트에 장애가 발생할 수 있으니 자신이 처리할 수 있는 양만 통지 받도록 조절하는 걸 뜻한다.**

<aside>
💡 `Subscription` 의 request 메소드를 이용해서 얼마나 받을지 요청함

</aside>

## Reactive Streams 구성

`Reactive Streams`는 4개의 구성 요소(인터페이스)로 이뤄져있다.

- `Publisher` : 데이터를 생성하고 전달하는 생성자 인터페이스
- `Subscriber` : 통지된 데이터를 전달 받아 처리하는 소비자 인터페이스
- `Subscription` : 생성자에게 통지받을 데이터 개수를 요청하고, 구독을 해지하는 인터페이스
- `Processor` : `Publisher` 와 `Subscriber` 를 둘다 가지고 있는 인터페이스

```java
public interface Publisher<T> {
    public void subscribe(Subscriber<? super T> s);
}

public interface Subscriber<T> { 
    public void onSubscribe(Subscription s);
    public void onNext(T t);
    public void onError(Throwable t);
    public void onComplete();
}

public interface Subscription {
    public void request(long n);
    public void cancel();
}

public interface Processor<T, R> extends Subscriber<T>, Publisher<R> {}
```

기본적인 흐름은

1.  `Publisher`의 subscribe 메소드를 이용해서 `Subscriber` 의 구독 처리를 한다.
2. `Subscriber`는 onSubscribe가 호출되고, `Subscription`을 통해 데이터를 요청하거나, 구독을 해지한다.
3. 데이터를 요청하면 `Subscriber`에  onNext 메소드가 호출되고, `Subscription`을 통해 계속 데이터를 요청하거나, 구독을 해지한다.
4. 완료된 경우 Subscriber의 onComplete가 호출되고 에러인 경우 onError가 호출 된다.

![출처 : [https://grokonez.com/java/java-9-flow-api-reactive-streams](https://grokonez.com/java/java-9-flow-api-reactive-streams)](RxJava%20%E1%84%81%E1%85%B3%E1%87%80%E1%84%8C%E1%85%A1%E1%86%BC%E1%84%82%E1%85%A2%E1%84%80%E1%85%B5%2080b4acec01174b3eb583e938b2e488cf/Untitled%203.png)

출처 : [https://grokonez.com/java/java-9-flow-api-reactive-streams](https://grokonez.com/java/java-9-flow-api-reactive-streams)

## Reactive Streams 규칙

목표도, 구성도, 기본적인 흐름도 알아봤다.
하지만 Reactive Streams는 인터페이스로 전체적인 구조만 제공하기에 구현시 **Reactive Streams 규칙을 따라야 제대로 동작한다.**

<aside>
💡 더 많은 규칙을 확인하고 싶다면 [여기](https://github.com/reactive-streams/reactive-streams-jvm/)를 클릭

</aside>

### `Publisher` 규칙

- 구독 시작 통지(onSubscribe)는 해당 구독에서 한번만 발생한다.
- 통지는 순차적으로 이뤄진다.
- null은 통지하지 않는다.
- Publisher는 `onComplete(처리완료)`또는 `onError(에러)`를 통지해 구독이 종료됨을 알린다.

### `Subscription` 규칙

- 데이터 개수 요청에 **Long.MAX_VALUE**를 설정하면 데이터 통지 개수 제한이 없어진다.
- `Subscription` 는 동기화된 상태에서 호출되어야한다.
`Publisher` 와 `Subscriber` 가 멀티 쓰레드 환경에서 동작시 에러가 발생할 수 있다.

## 예제

Reactive Streams는 인터페이스만 제공함으로 예제를 해볼려면 각각의 인터페이스를 구현해야한다. 

그래도 예제가 보고 싶다면 아래 블록을 클릭하고 들어가면 된다.

[Java 9 Flow API example - Publisher and Subscriber " grokonez](https://grokonez.com/java/java-9-flow-api-example-publisher-and-subscriber)

# 환경 구축

`RxJava`는 version 2부터 `Reactive Streams`에 의존하기 때문에 직접 추가할 경우 두 라이브러리(.jar)를 모드 추가해야한다.

Gradle을 사용할 경우 아래와 같이 의존성만 추가하면 된다.

```groovy
dependencies {
    implementation "io.reactivex.rxjava2:rxjava:2.2.21"
}
```

# 기본 구조

RxJava에서 생산자와 소비자의 관계는 크게 두 가지로 나뉜다.

하나는 `Reactive Streams`를 지원하는 `Flowable(생산자)`과 `Subscriber(소비자)` , 
다른 하나는 `Reactive Streams`를 지원하지 `Obserable(생산자)`와 `Observer(소비자)` 이다.

둘의 차이는 **배압 기능이 있느냐 없느냐로 `Obserable`에는 배압 기능이 없다.**

<aside>
💡 `Obserable(생산자)`과 `Observer(소비자)`는 배압 기능이 없기 때문에 데이터 개수를 요청하지 않는다. 
그럼으로 `Subscription`을 사용하는 것이 아닌 구독 해지만 할 수 있는 `Disposable`을 사용한다.

</aside>

---

## 연산자

RxJava에서는 생산자가 통지한 데이터가 소비자에게 도착하기 전에 불필요한 데이터를 삭제하거나, 소비자가 사용하기 쉽게 데이터를 변환하는 등 통지되는 데이터를 변경해야 할 때가 있다.

그럴때 **데이터를 생성하거나, 필터링 또는 변환하는 메서드를 연산자라고 부른다.**

```java
Flowable<Integer> flowable = Flowable.just(1, 2, 3, 4, 5) //인자를 순서대로 통지하는 생성자
        .filter(data -> data % 2 == 0) // 필터기능으로 true인 경우에만 통지된다.
        .map(data -> data * 100); //통지되는 데이터를 한건씩 받아 변환한다.

flowable.subscribe(data -> System.out.println("data: " + data));

------ 결과 ------------
data: 200
data: 400
```

<aside>
💡 연산자 메소드는 기본적으로 Builder 패턴과 유사하지만, **연산자를 설정한 순서가 대로 작업을 수행함으로 주의**해야한다.

</aside>

전달 받은 데이터를 변경하거나 처리 작업이 외부에 어떤 변화를 주는 것을 **부가 작용**이라고 하는데, 이러한 **부가 작용의 주의할 점은 외부 상태 변경이 데이터 처리에 영향을 주기 때문에 책임 범위가 넓어지게 된다.**

**기본으로 부가 작용을 처리하는 메소드는 체인(연산자 메소드) 도중이 아니라 최종 데이터를 받아 처리하는 소비자에서 이뤄지는게 좋습니다.**

그리고, **함수형 인터페이스에서 부가 작용이 발생하지 않으면 멀티 쓰레드 환경에서 개체가 없게 되 스레드의 안전을 보장**할 수 있다.

---

## Cold / Hot 생산자

`Flowable(생산자)` , `Obserable(생산자)`로 나뉘었으면서 또 나뉘는 것일까

둘의 차이는 **타임라인**이다. 

기본적으로 통지를 시작하면 데이터 스트림에서 값을 하나씩 소비자에게 전달한다.
이때 **Code 생성자는 소비자가 구독할 때마다 새로운 타임라인을 생성하고, Hot 생성자는 이미 진행되고 있는 타임라인에 중간에 참가하는 것을 허용**한다.

RxJava에서 **생성 메서드(ex: just())로 생성된 생성자는 기본적으로 Cold 생성자**이다.

Hot 생성자는 `ConnectableFlowable`, `ConnectableObservable`이 있는데, Hot 생성자는 Cold 생성자를 Hot생성자로 변환하는 연산자를 통해 생성할 수 있다.

---

### Cold에서 Hot으로 변환하는 연산자 메소드

생성 메서드로 생성된 생성자는 기본적으로 Cold라고 했다.
Code 생성자를 Hot 생성자로 변환하는 연산자롤 통해 생성할 수 있다. 

- publish(): Hot 생성자로 변환하는 연산자
- replay() / replay(int bufferSize) / replay(long time, TimeUnit unit) :
이 연산자로 생성한 Hot 생성자는 **통지된 데이터를 캐시하고, 처리를 시작한 뒤에 구독하면 캐시된 데이터를 먼저  새로 구독한 소비자에게 통지하고, 그 뒤엔 모든 소비자에게 같은 데이터를 통지**한다.
- share() : 다른 메서드와 달리 `ConnectableFlowable/ConnectableObservable`를 생성하지 않는다.
`Flowable/Obsdervable`은 구독하는 소비자가 있는 동안은 도중에 새로 구독해도 같은 타임라인에 생성되는 데이터를 통지한다.

<aside>
💡 Hot 생성자는 소비자의 처리 속도가 느리면 소비자들이 같은 데이터를 같은 시점에 받지 않을 수 있음으로 주의를 해야한다.

</aside>

---

### Hot 생성자  `ConnectableFlowable`, `ConnectableObservable` 특성

Cold 생성자와 다르게 Hot 생성자는 subscribe 메소드로 구독을 한다고 해서 통지가 시작되지 않는다. 여러 생산자가 동시에 구독할 수 있기에 **`connect`메소드를 호출해야만 통지가 시작**된다.

그외에 Hot 생성자만의 메소드를 보면 

- refCount() : Hot에서 Cold(`Flowable`, `Obserable`)생성자 생성
- autoConnect() / autoConnect(int numberOfSubscribers) : 지정한 개수의 구독이 시작된 시점에 처리를 시작하는 Cold(`Flowable`, `Obserable`) 생성자 생성, 지정을 안했으면 처음부터 처리를 시작하는 생성자를 만든다.

---

### subscribe / subscribeWith 메소드

subscribe()는 소비자가 생선자를 구독하는 메서드로 소비자와 생선자를 연결하는 매우 중요한 메소드이다.

하지만 굳이 **소비자를 추가하지 않고 함수형 인터페이스를 사용해서 소비자를 대신**할 수 있다. 

하지만 이때 **구독은 취소해야함으로 반환값으로 `Disposable`을 준다.**

```java
public final Disposable subscribe() { ... }
public final Disposable subscribe(Consumer<? super T> onNext) { ... }
public final Disposable subscribe(Consumer<? super T> onNext, Consumer<? super Throwable> onError) { ... }
public final Disposable subscribe(Consumer<? super T> onNext, Consumer<? super Throwable> onError, Action onComplete) { ... }
public final Disposable subscribe(Consumer<? super T> onNext, Consumer<? super Throwable> onError, Action onComplete, Consumer<? super Disposable> onSubscribe) { ... }
```

그리고 subscribe()는 원래 void 메소드지만 **subscribeWith()을 사용하면 매게변수로 넣은 소비자를 구독처리하고 리턴한다.**

<aside>
💡 `**Disposable**`는 dispose()와 isDisposed() 메소드가 있어서 구독이 해지하거나, 해지되었는지 확인할 수 있다. 
제대로 해지를 안할 경우 메모리 누수가 발생할 수 있다.

</aside>

---

## 비동기 처리(스케줄러)

RxJava는 **데이터를 통지하는 측의 처리 범위와 데이터를 받는 측의 처리 범위를 분리**할 수 있게 설계가 되어서 각각의 처리를 서로 다른 스레드에서 실행할 수 있다.

스레드를 관리하지 않고 **각 처리 목적에 맞춰 스레드 스케줄러를 제공**한다.

<aside>
💡 **기본적으로 따로 스케줄러를 설정하지 않았다면 생성자의 스레드를 소비자도 사용**한다.

</aside>

먼저 따로 스케줄러를 지정하지 않고 실행하는 코드를 보자

```java
public void 같은스레드에서동작() throws InterruptedException {
    Flowable.interval(1L, TimeUnit.SECONDS)
      .doOnNext(data -> {
          System.out.println("doOnNext[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
      })
      .subscribe(data -> {
          Thread.sleep(2000);
          System.out.println("Subscribe[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
      });

    Thread.sleep(10000L);
}
```

```
doOnNext[RxComputationThreadPool-1](1620314573468) : 0
Subscribe[RxComputationThreadPool-1](1620314575507) : 0
doOnNext[RxComputationThreadPool-1](1620314575507) : 1
Subscribe[RxComputationThreadPool-1](1620314577519) : 1
doOnNext[RxComputationThreadPool-1](1620314577519) : 2
Subscribe[RxComputationThreadPool-1](1620314579539) : 2
doOnNext[RxComputationThreadPool-1](1620314579539) : 3
Subscribe[RxComputationThreadPool-1](1620314581539) : 3
doOnNext[RxComputationThreadPool-1](1620314581539) : 4
```

같은 스레드 그리고 생성자와 소비자가 순서대로 호출되는걸 볼 수 있다.

### 제공되는 스케줄러

RxJava에서는 스레드를 관리하는 스케줄러 클래스를 제공한다. 
Class 이름은 `Schedulers`이다. ****사용하고 싶다면 `Schedulers.io()` 같이 필요한 스케줄러를 메소드로 호출하면 된다.

[Schedulers를 가져오는 메서드 ](RxJava%20%E1%84%81%E1%85%B3%E1%87%80%E1%84%8C%E1%85%A1%E1%86%BC%E1%84%82%E1%85%A2%E1%84%80%E1%85%B5%2080b4acec01174b3eb583e938b2e488cf/Schedulers%E1%84%85%E1%85%B3%E1%86%AF%20%E1%84%80%E1%85%A1%E1%84%8C%E1%85%A7%E1%84%8B%E1%85%A9%E1%84%82%E1%85%B3%E1%86%AB%20%E1%84%86%E1%85%A6%E1%84%89%E1%85%A5%E1%84%83%E1%85%B3%20dcf5f69bb3f24229add473d5fad6cd0d.csv)

### 스케줄러 설정하기

생성자에 스케줄러를 설정은 `subscribeOn`메서드를 사용하고,
데이터를 받는 측의 처리 작업을 진행할 스케줄러 설정은 `observeOn`메서드를 사용한다.

위에 코드에 `subscribeOn`와 `observeOn`를 적용시켜보면 

```java
public void 다른스레드에서동작() throws InterruptedException {
  Flowable.interval(1L, TimeUnit.SECONDS)
          .doOnNext(data -> {
              System.out.println("doOnNext[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
          })
          .subscribeOn(Schedulers.newThread())
          .observeOn(Schedulers.newThread())
          .subscribe(data -> {
              Thread.sleep(2000);
              System.out.println("Subscribe[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
          });

  Thread.sleep(10000L);
}
```

```
doOnNext[RxComputationThreadPool-1](1620317972264) : 0
doOnNext[RxComputationThreadPool-1](1620317973264) : 1
doOnNext[RxComputationThreadPool-1](1620317974274) : 2
Subscribe[RxNewThreadScheduler-1](1620317974284) : 0
doOnNext[RxComputationThreadPool-1](1620317975274) : 3
doOnNext[RxComputationThreadPool-1](1620317976276) : 4
Subscribe[RxNewThreadScheduler-1](1620317976298) : 1
doOnNext[RxComputationThreadPool-1](1620317977263) : 5
doOnNext[RxComputationThreadPool-1](1620317978274) : 6
Subscribe[RxNewThreadScheduler-1](1620317978314) : 2
doOnNext[RxComputationThreadPool-1](1620317979264) : 7
doOnNext[RxComputationThreadPool-1](1620317980262) : 8
Subscribe[RxNewThreadScheduler-1](1620317980324) : 3
doOnNext[RxComputationThreadPool-1](1620317981271) : 9
```

 둘다 다른 스레드에서 작동하는 걸 확인할 수 있다.

<aside>
💡 `subscribeOn`는 최초 1회만 설정된다. 
여러개 설정하여도 처음 이후로는 전부 무시된다.

</aside>

### `observeOn` 제대로 사용하기

![/images/posts/6f20d047-c194-48c6-bc9c-f62f47c44318.png](/images/posts/6f20d047-c194-48c6-bc9c-f62f47c44318.png)

<aside>
📌 `observeOn`는 데이터를 받는 연산자에게 스케줄러를 지정하는 것으로 연산자마다 다른 스케줄러를 지정할 수 있다. 
`observeOn`다음에 온 연산자 혹은 소비자는 지정한 스케줄러로 동작한다.

</aside>

`observeOn` 메소드는 Scheduler 이외에 파라미터 2개가 더 있다.
`observeOn(Scheduler scheduler, boolean delayError, int bufferSize)`

- `boolean delayError`
    
    true로 주면 에러가 발생해도 바로 에러를 통지하는 것이 아닌 버퍼에 들어간 값을 모두 통지후에 에러를 통지한다. 이때 기본 값은 false이다.
    
- `int bufferSize`
    
    통지를 기다리는 데이터 버퍼의 크기로, 기본 값은 128이다.
    

아래 코드에서는 Buffer을 넘으면 값을 버리는 것으로 설정했는데 해당 줄을 주석하면 버퍼가 해소될때까지 `map`연산자는 대기하게 된다.

```java
Flowable.interval(500L, TimeUnit.MILLISECONDS)
  .doOnNext(data -> {
      System.out.println("doOnNext[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
  })
  .observeOn(Schedulers.newThread())
  .map(data -> {
      System.out.println("map[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
      return data;
  })
  .onBackpressureDrop() // 버퍼를 초과하면 값을 버림 설정
  .observeOn(Schedulers.newThread(), true, 1)
  .subscribe(data -> {
      Thread.sleep(1000);
      System.out.println("Subscribe[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
  });

Thread.sleep(5000L);
```

```
doOnNext[RxComputationThreadPool-1](1620321725847) : 0
map[RxNewThreadScheduler-2](1620321725871) : 0
doOnNext[RxComputationThreadPool-1](1620321726337) : 1
map[RxNewThreadScheduler-2](1620321726337) : 1
doOnNext[RxComputationThreadPool-1](1620321726840) : 2
map[RxNewThreadScheduler-2](1620321726840) : 2
Subscribe[RxNewThreadScheduler-1](1620321726880) : 0
doOnNext[RxComputationThreadPool-1](1620321727343) : 3
map[RxNewThreadScheduler-2](1620321727343) : 3
doOnNext[RxComputationThreadPool-1](1620321727842) : 4
map[RxNewThreadScheduler-2](1620321727842) : 4
Subscribe[RxNewThreadScheduler-1](1620321728346) : 3
doOnNext[RxComputationThreadPool-1](1620321728346) : 5
map[RxNewThreadScheduler-2](1620321728346) : 5
doOnNext[RxComputationThreadPool-1](1620321728842) : 6
map[RxNewThreadScheduler-2](1620321728842) : 6
doOnNext[RxComputationThreadPool-1](1620321729336) : 7
map[RxNewThreadScheduler-2](1620321729336) : 7
Subscribe[RxNewThreadScheduler-1](1620321729352) : 5
doOnNext[RxComputationThreadPool-1](1620321729837) : 8
map[RxNewThreadScheduler-2](1620321729837) : 8
doOnNext[RxComputationThreadPool-1](1620321730345) : 9
map[RxNewThreadScheduler-2](1620321730345) : 9
```

빨간색으로 표시된 Subscribe를 보면 버퍼를 넘어가니 연속된 것이 아니라 중간에 값이 없게 된다.

## 비동기 연산자

RxJava 연산자 중에 **연산자 내부에서 Flowable/Observable을 생성하고 이를 시작한 뒤 데이터를 통지하는 메서드**를 알아볼 것이다.

### flatMap 연산자

![/images/posts/96120ea9-2143-4bb2-a905-ccebb130e1ea.png](/images/posts/96120ea9-2143-4bb2-a905-ccebb130e1ea.png)

데이터를 받으면 새로운 Flowable/Observable(생성자)을 생성하고, 실행해 새로운 생성자에서 통지되는 데이터를 다시 통지하는 연산자이다.

- **Code**
    
    ```java
    public void flatMap사용해보기() throws Exception {
      Flowable.just(1, 2, 3, 4, 5)
          .flatMap(data -> Flowable.just(data) // 새로운 생성자 생성
                  .delay(1000L, TimeUnit.MILLISECONDS) // 지연시키는 메서드
                  .doOnNext(it -> {
                      System.out.println("doOnNext[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + it);
                  }))
          .subscribe(data -> {
              System.out.println("Subscribe[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
          });  // 결과 출력
    
      Thread.sleep(5500L);
    }
    ```
    
    ```
    doOnNext[RxComputationThreadPool-4](1620402403682) : 4
    doOnNext[RxComputationThreadPool-3](1620402403682) : 3
    doOnNext[RxComputationThreadPool-2](1620402403682) : 2
    doOnNext[RxComputationThreadPool-5](1620402403682) : 5
    doOnNext[RxComputationThreadPool-1](1620402403684) : 1
    Subscribe[RxComputationThreadPool-4](1620402403730) : 4
    Subscribe[RxComputationThreadPool-4](1620402403739) : 1
    Subscribe[RxComputationThreadPool-4](1620402403739) : 2
    Subscribe[RxComputationThreadPool-4](1620402403739) : 3
    Subscribe[RxComputationThreadPool-4](1620402403739) : 5
    ```
    

그림과 코드 결과처럼 각 다른 스레드에서 동작하고 결과를 Return함으로 **데이터 순서를 보장받지 못한다**. 

<aside>
📌  실행 순서와 상관 없이 처리 성능이 중요할 때는 사용하지만, 데이터 순서가 중요하다면 flatMap을 사용하지 않는 편이 좋다.

</aside>

### concatMap 연산자

concatMap 연산자도 flatMap 처럼 새로운 Flowable/Observable을 생성하고, 각 다른 스레드에서 동작하게 하지만, 데이터 순서를 지키기 위해 앞 생성자가 종료되면 다음 생성자와 스레드를 만든다.

![/images/posts/1cb8a360-ad81-490a-b9f9-bd5fde9372b5.png](/images/posts/1cb8a360-ad81-490a-b9f9-bd5fde9372b5.png)

- **Code**
    
    ```java
    public void concatMap사용해보기() throws Exception {
        Flowable.just(1, 2, 3, 4, 5)
                .concatMap(data -> Flowable.just(data) // 새로운 생성자 생성
                        .delay(1000L, TimeUnit.MILLISECONDS) // 지연시키는 메서드
                        .doOnNext(it -> {
                            System.out.println("doOnNext[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + it);
                        }))
                .subscribe(data -> {
                    System.out.println("Subscribe[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
                });  // 결과 출력
    
        Thread.sleep(5500L);
    }
    ```
    
    ```
    doOnNext[RxComputationThreadPool-1](1620402797384) : 1
    Subscribe[RxComputationThreadPool-1](1620402797407) : 1
    doOnNext[RxComputationThreadPool-2](1620402798411) : 2
    Subscribe[RxComputationThreadPool-2](1620402798411) : 2
    doOnNext[RxComputationThreadPool-3](1620402799414) : 3
    Subscribe[RxComputationThreadPool-3](1620402799414) : 3
    doOnNext[RxComputationThreadPool-4](1620402800430) : 4
    Subscribe[RxComputationThreadPool-4](1620402800430) : 4
    doOnNext[RxComputationThreadPool-5](1620402801432) : 5
    Subscribe[RxComputationThreadPool-5](1620402801432) : 5
    ```
    

<aside>
📌 앞에 작업이 완료되면 다음 생성자와 스레드를 시작함으로, 성능에 관계없이 데이터 순서가 중요할 때는 사용하는게 좋다. (하지만 성능이 중요하다면 비추)

</aside>

### concatMapEager

앞선 flatMap, concatMap 과 동일하게 새로운 Flowable/Observable을 생성하고, 생성자를 멀티 스레드로 한번에 실행한다.
그리고 **데이터 순서를 보장받기 위해 Buffer에 값을 보관하고 하고 있다가 앞선 생성자가 완료되면 다음 생성자의 데이터를 통지**한다.

![/images/posts/5b75a768-42f2-4056-9833-9b8357ff89e7.png](/images/posts/5b75a768-42f2-4056-9833-9b8357ff89e7.png)

- **Code**
    
    ```java
    public void concatMapEager사용해보기() throws Exception {
        Flowable.just("A", "B", "C")
                .concatMapEager(data -> Flowable.create(emitter -> {
                    for (int i = 0; i < 3; i++) {
                        emitter.onNext(data);
                    }
                    emitter.onComplete();
                }, BackpressureStrategy.BUFFER) // 새로운 생성자 생성
                        .delay(100L, TimeUnit.MILLISECONDS) // 지연시키는 메서드
                        .doOnNext(it -> {
                            System.out.println("doOnNext[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + it);
                        })
                )
                .subscribe(data -> {
                    System.out.println("Subscribe[" + Thread.currentThread().getName() + "](" + System.currentTimeMillis() + ") : " + data);
                });  // 결과 출력
    
        Thread.sleep(10000L);
    }
    ```
    
    ```
    doOnNext[RxComputationThreadPool-2](1620480238647) : B
    doOnNext[RxComputationThreadPool-3](1620480238647) : C
    doOnNext[RxComputationThreadPool-2](1620480238714) : B
    doOnNext[RxComputationThreadPool-2](1620480238715) : B
    doOnNext[RxComputationThreadPool-1](1620480238647) : A
    doOnNext[RxComputationThreadPool-3](1620480238715) : C
    doOnNext[RxComputationThreadPool-3](1620480238715) : C
    Subscribe[RxComputationThreadPool-1](1620480238715) : A
    doOnNext[RxComputationThreadPool-1](1620480238717) : A
    Subscribe[RxComputationThreadPool-1](1620480238718) : A
    doOnNext[RxComputationThreadPool-1](1620480238718) : A
    Subscribe[RxComputationThreadPool-1](1620480238718) : A
    Subscribe[RxComputationThreadPool-1](1620480238718) : B
    Subscribe[RxComputationThreadPool-1](1620480238718) : B
    Subscribe[RxComputationThreadPool-1](1620480238718) : B
    Subscribe[RxComputationThreadPool-1](1620480238718) : C
    Subscribe[RxComputationThreadPool-1](1620480238718) : C
    Subscribe[RxComputationThreadPool-1](1620480238718) : C
    ```
    

<aside>
📌 데이터 순서와 성능 모두가 중요하다면 concatMapEager가 적합하다.
하지만 데이터를 버퍼에 쌓아야 해서 **대량의 데이터가 버퍼에 쌓이면 메모리가 부족해질 수 있는 위험**이 있다.

</aside>

### merge 메서드

RxJava를 사용하다보면 두개의 생성자가 같은 소비자를 이용할 경우가 생긴다.
이때 각각 소비자를 new(만들어서) 넣을 경우 스레드가 달라 공유객체에 접근할때 값이 꼬일 수 있다. 

이 문제를 해결하기 위해 **여러 개의 Flowable/Observable을 한개의 Flowable/Observable로 결합해주는 merge라는 메서드를 제공**한다. 

- **Code**
    
    ```java
    public void merge사용하기() throws Exception {
        Counter counter = new Counter();
    
        Flowable<Integer> flowable1 = Flowable.range(1, 10000)
                .subscribeOn(Schedulers.newThread())
                .observeOn(Schedulers.newThread());
    
        Flowable<Integer> flowable2 = Flowable.range(1, 10000)
                .subscribeOn(Schedulers.newThread())
                .observeOn(Schedulers.newThread());
    
        Flowable.merge(flowable1, flowable2)
                .subscribe(data -> counter.increment(),
                        Throwable::printStackTrace,
                        () -> System.out.println(counter.get()));
    
        Thread.sleep(1000L);
    }
    
    class Counter {
        private volatile int count;
    
        void increment() {
            count++;
        }
    
        int get() {
            return count;
        }
    }
    ```
    
    ```
    20000
    ```
    

## 에러 처리

에러 중에는 작업을 멈춰야하는 에러가 있는 반면 순간 네트워크가 중단처럼 재시도가 가능한 에러가 있다. 이에 맞게 RxJava에서는 3가지 에러 처리 방법을 제공한다.

- **소비자에게 에러 통지**
    
    처리 도중에 에러가 발생하면 에러를 던지고 처리를 중단하는 것이 아니라, **기본적으로 소비자에게 발생한 에러를 통지하게 되어 있다.**
    
    특히 비동기 처리중 에러가 발생한 경우, 소비자에게 에러를 전달하지 않으면 소비자에서 제대로 동작을 종료할 수 없게 된다. (무한 대기..)
    
    `onError(Throwable t)`메소드를 통해 에러를 통지하고 받는다.
    
- **처리 재시도**
    
    순간적인 네트워크 중단 같이 재시도 혹은 재실행을 하면 정상적으로 처리할 수 있을 때도 있다.
    이와 같은 에러를 처리하고자 하는 경우 RxJava에서는 `**retry` 메서드를 통해**  **생산자의 처리 작업을 처음부터 다시 시도함으로 에러 상황에서 회복할 방법을 제공한다, 이때 소비자에게 에러는 통지되지 않는다.**
    
    - **Code**
        
        ```java
        public void retry사용해보기() throws Exception {
        
            Flowable.create(emitter -> {
                for (int i = 0; i < 3; i++) {
                    System.out.println("Flowable : " + i);
                    emitter.onNext(i);
        
                    if (i == 2) {
                        throw new IOException();
                    }
                }
                emitter.onComplete();
            }, BackpressureStrategy.BUFFER)
                    .retry(2, error -> error.getClass() == IOException.class) // 두번 재시도
                    .subscribe(data -> System.out.println("subscribe : " + data),
                            throwable -> System.out.println("에러 발생 : " + throwable.getMessage()));
        
            Thread.sleep(1000L);
        }
        ```
        
        ```
        Flowable : 0
        subscribe : 0
        Flowable : 1
        subscribe : 1
        Flowable : 2
        subscribe : 2
        Flowable : 0
        subscribe : 0
        Flowable : 1
        subscribe : 1
        Flowable : 2
        subscribe : 2
        Flowable : 0
        subscribe : 0
        Flowable : 1
        subscribe : 1
        Flowable : 2
        subscribe : 2
        에러 발생 : java.io.IOException
        ```
        
    
    <aside>
    📌 특정 에러에 대해서만 재시도를 하거나, 에러를 판별한 후에 재시도를 하게 한다고 해도 재시도 횟수를 제안은 꼭 해야한다.
    
    </aside>
    
    `retry` 메서드 말고도 `retryWhen`메서드는 재시도하기 위한 Flowable/Observable을 생성하는 함수형 인터페이스를 인자로 받아 재시도를 제어할 수 있다.
    
- **대체 데이터 통지**
    
    에러가 발생하면 대체 데이터 통지 후 작업완료처리 하는 방법도 있다.
    이를 위해 RxJava에서는 `onError`, `onException`으로 시작하는 연산자가 있다.
    
    - **Code**
        
        ```java
        public void onError사용해보기1() throws Exception {
            Flowable.just(1, 3, 4, 0, 2)
                    .map(data -> 100 / data)
                    .onErrorReturnItem(0) // 0으로 대체
                    .subscribe(data -> System.out.println("subscribe : " + data),
                            error -> System.out.println("에러 발생 : " + error));
        }
        
        public void onError사용해보기2() throws Exception {
            Flowable.just(1, 3, 4, 0, 2)
                    .map(data -> 100 / data)
                    .onErrorResumeNext(s -> { // Publisher 받아서 처리
                        s.onNext(0);
                        s.onComplete();
                    })
                    .subscribe(data -> System.out.println("subscribe : " + data),
                            error -> System.out.println("에러 발생 : " + error));
        }
        ```
        
        ```
        subscribe : 100
        subscribe : 33
        subscribe : 25
        subscribe : 0
        ```
        

---

## 리소스 관리

File이나, DB 커넥션 같은 리소스는 사용후에 해제를 해야한다.
RxJava에서 리소스를 Flowable/Observable의 라이프 사이클 에 맞춰 생성하고 해지할 수 있다.

## using 메서드

using 메서드를 이용해 리소스의 라이프사이클에 맞춘 Flowable/Observable을 생성할 수 있다.
이 메서드는 처리 작업을 함수형 인터페이스로 제공한다.

1. 리소스 얻기
2. Flowable/Observable 생성 및 통지
3. 리소스 해제

```java
using(Callable<? extends D> resourceSupplier, // 리소스 얻기
      Function<? super D, ? extends Publisher<? extends T>> sourceSupplier, // 생산자
      Consumer<? super D> resourceDisposer, boolean eager) // 리소스 해제
```

<aside>
📌 Flowable/Observable의 라이프 사이클은 소비자가 구독이 되어 통지가 시작할때부터, 완료될때까지 이다.

</aside>

### FlowableEmitter / ObservableEmitter

Flowable/Observable의 create 메서드 내부에서 사용하는 FlowableEmitter/ObservableEmitter도 리소스를 해제하는 콜백 메서드가 있다.
아래와 같이 사용한다.

```java
Flowable.create(emitter -> {
    emitter.setDisposable();
    emitter.setCancellable();
}, BackpressureStrategy.BUFFER);
```

- **setCancellable 메서드**
    
    `Cancellable` 인터페이스를 설정해서 구독이 취소될 때(완료통지, 에러통지 또는 중독 구독 해지) `cancel`메서드가 실행된다.
    
    ```java
    public interface Cancellable {
    
        /**
         * Cancel the action or free a resource.
         * @throws Exception on error
         */
        void cancel() throws Exception;
    }
    ```
    
- **setDisposable 메서드**
    
    `Disposable` 인터페이스를 설정해서, 완료 에러를 통지한 후나, 구독을 중도에 해지했을 때 dispose 메서드가 실행된다.
    
    ```java
    public interface Disposable {
        /**
         * Dispose the resource, the operation should be idempotent.
         */
        void dispose();
    
        /**
         * Returns true if this resource has been disposed.
         * @return true if this resource has been disposed
         */
        boolean isDisposed();
    }
    ```
    

<aside>
📌 Cancelable과 Disposable을 함께 설정할 수는 없다.
setCancelable가 내부에서 setDisposable 메서드를 호출해 Cacellable을 Disposable로 감싸서 설정하게 된다.

</aside>

---

## 배압

배압이란 데이터 통지량을 제거하는 기능을 뜻한다.
이 기능은 **Reactive Streams에서는 필수 기능으로 Flowable에서는 제공하지만, Reactive Streams를 따르지 않는 Observable에서는 제공되지 않는다.**

<aside>
📌 베압은 생성자와 소비자가 다른 스레드에서 동작할 때 데이터를 소비되는 속도보다 통지보다가 빠를 때 필요하다.
통지되는 속도가 더 빠르면 데이터는 대기하게 되고, 대기중엔 데이터를 처리할 방법을 설정해줘야한다.

</aside>

배압 상태를 설정은 `BackpressureStrategy` enum으로 종류를 선택한다. 

```java
Flowable.create(emitter -> {
	//마법같은 일
	}, **BackpressureStrategy.BUFFER**);
```

### request 메서드

소비자가 생산자에게 데이터 개수를 요청할 때 사용되는 메서드이다. 

소비자가 `Subscription.request(long n)`로 n개의 데이터를 요청하면 `onNext` 메서드 통해 데이터가 통지된다. 이때 n에 `Long.MAX_VALUE`를 하게 되면 무제한으로 데이터를 통지한다.

### MissingBackpressureException

Flowable이 **버퍼에 쌓아둔 데이터가 너무 많아지면 기본적으로 MissingBackpressureException을 던지게 된다.**

```java
Flowable.interval(10L, TimeUnit.MILLISECONDS)
      .observeOn(Schedulers.newThread())
      .subscribe(data -> {
          Thread.sleep(1000);
          System.out.println(data);
      }, System.out::println);
```

```
0
1
io.reactivex.exceptions.MissingBackpressureException: Can't deliver value 128 due to lack of requests
```

데이터는 10ms만에 생성되지만 소비는 1000ms에 됨으로 기본 버퍼인 128을 2초만에 넘어가게 되어 MissingBackpressureException이 발생하였다.

MissingBackpressureException이 발생했다고 나쁜 것만은 아니다.
데이터 한건한건이 결제나, 유저의 요청일 경우에는 전부 처리를 해줘야하지만, 스마트폰에서 위치 정보에서 현재 위치만 알고 있고자 할 경우에는 넘는 데이터는 폐기하여도 된다.
물론 Rxjava에서는 이런 상황때 어떻게 처리할지 옵션을 제공한다. 

### BackpressureStrategy

BackpressureStrategy는 **Flowable이 어떤 방법으로 통지를 기다리는 데이터를 어떻게 다룰지 설정한 배압 종류**이다. 

[BackpressureStrategy 종류](RxJava%20%E1%84%81%E1%85%B3%E1%87%80%E1%84%8C%E1%85%A1%E1%86%BC%E1%84%82%E1%85%A2%E1%84%80%E1%85%B5%2080b4acec01174b3eb583e938b2e488cf/BackpressureStrategy%20%E1%84%8C%E1%85%A9%E1%86%BC%E1%84%85%E1%85%B2%20cacf0115157b4fd49d2a0e38882118df.csv)

## 데어터양 제어하기

배압 기능으로 데이터 통지를 제어하는 것이 아니라 통지하는 데이터를 별도의 메서드로 유연하게 제어하는 기능도 제공한다. 이건 Flowable뿐 아니라 Observable에서도 사용할 수 있다.

<aside>
📌 스로틀링이란 **대량으로 받은 데이터를 모두 흘려내보내는 것이 아니라 제한을 두고 지정된 기간 조건에 맞는 데이터만 통지하는 메서드**이다.

예를들어 텍스트 입력중에 대상이 될 만한 어구를 표시하는 기능이 있다고 했을 때, 텍스트를 입력할 때 마다 해당 데이터를 검색하면 검색 시간이 걸림으로, 입력중에 약간의 간격이 있을 때만 검색하게  해서 리소스를 아끼는 기능들을 뜻한다.

</aside>

### buffer 메서드와 window 메서드

**통지하는 모든 데이터가 필요하다면 매번 각각의 데이터를 받아 처리할 것이 아니라 리스트 등에 어느정도 데이터를 모아 처리하는 편이 효율적일 때**가 있다.

예시로 DB에 `where data = ?`로 모든 데이터를 검색하는 것보다 `where data in (?, ?, ?)`로 처리하는 것이 효율적일 때도 있다. 

buffer는 데이터를 리스트와 같은 컬렉션에 저장한 후 통지하는 기능을 제공하고,

window는 데이터를 모아 놓은 Flowable이나, Observable을 통지한다.

# 사용해보기

### Flowable 사용해보기

```java
Flowable<String> flowable =
        Flowable.create(new FlowableOnSubscribe<String>() {
            @Override
            public void subscribe(@NonNull FlowableEmitter<String> emitter) throws Exception {
                String[] datas = {"Hello", "World!"};

                for (String data : datas) {
                    if (emitter.isCancelled()) { // 구독이 해지되었는지 확인한다.
                        return;
                    }

                    System.out.println(emitter.hashCode() + ".onNext(" + data + ")");
                    emitter.onNext(data); //데이터 통지
                }

                System.out.println(emitter.hashCode() + ".onComplete()");
                emitter.onComplete(); // 완료 통지
            }
        }, BackpressureStrategy.BUFFER); //초과한 데이터는 버퍼링

	flowable.observeOn(Schedulers.computation()) //소비자가 실행될 스레드 설정(여기선 개별 스레드)
        .subscribe(new Subscriber<String>() {
            private Subscription subscription; //데이터 개수 요청과, 구독 해지를 하는 개체

            @Override
            public void onSubscribe(Subscription s) {
                this.subscription = s;
                this.subscription.request(1L); // 받을 데이터 개수 요청
            }

            @Override
            public void onNext(String data) {
                String threadName = Thread.currentThread().getName();
                System.out.println(threadName + " : " + data);
                this.subscription.request(1L);
            }

            @Override
            public void onError(Throwable t) {
                t.printStackTrace();
            }

            @Override
            public void onComplete() {
                String threadName = Thread.currentThread().getName();
                System.out.println(threadName + " : 완료");
            }
        });

Thread.sleep(500L);

/*------------결과--------------
1709366259.onNext(Hello)
1709366259.onNext(World!)
1709366259.onComplete()
RxComputationThreadPool-1 : Hello
RxComputationThreadPool-1 : World!
RxComputationThreadPool-1 : 완료
*/
```

간단한 HelloWorld를 통지하는 생성자였다. 
여기서 주의 깊게 봐야할 것은 **생성자에서 emitter.onNext()가 호출하는 시점과 소비자가 onNext() 메소드가 호출되는 시점의 차이**와 **소비자에서 `Subscription` 를 통해 데이터를 요청(배압)하는 부분**이다.

우리는 어떤 데이터를 통지할지만 작성하고, 각 소비자에게 언제 얼마나 통지될지는 RxJava에서 처리가 된다. 

BackpressureStrategy의 옵션을 변경하여, 배압의 전략을 선택할 수 있다.

- BUFFER : 통지할 수 있을 때까지 모든 데이터를 버퍼링
- DROP : 통지할 수 있을 떄까지 새로 생성한 데이터를 삭제
- LATEST : 생성한 최신 데이터만 버퍼링하고 생성할 때마다 버퍼링하는 데이터를 교환
- ERROR: 통지 대기 데이터가 버퍼 크기를 초기하면 `MissingBackpressureException` 에러 통지

### Observable 사용해보기

Flowable과 거의 비슷하지만 다른 점은 배압기능이 없다는 것이다.

```java
public static void observable사용해보기() throws InterruptedException {
    Observable<String> observable =
            Observable.create(new ObservableOnSubscribe<String>() {
                @Override
                public void subscribe(@NonNull ObservableEmitter<String> emitter) throws Exception {
                    String[] datas = {"Hello", "World!"};

                    for (String data : datas) {
                        if (emitter.isDisposed()) {
                            // 구독이 해지되면 처리를 중단
                            return;
                        }
                        emitter.onNext(data); //데이터 통지
                    }

                    emitter.onComplete(); // 완료 통지
                }
            });

    observable.observeOn(Schedulers.computation()) // 소비자 개별 스레드 실행
            .subscribe(new Observer<String>() {
                private Disposable disposable;

                @Override
                public void onSubscribe(@NonNull Disposable d) {
                    disposable = d; // 구독 해지가 필요할 경우를 대배
                }

                @Override
                public void onNext(@NonNull String data) {
                    String threadName = Thread.currentThread().getName();
                    System.out.println(threadName + " : " + data);
                }

                @Override
                public void onError(@NonNull Throwable e) {
                    e.printStackTrace();
                }

                @Override
                public void onComplete() {
                    String threadName = Thread.currentThread().getName();
                    System.out.println(threadName + " : 완료");
                }
            });

    Thread.sleep(500L);
}
```

`Observable`은 배압기능이 없기에 소비자의 코드가 조금 더 짧은 것을 볼 수 있다.

그외는 `Flowable`과 동일함으로 딱히 설명할게 없다.

## Flowable vs Observable

둘 중 어느 것을 사용하는게 좋을까? 라는 고민이 남는다.

일반적으로 Observable이 Flowable보다 오버헤드가 적다고 알려져있다.
하지만 상황에 따라서 선택해야한다.

### Flowable을 사용하는 경우

- 대량의 데이터(ex: 10,000건 이상)을 처리할 때
- 네트워크 통신이나 데이터베이스 등의 I/O 처리를 할 때

### Observable을 사용하는 경우

- 소량의 데이터(ex: 1,000건 이하)를 처리할 때
- GUI 이벤트
- 데이터 처리가 동기 방식이고, Java Stream을 대신 사용할 떄

# RxJava 기본 구성 중간 정리

RxJava는 소비자가 생성자를 구독하는 형태이다.
이  생산자와 소비자의 관계는 `Reactive Streams`사양을 지원하는 `Flowable/Subscriber`과 지원하지 않는 `Observable/Observer` 로 두가지 형태가 있다.

그 둘의 차이는 배압이 존재 여부였고, `Flowable/Subscriber`는 배압 기능이 있다.
 `Flowable/Subscriber`은 `Subscription` , `Observable/Observer` 은 `Disposable`이라는 생선자와 소비자 사이에 공유(연결)되는 개체가 존재한다.

### 통지시 규칙

RxJava에서 데이터를 통지할때 아래의 규칙을 따라서 통지를 해야 예상하는 결과를 받을 수 있다.

- **null을 통지하면 안된다.**
- 데이터 통지는 해도 되고 안 해도 된다.
- 생성자는 처리를 끝낼때 완료나 에러 통지를 하며 끝내야하고, 둘 다 통지하지는 않는다.
- **완료나 에러 통지를 한 뒤에는 다른 통지를 해서는 안된다.**
- 통지할 때는 1건씩 순차적으로 통지하며, 동시에 통지하면 안된다.

## 다른 클래스

대표적인 `Flowable`과 `Observable`말고도 뭐가 있는지 알아보자

<aside>
💡 대충 그런것들이 있었구나 하고 넘어간 다음 사용할 때 찾아서 쓰면 된다.

</aside>

### FlowableProcessor/Subject

Reactive Streams에서 생산자(`Publisher`)와 소비자(`Subscriber`)를 모두 상속받은 `Processer`인터페이스가 있다.

RxJava에도 `Processer`을 상속 받은 `FlowableProcesser`가 존재하고, `Processer`을 상속받지는 않았지만 비슷하게 `Observable`과 `Observer`의 기능을 둘 다 하는 `Subject`클래스가 존재한다.

`**FlowableProcessor`과 `Subject`는 추상 클래스이며**, 캐시할 수 있는 데이터의 개수가 다르거나, 구독 할 수 있는 소비자가 하나만 있는 것처럼 **각 특징에 맞게 여러 구현 클래스를 제공한다.**

### DisposableSubscriber / DisposableObserver

`**Disposable`기능을 구현한 소비자(Subscriber / Observer)로 외부에서 비동기로 구독 해지 메서드를 호출해도 안전하게 구독 해지를 할 수 있게 지원하는 클래스**이다.

`Disposable`은 구독 해지에 관한 인터페이스이다.

```java
public interface Disposable {
	/**
   * Dispose the resource, the operation should be idempotent.
   */
	void dispose();

	/**
   * Returns true if this resource has been disposed.
   *@returntrue if this resource has been disposed
   */
	boolean isDisposed();
}
```

- onSubscribe 메소드는 오버라이딩할 수 없게 `final`처리가 되었다.
대신 구독 시작 시점에 원하는 처리를 하고 싶다면 onStart()를 오버라이딩 하면 된다.

### ResourceSubscriber / ResourceObserver

`DisposableSubscriber`/`DisposableObserver`과 동일하게 Disposable을 구현한 클래스로 외부에서 비동기로 구독을 해지 메소드를 호출하더라도 안전하게 구독 해지를 지원한다.

그러나 그것 이외에도 **다른 `Disposable`(을 상속받은 클래스)를 함께 보관할 수 있는 add 메소드를 제공**한다.

`ResourceSubscriber`/ `ResourceObserver`가 dispose() 를 호출받으면 보관하고 있던 클래스들도 dispose()가 호출된다.

하지만 **완료 혹은 에러가 통지되도 자동으로 dispose()가 호출되지 않으니 주의**해야한다.

### CompositeDisposable

CompositeDisposable 클래스는 여러 Disposable을 모아 한번에 disposable() 메소드를 호출하게 할 수 있다. 

```java
public static void testCompositeDisposable() throws Exception {
    // Disposable을 합친다.
    CompositeDisposable compositeDisposable = new CompositeDisposable();

    compositeDisposable.add(Flowable.range(1, 3) // 1부터 3까지 통지하는 생성자.
            .doOnCancel(() -> System.out.println("No.1 canceld")) //구독이 취소되는 경우
            .observeOn(Schedulers.computation())
            .subscribe(data -> {
                Thread.sleep(100L);
                System.out.println("No.1(" + Thread.currentThread().getName() + "):" + data);
            }));

    compositeDisposable.add(Flowable.range(1, 3)  // 1부터 3까지 통지하는 생성자.
            .doOnCancel(() -> System.out.println("No.2 canceld")) //구독이 취소되는 경우
            .observeOn(Schedulers.computation()) // 다른 쓰레드에서 실행
            .subscribe(data -> {
                Thread.sleep(100L);
                System.out.println("No.2(" + Thread.currentThread().getName() + "):" + data);
            }));

    Thread.sleep(250L);
    compositeDisposable.dispose();
}

------ 결과-----------
No.2(RxComputationThreadPool-2):1
No.1(RxComputationThreadPool-1):1
No.1(RxComputationThreadPool-1):2
No.2(RxComputationThreadPool-2):2
No.1 canceld
No.2 canceld
```

생산자 소비자 전부 다른 Thread에서 실행됬지만 안전하게 해지되었다.

# 통지 데이터가 한건 또는 전혀 없을 때 생성자

RxJava에서는 대표적인 생성자 `Flowable`, `Observable` 말고도 `Single`, `Maybe`, `Completable`을 지원한다.  이 생성자들은 **통지하는 데이터가 한건 혹은 전혀 없을 경우에 사용**된다.

이런 생성자들은 주로 DB에 Insert, Update 하고 성공 실패여부 같은 경우에 사용한다.

그리고 일반적인 소비자(`Subscriber`, `Observer`)을 못사용함으로 각자 **독자적인 소비자를 제공**한다

## Single

**데이터를 1건만 통지하거나, 에러를 통지하는 생성자 클래스로 소비자로는 `SingleObserver`를 사용**한다.  당연히 한건을 통지하는게 성공이자 완료임으로 onNnext(), onComplete() 대신 **onSuccess() 메소드를 제공**한다.

```java
Single<DayOfWeek> single = Single.create(emitter -> {
   emitter.onSuccess(LocalDate.now().getDayOfWeek());
});

single.subscribe(new SingleObserver<DayOfWeek>() {

    @Override
    public void onSubscribe(@NonNull Disposable d) {
        // 아무것도 안함
    }

    @Override
    public void onSuccess(@NonNull DayOfWeek dayOfWeek) {
        System.out.println(dayOfWeek);
    }

    @Override
    public void onError(@NonNull Throwable e) {
        e.printStackTrace();
    }
});
```

## Maybe

**데이터를 1건만 통지하거나, 통지하지 않고 완료를 통지하거나, 에러를 통지하는 생성자 클래스로 소비자는 `MaybeObserver`을 사용**한다.

```java
Maybe<DayOfWeek> maybe = Maybe.create(emitter -> {
    emitter.onSuccess(LocalDate.now().getDayOfWeek());
});

maybe.subscribe(new MaybeObserver<DayOfWeek>() {
    @Override
    public void onSubscribe(@NonNull Disposable d) {
        
    }

    @Override
    public void onSuccess(@NonNull DayOfWeek dayOfWeek) {
        System.out.println(dayOfWeek);
    }

    @Override
    public void onError(@NonNull Throwable e) {
        e.printStackTrace();
    }

    @Override
    public void onComplete() {
        System.out.println("완료");
    }
});
```

## Completable

데이터를 1건도 통지하지 않고 완료 또는 에러를 통지하는 클래스로 생성자로는 `CompletableObserver`를 사용한다.

```java
Completable completable = Completable.create(emitter -> {
    // 어떤 작업~~
    emitter.onComplete();
});

completable
        .subscribeOn(Schedulers.computation())
        .subscribe(new CompletableObserver() {
            @Override
            public void onSubscribe(@NonNull Disposable d) {

            }

            @Override
            public void onComplete() {
                System.out.println("완료");
            }

            @Override
            public void onError(@NonNull Throwable e) {
                e.printStackTrace();
            }
        });
```

---

# RxJava 확장하기

RxJava는 경량화돼서 기본적으로 최소한의 기능만 있다.
따라서 일부 응용프로그램에서만 사용하는 편리한 기능은 별도의 모듈로 제공된다.
[ReactiveX Github](https://github.com/ReactiveX)에 가면 아래 나오는 모듈말고도 더 많은 모듈이 있다.

- `RxJavaString` : 문자열을 다루는 RxJava 확장 모듈로, InputStream이나 Reader에서 `Flowable`/`Observable`을 생성할 수 있다.
- `RxJavaFileUtils`: 파일 관련 처리를 하는 확장 모듈
- `RxJavaMath` : 수학 관련 처리를 한느 확장 모듈
- `RxJavaJoins` : 여러 `Observable`을 사용한 처리를 하는 확장 모듈
- `RxJavaAsyncUtil` : 비동기 처리 유틸리티 확장 모듈

아래는 안드로이드에서 사용하는 모듈이다.

- `RxAndroid` : 안드로이드에서 사용하는 스레드를 관리하는 스케줄러가 있는 확장 모듈
- `RxLifecycle` : 안드로이드 구성요소들의 라이프사이클과 동기화 하는 확장 모듈
- `RxBinding` : 각 View의 이벤트와 RxJava를 연계하는 모듈

# 추가로 볼만한 글

---

[taeiim/Android-Study](https://github.com/taeiim/Android-Study/blob/master/study/week12/RxJava/RxJava.md)

[RxJava, RxAndroid 3.0 출시, 무엇이 변경되었지!? | 찰스의 안드로이드](https://www.charlezz.com/?p=43954)

`Schedulers`