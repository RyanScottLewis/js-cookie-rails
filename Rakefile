require 'logger'
require 'pathname'

$logger       = Logger.new(STDOUT)
$project_path = Pathname.new(__FILE__).dirname.expand_path
$spec         = eval( $project_path.join('js-cookie-rails.gemspec').read )

Rake::TaskManager.record_task_metadata = true

def run_command(command)
  result = `#{command}`.chomp.strip
  message = command
  
  message << "\n" + result.lines.collect { |line| "  #{line}" }.join unless result.empty?

  $logger.debug(message)

  result
end

namespace :js_cookie do
  desc 'Update the `js-cookie` submodule'
  task :update do
    js_cookie_path = $project_path.join('lib', 'js-cookie')

    run_command("cd #{js_cookie_path} && git pull origin master")
    js_cookie_latest_tag = run_command("cd #{js_cookie_path} && git describe --abbrev=0 --tags")
    run_command "cd #{js_cookie_path} && git checkout #{js_cookie_latest_tag}"
  end

  desc 'Copy the `js.cookie.js` file to the `vendor/assets/javascripts` folder'
  task :vendor do
    js_cookie_script_path = $project_path.join('lib', 'js-cookie', 'src', 'js.cookie.js')
    vendor_path = $project_path.join('vendor', 'assets', 'javascripts')
    vendor_path.mkpath

    run_command "cp #{js_cookie_script_path} #{vendor_path}"
  end
end

desc 'Update js-cookie and copy `js.cookie.js` into vendor'
task :js_cookie => ['js_cookie:update', 'js_cookie:vendor']

desc 'Update js-cookie, update js-cookie-rails version, tag on git'
task :update => :js_cookie do
  js_cookie_path = $project_path.join('lib', 'js-cookie')
  js_cookie_latest_tag = run_command("cd #{js_cookie_path} && git describe --abbrev=0 --tags")
  js_cookie_version = js_cookie_latest_tag.gsub(/^v/, '')

  # Save new gem version
  gem_version_path = $project_path.join('VERSION')
  gem_version = "#{js_cookie_version}.0"

  File.open(gem_version_path, 'w') {|f| f.write(gem_version) }

  # Commit
  run_command "git add ."
  run_command "git commit -m \"Version bump to #{gem_version} (js-rails version #{js_cookie_version})\""
  run_command "git tag #{gem_version}"
end

task :default do
  Rake::application.options.show_tasks = :tasks  # this solves sidewaysmilk problem
  Rake::application.options.show_task_pattern = //
  Rake::application.display_tasks_and_comments
end
