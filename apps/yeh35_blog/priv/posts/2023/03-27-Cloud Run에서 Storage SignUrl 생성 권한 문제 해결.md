%{
title: "Cloud Run에서 Storage SignUrl 생성 권한 문제  a467e15bf72e4c5395f99b1d21a043d5.md",
author: "yeh35",
tags: ~w(dev),
description: "",
published: false
}
---
# Cloud Run에서 Storage SignUrl 생성 권한 문제 해결

게시: Yes
생성일자: 2023년 3월 27일 오후 9:19
수정일자: 2023년 4월 18일 오전 2:16
태그: GCP, 삽질
날짜: 2023년 3월 27일

로컬에서 Storage SignUrl을 생성하면 잘 되는데, GCP Cloud Run에서 하는 경우 권한 문제가 생겼다.

에러 로그는 아래와 같다.

```
com.google.auth.ServiceAccountSigner$SigningException: Failed to sign the provided bytes
 at com.google.auth.oauth2.IamUtils.sign(IamUtils.java:87) ~[google-auth-library-oauth2-http-1.6.0.jar:na]
 at com.google.auth.oauth2.ComputeEngineCredentials.sign(ComputeEngineCredentials.java:425) ~[google-auth-library-oauth2-http-1.6.0.jar:na]
 at com.google.cloud.storage.StorageImpl.signUrl(StorageImpl.java:650) ~[google-cloud-storage-2.6.0.jar:2.6.0]
```

## 검색에서 가장 많이 나오는 해결책

[403 trying to sign provided bytes: The caller does not have permission](https://stackoverflow.com/questions/63503247/403-trying-to-sign-provided-bytes-the-caller-does-not-have-permission)

서비스 계정에 `서비스 계정 토큰 생성자` 권한을 추가해주면 된다.!

설정하는 방법이 궁금하면 빙이 알려준다. ㅋㅋㅋ

![Untitled](/images/posts/f8b14c74-721e-4682-bfce-3fc2b0ff834c.png)

## 위에 방법으로 해결안되는 경우..

나의 경우 위의 방법으로 안되었다. 하하…. (한 6시간 삽질했나?)

`https://console.developers.google.com/apis/api/iamcredentials.googleapis.com/overview?project=<project-id>`

![Untitled](/images/posts/d20f20b7-717b-4d74-9300-a64fb5c5e806.png)

**IAM Service Account Credentials API 가 사용중인지 확인하면 된다.**

이걸 허용해야지 Cloud Run에서 우리가 줬던 권한을 확인할 수 있는거 같다. (추정)