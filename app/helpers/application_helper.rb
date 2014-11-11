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
        content_tag :a, :href => "/#{method}/#{x.path}" do 
          tag :img, :src => 'img/300x300.png', :class => 'img-responsive center-block'
        end
      text_box = #하나의 박스중에 아래쪽에 있는 이름(ex. STAR BOX)
        content_tag :a, :href => "/#{method}/#{x.path}" do 
          content_tag :h4, :class => 'product_title' do 
            x.display_name
          end
        end
      inner_html += #image_box + text_box
        content_tag :div, :class => 'col-md-4 col-xs-6 text-center' do
          content_tag :div, :class => "box_view" do 
            image_box + text_box
          end
        end
    end

    content_tag :div, :class => 'container' do #for bootstrap
      content_tag :div, :class => 'row' do 
        inner_html.html_safe
      end
    end
  end
end
