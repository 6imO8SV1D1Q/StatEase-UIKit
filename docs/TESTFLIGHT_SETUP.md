# TestFlight 自動デプロイセットアップガイド

このドキュメントでは、GitHub Actionsを使用してTestFlightに自動的にアプリをアップロードするための設定手順を説明します。

## 概要

`claude/**` または `codex/**` ブランチにプッシュすると、自動的にアプリがビルドされ、TestFlightにアップロードされます。

## 必要なGitHub Secrets

以下のsecretsをGitHubリポジトリに設定する必要があります:

### 1. Apple API Key関連

#### `APPLE_API_KEY_ID`
- **説明**: App Store Connect APIキーのKey ID
- **取得方法**:
  1. [App Store Connect](https://appstoreconnect.apple.com) にログイン
  2. Users and Access > Keys タブを選択
  3. 新しいAPIキーを作成（またはキーを使用）
  4. Key IDをコピー

#### `APPLE_API_ISSUER_ID`
- **説明**: App Store Connect APIのIssuer ID
- **取得方法**:
  1. [App Store Connect](https://appstoreconnect.apple.com) にログイン
  2. Users and Access > Keys タブを選択
  3. ページ上部に表示されているIssuer IDをコピー

#### `APPLE_API_KEY_CONTENT`
- **説明**: APIキーファイル(.p8)の内容
- **取得方法**:
  1. App Store ConnectでAPIキーをダウンロード
  2. ダウンロードした.p8ファイルの内容をコピー
  3. `cat AuthKey_XXXXXXXXXX.p8` でファイル内容を表示し、全体をコピー

### 2. コード署名関連

#### `CERTIFICATES_P12`
- **説明**: 配布証明書のbase64エンコード内容
- **取得方法**:
  1. Keychainから「Apple Distribution」証明書をエクスポート（.p12形式）
  2. base64エンコード: `base64 -i certificate.p12 | pbcopy`
  3. コピーした内容を設定

#### `CERTIFICATE_PASSWORD`
- **説明**: p12証明書のパスワード
- **設定値**: 証明書エクスポート時に設定したパスワード

#### `PROVISIONING_PROFILE`
- **説明**: プロビジョニングプロファイルのbase64エンコード内容
- **取得方法**:
  1. [Apple Developer](https://developer.apple.com) でApp Store用プロビジョニングプロファイルをダウンロード
  2. base64エンコード: `base64 -i profile.mobileprovision | pbcopy`
  3. コピーした内容を設定

#### `PROVISIONING_PROFILE_SPECIFIER`
- **説明**: プロビジョニングプロファイルの名前
- **設定値**: プロビジョニングプロファイルの正確な名前（例: "StatEase-UIKit AppStore"）

#### `DEVELOPMENT_TEAM`
- **説明**: Apple Developer Team ID
- **設定値**: `NA5UKGY8F8` (プロジェクトで使用中のTeam ID)
- **確認方法**:
  1. [Apple Developer](https://developer.apple.com/account) にログイン
  2. Membership > Team ID を確認

## GitHub Secretsの設定方法

1. GitHubリポジトリページにアクセス
2. Settings > Secrets and variables > Actions を選択
3. "New repository secret" をクリック
4. 上記の各secretを名前と値のペアで追加

## 証明書とプロビジョニングプロファイルの準備

### 配布証明書の作成
1. [Apple Developer](https://developer.apple.com) にログイン
2. Certificates, Identifiers & Profiles > Certificates を選択
3. 新しい "Apple Distribution" 証明書を作成
4. Keychainに証明書をインストール

### プロビジョニングプロファイルの作成
1. [Apple Developer](https://developer.apple.com) にログイン
2. Certificates, Identifiers & Profiles > Profiles を選択
3. 新しい "App Store" プロファイルを作成
4. Bundle ID: `com.yusukeabe.StatEase-UIKit`
5. 作成した配布証明書を選択
6. プロファイルをダウンロード

## ワークフローの動作確認

1. `claude/**` または `codex/**` ブランチを作成
2. コードをプッシュ
3. GitHub Actions タブでビルドの進行状況を確認
4. ビルドが成功したら、App Store Connectでアプリの処理状況を確認
5. TestFlightでアプリが利用可能になるのを待つ（通常15-30分）

## トラブルシューティング

### ビルドが失敗する場合
- すべてのsecretsが正しく設定されているか確認
- 証明書が有効期限内か確認
- プロビジョニングプロファイルが有効か確認
- Bundle IDが一致しているか確認

### アップロードが失敗する場合
- Apple API Keyの権限を確認（App Manager以上が必要）
- API Keyが有効か確認
- App Store Connectでアプリが作成済みか確認

## 参考資料

- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Xcode Build Settings](https://developer.apple.com/documentation/xcode/build-settings-reference)
