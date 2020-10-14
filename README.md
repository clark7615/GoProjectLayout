Golang Project Layout
---
本專案為一個簡單範例，包含一些小工具直接可以Import至Golnad IDE中

專案資料夾結構如下
```shell script
.
├── Dockerfile 
├── cmd
│   └── mian.go 
├── configs           //存放設定檔 yaml ro json
├── go.mod
├── modules
│   ├── graphql 
│   └── restful 
└── pkg
    ├── database      //db關聯的struct
    ├── http          //API相關程式
    └── other...      //其他功能
```

Xorm 轉換
---
首先Clone本專案
``$ git clone git@git.championtek.com.tw:go/layout.git``

從專案目錄下pkg/ImportData找到xorm 複製到 /Users/$userName/go/bin/下<br>
Import settings.zip設定檔案至GoLand 

至Preferences>Tool>External Tool修改工具內的參數如下
```shell script
reverse mysql "$account:$password]@tcp($host:$port)/$dbName?charset=utf8&parseTime=True&loc=Local" $GOPATH$/bin/goxorm $ProjectFileDir$/pkg/database
```

其他小工具
-----
新增了structTag自動補全功能json yaml xml
```
type name struct {
	ID int `json:"id" yaml:"id" xml:"id"` 
}
```
