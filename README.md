# HealthPlanetClient

タニタ社の`HealthPlanetAPI`を叩くためのラッパーです。

## usage

```Swift
let client = HealthPlanetClient(clientId: "CLIENT_ID", clientSecret: "CLIENT_SECRET", refreshToken: "REFRESH_TOKEN")
// from,　to　は"yyyyMMddHHmmss"の形で渡すこと
client.fetch(from: "20220101120000", to: "20220301120000") { result in
    switch result {
    case .success(let innerScan):
        // Do anything.
    case .failure(let error):
        // Error handling.
    }
}
```

## parameters

基本的には[API仕様書](https://www.healthplanet.jp/apis/api.html)を参考にしてください。

- `clientId`, `clientSecret`  
https://www.healthplanet.jp/ から、 `登録情報` > `サービス連携` > `アプリケーション開発者の方はこちら` で登録することで取得できます。(Domainは適当で構いません。)

- `refreshToken`  
いずれ書く。
