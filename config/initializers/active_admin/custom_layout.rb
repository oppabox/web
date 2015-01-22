module ActiveAdmin
  module Views
    module Pages
      class Base < Arbre::HTML::Document
        def build(*args)
          super
          add_classes_to_body
          
          build_active_admin_head
          custom_css
          custom_js
          build_page
        end

        def custom_css
          within @head do
            text_node "<link href='/css/bootstrap.min.css' media='all' rel='stylesheet'>".html_safe
            text_node "<link href='/css/bootstrap-social.css' media='all' rel='stylesheet'>".html_safe
            text_node "<link href='/css/font-awesome.min.css' media='all' rel='stylesheet'>".html_safe
          end
        end

        def custom_js
          within @head do
            text_node "<script src='/js/bootstrap.min.js'></script>".html_safe
          end
        end
      end
    end
  end
end