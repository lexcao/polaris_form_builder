# Capture Block Handling

## 结论
- 这项额外优化已经没有保留必要。
- `PolarisFormBuilder::FormBuilder#capture_block` 可以直接回到标准的 `@template.capture(&block)`。
- 继续保留通过 block binding 探测 `@output_buffer` 的逻辑，只会增加隐式行为和维护成本，没有找到对应收益。

## 判断依据
- Rails 8.1 的 `ActionView::Helpers::CaptureHelper#capture` 已经围绕当前 view 的 `@output_buffer` 做了标准处理。
- Simple Form 和 Formtastic 也都直接依赖 `template.capture(&block)`，没有额外探测 block binding buffer。
- Polaris 现有定制逻辑不是 Rails 常规扩展点，而且会把行为绑定到 ERB block 的内部实现细节。

## 本地验证
- 相关单元测试在现状下通过：`test/test_text_field.rb`、`test/test_select.rb`。
- 将 `capture_block` 临时替换为纯 `@template.capture(&block)` 后，上述测试仍然通过。
- 在 playground 的真实请求路径下，对 `/components/textfield` 和 `/components/choicelist` 做了 DOM 对照：
  - `TextField` 的 accessory slot 渲染结果一致。
  - `ChoiceList` 的实际 `<s-select>` DOM 结构一致。
- 另外补了嵌套 `render inline` 的回归测试，覆盖最接近 `ExampleRenderer` 的场景。

## 最终处理建议
- 直接删除 block binding / `@output_buffer` 探测逻辑，保持实现和 Rails 生态一致。
- 保留回归测试即可，不再继续围绕这块做额外优化。

## 参考位置
- Rails: `ActionView::Helpers::CaptureHelper#capture`
- Rails: `ActionView::Helpers::FormHelper#form_with`
- Simple Form: `SimpleForm::Inputs::BlockInput#input`
- Formtastic: `Formtastic::Actions::Base#wrapper`
- Formtastic: `Formtastic::Helpers::FieldsetWrapper#field_set_and_list_wrapping`
