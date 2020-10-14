# 由於golang image容量為750MB，我們不需這麼大的image，所以採用兩階段方式來建立image
# step1先拉下golang image來build go專案的執行檔
# step2再拉下scratch image來建立執行檔的image

# step1:
#取得golang image
FROM golang:alpine as build
#安裝timezone工具
RUN apk --no-cache add tzdata ca-certificates
RUN update-ca-certificates
#複製專案到根目錄下
COPY . /go/src/git.championtek.com.tw/layout
#設定工作目錄
WORKDIR /go/src/git.championtek.com.tw/layout
#設定golang使用go mod並且下載引用的套件至vendor資料夾下
RUN export GO111MODULE=on && go mod vendor
#測試編譯
RUN go build ./...
#編譯成正式環境可執行檔案準備打包成scratch image
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cog -o ./build/layout ./cmd/main.go

# step2:
#取得scratch image
FROM scratch as final
LABEL maintainer="Champ Champ@championtek.com.tw"
#設定工作目錄
WORKDIR /go/src/git.championtek.com.tw/layout
#複製執行檔到bulid目錄及設定檔configs
COPY --from=build /go/src/git.championtek.com.tw/layout/build ./build
COPY --from=build /go/src/git.championtek.com.tw/layout/configs/ ./configs
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /usr/share/zoneinfo /usr/share/zoneinfo

ENV TZ=Asia/Taipei

#設定對外port
EXPOSE 8080
#設定執行程序
ENTRYPOINT ["./build/layout"]
