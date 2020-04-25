require 'rake-terraform'
require 'rake-terraform/default_tasks'

task default: ['test:default']

#desc "Run syntax, lint, and spec tests."
#task :test => [
#  :metadata_lint,
#  :syntax,
#  :lint,
#  :spec,
#]

desc "Build, bump_commit, Upload to HomeAway private forge and git push"
task "publish" do
  require 'puppet_blacksmith/rake_tasks'
  Rake::Task["module:bump_commit"].invoke
  Rake::Task["module:tag"].invoke
  Rake::Task["build"].invoke
  Dir.glob("pkg/*.tar.gz") do |filename|
    modulename = File.basename(filename)
    puts "Publishing module #{modulename}"
  end
end

