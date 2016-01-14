module Jekyll
  module Commands
    class Paginate < Command
      class << self
        def init_with_program(prog)
          prog.command(:paginate) do |c|
            c.syntax 'paginate'
            c.description 'Generate paginations for categories and tags'

            c.action do |_, options|
              process(options)
            end
          end
        end

        def process(options)
          config = config(options)
          site = site(config)
          pages = target_pages(site)
          paginate(pages, site)
        end

        def config(options)
          defaults = Configuration[PaginateCommand::DEFAULTS]
          config = configuration_from_options(options)
          Utils.deep_merge_hashes(defaults, config)
        end

        def site(config)
          site = Site.new(config)
          site.read
          site
        end

        def target_pages(site)
          site.pages.select { |page| page['paginate'] }
        end

        def paginate(pages, site)
          pages.each { |page| PaginateCommand::Pagination.new(page, site).generate }
        end
      end
    end
  end
end
