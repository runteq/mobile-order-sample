# LIFF Mobile Order Demo

LINEのLIFFからアクセスするモバイルオーダーデモアプリケーションです。

## 概要

- LINEのトークからLIFF(Web画面)を開き、商品選択 → カート → 注文確定 → 完了 まで体験できるデモ
- 決済なし、デモ用途
- 管理者はWeb管理画面で注文一覧/ステータス更新ができ、更新に応じてLINE通知を送信

## 技術スタック

- Ruby 3.3
- Rails 7.2
- PostgreSQL 16
- Hotwire (Turbo + Stimulus)
- Tailwind CSS
- Docker Compose (開発環境)

## セットアップ

### 1. 環境変数の設定

```bash
cp .env.example .env
```

`.env`ファイルを編集して必要な値を設定:

```
# LIFF設定
LIFF_ID=your_liff_id_here

# LINE Messaging API
LINE_CHANNEL_ACCESS_TOKEN=your_channel_access_token_here

# 管理画面Basic認証
ADMIN_USER=admin
ADMIN_PASSWORD=password

# 本番用 (Render)
# DATABASE_URL=postgres://user:password@host:5432/dbname
# RAILS_MASTER_KEY=your_master_key_here

# Cloudinary (本番用画像ストレージ)
# CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME
```

### 2. Docker Composeで起動

```bash
# コンテナをビルドして起動
docker compose up -d

# データベースの作成とマイグレーション
docker compose exec web rails db:create db:migrate db:seed

# ログの確認
docker compose logs -f web
```

### 3. アクセス

- LIFF画面: http://localhost:3000/liff
- 管理画面: http://localhost:3000/admin (Basic認証: admin/password)

## LIFF設定手順

### LINE Developersコンソールでの設定

