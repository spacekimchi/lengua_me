module ApplicationHelper
  def admin_route?
    request.path.start_with?('/admin')
  end

  def urlify(string)
    string.strip.downcase.gsub(/\s+/, '-')
  end
end
