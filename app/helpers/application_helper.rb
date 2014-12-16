module ApplicationHelper
  def image_head image_path
    content_tag :div, 
                :class => 'container', 
                :id => 'main_image' do 
      content_tag :div, :class => 'row' do 
        tag :img, 
            :src => image_path, 
            :class => "center-block img-thumbnail"
      end
    end
  end

  def item_body items, method
    inner_html = "" #storage for return

    items.each do |x|
      image_box = #하나의 박스중에 위쪽에 있는 image
        if x.opened != true
          tag :img, :src => "/images/box/#{x.path}.jpg", :class => 'img-responsive center-block'
        else
          content_tag :a, :href => "/#{method}/#{x.path}" do 
            tag :img, :src => "/images/box/#{x.path}.jpg", :class => 'img-responsive center-block'
          end
        end
      text_box = #하나의 박스중에 아래쪽에 있는 이름(ex. STAR BOX)
        if x.opened != true
          content_tag :h4, :class => 'product_title' do 
            x.display_name
          end
        else
          content_tag :a, :href => "/#{method}/#{x.path}" do 
            content_tag :h4, :class => 'product_title' do 
              x.display_name
            end
          end
        end
      inner_html += #image_box + text_box                             # class로 조절이 안되서 style로 조절
        content_tag :div, :class => 'col-md-4 col-xs-6 text-center', :style => 'padding-left:0; padding-right:0;' do
          content_tag :div, :class => "box_view" do 
            image_box + text_box
          end
        end
    end

    content_tag :div, :class => 'container' do #for bootstrap
      content_tag :div, :class => 'row ' do 
        inner_html.html_safe
      end
    end
  end
end
