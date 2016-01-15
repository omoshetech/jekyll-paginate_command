module Jekyll
  module Commands
    class Paginate < Command
      class << self
        def init_with_program(prog)
          prog.command(:paginate) do |c|
            c.version Jekyll::PaginateCommand::VERSION
            c.syntax 'paginate [options]'
            c.description 'Generate pagination templates'

            c.option 'quiet',   '-q', '--quiet', 'Silence output.'
            c.option 'verbose', '-V', '--verbose', 'Print verbose output.'

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
          t = Time.now
          Jekyll.logger.info "Source:", site.config['source']
          Jekyll.logger.info "Destination:", site.config['paginate_destination']
          Jekyll.logger.info "Paginating..."
          pages.each { |page| PaginateCommand::Pagination.new(page, site).generate }
          Jekyll.logger.info "", "done in #{(Time.now - t).round(3)} seconds."
        end
      end
    end
  end
end
