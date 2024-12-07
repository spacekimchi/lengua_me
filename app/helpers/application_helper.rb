module ApplicationHelper
  def inline_svg(filename, options = {})
    file_path = Rails.root.join("public/icons", filename)
    if File.exist?(file_path)
      file = File.read(file_path)
      doc = Nokogiri::HTML::DocumentFragment.parse(file)
      svg = doc.at_css("svg")
      options.each { |key, value| svg[key.to_s] = value }
      doc.to_html.html_safe
    else
      "(SVG not found)"
    end
  end

  def admin_route?
    request.path.start_with?('/admin')
  end

  def urlify(string)
    string.strip.downcase.gsub(/\s+/, '-')
  end
end
