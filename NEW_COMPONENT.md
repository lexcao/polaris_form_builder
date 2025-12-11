# NEW COMPONENT WORKFLOW (TextField 示例)

## 现有 TextField 参考
- **FormBuilder 实现**：`lib/polaris_form_builder/form_builder.rb` 的 `text_field` 从对象读取值与错误，构建 `name/value/error`，支持 block slot，通过 `@template.content_tag("s-text-field", ...)` 渲染。
- **Unit Test**：`test/test_text_field.rb` 验证基础渲染 `<s-text-field name="post[title]"></s-text-field>`，覆盖属性注入与闭合标签。
- **Integration Test**：`test/dummy/test/integration/components/text_field_test.rb` 覆盖主示例 GET（`name/label/value` 属性与提交按钮）、invalid 提交显示错误（422）、valid 提交重定向并再渲染提交值。

## 新组件落地流水线
1. 建分支  
   ```bash
   git checkout -b feature/<component-name>
   ```
2. 设计与实现  
   - 阅读 `data/components/<Component>.json` 属性说明与 `erb_code` 示例，确定必选/可选属性、slot、错误与交互需求。  
   - 在 `lib/polaris_form_builder/form_builder.rb` 添加对应 builder 方法：取值、name 拼接、错误收集、slot 捕获，输出匹配 JSON 示例的 Polaris 元素（不要机械照搬 `text_field`，以 JSON 为准）。
3. Unit Test  
   - 新增/更新 `test/test_<component>.rb`，基于 JSON 示例覆盖：基础渲染、必填/默认属性、错误信息、slot/附加内容。  
   - 运行：  
     ```bash
     mise exec ruby@3.4.5 -- bundle exec ruby -I test test/test_<component>.rb
     ```
4. Integration Test  
   - 在 `test/dummy/test/integration/components/<component>_test.rb` 添加用例：GET 主示例渲染、invalid 提交错误、valid 提交重定向后再渲染。  
   - 如需，与 JSON 示例保持一致，补齐 dummy controller/view 与 `data/components/<Component>.json`。  
   - 运行：  
     ```bash
     mise exec ruby@3.4.5 -- rake test TEST=test/dummy/test/integration/components/<component>_test.rb
     ```
5. 回归检查  
   - 确认命名与 API 与既有组件风格一致，示例数据、实现、测试三者同步。必要时补充文档/样例。
6. 提交与 PR  
   ```bash
   git status
   git commit -am "feat(<component>): add <component> field"
   gh pr create --fill   # 或指定 --title/--body/--base
   ```
