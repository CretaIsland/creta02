# creta02

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

####
####  When love and skil work together, expect a masterpiece
####  - John Ruskin - 
####

기본 환경 설정

# project 환경변수의 설정
# 다음과 같은 Project 환경 변수를 공통으로 설정해주자

CRETA_HOME  D:/Flutter/project/creta02   <-- 사람마다 path 는 다르겠지>

# appwrite 설치시는 다음의 디렉토리에서 설치해주자. (appwrite cli 설치 위치)

%CRETA_HOME%/3rdpary/appwrite

# python 사용을 위해서는 
# python 3.1 을 설치해주자
# 파이손 path 환경 변수를 설정해주자

PYTHONPATH   %CRETA_HOME%\3rdparty\appwrite\sdk-for-python;C:\Python310\Lib;

##
## skpark
## run way
## build directory configuration
flutter config --build-dir=../release/cretaTest04  

#visual code 를 재기동한다.

## creta_main.dart 에서 version 번호를 바꾸는 것을 잊지말자.  ver 0.98

## flutter run -d web-server --web-renderer html
flutter run -d chrome --web-renderer html
# or
flutter run -d chrome --web-renderer canvaskit




## build and release process
flutter build web --web-renderer html --release --base-href="/cretaTest04/"
# or
flutter build web --web-renderer canvaskit --release --base-href="/cretaTest04/"

## first time after create repository
cd ../release/cretaTest04/web
echo "# cretaTest04" >> README.md
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/CretaIsland/cretaTest04.git
git push -u origin main

## GitHub 페이지에서 Settings 에서 GitHub pages 'click it out here' 를 누른다.
# Source choice 박스에서 main 을 고른뒤 save 를 눌러주면 웹페이지가 생기다.
# https://CretaIsland.github.io/cretaTest04/

# for windows configuration

flutter config --enable-windows-desktop 
flutter create --platforms=windows . 
# you need to install Xcode or VisualStudio or gcc toolchains.
flutter run -d windows
flutter build windows





#npm install firebase
#npm install -g firebase-tools
#flutter build web --web-renderer html --release --base-href="/accTest0390/"
#flutter build web --web-renderer canvaskit --release --base-href="/accTest0390/"

#############################################
### Flutter 소스 코드 변경건 
#############################################
## Youtube 관련 수정
copy D:\Flutter\project\creta00\source_modify\youtube_value_builder.daxt  D:\Flutter\src\flutter\.pub-cache\hosted\pub.dartlang.org\youtube_player_iframe-2.2.0\lib\src\helpers\youtube_value_builder.dart

## text ticker 관련 수정 
copy D:\Flutter\project\creta00\source_modify\scroll_loop_auto_scroll.daxt
D:\Flutter\src\flutter\.pub-cache\hosted\pub.dartlang.org\scroll_loop_auto_scroll-0.0.5\lib\scroll_loop_auto_scroll.dart

## effect 관련 수정
copy D:\Flutter\project\creta00\source_modify\vitality.daxt D:\Flutter\src\flutter\.pub-cache\hosted\pub.dartlang.org\vitality-1.0.2\lib\vitality.dart

copy D:\Flutter\project\creta00\source_modify\flutter_web_auth.daxt  D:\Flutter\src\flutter\.pub-cache\hosted\pub.dartlang.org\flutter_web_auth-0.4.1\lib\flutter_web_auth.daxt

#############################################
### Flutter Web fireStore dataabse 사용하기
#############################################

1. Firebase 웹페이지에서 할일

-  console.firebase.google.com  엦 접속

* [+ project 추가]
* 프로젝트 이름 "creta02"  [계속]
* 애널리틱스 사용설정 안함 [프로젝트 만들기]
* 앱에 Firebase 추가하여 시작하기
* [Web 아이콘버튼]
* 앱등록,  앱 닉네임
creta02 
Firebase 호스팅 체크박스는 일단 건너뛰어 봄.
[앱등록]

#npm install firebase
#npm install -g firebase-tools

한 후에..

const firebaseConfig = {
  apiKey: "AIzaSyAy4Bvw7VBBklphDa9H1sbLZLLB9WE5Qk0",
  authDomain: "creta00-4c349.firebaseapp.com",
  projectId: "creta00-4c349",
  storageBucket: "creta00-4c349.appspot.com",
  messagingSenderId: "1022332856313",
  appId: "1:1022332856313:web:872be7560e0a039fb0bf28"
};

const firebaseConfig = {
  apiKey: "AIzaSyBe_K6-NX9-lzYNjQCPOFWbaOUubXqWVHg",
  authDomain: "creta02-ef955.firebaseapp.com",
  projectId: "creta02-ef955",
  storageBucket: "creta02-ef955.appspot.com",
  messagingSenderId: "878607742856",
  appId: "1:878607742856:web:87e91c3185d1a79980ec3d"
};

