---
layout: category
index: noindex, follow
---

      {% for post in page.posts reversed %}

      {% capture therow %}{% cycle '1', '2' %}{% endcapture %}

      {% capture theblock %}{% cycle '1', '2', '3', '4', '5', '6', '7', '8' %}{% endcapture %}

      {% if theblock == '1' %}{% assign blockspan = 'medium-6' %}
      {% elsif theblock == '2' %}{% assign blockspan = 'medium-6' %}
      {% elsif theblock == '3' %}{% assign blockspan = 'medium-5' %}
      {% elsif theblock == '4' %}{% assign blockspan = 'medium-7' %}
      {% elsif theblock == '5' %}{% assign blockspan = 'medium-7' %}
      {% elsif theblock == '6' %}{% assign blockspan = 'medium-5' %}
      {% elsif theblock == '7' %}{% assign blockspan = 'medium-8' %}
      {% elsif theblock == '8' %}{% assign blockspan = 'medium-4' %}
      {% else %}{% assign blockspan = 'medium-12' %}
      {% endif %}

      {% if post.featured == true %}{% assign  featured = 'featured' %}{% endif %}

      <!--start post block -->
      {% if therow == '1' %}<div class="row">{% endif %}

          <article class="small-12 columns  post-category">


              <header>
                <h3><a href="{{ post.url | prepend: site.baseurl }}" alt="{{ post.title }}" rel="bookmark" itemprop="url">{{ post.title }}</a></h3>
              </header>

                <p>Posted on <i class="fa fa-clock-o"></i> <span datetime="{{ post.date | date: "%Y-%m-%d" }}">{{ post.date | date: "%B %-d, %Y" }}</span></p>

                <div class="excerpt">
                    {{ post.content | strip_html | truncatewords:45}}
                </div>

          </article>


      {% if therow == '2' %}</div>{% endif %}

      {% endfor %}

      {% if therow == '1' %}</div>{% endif %}
