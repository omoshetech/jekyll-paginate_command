# Jekyll::PaginateCommand

The paginate command for Jekyll generates pagination templates. Generated templates work well on GitHub Pages.

[![Build Status](https://travis-ci.org/omoshetech/jekyll-paginate_command.svg?branch=master)](https://travis-ci.org/omoshetech/jekyll-paginate_command)

## Installation

Add this line to your application's Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll-paginate_command'
end
```

And then execute:

    $ bundle

## Usage

Install `jekyll-paginate_command` and run `jekyll help`.

You will see a new command:

```
  paginate              Generate pagination templates
```

To enable the pagination of your posts, add a line to the front matter in the `index.html` file:

```yaml
paginate: true
```

And then execute:

    $ jekyll paginate

This command generates a `paginator` variable like the `jekyll-paginate` plugin.
The difference of this command is a `paginator` variable is directly written in the front matter.
Therefore, you need to access the `paginator` variable as `page.paginator`.
You can see the generated front matter in the `index.html` file:

```yaml
---
layout: default
paginate: true
paginator:
  per_page: 10
  total_posts: 26
  total_pages: 3
  page: 1
  next_page: 2
  next_page_path: "/page2/"
---
```

This command also generates pagination templates in the `paginations` directory.
These pages have same content of first page except front matter variables.

When you write a new post, you need to run `jekyll paginate` before previewing your site.

## Examples

Here is examples of a paginated page.

### Posts

/index.html

```html
---
layout: default
paginate: true
paginator:
  per_page: 10
  total_posts: 26
  total_pages: 3
  page: 1
  next_page: 2
  next_page_path: "/page2/"
---
{% assign paginator = page.paginator %}

<div class="home">

  <h1 class="page-heading">Posts</h1>

  <ul class="post-list">
    {% assign offset = paginator.page | minus: 1 | times: paginator.per_page %}
    {% for post in site.posts limit: paginator.per_page offset: offset %}
      <li>
        <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span>

        <h2>
          <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        </h2>
      </li>
    {% endfor %}
  </ul>

  {% if paginator.total_pages > 1 %}
    <div class="pagination">
      {% if paginator.previous_page %}
        <a href="{{ paginator.previous_page_path | prepend: site.baseurl | replace: '//', '/' }}">&laquo; Prev</a>
      {% else %}
        <span>&laquo; Prev</span>
      {% endif %}

      {% assign paginate_relative_path = site.paginate_relative_path | default: '/page:num/' %}
      {% assign relative_path = paginate_relative_path | replace: ':num', paginator.page %}
      {% assign url = page.url | replace: relative_path, '/' %}

      {% for page in (1..paginator.total_pages) %}
        {% if page == paginator.page %}
          <em>{{ page }}</em>
        {% elsif page == 1 %}
          <a href="{{ url | append: '/' | prepend: site.baseurl | replace: '//', '/' }}">{{ page }}</a>
        {% else %}
          <a href="{{ url | append: paginate_relative_path | prepend: site.baseurl | replace: '//', '/' | replace: ':num', page }}">{{ page }}</a>
        {% endif %}
      {% endfor %}

      {% if paginator.next_page %}
        <a href="{{ paginator.next_page_path | prepend: site.baseurl | replace: '//', '/' }}">Next &raquo;</a>
      {% else %}
        <span>Next &raquo;</span>
      {% endif %}
    </div>
  {% endif %}

  <p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS</a></p>

</div>
```

### Category

/categories/jekyll/index.html

```html
---
layout: default
category: jekyll
paginate: true
paginator:
  per_page: 10
  total_posts: 26
  total_pages: 3
  page: 1
  next_page: 2
  next_page_path: "/categories/jekyll/page2/"
---
{% assign paginator = page.paginator %}

<div class="home">

  <h1 class="page-heading">Posts</h1>

  <ul class="post-list">
    {% assign offset = paginator.page | minus: 1 | times: paginator.per_page %}
    {% for post in site.categories[page.category] limit: paginator.per_page offset: offset %}
      <li>
        <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span>

        <h2>
          <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        </h2>
      </li>
    {% endfor %}
  </ul>

  {% if paginator.total_pages > 1 %}
    <div class="pagination">
      {% if paginator.previous_page %}
        <a href="{{ paginator.previous_page_path | prepend: site.baseurl | replace: '//', '/' }}">&laquo; Prev</a>
      {% else %}
        <span>&laquo; Prev</span>
      {% endif %}

      {% assign paginate_relative_path = site.paginate_relative_path | default: '/page:num/' %}
      {% assign relative_path = paginate_relative_path | replace: ':num', paginator.page %}
      {% assign url = page.url | replace: relative_path, '/' %}

      {% for page in (1..paginator.total_pages) %}
        {% if page == paginator.page %}
          <em>{{ page }}</em>
        {% elsif page == 1 %}
          <a href="{{ url | append: '/' | prepend: site.baseurl | replace: '//', '/' }}">{{ page }}</a>
        {% else %}
          <a href="{{ url | append: paginate_relative_path | prepend: site.baseurl | replace: '//', '/' | replace: ':num', page }}">{{ page }}</a>
        {% endif %}
      {% endfor %}

      {% if paginator.next_page %}
        <a href="{{ paginator.next_page_path | prepend: site.baseurl | replace: '//', '/' }}">Next &raquo;</a>
      {% else %}
        <span>Next &raquo;</span>
      {% endif %}
    </div>
  {% endif %}

  <p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS</a></p>

</div>
```

## Configurations

### Global Configurations

|Configuration         |Type   |Default    |Description                                                            |
|----------------------|-------|-----------|-----------------------------------------------------------------------|
|paginate_per_page     |Integer|10         |Set the number of posts per page.                                      |
|paginate_relative_path|String |/page:num/ |Set the relative path of paginated pages from the first page directory.|
|paginate_destination  |String |paginations|Set the destination of pagination templates.                           |

### Front Matter Variables

|Variable|Type   |Description                        |
|--------|-------|-----------------------------------|
|paginate|Boolean|Enable the pagination.             |
|category|String |Set a category for filtering posts.|
|tag     |String |Set a tag for filtering posts.     |

### Generated Variables for Liquid

|Variable                         |Description                                                         |
|---------------------------------|--------------------------------------------------------------------|
|page.paginator.per_page          |The number of Posts per page.                                       |
|page.paginator.total_posts       |The total number of Posts.                                          |
|page.paginator.total_pages       |The total number of Pages.                                          |
|page.paginator.page              |The number of the current page.                                     |
|page.paginator.previous_page     |The number of the previous page, or `nil` if no previous page exist.|
|page.paginator.previous_page_path|The path to the previous page, or `nil` if no previous page exist.  |
|page.paginator.next_page         |The number of the next page, or `nil` if no next page exist.        |
|page.paginator.next_page_path    |The path to the next page, or `nil` if no next page exist.          |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/omoshetech/jekyll-paginate_command.