부분을 복사한다.



- 테이블 만들기

[콘솔로 이동]

좌측 메뉴 증에 [Firestore Database] 선택
[데이터베이스 만들기]

일단 [테스트모드에서 시작] 선택 (30일후 보안 정책을 결정해주면 됨)

[시작]

Cloud Firestore 위치  "asia-northeast3"  
[사용설정]

[+컬렉션 시작]

컬렉션 ID :  creta_user

데이터베이스를 만든다.
만들다가 오류가 나는 것은  Project home 으로 나갔다가 다시 들어와보면 만들어져 있다.



1.  yaml 에 다음을 추가


firebase_core: ^1.13.1
cloud_firestore: ^3.1.10
cloud_firestore_web: ^2.6.10

2. create_db.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creta02/common/util/logger.dart';

// 아까 복사한 부분을 이용해서 만든다.
class FirebaseConfig {
  static const String apiKey = "AIzaSyAy4Bvw7VBBklphDa9H1sbLZLLB9WE5Qk0";
  static const String authDomain = "creta00-4c349.firebaseapp.com";
  static const String projectId = "creta00-4c349";
  static const String storageBucket = "creta00-4c349.appspot.com";
  static const String messagingSenderId = "1022332856313";
  static const String appId = "1:1022332856313:web:872be7560e0a039fb0bf28";
}

class CretaDB {
  final List resultList = [];
  late CollectionReference collectionRef;

  CretaDB(String collectionId) {
    collectionRef = FirebaseFirestore.instanceFor(app:AbsDatabase.fbDBConn!).collection(collectionId);
  }

  Future<List> getData(String? key) async {
    try {
      if (key != null) {
        DocumentSnapshot<Object?> result = await collectionRef.doc(key).get();
        if (result.data() != null) {
          resultList.add(result);
        }
      } else {
        await collectionRef.get().then((snapshot) {
          for (var result in snapshot.docs) {
            resultList.add(result);
          }
        });
      }
      return resultList;
    } catch (e) {
      logHolder.log("GET DB ERROR : $e");
      return resultList;
    }
  }
}


2.  main.dart 수정

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //for firebase
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: FirebaseConfig.apiKey,
          appId: FirebaseConfig.appId,
          messagingSenderId: FirebaseConfig.messagingSenderId,
          projectId: FirebaseConfig.projectId)); // for firebase
  runApp(const MyApp());
}

3  web/index.html 수정

body 바로 아래...

<body>

  <script> src="https://www.gstatic.com/firebasejs/9.0.2/firebase-app.js"</script>
  <script> src="https://www.gstatic.com/firebasejs/9.0.2/firebase-firestore.js"</script>
  <script> src="https://www.gstatic.com/firebasejs/9.0.2/firebase-storage.js"</script>
  


##############################
## DB 별 인덱스 잡는 법
###############################
1. firebase
 : where 조건절과 order by 에 사용된  attribute 를 복합 index 로 잡는다.
 예를 들어 다음과 같은 Query 라면
  where attr1 = 'abc' and attr2 = 'cdf' order by updateTime desc;
  인덱스는 다음과 같이 하나의 복합 인덱스로 잡아야 한다.
   
   index = attr1 ASC + attr2 ASC + updateTime desc

2. appwrite 
 : where 조건절과 order by 에 사용된  attribute 를 각각 별도의 index 로 잡는다.
 예를 들어 다음과 같은 Query 라면
  where attr1 = 'abc' and attr2 = 'cdf' order by updateTime desc;
 
  index1 = attr1 ASC + attr2 ASC
  index2 = updateTime desc

  이렇게 2개의 index 를 잡는다.


##############################
## appwrite cli 사용법
###############################

1. 윈도우즈용 cli 실행파일 다운로드

https://github.com/appwrite/sdk-for-cli/releases/tag/0.18.4

요기서, appwrite-cli-win-x64.exe 를 다운로드 받는다.
이것은 설치파일이 아니고, 그냥 cli 실행파일이다.
파일 이름을  appwrite.exe 로 바꾸어즈고 바로 사용할 수 있다.

2. initialize 
처음 DB 접속 정보를 설정해준다.

./appwrite init project

라고 해주면, projectId, id/pwd 를 물어보는데 묻는 질문에 성실하게 대답해준다.
처음 설치시 한번만 해주면 된다.
이 결과로  appwrite.json 파일이 생기게 된다.

3. collection 정보를 json 형태로 보기

./appwrite --help 해보면 대충 알수 있다.

./appwrite databases listCollections --databaseId 62d79f2e5fda513f4807 --json

