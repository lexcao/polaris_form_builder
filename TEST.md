# TextField 集成测试方案（可复制到所有组件）

> 目标：用一套最小可复用的流水线，把 `data/components/*.json` 的「Main example」渲染到 dummy Rails app，通过真实请求验证生成的 Polaris Web Components（标签、核心属性、错误回填、`data-disable-with`），先落地 `TextField`，后续组件照抄。

## 流水线总览
- 数据源：`data/components/<Component>.json`，示例固定选用名称为 `Main example` 的示例。
- 控制器：`ComponentsController`（`show/create`），`params[:component]` 决定加载哪个组件/示例。
- 视图：单一 `components/show.html.erb`，用 `polaris_form_with` 渲染示例的 `erb_code`（来自 JSON），并附加 `form.submit`。
- 表单模型：`PreviewForm`（ActiveModel），集中声明字段与校验；按组件动态挑选字段。
- 测试：`test/dummy/test/integration/components/<component>_test.rb`，每组件独立文件，覆盖渲染、失败错误、成功回显/跳转三类用例。
- 路由：`get "/components/:component"` + `post "/components/:component"`，命名为 `component_path(:component)`.

## 文件与职责
1) `app/controllers/components_controller.rb`
   - `before_action :load_component`：下划线命名 -> 常量化（`text_field` -> `TextField`）。
   - `before_action :load_example`：从 JSON 取 `examples.detect { |e| e["name"] == "Main example" }`。
   - `before_action :build_preview`：`@preview = PreviewForm.new(permitted_params)`，`permitted_params` 只允许当前组件的字段。
   - `show`：渲染视图。
   - `submit`：`if @preview.valid?` -> redirect/back（可 303 see_other 到 show）；否则 render `show`, status: `:unprocessable_entity`.
   - `component_fields`：根据组件名返回字段数组（先做 TextField -> `%i[store_name]`，后续按组件清单扩展）。

2) `app/models/preview_form.rb`
   - `include ActiveModel::Model`, `include ActiveModel::Attributes`（可选），定义超集字段（覆盖所有组件需要的字段，TextField 先有 `attr_accessor :store_name`）。
   - 校验示例：TextField -> `validates :store_name, presence: true`；其他组件按需追加。

3) `app/views/components/show.html.erb`
   - 使用 `polaris_form_with model: @preview, url: submit_component_path(@component), method: :post`.
   - 调用 `render inline: @example.fetch("erb_code"), locals: { form: form }` 生成组件。
   - 追加 `<%= form.submit submit_label(@component) %>`。
   - 可以在视图或 helper 里提供 `submit_label(component)`，约定：`"Save #{component.titleize}"`。

4) `data/loader.rb`
   - `def self.load(component, name: "Main example")` -> 读 JSON，返回示例 Hash。
   - `def self.component_path(component)` -> `Rails.root.join("data/components/#{component.camelize}.json")`（注意文件首字母大写）。

5) 路由：`config/routes.rb`（resources 语法，保持 Rails 惯例）
   ```ruby
   resources :components, param: :component, only: [:show] do
     post :submit, on: :member
   end
   ```

6) 测试基类：`test/integration/components/base_test.rb`
   - 继承 `ActionDispatch::IntegrationTest`。
   - 提供 `component_get(component)`, `component_post(component, params)` 辅助。
   - 提供常用断言：
     - `assert_component_tag(selector, attrs = {})` 使用 `assert_select`.
     - `assert_error(component_attr, message)` 检查 `error` 属性。
     - `assert_submit(label)` 检查 `s-button[type=submit][data-disable-with=label]`.

7) TextField 测试（模板）：`test/integration/components/text_field_test.rb`
   - `setup`：`@component = "text_field"`, `@field = "store_name"`.
   - `test "renders main example"`：GET `/components/text_field`，`assert_response :success`，`assert_select 's-text-field[name=?]', "preview[store_name]"`，`assert_submit "Save Text Field"`.
   - `test "shows errors on invalid submit"`：POST `params: { preview: { store_name: "" } }`，`assert_response :unprocessable_entity`，`assert_select 's-text-field[error=?]', "can't be blank"`.
   - `test "persists value on success"`：POST `store_name: "Hello"`，期望 `assert_response :see_other`（或 302），随后 GET follow_redirect / GET show 再次渲染时 `assert_select 's-text-field[value=?]', "Hello"`.
   - 可选：断言示例内容存在（若 `erb_code` 带内嵌 slot/label），例如 `assert_select 's-text-field[label=?]', 'Store name'`。

## 命名与生成约定
- 组件名：路径参数用下划线小写（`text_field`），JSON 文件首字母大写（`TextField.json`），`component_path` 转换用 `component.camelize`.
- 示例名：固定 `"Main example"`，避免索引漂移。
- 提交按钮：`"Save #{component.titleize}"` 同时也作为 `data-disable-with`，保持 Rails 默认行为。
- 校验：优先用 `presence` 触发错误，错误消息使用 Rails 默认（ActiveModel）英文。

## 推广到其他组件（照抄）
1) 在 `PreviewForm` 增加字段与校验，例如：
   - `password_field` -> `attr_accessor :password` + presence.
   - `select`/`choice_list` -> 对应值字段 + inclusion 校验。
   - `checkbox`/`switch` -> boolean 字段，校验可选。
2) 在 `ComponentsController#component_fields` 补充映射，如：
   ```ruby
   {
     text_field: %i[store_name],
     password_field: %i[password],
     select: %i[category],
     checkbox: %i[accept_terms],
     switch: %i[notifications],
     date_field: %i[published_on],
     date_picker: %i[published_on],
     number_field: %i[quantity],
     money_field: %i[price],
     color_field: %i[color],
     search_field: %i[query],
     email_field: %i[email],
     url_field: %i[url],
     text_area: %i[description],
     drop_zone: %i[file_token],
     choice_list: %i[choices]
   }
   ```
   每个组件测试文件直接继承基类，设定 `@component` 与有效/无效参数。

## 验证点（TextField 版）
- 标签：`s-text-field` 存在且 `name="preview[store_name]"`。
- 值回显：成功提交后 `value` 属性匹配提交值。
- 错误：失败提交返回 422，`error` 属性包含校验消息。
- 提交按钮：`s-button[type=submit][data-disable-with="Save Text Field"]`.
- 示例忠实度：若 JSON 示例含 `label`/slot，则断言对应属性/子节点存在。

## 开发步骤（执行顺序）
1) 新增 `ComponentExampleLoader`（读取 JSON 取 Main example）。
2) 增加 `PreviewForm`（store_name + presence）。
3) 增加 `ComponentsController` + 路由。
4) 增加视图 `components/show.html.erb`（inline render + submit）。
5) 增加测试基类 + `text_field_test.rb` 三个用例。
6) 跑 `mise exec ruby@3.4.5 -- rake test TEST=test/dummy/test/integration/components/text_field_test.rb`。
7) 后续组件按映射表补字段和测试文件。
