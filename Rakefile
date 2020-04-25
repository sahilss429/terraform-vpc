require 'puppet_blacksmith/rake_tasks'
#require 'rake-terraform/default_tasks'

task default: ['test:default']

task "bump" do
  require 'puppet_blacksmith/rake_tasks'
  Blacksmith::RakeTask.new do |t|
    t.tag_pattern = "v%s" # Use a custom pattern with git tag. %s is replaced with the version number.
    t.build = false # do not build the module nor push it to the Forge, just do the tagging [:clean, :tag, :bump_commit]
  end
end

desc "Build, bump_commit and git push"
task "publish" do
  require 'puppet_blacksmith/rake_tasks'
  Rake::Task["module:bump_commit"].invoke
  Rake::Task["module:tag"].invoke
  Rake::Task["build"].invoke
#  Dir.glob("pkg/*.tar.gz") do |filename|
#    modulename = File.basename(filename)
#    puts "Publishing module #{modulename}"
end
