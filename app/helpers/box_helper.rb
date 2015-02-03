module BoxHelper
# this will make group according to path name
	def custom_item_body items, method
    inner_html = "" #storage for return

    grouped_items = []
    i = 0
    puts items.count
    while i < items.count
    	rtn = [ items[i] ]
    	group_name = items[i].path.split('_')[0]
    	idx = i + 1

    	while idx < items.count
    		if items[idx].path.split('_')[0] == group_name
    			rtn << items[idx]
    			idx = idx + 1
  			else
  				break
  			end
    	end
    	grouped_items << rtn
    	i = idx
    end

    grouped_items.each do |items|
    	temp_html = ""
    	inner_html +=
    		content_tag :h3 do
    			items[0].display_name
    		end
    	inner_html +=
    		content_tag :hr

	    items.each do |x|
	      image_box = #하나의 박스중에 위쪽에 있는 image
	        if x.opened != true
	          tag :img, :src => x.image_url, :class => 'img-responsive center-block'
	        else
	          content_tag :a, :href => "/#{method}/#{x.path}" do 
	            tag :img, :src => x.image_url, :class => 'img-responsive center-block'
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

	        # customize
	        # get top 2
	        if method == "box"
	          size_md = 6
	          size_xs = 12
	        else
	          size_md = 4
	          size_xs = 6
	        end

	      temp_html += #image_box + text_box                             # class로 조절이 안되서 style로 조절
	        content_tag :div, :class => "col-md-#{size_md} col-xs-#{size_xs} text-center", :style => 'padding-left:0; padding-right:0;' do
	          content_tag :div, :class => "box_view" do 
	            image_box + text_box
	          end
	        end

	      inner_html +=
	      	content_tag :div, :class => 'row' do
	      		temp_html.html_safe
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
