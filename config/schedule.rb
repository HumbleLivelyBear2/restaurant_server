env :PATH, ENV['PATH']

every :day, :at => '04:00am' do
  rake 'crawl:make_selected_res_table',:output => {:error => 'log/error.log', :standard => 'log/cron.log'}
  rake 'crawl:crawl_rank_category_ship',:output => {:error => 'log/error.log', :standard => 'log/cron.log'}
end

every :day, :at => '04:30am' do
  rake 'crawl:make_selected_note_table',:output => {:error => 'log/error.log', :standard => 'log/cron.log'}
end

every :day, :at => '04:50am' do
  rake 'environment tire:import CLASS=Article FORCE=true',:output => {:error => 'log/error.log', :standard => 'log/cron.log'}
end