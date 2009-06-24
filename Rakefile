require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/contrib/sshpublisher'
require 'fileutils'
include FileUtils

NAME              = "smartfm"
AUTHOR            = "nov"
EMAIL             = "developer@smart.fm"
DESCRIPTION       = "A rubygem for smart.fm APIs"
RUBYFORGE_PROJECT = NAME
HOMEPATH          = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
BIN_FILES         = %w(  )

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"
require 'lib/smartfm'
VERS              = Smartfm::Version.to_version
REV = File.read(".svn/entries")[/committed-rev="(d+)"/, 1] rescue nil
CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = [
  '--title', "#{NAME} documentation",
  "--charset", "utf-8",
  "--opname", "index.html",
  "--line-numbers",
  "--main", "README",
  "--inline-source",
]

task :default => [:spec]
task :package => [:clean]

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_opts = ["-f specdoc", "-c"]
    t.spec_files = FileList['spec/*_spec.rb', 'spec/**/*_spec.rb']
  end
rescue LoadError
  desc 'Spec rake task not available'
  task :spec do
    abort 'Spec rake task is not available. Be sure to install rspec as a gem or plugin'
  end
end

spec = Gem::Specification.new do |s|
  s.name              = NAME
  s.version           = VERS
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README", "ChangeLog"]
  s.rdoc_options     += RDOC_OPTS + ['--exclude', '^(examples|extras)/']
  s.summary           = DESCRIPTION
  s.description       = DESCRIPTION
  s.author            = AUTHOR
  s.email             = EMAIL
  s.homepage          = HOMEPATH
  s.executables       = BIN_FILES
  s.rubyforge_project = RUBYFORGE_PROJECT
  s.bindir            = "bin"
  s.require_path      = "lib"
  #s.autorequire       = ""
  s.test_files        = Dir["spec/*_spec.rb"]

  s.add_dependency('json')
  s.add_dependency('oauth')
  # s.required_ruby_version = '>= 1.8.6'

  s.files = %w(README ChangeLog Rakefile) +
    Dir.glob("{bin,doc,spec,lib,templates,extras,website,script}/**/*") + 
    Dir.glob("ext/**/*.{h,c,rb}") +
    Dir.glob("examples/**/*.rb") +
    Dir.glob("tools/*.rb") +
    Dir.glob("rails/*.rb")

  s.extensions = FileList["ext/**/extconf.rb"].to_a
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
  p.gem_spec = spec
end

desc "Install"
task :install do
  name = "#{NAME}-#{VERS}.gem"
  sh %{rake package}
  sh %{sudo gem install pkg/#{name}}
end

desc "Uninstall"
task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end


Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.options += RDOC_OPTS
  rdoc.template = "resh"
  #rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  if ENV['DOC_FILES']
    rdoc.rdoc_files.include(ENV['DOC_FILES'].split(/,\s*/))
  else
    rdoc.rdoc_files.include('README', 'ChangeLog')
    rdoc.rdoc_files.include('lib/**/*.rb')
    rdoc.rdoc_files.include('ext/**/*.c')
  end
end

desc "Publish to RubyForge"
task :rubyforge => [:rdoc, :package] do
  require 'rubyforge'
  Rake::RubyForgePublisher.new(RUBYFORGE_PROJECT, 'nov').upload
end

# rake release VERSION=x.y.z
desc 'Package and upload the release to rubyforge.'
task :release => [:clean, :package] do |t|
  v = ENV["VERSION"] or abort "Must supply VERSION=x.y.z"
  abort "Versions don't match #{v} vs #{VERS}" unless v == VERS
  pkg = "pkg/#{NAME}-#{VERS}"

  require 'rubyforge'
  rf = RubyForge.new.configure
  puts "Logging in"
  rf.login

  c = rf.userconfig
#  c["release_notes"] = description if description
#  c["release_changes"] = changes if changes
  c["preformatted"] = true

  files = [
    "#{pkg}.tgz",
    "#{pkg}.gem"
  ].compact

  puts "Releasing #{NAME} v. #{VERS}"
  rf.add_release RUBYFORGE_PROJECT, NAME, VERS, *files
end

desc 'Show information about the gem.'
task :debug_gem do
  puts spec.to_ruby
end

desc 'Update gem spec'
task :gemspec do
  open("#{NAME}.gemspec", 'w').write spec.to_ruby
end
