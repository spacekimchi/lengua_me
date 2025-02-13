module ApplicationHelper
  include ::Pagy::Frontend

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

  def stom(seconds)
    return "0s" if !seconds || seconds == 0

    days = seconds / 86400
    seconds %= 86400
    hours = seconds / 3600
    seconds %= 3600
    minutes = seconds / 60
    seconds %= 60

    result = []
    result << "#{days}d" if days > 0
    result << "#{hours}h" if hours > 0
    result << "#{minutes}m" if minutes > 0
    result << "#{seconds}s" if seconds > 0

    result.join(" ")
  end

  def flag_emoji(locale)
    country_code = Language::LOCALE_COUNTRY_MAP[locale.to_s]
    # Ensure the locale corresponds to a valid country code
    if country_code.match?(/^[A-Z]{2}$/)
      country_code.chars.map { |char| (127397 + char.ord).chr(Encoding::UTF_8) }.join
    else
      "" # Return an empty string or a default emoji if the locale doesn't match a country code
    end
  end

  def admin_route?
    request.path.start_with?('/admin')
  end

  def urlify(string)
    string.strip.downcase.gsub(/\s+/, '-')
  end
end
