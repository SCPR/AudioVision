def log(msg)
  puts "*** [#{Time.zone.now}] #{msg}"
end


namespace :av do
  desc "Fire pending alarms"
  task :fire_alarms => [:environment] do
    log "Firing pending alarms... "
    PublishAlarm.fire_pending
    log "Finished.\n"
  end

  desc "Fix timezones"
  task :fix_tz => [:environment] do
    connection = ActiveRecord::Base.connection

    connection.tables.each do |table|
      cols = connection.columns(table).select { |c| c.type == :datetime }
      next if cols.empty?

      query = cols.map { |col|
        %Q{#{col.name} = convert_tz(#{col.name}, 'America/Los_Angeles', 'UTC')}
      }.join(", ")

      execute "UPDATE #{table} SET #{query}"
    end
  end
end
