# TypeScriptでInterfaceのプロパティに動的アクセスしたいのにハマった時の解決方法

最近TypeScriptをやっています。

その際にInterfaceのプロパティにObject[propety]で動的アクセスしたかったけど、以下の様なエラーが出てハマったので解決方法を共有します。

```
src/index.ts(20,31): error TS7017: Element implicitly has an 'any' type 
because type 'MyInterface' has no index signature.
```

具体的に説明していきます。

## 問題点

以下の様なInterfaceを定義したとします。

```TypeScript
interface MyInterface{
  name: string;
  address: string;
  email: string;
}
```

このInterfaceの各プロパティにアクセスするfor文を回したいという状況です。

```TypeScript
const entity: MyInterface = {
  name: "rednes",
  address: "Japan",
  email: "hogehoge@example.com",
}

let result = '';

for (const property in entity){
  result += `${property}: ${entity[property]}`;
}

console.log(result);
```

これをコンパイルしようとすると以下の様なコンパイルエラーが発生します。

```
src/index.ts(20,31): error TS7017: Element implicitly has an 'any' type 
because type 'MyInterface' has no index signature.
```

どうやら動的にMyInterfaceのプロパティにアクセスしようとしているので、MyInterfaceがそのプロパティ名を本当にもっているかどうか分からんと怒られているようです。

良くある解決方法としてはコンパイラのオプションに「--suppressImplicitAnyIndexErrors」
を渡すという方法もあるようですが、一律インデクサアクセス時のエラーを抑制することはあまりやりたくありません。

別の解決方法を探しました。


## 解決方法

keyofとUser Defined Type Guardsを使います。

* keyof: 許可されるプロパティ名の列挙型を表します。`keyof MyInterface`は「'name' | 'address' | 'email'」
* User Defined Type Guards: データの型を確定する関数を自分で定義できます。

詳細はTypeScript handbookを参照してください。
https://www.typescriptlang.org/docs/handbook/advanced-types.html

User Defined Type Guardsを利用して、MyInterfaceのプロパティ名であることを保証する関数「isProperty」を定義します。

```TypeScript
function isProperty(value: string): value is (keyof MyInterface){
    return value === 'name' || value === 'address' || value === 'email';
}
```

この関数をかませて、コンパイラにMyInterfaceのプロパティであることを学習させることで、インターフェイスのプロパティに動的アクセスしても、コンパイルエラーが発生しなくなります。

```TypeScript
let result = '';

for (const property in entity){
  if (isProperty(property)) {
    result += `${property}: ${entity[property]}`;
  }
}

console.log(result);
```
