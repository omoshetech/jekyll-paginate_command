$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jekyll'
require 'jekyll-paginate_command'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

SOURCE_DIR      = File.expand_path('../source', __FILE__)
DESTINATION_DIR = File.join(SOURCE_DIR, '_site')
POSTS_DIR       = File.join(SOURCE_DIR, '_posts')
PAGINATE_DESTINATION_DIR = File.join(SOURCE_DIR, 'paginations')

DEFAULTS = {
  quiet:       true,
  source:      SOURCE_DIR,
  destination: DESTINATION_DIR,
  paginate_destination: PAGINATE_DESTINATION_DIR
}