1. [LINE Developers](https://developers.line.biz/console/) にアクセス
2. プロバイダーを選択（または新規作成）
3. 新しいLINEログインチャネルを作成
4. LIFFタブでLIFFアプリを追加:
   - エンドポイントURL: `https://your-app-url.com/liff`
   - スコープ: `profile`
   - ボットリンク機能: 任意
5. 発行されたLIFF IDを`.env`の`LIFF_ID`に設定

### LINE Messaging API設定（通知機能用）

1. Messaging APIチャネルを作成
2. チャネルアクセストークンを発行
3. `.env`の`LINE_CHANNEL_ACCESS_TOKEN`に設定

## 画面一覧

### LIFF画面（ユーザー向け）

| パス | 説明 |
|------|------|
| `/liff` | 商品一覧 |
| `/liff/cart` | カート |
| `/liff/checkout` | 注文確認 |
| `/liff/orders/:id/complete` | 注文完了 |

### 管理画面

| パス | 説明 |
|------|------|
| `/admin` | 注文一覧 |
| `/admin/orders/:id` | 注文詳細・ステータス更新 |
| `/admin/products` | 商品一覧 |
| `/admin/products/new` | 商品追加 |
| `/admin/products/:id/edit` | 商品編集 |

## 環境変数一覧

| 変数名 | 説明 | 必須 |
|--------|------|------|
| `DATABASE_URL` | PostgreSQL接続URL | Yes (本番) |
| `RAILS_MASTER_KEY` | Rails credentials key | Yes (本番) |
| `ADMIN_USER` | 管理画面Basic認証ユーザー | Yes |
| `ADMIN_PASSWORD` | 管理画面Basic認証パスワード | Yes |
| `LIFF_ID` | LIFFアプリID | Yes |
| `LINE_CHANNEL_ACCESS_TOKEN` | LINE Messaging APIトークン | Yes (通知機能) |
| `CLOUDINARY_URL` | Cloudinary接続URL | Yes (本番) |

## Cloudinary設定（本番環境の画像ストレージ）

本番環境では商品画像の保存にCloudinaryを使用します。

### 1. Cloudinaryアカウント作成

1. [Cloudinary](https://cloudinary.com/) にアクセス
2. 無料アカウントを作成（月25GBまで無料）
3. ダッシュボードにアクセス

### 2. 接続情報の取得

ダッシュボードの「API Environment variable」から`CLOUDINARY_URL`をコピー:

```
CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME
```

### 3. 環境変数の設定

本番環境（Render等）に`CLOUDINARY_URL`環境変数を設定します。

### 注意事項

- **開発環境**: ローカルディスク（Active Storage local）を使用
- **本番環境**: Cloudinaryを使用（`config/environments/production.rb`で設定済み）
- 画像形式: PNG, JPEG, WebP対応
- 最大サイズ: 5MB

## デモ操作手順

### ユーザー側

1. LINEアプリでLIFF URLを開く（または開発時は直接ブラウザでアクセス）
2. 商品一覧から商品をカートに追加
3. カートで数量を調整
4. チェックアウトで注文を確定
5. 完了画面で注文番号を確認

### 管理者側

1. `/admin`にアクセス（Basic認証）
2. 注文一覧でステータスや日付でフィルター
3. 注文詳細でステータスを更新
4. `ready`ステータスに更新するとLINE通知が送信される

## 開発コマンド

```bash
# コンテナ起動
docker compose up -d

# コンテナ停止
docker compose down

# Railsコンソール
docker compose exec web rails c

# マイグレーション実行
docker compose exec web rails db:migrate

# シード投入
docker compose exec web rails db:seed

# ログ確認
docker compose logs -f web
```

## ローカル開発でのLIFFデバッグ（ngrok使用）

LIFFはHTTPSが必須のため、ローカル開発では[ngrok](https://ngrok.com/)を使用してトンネリングします。

### 1. ngrokのインストール

```bash
# macOS (Homebrew)
brew install ngrok

# または公式サイトからダウンロード
# https://ngrok.com/download
```

### 2. ngrokアカウント設定

```bash
# ngrokにサインアップ後、認証トークンを設定
ngrok config add-authtoken YOUR_AUTH_TOKEN
```

### 3. アプリを起動してngrokでトンネル作成

```bash
# ターミナル1: アプリを起動
docker compose up -d

# ターミナル2: ngrokでトンネル作成
ngrok http 3000
```

ngrokが起動すると以下のようなURLが表示されます:

```
Forwarding    https://xxxx-xxx-xxx.ngrok-free.app -> http://localhost:3000
```

### 4. LINE DevelopersでLIFFエンドポイントURLを更新

1. [LINE Developers Console](https://developers.line.biz/console/) にアクセス
2. 対象のLIFFアプリを選択
3. エンドポイントURLを `https://xxxx-xxx-xxx.ngrok-free.app/liff` に変更
4. 保存

### 5. LINEアプリからアクセス

LINEアプリで以下のURLを開きます:

```
https://liff.line.me/{LIFF_ID}
```

### 注意事項

- ngrokの無料プランではURLが起動ごとに変わるため、毎回LINE DevelopersでエンドポイントURLの更新が必要です
- ngrok有料プランでは固定ドメインが利用可能です
- ngrok経由のアクセスでは初回に「Visit Site」ボタンが表示される場合があります

### テスト実行

```bash
# RSpecテストを実行
docker compose exec -e RAILS_ENV=test web bundle exec rspec
```

## デプロイ（Render）

### Render設定

1. Web Service を作成
2. Docker runtime を選択
3. 環境変数を設定
4. Neonでデータベースを作成し、`DATABASE_URL`を設定

### ビルド設定

- Build Command: (Dockerfileで自動)
- Start Command: `./bin/rails server`

## 免責事項

**これはデモ用の注文です。実際の提供/決済はありません。**

- 本アプリケーションはデモ・学習目的です
- 実際の決済処理は含まれていません
- 個人情報（住所・電話番号等）は収集しません
- 注文データは永続化されますが、本番運用を想定していません

## ライセンス

MIT
