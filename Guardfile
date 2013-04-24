guard :resque, task: 'environment resque:work', environment: 'development' do
  watch(%r{^app/models/(.+)\.rb$})
  watch(%r{^app/jobs/(.+)\.rb$})
  watch(%r{^lib/(.+)\.rb$})
end

guard :rspec, cli: "-c -f progress", all_on_start: false, all_after_pass: false do
  # --format nested --profile --fail-fast
  watch(%r{^spec/.+_spec\.rb$})
  
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }

  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"] }
  watch(%r{^app/views/(.+)/(?:.+/).+(\.erb|\.jbuilder)$})    { |m| "spec/controllers/#{m[1]}_controller_spec.rb" }
  watch(%r{^app/views/billboards/.+})    { |m| "spec/controllers/home_controller_spec.rb" }

  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
end