현재 Collection 정보를 json 형태로 리스트업해서 보여준다.

4. Create Collection 하기

Create Collection 을  Command line 명령으로 하려면 매우 힘드므로
collection 정보를 appwrite.json 파일에 써놓고
appwrite.json 파일에 써 놓고, 이를 deploy 하는 방식으로 진행한다.

./appwrite deploy collection --all

기존에 collection 이 이미 있는 경우, 데이터가 모두 날아가게 된다는 점에 유의한다.
다만, field 가 추가되는 경우는 안날아가는 것 같다.
collection 을 특정한 것만 create 하고 싶으면  --all 옵션을 뺀다.

현 project 의  database/appwrite/ 폴더 밑에 있는 appwrite.json 파일을 참고한다.

5. alter table 하기

다음과 같이 field 를 추가할 수 있다. (test 라는  field 추가 예제)

./appwrite databases createStringAttribute --databaseId  62d79f2e5fda513f4807  --collectionId creta_book --key  test  --size 128  --required false


#############################
# appwrite 환경 변수 설정
##############################

처음에 Appwrite 를 설치했던, 폴더에 appwrite 라는 폴더가 생겨있다.
여기에 보면 env 라는 파일이 있는데,  이 파일을 메모장으로 열어서
고치면 된다.
고친후,  Appwrite 를 도커에서 재기동시켜야 한다.

환경변수
--------------------------------------------
1) API 호출량의 일일 limit 가 걸려있는것을 해제하려면

_APP_OPTIONS_ABUSE=disable

로 설정해야 한다.

#############################
# appwrite function 사용법
#############################

# appwrite cli 가 설치된 디렉토리에서 파워쉘을 연다.
# 먼저 git 을 최신버전으로 업그레이드 해준다.

git upgrade

# 다음과 같이  function 을 init 해준다.

.\appwrite init function

# 묻은 말에 대답해준다.
# 여기서는 test2 이라는 함수를 만든다고 했다.  그리고 python 을 쓰겠다고 했다.
# (아마 로컬 시스템에 파이쎤이 깔려 있어야 하지 않을 까 싶다...)
# appwrite.json 파일에 test2 function 이 포함된 것을 볼 수 있다.
# function/test2/src 이라는 폴더가 생기고, index.py 가 생긴것을 볼 수 있다.

# 다음과 같이 이를 deploy 한다.
# json 파일에 적혀있는 test2 함수가 시스템에 등록되게 한다.

.\appwrite deploy function

# test2 을 space bar 로 선택한 후 enter key 를 누른다.
# 이제 localhost dashbord 에서 function 에 가보면,,,해당 test2 function 이 만들어져 있고,
# 실행해 볼 수 있다.
# 로그 버튼을 눌러보면 실행결과도 볼 수 있다. (오우 예~~)

# 이제 functions/test2/src/index.py 를 수정해서 원하는 로직을 수행한 후에, 다시 deploy를 해주면 된다.

.\appwrite deploy function

# 대쉬보드로 돌아와서 몇초를 인내심을 가지고 기다리면,  과거 function 이 deactivate 상태로 변하는데
# 그러면 새 함수가 적용된 것이다.
# 다시 execute 해서 실행해 볼 수 있다.

# python 으로 appwrite database 조회는 다음 web site 를 참조 : 
# https://dev.to/robimez/python-in-appwrite-378h


#python 설정
#python 3.1 이상 설치하고,
#PYTHONPATH  <python 설치위치>/Lib 환경변수 추가하고
# appwrite 설치 디레토리에  appwrite 의 sdk-for-python 을 git clone 으로 설치합니다.
# https://github.com/orgs/appwrite/repositories 요기서 찾습니다.

# 그다음 PYTHONPATH 에  sdk-for-python path 을 추가해줍니다.
# 그다음 requests 패키지를 다음과 같은 명령으로 설치한다. (관리자권한으로 powershell 을 열어서 해야한다.)
pip3 install requests

# 다 끝났으면 function 을 테스트 해보자.
# appwrite 설치 패스로 가서,
# cd functions/<function_name>/src 

python index.py 

# index.py 를 실행해 볼 수 있다.
# 이때 물론 main 함수 호출절을 만들어 주어야 한다.

ex) if __name__ == "__main__":
  main('','')

# 또한 endPoint 는  localhost 를 인식하지 못하므로 반드시 ip Address 로 바꾸어 적어주어야 한다.


### dart 에서 appwrite function 호출하기
참조
https://appwrite.io/docs/functions

# 1) 권한주기
### 우선 Appwrite console 에서, 해당 함수의 Settings 메뉴로 들어가서, 
# Execute Access 에 "role:all" 을 추가해주어야 한다.












