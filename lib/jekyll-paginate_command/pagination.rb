module Jekyll
  module PaginateCommand
    class Pagination
      def initialize(base, site)
        @base = base
        @site = site
        @config = site.config
      end

      def generate
        (1..total_pages).each do |page|
          @page = page
          generate_current_page
        end
      end

      private

      def generate_current_page
        Jekyll.logger.debug "Writing:", file_path
        FileUtils.mkpath(dir_path)
        File.write(file_path, file_content)
      end

      def dir_path
        File.dirname(file_path)
      end

      def file_path
        if 1 < page
          File.join(@config['paginate_destination'], @base.dir, "#{page}.html")
        else
          File.join(@config['source'], @base.path)
        end
      end

      def file_content
        front_matter.concat(@base.content)
      end

      def front_matter
        @base.data.merge(data).to_yaml.concat("---\n")
      end

      def data
        {
          'paginate'  => paginate,
          'paginator' => paginator,
          'permalink' => permalink
        }.select { |_, value| !value.nil? }
      end

      def paginate
        1 < page ? false : true
      end

      def paginator
        {
            'per_page'           => per_page,
            'total_posts'        => total_posts,
            'total_pages'        => total_pages,
            'page'               => page,
            'previous_page'      => previous_page,
            'previous_page_path' => previous_page_path,
            'next_page'          => next_page,
            'next_page_path'     => next_page_path
        }.select { |_, value| !value.nil? }
      end

      def per_page
        @per_page ||= @config['paginate_per_page']
      end

      def total_posts
        @total_posts ||= count_posts
      end

      def count_posts
        case
        when @base['category'] then @site.categories[@base['category']].length
        when @base['tag']      then @site.tags[@base['tag']].length
        else                        @site.posts.docs.length
        end
      end

      def total_pages
        @total_pages ||= total_posts.fdiv(per_page).ceil
      end

      def page
        @page
      end

      def previous_page
        1 < page ? page - 1 : nil
      end

      def previous_page_path
        return @base.url if previous_page == 1
        previous_page ? paginate_path.sub(':num', previous_page.to_s) : nil
      end

      def next_page
        page < total_pages ? page + 1 : nil
      end

      def next_page_path
        next_page ? paginate_path.sub(':num', next_page.to_s) : nil
      end

      def paginate_path
        @paginate_path ||= File.join(@base.dir, @config['paginate_relative_path'])
      end

      def permalink
        1 < page ? paginate_path.sub(':num', page.to_s) : nil
      end
    end
  end
end
