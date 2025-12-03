# frozen_string_literal: true

module CodeHelper
  # 规范代码缩进：
  # - 去掉首尾空行
  # - 去掉所有行共同的最小缩进
  def normalize_indent(code)
    return "" if code.blank?

    # 统一换行符
    lines = code.to_s.gsub("\r\n", "\n").gsub("\r", "\n").lines

    # 去掉头尾全空行
    lines.shift while lines.first&.strip == ""
    lines.pop   while lines.last&.strip  == ""

    return "" if lines.empty?

    # 找出所有非空行的最小缩进
    indents = lines
      .reject { |l| l.strip.empty? }
      .map    { |l| l[/^\s*/].size }

    min_indent = indents.min || 0

    # 去掉这部分缩进
    lines.map { |l| l[min_indent..] || "" }.join
  end
end
