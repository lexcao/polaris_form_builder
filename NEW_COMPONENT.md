# 新组件落地流水线（以 TextField / Checkbox 为参照）

## 参考：现有 TextField
- **FormBuilder 实现**：`lib/polaris_form_builder/form_builder.rb` 的 `text_field` 先用 Rails `super` 生成 `<input ...>`（复用 Rails 的 `name/value/checked/disabled/...` 语义），再用 `PolarisTag` 将 tag 变换为 `<s-text-field ...>`，剔除不需要的属性（例如 `type`），并在必要时 unwrap `field_error_proc` 的 wrapper，确保最终输出是单一 Polaris 组件 tag；支持 block 作为 slot 内容。
- **Unit Test**：`test/test_text_field.rb` 验证基础渲染 `<s-text-field name="post[title]"></s-text-field>`，覆盖属性注入与闭合标签。
- **Integration Test**：`test/dummy/test/integration/components/text_field_test.rb` 覆盖主示例 GET、invalid 提交显示错误（422）、valid 提交重定向并再渲染提交值。

## 参考：现有 Checkbox
- **FormBuilder 实现**：`lib/polaris_form_builder/form_builder.rb` 的 `check_box` 复用 Rails `super` 的表单语义（默认会包含 unchecked 的 hidden input），再将 `<input type="checkbox" ...>` 变换为 `<s-checkbox ...>`；对 SoT example 对比时，测试基建会忽略 hidden input 与 checkbox 的默认 `value="1"`。
- **Unit Test**：`test/test_checkbox.rb` 覆盖 SoT examples，以及 `include_hidden`、`value:` 映射、checked 语义等行为断言。
- **Integration Test**：`test/dummy/test/integration/components/checkbox_test.rb` 覆盖 GET 主示例、invalid 提交展示 error（422）、valid 提交重定向并反映 checked 状态。

## 0. 关键约束：`data/components/<Component>.json` 是 SoT
- `data/components/<Component>.json` 视为只读输入（source of truth），实现与测试都要 follow 它。
- 不要为了让测试通过去手改 `data/components/*.json`。
- 如果发现 `html_code` 与 `erb_code` 不一致或示例缺失：
  - 优先把问题记录清楚并上报（外部 SoT 的问题应该在上游修复）。
  - 本仓库的 unblock 策略二选一（需要在 Pipeline 中显式写明并保持一致）：
    - **Skip**：在 `test/test_<component>.rb` 中跳过该 example，并写清原因（最小改动，保留信号）。
    - **Snapshot**：在 `test/fixtures/components/` 维护“本仓库认可的 snapshot”，并让测试基建从 fixture 读取（需要额外改测试基建）。

## 1. 命名与 alias（必须先对齐）
一个组件通常会同时涉及 3 个名字：
- **Component key（canonical）**：以实际 Web Component tag 为准（例如 `s-checkbox` → `checkbox`），用于 dummy 路由参数与 loader。
- **JSON 文件名**：由 loader 根据 component key 映射，例如 `checkbox` → `Checkbox.json`。
- **Ruby helper 名**：FormBuilder 方法名（可能受 Rails 命名影响），例如 `check_box`。

常规情况下 component key 可以由 tag 推导：
- `s-<kebab-case>` → `<snake_case>`（去掉 `s-` 前缀，并把 `-` 转成 `_`）。
  - 例如：`s-text-field` → `text_field`，`s-checkbox` → `checkbox`。

但 Ruby helper 可能有 Rails 特例（例如 `check_box`）。建议以 Rails 的 helper 命名为准（跟随 SoT 的 `erb_code`），而 component key 仍以 tag 推导出来的 canonical 为准：
- **Dummy canonicalization**：dummy 的路由参数用 canonical（例如 `checkbox`），loader 才能找到 `Checkbox.json`。
- **Converter alias**：`bin/dev/converter.rb` 里维护特殊映射（例如 `checkbox` → `check_box`），用于从 HTML 生成 ERB。

## 2. 新组件落地步骤
1. 建分支  
   ```bash
   git checkout -b feature/<component-name>
   ```
