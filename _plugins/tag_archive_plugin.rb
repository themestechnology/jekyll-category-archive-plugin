module Jekyll

  module TagArchiveUtil
    def self.archive_base(site)
      site.config['category_archive'] && site.config['category_archive']['path'] || ''
    end
  end

  # Generator class invoked from Jekyll
  class TagArchiveGenerator < Generator
    def generate(site)
      posts_group_by_tag(site).each do |tag, list|
        site.pages << TagArchivePage.new(site, TagArchiveUtil.archive_base(site), tag, list)
      end
    end

    def posts_group_by_tag(site)
      tag_map = {}
      site.posts.each {|p| p.tags.each {|c| (tag_map[c] ||= []) << p } }
      tag_map
    end
  end

  # Tag for generating a link to a tag archive page
  class TagArchiveLinkTag < Liquid::Block

    def initialize(tag_name, tag, tokens)
      super
      @tag = tag.split(' ').first || tag
    end

    def render(context)
      # If the tag is a variable in the current context, expand it
      if context.has_key?(@tag)
	      tag = context[@tag]
      else
	      tag = @tag
      end


      if context.registers[:site].config['category_archive'] && context.registers[:site].config['category_archive']['slugify']
        tag = Utils.slugify(tag)
      end

      href = File.join('/', context.environments.first['site']['category_archive']['path'],
                       tag, 'index.html')
      "<a href=\"#{href}\">#{super}</a>"
    end
  end

  # Actual page instances
  class TagArchivePage < Page
    ATTRIBUTES_FOR_LIQUID = %w[
      tag,
      content
    ]

    def initialize(site, dir, tag, posts)
      @site = site
      @dir = dir
      @tag = tag

      if site.config['category_archive'] && site.config['category_archive']['slugify']
        @tag_dir_name = Utils.slugify(@tag) # require sanitize here
      else
        @tag_dir_name = @tag
      end

      @layout =  site.config['category_archive'] && site.config['category_archive']['layout'] || 'category_archive'
      self.ext = '.html'
      self.basename = 'index'
      self.content = <<-EOS
{% for post in page.posts %}<li><a itemprop="url" href="{{ post.url | prepend: site.baseurl | replace: '//', '/' }}"><span itemprop="name">{{ post.title }}<span></a></li>
{% endfor %}
      EOS
      self.data = {
          'layout' => @layout,
          'type' => 'archive',
          'title' => "Tag: #{@tag}",
          'posts' => posts,
          'url' => File.join('/',
                     TagArchiveUtil.archive_base(site),
                     @tag_dir_name, 'index.html')
      }
    end

    def render(layouts, site_payload)
      payload = {
          'page' => self.to_liquid,
          'paginator' => pager.to_liquid
      }.merge(site_payload)
      do_layout(payload, layouts)
    end

    def to_liquid(attr = nil)
      self.data.merge({
                               'content' => self.content,
                               'tag' => @tag
                           })
    end

    def destination(dest)
      File.join('/', dest, @dir, @tag_dir_name, 'index.html')
    end

  end
end

Liquid::Template.register_tag('taglink', Jekyll::TagArchiveLinkTag)
