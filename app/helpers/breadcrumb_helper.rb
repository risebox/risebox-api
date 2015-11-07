module BreadcrumbHelper
  def breadcrumb slice_hash
    @breadcrumb ||= []
    slice_hash.kind_of?(Array) ? @breadcrumb.concat(slice_hash) : @breadcrumb.push(section)
  end

  def breadcrumb_max_level
    @breadcrumb_max_level ||= @breadcrumb.count
  end

  def breadcrumb_title level
    return nil if level < 1
    @breadcrumb.nil? ? nil : @breadcrumb[level-1][:title]
  end

  def breadcrumb_path level
    return nil if level < 1
    @breadcrumb.nil? ? nil : @breadcrumb[level-1][:path]
  end

end