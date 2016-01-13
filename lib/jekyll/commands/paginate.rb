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
        end
      end
    end
  end
end
