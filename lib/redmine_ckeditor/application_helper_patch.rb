require_dependency 'application_helper'

module ApplicationHelper
  def ckeditor_javascripts
    root = RedmineCkeditor.assets_root
    javascript_tag("CKEDITOR_BASEPATH = '#{root}/ckeditor/';") +
    javascript_include_tag("application", :plugin => "redmine_ckeditor") +
    javascript_tag(RedmineCkeditor.plugins.map {|name|
      path = "#{root}/ckeditor-contrib/plugins/#{name}/"
      "CKEDITOR.plugins.addExternal('#{name}', '#{path}/');"
    }.join("\n"))
  end

  def textilizable_with_ckeditor(*args)
    if  Setting['text_formatting'] == 'CKEditor'
      options = args.last.is_a?(Hash) ? args.pop : {}
      case args.size
        when 1
          obj = options[:object]
          text = args.shift
        when 2
          obj = args.shift
          attr = args.shift
          text = obj.send(attr).to_s.html_safe
        else
          raise ArgumentError, 'invalid arguments to textilizable'
      end
    else
      textilizable_without_ckeditor args
    end
  end

  def format_activity_description_with_ckeditor(text)
    if RedmineCkeditor.enabled?
      simple_format(truncate(HTMLEntities.new.decode(strip_tags(text.to_s)), :length => 120))
    else
      format_activity_description_without_ckeditor(text)
    end
  end
 alias_method_chain :textilizable, :ckeditor
  alias_method_chain :format_activity_description, :ckeditor
end
