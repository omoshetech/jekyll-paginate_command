require "jekyll-paginate_command/version"
require "jekyll-paginate_command/pagination"
require "jekyll/commands/paginate"

module Jekyll
  module PaginateCommand
    DEFAULTS = {
      'paginate_per_page' => 10,
      'paginate_relative_path' => '/page:num/',
      'paginate_destination' => 'paginations'
    }
  end
end
