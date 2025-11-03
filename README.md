# Bike Review Map

## 目次

- [サービス概要](#サービス概要)
- [サービスURL](#サービスurl)
- [サービス開発の背景](#サービス開発の背景)
- [機能紹介](#機能紹介)
- [技術構成](#技術構成)
  - [使用技術](#使用技術)
  - [ER図](#er図)
  - [画面遷移図](#画面遷移図)
---

## サービス概要

自転車が趣味で旅先や出先でパンクや整備が必要になる場面が多く、土地勘のない場所で信頼できる店舗を探すのに苦労した経験がきっかけです。
Googleマップで探すこともできますが、「自転車専門かどうか」「対応の丁寧さ」などの判断材料が乏しく、レビューの質にばらつきがあることが課題でした。
同じように自転車に乗る人たちのリアルな口コミや体験談を共有できる場所を作りたいという思いから、このサービスを立ち上げました。

---

## サービスURL

- [BIKE REVIEW MAP アプリ](https://bike-review-map.fly.dev/)

---

## サービス開発の背景

自転車が趣味で旅先や出先でパンクや整備が必要になる場面が多く、土地勘のない場所で信頼できる店舗を探すのに苦労した経験がきっかけです。

Googleマップで探すこともできますが、「自転車専門かどうか」「対応の丁寧さ」などの判断材料が乏しく、レビューの質にばらつきがあることが課題でした。

同じように自転車に乗る人たちのリアルな口コミや体験談を共有できる場所を作りたいという思いから、このサービスを立ち上げました。


---

## 機能紹介

- **店舗検索**
  - 住所入力または現在地取得
  - 検索結果をリスト上で表示

    [![Image from Gyazo](https://i.gyazo.com/2d2d090d704070ae55d4fc0f2b0f4dc9.gif)](https://gyazo.com/2d2d090d704070ae55d4fc0f2b0f4dc9)

- **店舗詳細**
  - ユーザー投稿レビュー（タグ付き）
  - Google レビュー表示

    [![Image from Gyazo](https://i.gyazo.com/572ac2adb76058631e3f6c34cb9a717c.gif)](https://gyazo.com/572ac2adb76058631e3f6c34cb9a717c)

- **レビュー投稿**
  - ログインが必要
  - 総合・技術・接客・金額の星評価
  - タグ付け機能（例：スポーツ自転車のみ対応、即日修理可）

    [![Image from Gyazo](https://i.gyazo.com/aae644f67a19b9f1a4b4b077e123bafb.gif)](https://gyazo.com/aae644f67a19b9f1a4b4b077e123bafb)


- **ユーザー管理**
  - Devise による認証
  - プロフィール閲覧・編集

---

## 技術構成

アプリ全体は MVC 構造に基づき、以下のレイヤーで構成されています。

### 使用技術

| 分類 | 技術 |
|------|------|
| バックエンド | Ruby on Rails 7.1.3 |
| フロントエンド | Hotwire (Turbo + Stimulus), Tailwind CSS |
| データベース | PostgreSQL |
| 外部 API | Google Maps API, Places API |
| 認証 | Devise |
| コンテナ | Docker |
| アプリケーションサーバー | Fly.io |
| バージョン管理ツール | GitHub・Git Flow |

### ER図

[![Image from Gyazo](https://i.gyazo.com/4d413fb6d8aa1a8eec449282e6a860ca.png)](https://gyazo.com/4d413fb6d8aa1a8eec449282e6a860ca)


### 画面遷移図
- [画面遷移図](https://www.figma.com/design/1zSAEAHLbT2t7YmMSZzw8A/%E8%87%AA%E8%BB%A2%E8%BB%8A%E5%BA%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC%E3%82%A2%E3%83%97%E3%83%AA?node-id=1-19&p=f&t=12sVQ1uUesx5Zwrf-0)



<!--# README
# 🚲 自転車店レビューアプリ（名称：bike review map）

## ■ サービス概要（3行で説明）

自転車店を地図上で検索し、Googleレビューやユーザー独自のレビューを確認できるサービスです。
近くの信頼できる店舗を簡単に探せるようになります。
ユーザー自身もレビューを投稿して、地域のサイクリスト同士で情報を共有できます。

---

## ■ このサービスへの思い・作りたい理由

自転車が趣味で旅先や出先でパンクや整備が必要になる場面が多く、土地勘のない場所で信頼できる店舗を探すのに苦労した経験がきっかけです。
Googleマップで探すこともできますが、「自転車専門かどうか」「対応の丁寧さ」などの判断材料が乏しく、レビューの質にばらつきがあることが課題でした。
同じように自転車に乗る人たちのリアルな口コミや体験談を共有できる場所を作りたいという思いから、このサービスを立ち上げました。

---

## ■ ユーザー層について

サイクリスト（趣味・通勤） 自転車を日常的に使う人が、店舗選びに悩むケースが多いため。
ツーリング中の利用者  旅先でのメンテナンス需要が高く、信頼できる店舗情報が求められるため。
自転車店オーナー  良質な口コミで集客したい店舗側にもメリットがあるため。

---

## ■ サービスの利用イメージ

ユーザーはアプリを開き、現在地や指定エリア周辺の自転車店を一覧・地図で確認できます。
各店舗のGoogleレビューに加えて、他ユーザーが投稿した独自レビューも見ることができます。
レビューを通じて安心して店舗を選べるようになり、同時に自分の体験をシェアすることで他のユーザーに貢献できます。

---

## ■ ユーザーの獲得について

主にX（旧Twitter）やInstagramなど、自転車ユーザーが多く集まるSNSでの告知を予定しています。
また、サイクリスト向けのコミュニティやイベントと連携し、サービスの認知を広げていく計画です。
さらに、身近なユーザーによる初期レビューの投稿も想定しています。
実際の投稿例があることで、他のユーザーもレビューしやすくなり、活発な利用につながりやすいと考えています。

## ■ サービスの差別化ポイント・推しポイント

Google Maps単体と比較すると、「自転車専門店」の絞り込み＋ユーザーによる独自レビューが可能
食べログなどのレビューサイトと比較すると、一般店舗向けで「自転車特化」の情報が濃い
店舗の公式サイトと比較すると、ユーザー視点の評価が分かる、情報が更新されていく

**推しポイント：**
- Googleレビュー + ユーザー口コミの融合
- 地図ベースで視覚的に探せる UI
- サイクリスト同士のつながりを意識したレビュー設計

---

## ■ 技術スタック

バックエンド        Ruby / Ruby on Rails
フロントエンド      JavaScript、Tailwind CSS
認証機能           Devise
データベース        PostgreSQL
外部API            Google Maps API, Places API
デプロイ・インフラ  Fly.io
バージョン管理     Git / GitHub

## ■ 使用予定の主なGemについて

このアプリでは、以下のGemを主に使用する予定です。

ユーザー認証には `devise` を使用予定で、メール認証やパスワードリセットなどの基本機能を実装します。
地図機能は `geocoder` を用いて、住所や現在地から緯度経度を取得し、Google Mapsとの連携に活用します。
テストは `rspec-rails` と `factory_bot_rails` を使用し、デバッグには `pry-rails` を導入予定です。
スタイリングには `tailwindcss-rails` を使用し、柔軟でモダンなUIを構築します。
また、コードの静的解析には `rubocop` を導入し、可読性や保守性の高いコードを目指します。

必要に応じて他のGemも随時追加・見直しを行っていく方針です。

---

## ■ 機能候補

### MVPリリースまでに実装したい機能

- Google Maps & Places API 連携（自転車店検索）
- 店舗一覧・地図表示・閲覧
- 店舗詳細ページ（Googleレビューの表示）
- 独自レビュー投稿（ログイン必須）
- ユーザー登録・ログイン
- 店舗のタグ付け
### 本リリースまでに追加したい機能

- Googleログイン
- ユーザーページ
- Autocomplete（住所自動補完）
- 検索絞り込み機能
- ページング機能
- OGP対応
- プライバシーポリシー表示
- 利用規約表示
- RSpecテストの導入
- RuboCop導入（コード静的解析）
- GitHub Actions（CI/CD）

---

## ■ 機能の実装方針予定

店舗検索  Google Places API
店舗詳細＋レビュー取得  Google Places API
地図表示  Google Maps JavaScript API
ユーザー投稿レビュー  ユーザー投稿とGoogleレビューを統合表示
ユーザー認証  Devise

## ■ 画面遷移図

https://www.figma.com/design/1zSAEAHLbT2t7YmMSZzw8A/%E8%87%AA%E8%BB%A2%E8%BB%8A%E5%BA%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC%E3%82%A2%E3%83%97%E3%83%AA?node-id=1-19&p=f&t=12sVQ1uUesx5Zwrf-0

## ■ ER図

[![Image from Gyazo](https://i.gyazo.com/4d413fb6d8aa1a8eec449282e6a860ca.png)](https://gyazo.com/4d413fb6d8aa1a8eec449282e6a860ca)
https://i.gyazo.com/4d413fb6d8aa1a8eec449282e6a860ca.png




 This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ... -->

