module Jekyll
  module Commands
    class Paginate < Command
      def self.init_with_program(prog)
        prog.command(:paginate) do |c|
          c.syntax 'paginate'
          c.description 'Generate paginations for categories and tags'

          c.action do |args, options|
          end
        end
      end
    end
  end
end
