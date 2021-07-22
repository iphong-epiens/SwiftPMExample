# 💾 Framework Guidelines

타사에 방송 송출 기능을 제공위한 프레임워크는 소스를 외부에서 확인할 수 없도록 구현되어야 한다.  구현 소스 내용의 은닉성을 지원하기 위해서는  [Binary Framework](https://developer.apple.com/videos/play/wwdc2019/416/) 형태로 구현되어야 한다. 

현재 애플에서 제공하는 프레임워크 방식은 [XCFramework](https://help.apple.com/xcode/mac/11.4/#/dev544efab96)이며,  `Binary Framework` Target 옵션으로 생성한다. 배포 방식은 애플에서 지원하는 `Swift Package Manager` 방식 및  `Thrid Party` 배포 방식인 [Cocoapod](https://cocoapods.org)이나 [Carthage](https://github.com/Carthage/Carthage) 방식으로도 배포가 가능하다.

# 작업 순서

- [Framework 구현](#framework-구현)
- [XCFramework  생성](#xcframework-생성)
- [Swift Package 수정](#swift-package-수정)
- [Swift Package Manager 배포](#swift-package-manager-배포)

# Framework 구현
 
## Framework로 구현하고자 하는 기존 소스 및 리소스를 구현 프로젝트로 가져온다. 기존 구현 내용 중 Third Party 라이브러리를 프레임워크에서 동작하기 위한 방식으로 적용하기 위해 소스 원본을 가져온다.

## Third Party 라이브러리 추가

- [ ]  작업하는 소스 프로젝트에 추가하고자 하는 라이브러리를 소스 형태로  추가하고, 추가된 프레임워크의 타겟으로 변경하여 라이브러리를 컴파일하여, 오브젝트 형태로 프레임워크에 추가한다.

- [ ]  추가한 라이브러리를 XCode Menu의 General→Frameworks and Libraries에  라이브러리의  `.framework` 파일을 Drag & Drop 으로 추가하고, `Embed & Sign` 형태로 설정한다. Build Phase 메뉴에서 `Link Binary With Libraries` 메뉴에 라이브러리가 포함되어 있는지 확인다.

- [ ]  추가한 라이브러리를 소스에서 import 후 라이브러리 동작을 확인한다.

- [ ]  `Build Settings` 메뉴에서  `BUILD_LIBRARIES_FOR_DISTRIBUTION`  옵션을 `YES`로 설정한다.

> `주의: @import` 구문이 포함된 라인에 Warning 메세지가  발생할 경우 정상적으로 라이브러리가 추가되지 않은것이다.

# XCFramework 생성

XCFramework는 `Platform` (MacOs, iOS, iOS-Simulator, iPadOS, WatchOS) 별로 xcarchive 파일을 생성할 수 있다. 구현 소스는 전화번호 인증 및 카메라 송출 기능이 포함되어 있기 때문에, 시뮬레이터에서는 사용할 수 없기 때문에 iOS 타켓으로만 아카이빙한다.

##  **iOS Framework로 xcarchive 파일 생성**

```swift
xcodebuild archive \\
-scheme DemoXCFramework \\
-configuration Release \\
-destination 'generic/platform=iOS' \\
-archivePath './build/DemoXCFramework.framework-iphoneos.xcarchive' \\
SKIP_INSTALL=NO \\
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
```

##  **xcarchive 파일을 XCFramework로 변환**

```swift
xcodebuild -create-xcframework \\
-framework './build/DemoXCFramework.framework-iphoneos.xcarchive/Products/Library/Frameworks/DemoXCFramework.framework' \\
-output './build/DemoXCFramework`.xcframework
```

# Swift Package 수정
- `Swift Package` 프로젝트의 `Package.swift` 파일에 `targets` 옵션을 `.binaryTarget`으로 설정하고, `XCFramework` 파일 추가
- `Swift Package` 버전 정보 변경

# Swift Package Manager 배포
- `GitHub Repository`에 소스 업로드 후 변경한 버전을 `Git Tag`로 추가하고,`Tag`를 `Release`로 변경하여 배포한다.
- `Framework`를 porting한 앱은 `Framework` 파일 내부에 오브젝트 형태로 존재하는 라이브러리를 `Framework` 적용시 같이 동일한 버전으로 적용해야 정상동작한다. 

## Reference

1. [Create an XCFramework](https://help.apple.com/xcode/mac/11.4/#/dev544efab96)
2. [Distributing Binary Frameworks as Swift Packages](https://developer.apple.com/documentation/swift_packages/distributing_binary_frameworks_as_swift_packages)
