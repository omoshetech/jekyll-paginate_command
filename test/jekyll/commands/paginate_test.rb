require 'test_helper'

module Jekyll
  module Commands
    class PaginateTest < Minitest::Test
      def setup
        FileUtils.mkdir_p(SOURCE_DIR)
      end

      def teardown
        FileUtils.rm_r(SOURCE_DIR)
      end

      def test_generates_no_pagination_template_if_paginate_does_not_exist
        create_posts(25)
        create_page('index.html')

        Paginate.process(config)

        refute File.exist?(PAGINATE_DESTINATION_DIR)
      end

      def test_generates_post_pagination_templates_if_paginate_is_true_and_category_and_tag_dont_exist
        create_posts(25)
        create_page('index.html', { paginate: true })

        Paginate.process(config)

        assert File.exist?(PAGINATE_DESTINATION_DIR)
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/2.html'))
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/3.html'))
        assert_equal 2, Dir.glob(PAGINATE_DESTINATION_DIR + '/*.html').length
      end

      def test_generates_category_pagination_templates_if_paginate_is_true_and_category_exists
        create_posts(25, { category: 'jekyll' })
        create_page('categories/jekyll/index.html', { paginate: true, category: 'jekyll' })

        Paginate.process(config)

        assert File.exist?(PAGINATE_DESTINATION_DIR)
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/categories/jekyll/2.html'))
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/categories/jekyll/3.html'))
        assert_equal 2, Dir.glob(PAGINATE_DESTINATION_DIR + '/categories/jekyll/*.html').length
      end

      def test_generates_tag_pagination_templates_if_paginate_is_true_and_tag_exists
        create_posts(25, { tags: %w(jekyll update) })
        create_page('tags/jekyll/index.html', { paginate: true, tag: 'jekyll' })

        Paginate.process(config)

        assert File.exist?(PAGINATE_DESTINATION_DIR)
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/tags/jekyll/2.html'))
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/tags/jekyll/3.html'))
        assert_equal 2, Dir.glob(PAGINATE_DESTINATION_DIR + '/tags/jekyll/*.html').length
      end

      def test_generates_four_pages_for_twenty_posts_if_paginate_per_page_is_5
        config = config({ paginate_per_page: 5 })

        create_posts(20)
        create_page('index.html', { paginate: true })

        Paginate.process(config)

        assert File.exist?(PAGINATE_DESTINATION_DIR)
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/2.html'))
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/3.html'))
        assert File.exist?(File.join(PAGINATE_DESTINATION_DIR, '/4.html'))
        assert_equal 3, Dir.glob(PAGINATE_DESTINATION_DIR + '/*.html').length
      end

      def test_generates_paginator_variables
        create_posts(25)
        create_page('index.html', { paginate: true })

        Paginate.process(config)

        front_matter_1 = {
          'paginate'  => true,
          'paginator' => { 'per_page'  => 10, 'total_posts'    => 25, 'total_pages' => 3, 'page' => 1,
                           'next_page' => 2,  'next_page_path' => '/page2/' } }
        assert_equal front_matter_1, YAML.load_file(File.join(SOURCE_DIR, '/index.html'))
        front_matter_2 = {
          'paginate'  => false,
          'paginator' => { 'per_page'      => 10, 'total_posts'        => 25, 'total_pages' => 3, 'page' => 2,
                           'previous_page' => 1,  'previous_page_path' => '/',
                           'next_page'     => 3,  'next_page_path'     => '/page3/' },
          'permalink' => '/page2/' }
        assert_equal front_matter_2, YAML.load_file(File.join(PAGINATE_DESTINATION_DIR, '/2.html'))
        front_matter_3 = {
          'paginate'  => false,
          'paginator' => { 'per_page'      => 10, 'total_posts'        => 25, 'total_pages' => 3, 'page' => 3,
                           'previous_page' => 2,  'previous_page_path' => '/page2/' },
          'permalink' => '/page3/' }
        assert_equal front_matter_3, YAML.load_file(File.join(PAGINATE_DESTINATION_DIR, '/3.html'))
      end

      def test_generates_paginator_variables_with_custom_paginate_relative_path
        config = config({ paginate_relative_path: '/page:num.html' })

        create_posts(25)
        create_page('index.html', { paginate: true })

        Paginate.process(config)

        front_matter_1 = {
          'paginate'  => true,
          'paginator' => { 'per_page'  => 10, 'total_posts'    => 25, 'total_pages' => 3, 'page' => 1,
                           'next_page' => 2,  'next_page_path' => '/page2.html' } }
        assert_equal front_matter_1, YAML.load_file(File.join(SOURCE_DIR, '/index.html'))
        front_matter_2 = {
          'paginate'  => false,
          'paginator' => { 'per_page'      => 10, 'total_posts'        => 25, 'total_pages' => 3, 'page' => 2,
                           'previous_page' => 1,  'previous_page_path' => '/',
                           'next_page'     => 3,  'next_page_path'     => '/page3.html' },
          'permalink' => '/page2.html' }
        assert_equal front_matter_2, YAML.load_file(File.join(PAGINATE_DESTINATION_DIR, '/2.html'))
        front_matter_3 = {
          'paginate'  => false,
          'paginator' => { 'per_page'      => 10, 'total_posts'        => 25, 'total_pages' => 3, 'page' => 3,
                           'previous_page' => 2,  'previous_page_path' => '/page2.html' },
          'permalink' => '/page3.html' }
        assert_equal front_matter_3, YAML.load_file(File.join(PAGINATE_DESTINATION_DIR, '/3.html'))
      end

      private

      def config(options = {})
        defaults = Configuration[DEFAULTS]
        Utils.deep_merge_hashes(defaults, options)
      end

      def create_posts(n, vars = {})
        n.times.each { |i| create_post(i, vars) }
      end

      def create_post(i, vars = {})
        FileUtils.mkdir_p(POSTS_DIR)
        File.write(File.join(POSTS_DIR, "1970-01-01-post-#{i}.md"), <<-EOS)
#{front_matter(vars)}
# Post #{i}
        EOS
      end

      def create_page(path, vars = {})
        FileUtils.mkdir_p(File.join(SOURCE_DIR, File.dirname(path)))
        File.write(File.join(SOURCE_DIR, path), <<-EOS)
#{front_matter(vars)}
<h1>Test</h1>
        EOS
      end

      def front_matter(vars)
        Jekyll::Utils.stringify_hash_keys(vars).to_yaml.concat("---\n")
      end
    end
  end
end
