set :output, "log/cron.log"
set :environment, :development
env :PATH, ENV["PATH"]

every 1.day, at: "4:00 am" do
  command "node crawl_data/all_tickets_crawl.js"
end

every 1.day, at: "4:30 am" do
  runner "UpdatePostJob.perform_now"
end

