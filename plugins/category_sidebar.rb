# place this file in your plugins directory and add the tag to your sidebar
#$ cat source/_includes/asides/categories.html 
#<section>
#  <h1>Categories</h1>
#  <ul id="categories">
#    {% category_list %}
#  </ul>
#</section>

module Jekyll
  class CategoryListTag < Liquid::Tag
    def render(context)
      html = ""
      categories = context.registers[:site].categories.keys
      dir = context.registers[:site].config['category_dir']
      categories.sort.each do |category|
        posts_in_category = context.registers[:site].categories[category].size
        #html << "<li class='category'><a href='/blog/categories/#{category.downcase}/'>#{category} (#{posts_in_category})</a></li>\n"
        #support chinese link
        url =  dir+"/"+category.gsub(/_|\P{Word}/u, '-').gsub(/-{2,}/u, '-').downcase
        html << "<li class='category'><a href=' /#{url}/'>#{category} (#{posts_in_category})</a></li>\n"
      end
      html
    end
  end
end

Liquid::Template.register_tag('category_sidebar', Jekyll::CategoryListTag)