# --- ビルド専用ステージ ---
    FROM golang:1.23-alpine AS builder
    WORKDIR /src
    
    # 1) 依存情報だけ先にコピーしてキャッシュを効かせる
    COPY go.mod go.sum ./
    RUN go mod download
    
    # 2) ソースを丸ごとコピー
    COPY . .
    
    # 3) 依存関係を最終調整してビルド
    RUN go mod tidy \
     && go build -o /go/bin/api ./cmd/api
    
    # --- 実行専用ステージ ---
    FROM alpine:3.20
    RUN apk add --no-cache tzdata
    ENV TZ=Asia/Tokyo
    
    # ビルド済みバイナリだけ取り込む
    COPY --from=builder /go/bin/api /usr/local/bin/api
    
    EXPOSE 8080
    ENTRYPOINT ["api"]
    