<!-- <link href="https://raw.github.com/simonlc/Markdown-CSS/master/markdown.css" rel="stylesheet"> -->

<style>
body {
  font-size: 0.9em;
}
</style>

# SPFコーディング規約

SPFのコーディング規約をまとめたページになります。

## 基本的なところ

smacssとBEMを参考にしたコーディング規約

## HTMLコーディング

### html5

HTMLのコーディングはHTML5のDOCTYPE準拠のタグを利用します。

```
<!DOCTYPE html>
```

## cssコーディング

### scss

柔軟性を重視し、CSSの記法はSCSSを採用します。

### 基本スタイル

#### リセット

基本のリセットスタイルにはnormalize.cssを利用します。

#### compass

CSS3のベンダープレフィックスについては、Compassを利用。

#### ベース、モジュールとレイアウト

モジュールとレイアウトの概念はSMACSSを参考にしています。詳しくはSMACSSのドキュメントを参照してください。
モジュールとレイアウトに構造を分けることで、CSSクラスの再利用性を高めます。
基本的に、再利用できるような部品としてモジュールにまとめた上で、ページ上の位置指定などをレイアウトを使って行います。

#### セレクタ定義とモジュール化

それぞれのモジュールの平等性を高めるため、CSSのセレクタにはIDは利用せず、必ずクラスを使うことにします。同様の理由で多重の入れ子構造も利用しません。

BAD
```
#what-a-strong-selector {
  ...
}
```

BAD
```
.wrapper {
  .wrapper-inner {
    .module {
      .module-inner {
        ...
      }
    }
  }
}
```

#### ファイル構造

CSSのファイル構造は以下のようにします。
ベース、モジュール（ui）とレイアウトをそれぞれフォルダに分け、モジュール、レイアウトそれぞれの名前でSCSSファイルを作成してください。
mixinは「function」にまとめて書き、uiやlayoutから読み出してください。

また、変数は_settings.scssにまとめて記述します。

```
.
├── README.md
├── _settings.scss
├── app.scss
├── base
│   ├── _main.scss
│   └── _util.scss
├── layout
│   ├── _chat.scss
│   ├── _contacts.scss
│   ├── _footer.scss
│   ├── _navbar.scss
│   └── _signin.scss
└── module
    ├── _chat.scss
    ├── _contacts.scss
    ├── _dropdown.scss
    ├── _footer.scss
    ├── _modal.scss
    ├── _navbar.scss
    └── _signin.scss
```



### インデント

・スペース2個で

### ファイル構造



### ドキュメントとコメントアウト

CSSのドキュメントはStyleDoccoを利用して作成されています。
ドキュメント化しないコメントアウトは先頭に半角スペースを入れてください。




# SASSを使ったCSSのコーディングルール

## インデント

- ソフトインデントで2個

## コロンの位置とかっこの位置

- 下記を参照

```scss
.link {
  color: #fff;
}

.hoge,
.nanika {
  text-decoration: underline;
}

/*
クラス名の後の{は半角スペースを空ける
コロンの後は半角スペースを空ける
クラス間は1行空ける
複数クラスの指定はカンマの後に改行を入れる
*/

```

## 入れ子

- 下記を参照

```scss
.link {
  color: #fff;

  .text {
    //とりあえずコメントしてみる
    text-decoration: underline;
  }
}

/*
入れ子の中にコメントは適宜書いてよい
*/

```

## 命名規則

### クラス名の命名規則

- クラス名はロワーキャメルケースを使う
- レイアウトを明示する時は`ly`プレフィックスを付ける ->SMACSSに沿う

```scss

.lyWrapper {
 margin: 0 auto;
}

```

- 状態を明示する時は`is-*`、`has-*`、`type-*`など、ハイフンケースを使ったサブクラスを定義する ->SMACSSに沿う

```scss

.headingLv1 {
 margin: 0 auto;
 &.has-button {
   @include pie-clearfix();
 }
}

```

- モジュールを明示する時は何もプレフィックスをつけない ->SMACSSに沿う

```scss

.btn {
  border: solid 1px #ccc;
  @include border-radius(5px);
}

```

- 　レイアウトの中のモジュールを命名する必要がある時はBEMに沿って名前を付ける

```scss

.lyWrapper {
  .lyHogeBlock {
    .lyWrapper--lyHogeBlock__btn {
      border-color: #eee;
    }
  }
}

.lyHugaBlock {
  .lyHugaBlock__btn {
    border-color: #ccc;
  }
}

```

```scss

こちらを採用！

.lyWrapper {
  margin: 0 auto;
}

.lyHogeBlock {
  width: 960px;
}
.lyHogeBlock__btn {
  border-color: #eee;
}

```

###変数の命名規則

- 変数の名前はロワーキャメルケースを使う
- ダブルクォーテーションを使う
- 値が見やすいようにカテゴリごとにインデントを整理する

```scss

/* 状態色の定義 */
$alertColor        : "#ddd";
$notificationColor : "#eee";

/* 背景色の定義 */
$bgMainColor : '#ccc';
$bgSubColor  : 'bbb';

```
### Mixinの命名規則

- Mixinの名前はロワーキャメルケースを使う

```scss

@mixin createButton ( $buttonWidth ) {
  width: #{$buttonWidth}px;
}

```
