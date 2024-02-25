%{
title: "Groovy 문법 4015df8e3f3e4718bd876d21b5bfb83d.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# Groovy 문법

게시: Yes
생성일자: 2021년 6월 4일 오전 11:22
수정일자: 2021년 6월 4일 오전 11:23
태그: Develop, Gradle

# **Groovy 문법**

Gradle을 편하게 사용하기 위해서는 Groovy문법이 필요하다. 물론 요즘은 Kotlin으로 작성할 수 있다고는 하지만 아직 많은 예제소스들이 Groovy로 되어있어서 완전히 모를 수는 없다. Groovy에 대해 깊게 보는 것이 아닌 Gradle을 사용하면서 이정도는 알자라는 느낌으로 [Groovy 공식 문서](https://groovy-lang.org/index.html)를 정리하였다. 솔직히 한번쭉 읽고 넘어가자 (필요할때 찾아쓰는걸로..)

## **Semicolons**

Groovy에서는 세미콜론이 있어도 없어도 된다.

```
println 'Hello World';
println 'Hello World'

```

## **Parentheses**

괄호 역시 필수가 아니다.

```
println ('Hello World')
println 'Hello World'

```

## **def KeyWord**

def 키워드를 사용하면 함수도 변수도 타입을 명시적으로 지정하지 않아도 된다.

```
def hello() {
    'Hello'
}

def helloWord = hello() + ` World'

```

## **String 문자열**

작은 따움표(')는 자바와 비슷 큰 따움표(")는 $기호를 이용해 동적인 내용을 넣을 수 있다.

```
String name = 'sangoh'
String fullName1 = 'Yeh ${name}'
String fullName2 = 'Yeh $name'
String MultipleLines = ""************
Hello
************""

```

## **Access Modifiers**

기본 접근 제어자가 Public으로 되어있다.

```
class simpleUser { // == public class simpleUser
    int id  // == public int id
    String name // == public String name
}

```

## **Import**

Java의 Import 명령의 개념과 동일하다.

```
import groovy.xml.MarkupBuilder  // MarkupBuilder만 참조
import groovy.xml.* // xml하위에 전부 참조

```

### **Default Import**

기본적으로 여러 패키지들을 임포트하고 있기 때문에, 임포트문을 생략할 수 있다.

- Groovy.lang.*
- Groovy.util.*
- Java.lang.*
- Java.util.*
- Java.net.*
- Java.io.*
- Java.math.BigInteger
- Java.math.BigDecimal

### **정적 Import**

정적 Import 기능을 사용하면 가져온 클래스 자신의 정적 메소드인 것처럼 참조할 수 있다.

```
import static Boolean.FALSE
assert !FALSE //use directly, without Boolean prefix!

```

### **이름 겹치지 말자**

정적 Import와 동일한 이름의 메소드를 아래와 같이 선언할 수 있지만 사용하지 말자…

```
import static java.lang.String.format // 1순위

class SomeClass {

    String format(Integer i) {   // 2순위
        i.toString()
    }

    static void main(String[] args) {
        assert format('String') == 'String'  //
        assert new SomeClass().format(Integer.valueOf(1)) == '1'
    }
}

```

Java같으면 컴파일 오류가 발생하지만 Groovy는 컴파일되고 가져온 클래스가 더 우선된다. 위와 같이 겹칠거 같다면 ‘as’ 키워드를 사용하자

```
import static java.lang.String.format as stringFormat

```

물론 ‘*‘를 이용해 하위에 모든 메소드를 가져올 수도 있다.

```
import static java.lang.Math.*

```

## **스크립트 컴파일**

Groovy는 스크립트를 지원한다. Java 형식을 따랐다면 다음과 같이 했겠지만

```
class Main {
    static void main(String... args) {
        println 'Groovy world!'
    }
}

```

스크립트를 사용하면 다음과 같이 해도 된다.

```
println 'Groovy world!'

```

스크립트가 작성해도 스크립트 내용을 복사하여 다음과 같이 클래스를 만들고 컴파일한다.

```
import org.codehaus.groovy.runtime.InvokerHelper
class Main extends Script {
    def run() {
        println 'Groovy world!'
    }
    static void main(String[] args) {
        InvokerHelper.runScript(Main, args)
    }
}

```

스크립트에 함수가 포함되어 있다면

```
println 'Hello'

int power(int n) { 2**n }

println "2^6==${power(6)}"

```

다음과 같이 변형되서 컴파일 된다.

```
import org.codehaus.groovy.runtime.InvokerHelper
class Main extends Script {
    int power(int n) { 2** n}
    def run() {
        println 'Hello'
        println "2^6==${power(6)}"
    }
    static void main(String[] args) {
        InvokerHelper.runScript(Main, args)
    }
}

```

## **Closures**

`Groovy의 클로저는 인수를 취하고 값을 반환하며 변수에 할당 할 수있는 개방 된 익명의 코드 블록입니다.`라고 공식문서에 적혀있었지만 익명 메소드(함수)라고 생각하면 된다.

```
{ item++ }
    // item 이름이 지정된 변수를 참조
{ -> item++ }
    // 화살표 ( ->)를 추가하여 클로저 매개 변수를 코드와 명시 적으로 분리
{ println it }
    // 암시적 매개 변수 ( it)를 사용
{ it -> println it }
    // 암시적 매개 변수을 it 명시적으로 표시
{ name -> println name }
   // 명시적인 매개 변수 사용
{ String x, int y ->
    println "hey ${x} the value is ${y}"
}
    // 두 가지 유형의 매개 변수
{ reader ->
    def line = reader.readLine()
    line.trim()
}
    // 여러 문장을 포함

```

### **Gradle Task**

Gradle Task를 클로저로 구현할 수 있다.

```
task hello << {
    println 'Hello Gradle Task'
}

```

‘«'는 .leftShift(Closure)을 생략한 것이다.

```
def helloClosure = {println 'Hello Gradle Task'}
task helloTask {}
helloTask.leftShift(helloClosure)

```

## **Assert**

Groovy에서는 assert기능이 강화되었다.

```
x=1
assert x
assert (x ==1)
assert ['a'] // 리스트가 비어있지 않으므로 true
assert ['a':1] // 맵이 비어있지 않으므로 true
assert 'a' // 스트링이  비어있지 않으므로 true
assert 1
assert !null
assert true

def listener = { e -> println "Clicked on $e.source" }
assert listener instanceof Closure

```

## **Lists**

```
def a = [1, 2, 3, 4]
def b = ['Hi', 1, true, File]

// ADD
def x = []
x += [1,2,3]
assert x == [1,2,3]
assert x.size == 3

// ADD
a << 4 << 5
assert a == [1,2,3,4,5]
a.add(6)
assert a == [1,2,3,4,5,6]

// GET
assert a[0] == 1
assert a.get(0) == 1
assert a.getAt(0) == 1
assert a[-1] == 6

// PUT
a.putAt(1,1)
assert a == [1,1,3,4,5,6]

//SET (Return으로 이전값을 리턴)
assert a.set(1,2) == 1
assert a == [1,2,3,4,5,6]

// Loop
a.each{println "$it"}
a.eachWithIndex{it, index -> println item : "$it", index : "$index"}

// REMOVE
a -=1
assert a == [2,3,4,5,6]
a = a.minus([2,3,4])
assert a == [5,6]

```

## **Maps**

```
def map = ['one':1, 'hello':'word', 'other':[1,2,3]]
assert map.size() == 2
// 여기도 +, - 연산자가 오버라이딩 되어있다.

assert map['one'] == 1
assert map.get('hello') == 'word'
assert map.other[0] == 1

```

# **참고**

- [https://groovy-lang.org/structure.html](https://groovy-lang.org/structure.html)
- [https://groovy-lang.org/closures.html](https://groovy-lang.org/closures.html)
- [https://springsource.tistory.com/85](https://springsource.tistory.com/85)