# 設計概要 (iOSEngineerCodeCheck-SwiftUI)

  
## UI設計


### **ViewModel構造**

- ****SearchViewModel**** : <br>SearchViewにて使用するObservableObject で値の監視を行う。<br>Repositry配列を所有しViewで描写する配列をAPIから取得する。<br>


### **View構造**


- ****SearchView****:<br>
NavigationViewを基にしたRootView。<br>SearchBar,Cellを所有しViewModelで取得した値を描写する。<br>paginationでは.onAppear を利用しlastObjectが描写された際に,再度ViewModelを経由し新たな配列を取得する。

- ****DetailView****:<br>
リポジトリの詳細情報を掲載。<br>
各Repositry に応じた情報や画像描写を行う事を目的とする。


### **Model構造**


- ****GitHubSearchResultModel****: <br>
Codableを批准しJSON型をデータ型にdecodeしています。<br>基本的なpropertyはUIKitで使用したものと同一です。



### **ライブラリ**
___

- pod 'SDWebImageSwiftUI'

### **動作環境**
___

- IDE：Xcode 12.3
- Swift：5.3
- iOS : 14.3

 ___

<div style="text-align: right;">
2020年12月24日<br>
酒井 佑樹
<div>

