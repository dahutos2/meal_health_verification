# 静的解析
## 追加ルール
1. **prefer_single_quotes**: 
文字列を定義する際に単一引用符(')を使用することを推奨します。
2. **prefer_double_quotes**: 
このルールをfalseに設定しているので、二重引用符(")を使用することは推奨されていません
3. **avoid_returning_this**: 
void型の非同期関数を避けることを推奨します。
4. **use_colored_box**: 
Colorの指定だけをしているContainerがある場合、ColoredBoxの使用を推奨します。
5. **use_decorated_box**: 
Decorationの指定だけをしているContainerがある場合、DecoratedBoxの使用を推奨します。
6. **cancel_subscriptions**: 
StreamSubscriptionインスタンスに対してcancelを行うことを推奨します。
7. **prefer_constructors_over_static_methods**: 
オブジェクトを返す静的メソッドよりも、コンストラクタを使用することを推奨します。
8. **avoid_slow_async_io**: 
パフォーマンスの低下を引き起こす可能性がある非同期のI/Oを避けることを推奨します。
9. **avoid_multiple_declarations_per_line**: 
1行に複数の変数宣言を避けることを推奨します。
## 初期ルール
### バージョン
- flutter_lints: 
2.0.0
### 関連リンク　
- [flutter.yaml](https://github.com/flutter/packages/blob/main/packages/flutter_lints/lib/flutter.yaml)
- [recommended.yaml](https://github.com/dart-lang/lints/blob/main/lib/recommended.yaml)
- [core.yaml](https://github.com/dart-lang/lints/blob/main/lib/core.yaml)
### 詳細
#### コード
<details>
<summary>クリックして展開します。</summary>

```yaml
avoid_empty_else: true
avoid_relative_lib_imports: true
avoid_shadowing_type_parameters: true
avoid_types_as_parameter_names: true
await_only_futures: true
camel_case_extensions: true
camel_case_types: true
collection_methods_unrelated_type: true
curly_braces_in_flow_control_structures: true
depend_on_referenced_packages: true
empty_catches: true
file_names: true
hash_and_equals: true
implicit_call_tearoffs: true
no_duplicate_case_values: true
non_constant_identifier_names: true
null_check_on_nullable_type_parameter: true
package_prefixed_library_names: true
prefer_generic_function_type_aliases: true
prefer_is_empty: true
prefer_is_not_empty: true
prefer_iterable_whereType: true
prefer_typing_uninitialized_variables: true
provide_deprecation_message: true
unnecessary_overrides: true
unrelated_type_equality_checks: true
use_string_in_part_of_directives: true
valid_regexps: true
void_checks: true
annotate_overrides: true
avoid_function_literals_in_foreach_calls: true
avoid_init_to_null: true
avoid_null_checks_in_equality_operators: true
avoid_renaming_method_parameters: true
avoid_return_types_on_setters: true
avoid_returning_null_for_void: true
avoid_single_cascade_in_expression_statements: true
constant_identifier_names: true
control_flow_in_finally: true
empty_constructor_bodies: true
empty_statements: true
exhaustive_cases: true
implementation_imports: true
library_names: true
library_prefixes: true
library_private_types_in_public_api: true
no_leading_underscores_for_library_prefixes: true
no_leading_underscores_for_local_identifiers: true
null_closures: true
overridden_fields: true
package_names: true
prefer_adjacent_string_concatenation: true
prefer_collection_literals: true
prefer_conditional_assignment: true
prefer_contains: true
prefer_equal_for_default_values: true
prefer_final_fields: true
prefer_for_elements_to_map_fromIterable: true
prefer_function_declarations_over_variables: true
prefer_if_null_operators: true
prefer_initializing_formals: true
prefer_inlined_adds: true
prefer_interpolation_to_compose_strings: true
prefer_is_not_operator: true
prefer_null_aware_operators: true
prefer_spread_collections: true
prefer_void_to_null: true
recursive_getters: true
slash_for_doc_comments: true
type_init_formals: true
unnecessary_brace_in_string_interps: true
unnecessary_const: true
unnecessary_constructor_name: true
unnecessary_getters_setters: true
unnecessary_late: true
unnecessary_new: true
unnecessary_null_aware_assignments: true
unnecessary_null_in_if_null_operators: true
unnecessary_nullable_for_final_variable_declarations: true
unnecessary_string_escapes: true
unnecessary_string_interpolations: true
unnecessary_this: true
use_function_type_syntax_for_parameters: true
use_rethrow_when_possible: true
avoid_print: true
avoid_unnecessary_containers: true
avoid_web_libraries_in_flutter: true
no_logic_in_create_state: true
prefer_const_constructors: true
prefer_const_constructors_in_immutables: true
prefer_const_declarations: true
prefer_const_literals_to_create_immutables: true
sized_box_for_whitespace: true
sort_child_properties_last: true
use_build_context_synchronously: true
use_full_hex_values_for_flutter_colors: true
use_key_in_widget_constructors: true
```

</details>

---

#### 説明
<details>
<summary>クリックして展開します。</summary>

##### 1. 命名規則
1. **camel_case_extensions**: 
拡張名はキャメルケースを使用すべきです。
2. **camel_case_types**: 
クラス名はキャメルケースを使用すべきです。
3. **constant_identifier_names**: 
定数の名前は、全て小文字のスネークケースを使用することを推奨します。
4. **file_names**: 
ファイル名はsnake_caseを使用すべきです。
5. **library_names**: 
ライブラリの名前は、Dartの命名規則に従っていることを確認します。
6. **package_names**: 
パッケージの名前がDartの命名規則に従っているかを確認します。
7. **non_constant_identifier_names**: 
非定数識別子にはlowerCamelCaseを使用すべきです。
8. **no_leading_underscores_for_library_prefixes**: 
ライブラリの接頭辞としてアンダースコアを先頭に使用するのを避けることを推奨します。
9. **no_leading_underscores_for_local_identifiers**: 
ローカル変数やローカル関数の名前の先頭にアンダースコアを使用するのを避けることを推奨します。
##### 2. コードスタイルとフォーマット
10.  **avoid_empty_else**: 
`else`ブロックが空である場合に警告します。
11.  **curly_braces_in_flow_control_structures**: 
制御フロー構造(if、for、whileなど)において、中括弧{}を省略せずに使用することを推奨します。
12.  **empty_constructor_bodies**: 
空のコンストラクタ本体を持つ場合、その本体を省略することを推奨します。
13.  **empty_statements**: 
空のステートメント（`;` のみ）を避けることを推奨します。
14.  **prefer_adjacent_string_concatenation**: 
隣接する文字列リテラルは連結されるべきです。
15.  **slash_for_doc_comments**: 
ドキュメントコメントに`///`を使用します。
16.  **unnecessary_brace_in_string_interps**: 
文字列補間内での不要な中括弧を避けます。
17.  **unnecessary_const**: 
constが不要な場合はそれを使用しないことを推奨します。
18.  **unnecessary_new**: 
Dart 2以降で`new`キーワードは不要なので、それを使用しないことを推奨します。
19.  **unnecessary_this**: 
`this` キーワードが不要な場合、それを使用しないことを推奨します。
##### 3. インポートとエクスポート
20. **avoid_relative_lib_imports**: 
ライブラリをインポートする際に相対パスを避けることを推奨します。
21. **depend_on_referenced_packages**: 
使用するすべてのパッケージに依存する必要があります。
22. **implementation_imports**: 
実装の詳細を公開するモジュールのインポート（`'package:xxx/src/...'` のような形）を避けることを推奨します。
23. **library_prefixes**: 
インポートされたライブラリに接頭辞を付ける場合、その接頭辞が適切なものであるかを確認します。
24. **package_prefixed_library_names**: 
ライブラリ名にはパッケージ名をプレフィックスとして使用すべきです。
25. **use_string_in_part_of_directives**: 
`part of`ディレクティブでライブラリ名の文字列を使用します。
##### 4. 型と型安全
26. **avoid_shadowing_type_parameters**: 
型パラメータが同じスコープ内の別の型パラメータを隠さないようにします。
27. **avoid_types_as_parameter_names**: 
パラメータ名として型名を避けます。
28. **await_only_futures**: 
`await`キーワードは`Future`オブジェクトにのみ使用すべきです。
29. **null_check_on_nullable_type_parameter**: 
nullチェックはnullableな型パラメータでは不要です。
30. **prefer_generic_function_type_aliases**: 
一般的な関数型の別名を使用することを推奨します。
31. **prefer_is_not_empty**: 
`.length > 0`よりも`isNotEmpty`を使用することを推奨します。
32. **prefer_is_empty**: 
`.length == 0`よりも`isEmpty`を使用することを推奨します。
33. **prefer_iterable_whereType**: 
一般的な型でのフィルタリングに`iterable.whereType<T>()`を使用することを推奨します。
34. **prefer_typing_uninitialized_variables**: 
初期化されていない変数は明示的に型を指定することを推奨します。
35. **unrelated_type_equality_checks**: 
異なる型間の等しさのチェックを警告します。
36. **valid_regexps**: 
正規表現のリテラルが正しいかどうかをチェックします。
37. **void_checks**: 
戻り値の型として`void`の使用をチェックします。
##### 5. 最適化とリファクタリング**
38. **implicit_call_tearoffs**: 
メソッドや関数の暗黙的なcall tear-offsを避けます。
39.  **no_duplicate_case_values**: 
`switch`文で重複した`case`値を避けます。
40.  **prefer_conditional_assignment**: 
条件付きの代入を使用して、変数の代入を行います。
41.  **prefer_contains**: 
`indexOf`よりも`contains`を使用して、コレクションが特定の要素を含んでいるかどうかを確認することを推奨します。
42.  **prefer_final_fields**: 
可変性を最小限に抑えるために、可能な場合`final`フィールドを使用することを推奨します。
43.  **prefer_for_elements_to_map_fromIterable**: 
可能な場合、`Map.fromIterable`よりもfor要素を使用することを推奨します。
44.  **prefer_function_declarations_over_variables**: 
変数よりも関数の宣言を好むことを推奨します。
45.  **prefer_if_null_operators**: 
`??`オペレータを使用して、nullチェックと代入を行います。
46.  **prefer_inlined_adds**: 
`add`メソッドの呼び出しを直接リスト/セットの中に組み込むことを推奨します。
47.  **prefer_interpolation_to_compose_strings**: 
文字列を組み立てる場合、`+`よりも文字列補間を使用することを推奨します。
48.  **prefer_is_not_operator**: 
`x is! T`という形式を`!(x is T)`よりも推奨します。
49.  **prefer_equal_for_default_values**: 
デフォルト値として等価演算子`=`を使用します。
50.  **prefer_null_aware_operators**: 
可能な場合、null許容オペレータを使用します。
51.  **prefer_spread_collections**: 
スプレッドコレクションを使用して、コレクションを組み合わせることを推奨します。
52. **unnecessary_constructor_name**: 
インスタンスの生成時に、コンストラクタ名が不要な場合はそれを省略します。
53.  **use_function_type_syntax_for_parameters**: 
関数タイプのパラメータのシンタックスを使用することを推奨します。
54.  **use_rethrow_when_possible**: 
例外を再スローする際に、`rethrow`を使用することを推奨します。
55.  **unnecessary_getters_setters**: 
不要なgetterやsetterを避けます。
56.  **unnecessary_late**: 
必要のない場所での`late`キーワードの使用を避けます。
57.  **unnecessary_null_aware_assignments**: 
null許容代入が不要な場合、それを使用しないことを推奨します。
58.  **unnecessary_null_in_if_null_operators**: 
`??`オペレータ内での不要なnullを避けます。
59.  **unnecessary_string_escapes**: 
文字列内の不要なエスケープを避けることを推奨します。
60.  **unnecessary_string_interpolations**: 
不要な文字列補間を避けます。
##### 6. エラーと例外処理
61. **empty_catches**: 
空の`catch`ブロックにはコメントを付けるべきです。
62. **provide_deprecation_message**: 
`@Deprecated`アノテーションを使用する場合、非推奨の理由を提供することを推奨します。
63. **unnecessary_overrides**: 
不要な`@override`アノテーションを持つメソッドを警告します。
64. **recursive_getters**: 
getterが自身を再帰的に呼び出すことを避けます。
##### 7. オブジェクトとクラス設計
65. **avoid_function_literals_in_foreach_calls**: 
`forEach` メソッドの呼び出し内で関数リテラル（無名関数）を使用するのを避けることを推奨します。これにより、パフォーマンスの低下や意図しないクロージャの作成を避けることができます。
66. **avoid_init_to_null**: 
変数を`null`で初期化するのを避けます。Dartでは変数はデフォルトで`null`になります。
67. **avoid_null_checks_in_equality_operators**: 
等価演算子(==)内でnullチェックを避けることを推奨します。
68. **avoid_renaming_method_parameters**: 
オーバーライドされたメソッドのパラメータ名を変更しないようにします。
69. **avoid_return_types_on_setters**: 
setterに戻り値の型を指定しないようにします。
70. **avoid_returning_null_for_void**: 
voidを返す関数やメソッドでnullを返すのを避けることを推奨します。
71. **avoid_single_cascade_in_expression_statements**: 
単一のカスケードを持つ式文を避けます。
72. **collection_methods_unrelated_type**: 
関連性のない型に対してコレクションメソッドを呼び出さないようにします。
73. **hash_and_equals**: 
`==`をオーバーライドするときは、`hashCode`もオーバーライドする必要があります。
74. **library_private_types_in_public_api**: 
公開APIでライブラリプライベートの型を使用するのを避けることを推奨します。
75. **overridden_fields**: 
親クラスで定義されているフィールドを、サブクラスでオーバーライドするのを避けることを推奨します。
76. **prefer_collection_literals**: 
コレクションリテラルを使用して、新しいコレクションインスタンスを作成することを推奨します。
77. **prefer_initializing_formals**: 
コンストラクタでの初期化を行う場合、初期化フォーマルを使用することを推奨します。
78. **prefer_void_to_null**: 
void型を返す関数やメソッドに、nullを明示的に返すことを避けるよう推奨します。
79. **type_init_formals**: 
パラメータの型を二重に指定しないようにします。
80. **annotate_overrides**: 
オーバーライドされたメンバに`@override`アノテーションを付けることを推奨します。
##### 8. Flutter固有
81. **avoid_print**: 
一般的なコードでの`print`ステートメントの使用を避けます。
82. **avoid_unnecessary_containers**: 
不要な`Container`ウィジェットを避けることを推奨します。
83. **avoid_web_libraries_in_flutter**: 
Flutterアプリケーション内でWeb固有のライブラリを使用するのを避けることを推奨します。
84. **no_logic_in_create_state**: 
`createState`メソッド内にロジックを配置しないようにします。
85. **prefer_const_constructors**: 
可能な場合、`const` コンストラクタを使用することを推奨します。
86. **prefer_const_constructors_in_immutables**: 
不変のオブジェクトで`const` コンストラクタを使用することを推奨します。
87. **prefer_const_declarations**: 
可能な場合、`const`宣言を使用することを推奨します。
88. **prefer_const_literals_to_create_immutables**: 
不変オブジェクトを作成するための`const`リテラルを使用することを推奨します。
89. **sized_box_for_whitespace**: 
空白を作成するために`SizedBox`を使用します。
90. **sort_child_properties_last**: 
子プロパティを最後にソートすることを推奨します。
91. **use_build_context_synchronously**: 
`BuildContext`を同期的に使用することを推奨します。
92. **use_full_hex_values_for_flutter_colors**: 
Flutterの色で完全な16進値を使用することを推奨します。
93. **use_key_in_widget_constructors**: 
ウィジェットのコンストラクタにKeyを追加することを推奨します。
##### 9. その他のベストプラクティス
94. **control_flow_in_finally**: 
`finally` ブロック内で `return`, `break`, `throw`, `continue` などの制御フローを変更するステートメントを使用するのを避けることを推奨します。
95. **exhaustive_cases**: 
`switch` ステートメントが列挙型に対して使われる場合、全てのケースを網羅していることを確認します。
96. **null_closures**: 
nullとしてクロージャを渡すのを避けることを推奨します。
97. **unnecessary_nullable_for_final_variable_declarations**: 
`final`変数宣言で不要な`?` (null許容型) を避けます。

</details>