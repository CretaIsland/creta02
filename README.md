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
    collectionRef = FirebaseFirestore.instance.collection(collectionId);
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






