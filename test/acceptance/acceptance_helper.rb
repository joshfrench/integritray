$:.unshift File.dirname(__FILE__) + "/../lib", File.dirname(__FILE__)

require "rubygems"

require "test/unit"
require "rr"
require "mocha"
require "dm-sweatshop"
require "webrat/sinatra"

gem "jeremymcanally-context"
gem "jeremymcanally-matchy"
gem "jeremymcanally-pending"
require "context"
require "matchy"
require "pending"

require "integrity"
require "integrity/notifier/test/fixtures"

begin
  require "ruby-debug"
  require "redgreen"
rescue LoadError
end

module TestHelper
  def ignore_logs!
    Integrity.config[:log] = "/tmp/integrity.test.log"
  end

  def capture_stdout
    output = StringIO.new
    $stdout = output
    yield
    $stdout = STDOUT
    output
  end

  def silence_warnings
    $VERBOSE, v = nil, $VERBOSE
    yield
  ensure
    $VERBOSE = v
  end
end

class Test::Unit::TestCase
  class << self
    alias_method :specify, :test
  end

  include RR::Adapters::TestUnit
  include Integrity
  include TestHelper

  before(:all) do
    DataMapper.setup(:default, "sqlite3::memory:")

    require "integrity/migrations"
  end

  before(:each) do
    [Project, Build, Commit, Notifier].each{ |i| i.auto_migrate_down! }
    capture_stdout { Integrity.migrate_db }
    Notifier.available.clear
    Integrity.instance_variable_set(:@config, nil)
  end

  after(:each) do
    capture_stdout { Integrity::Migrations.migrate_down! }
  end
end

gem "foca-storyteller"
require "storyteller"

module AcceptanceHelper
  include FileUtils

  def export_directory
    File.dirname(__FILE__) + "/../../exports"
  end

  def enable_auth!
    Integrity.config[:use_basic_auth]      = true
    Integrity.config[:admin_username]      = "admin"
    Integrity.config[:admin_password]      = "test"
    Integrity.config[:hash_admin_password] = false
  end

  def login_as(user, password)
    def AcceptanceHelper.logged_in; true; end
    basic_auth user, password
    visit "/login"
    Integrity::App.before { login_required if AcceptanceHelper.logged_in }
  end

  def log_out
    def AcceptanceHelper.logged_in; false; end
    @_webrat_session = Webrat::SinatraSession.new(self)
  end

  def disable_auth!
    Integrity.config[:use_basic_auth] = false
  end

  def set_and_create_export_directory!
    FileUtils.rm_r(export_directory) if File.directory?(export_directory)
    FileUtils.mkdir(export_directory)
    Integrity.config[:export_directory] = export_directory
  end

  def setup_log!
    log_file = Pathname(File.dirname(__FILE__) + "/../../integrity.log")
    log_file.delete if log_file.exist?
    Integrity.config[:log] = log_file
  end
end

class Test::Unit::AcceptanceTestCase < Test::Unit::TestCase
  include AcceptanceHelper
  include Test::Storyteller
  include Webrat::Methods
  include Webrat::Matchers
  include Webrat::HaveTagMatcher

  Webrat::Methods.delegate_to_session :response_code

  def app
    Integrity::App
  end

  before(:all) do
    app.set(:environment, :test)
  end

  before(:each) do
    # ensure each scenario is run in a clean sandbox
    Integrity.config[:base_uri] = "http://www.example.com"
    enable_auth!
    setup_log!
    set_and_create_export_directory!
    log_out
  end

  after(:each) do
    rm_r export_directory if File.directory?(export_directory)
  end
end