2. 设计与实现（以 JSON 为准）  
   - 阅读 `data/components/<Component>.json`：`properties` + `examples[*].erb_code/html_code`。
   - 明确：必选/可选属性、slot、错误展示、值来源（object / options）、以及任何特殊命名 alias。
   - 在 `lib/polaris_form_builder/form_builder.rb` 添加对应 builder 方法与必要的 alias。
   - 实现要求：
     - **Correctness first**：优先保证行为正确（包含边界条件与错误路径），不要为了“看起来像 Rails”牺牲正确性。
     - **DHH style**：代码保持 clean & simple，避免抽象过度与不必要的间接层；优先小而直白的方法、清晰命名、少魔法。
     - **Prefer `super` + `PolarisTag`**：优先用 Rails `super` 生成基础 tag（拿到 `name/value/checked/...` 等 Rails 语义），再用 `PolarisTag` 做 tag 变换与属性规整；避免手拼字符串或重复实现 Rails 细节。
     - **Multi-tag output**：允许保留 Rails 为语义完整性生成的额外 tag（例如 `check_box` 的 unchecked hidden input）；若业务上必须单 tag，再显式选择 `include_hidden: false` 并补足对应语义。
     - **Require hygiene**：不要在实现代码里为测试补 require；测试缺失的依赖应加到 `test/test_helper.rb`（或对应 dev tool）。
     - **Rails-like attributes**：boolean attributes 用 `true` 表示存在（由 Rails 输出 `checked="checked"` / `disabled="disabled"`），测试侧用 attribute presence 断言。
     - **Rails API compatibility**：如果实现的是 Rails `FormBuilder` 同名方法（例如 `check_box`），尽量保持方法签名与核心语义一致（包括参数顺序与默认值），避免破坏调用方习惯。
     - **Options discipline**：不要就地修改调用方传入的 `options`，先 `dup` 再 `delete`/归一化；同时明确“调用方 options 优先还是 builder 推导优先”的规则，并在实现里用一致的 merge 顺序表达。
3. Unit Test（两层测试，避免只靠 example）  
   - **Example-driven**：用 `ComponentExampleTest` 覆盖“JSON 中一致且有价值”的 examples；对已知不一致 examples 做显式 skip。
   - **Behavior-driven**：补充最小闭环断言：`name/value/error/checked` 等由 builder 推导出来的行为。
   - 运行：  
     ```bash
     mise exec ruby@3.4.5 -- bundle exec ruby -I test test/test_<component>.rb
     ```
4. Integration Test（dummy wiring 清单）  
   - `test/dummy/app/controllers/components_controller.rb`：加入 permit 字段（必要时加入 alias canonicalization）。
   - `test/dummy/app/models/preview_form.rb`：加入字段与校验，用于覆盖 422/303 两条路径。
   - `test/dummy/test/integration/components/<component>_test.rb`：至少 3 个用例：GET 主示例、POST invalid（422）、POST valid（303 + follow redirect）。
   - 运行：  
     ```bash
     mise exec ruby@3.4.5 -- rake test TEST=test/dummy/test/integration/components/<component>_test.rb
     ```
5. Playground Preview（建议同步维护，避免 E2E 里“看起来不工作”）  
   Playground 会直接执行 SoT 的 `erb_code`，因此它能很好地暴露“builder 是否真的生效 / 表单语义是否正确 / round-trip 是否工作”。但要让 “Try it” 真正可用，需要补齐 preview plumbing：
   - `app/playground/app/controllers/components_controller.rb`：`preview_params` 必须按 component key permit 对应字段（checkbox 往往不止一个 field）。
   - `app/playground/app/models/preview.rb`：为会出现在 examples 里的 field 增加属性（checkbox 推荐 `:boolean`），否则无法回显 checked 状态。
   - `app/playground/app/views/components/_preview.html.erb`：form 的 model 用 `@preview`（例如 `@preview || Preview.new`），才能在 redirect 回 show 时回显用户输入。
   - `app/playground/test/components_preview_test.rb`：加一个 round-trip 回归用例（POST preview → redirect → assert checked + result JSON）。
   - 运行：  
     ```bash
     BUNDLE_GEMFILE=app/playground/Gemfile RAILS_ENV=test bundle exec rails db:prepare
     BUNDLE_GEMFILE=app/playground/Gemfile RAILS_ENV=test bundle exec rails test
     ```
6. 回归检查  
   - 确认命名、API、dummy wiring、tests 与 SoT 输入的一致性；对任何不一致点做显式记录（skip 或 snapshot）。
7. 提交与 PR  
   ```bash
   git status
   git commit -am "feat(<component>): add <component> field"
   gh pr create --fill
   ```
