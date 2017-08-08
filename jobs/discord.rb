require 'rufus-scheduler'
require 'discordrb'

scheduler = Rufus::Scheduler.new

bot = Discordrb::Bot.new token: 'MTk4NjY1NjkwNjMzMjA3ODA4.CljdVw.vc3Uia3bCxdP1UtQiCo9x4PuSvQ', application_id: 198665319659601922

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.mention do |event|
  event.user.pm('I am your new god')
end

bot.message(with_text: '!deetz') do |event|
  event.respond(bot.server((192481924655087616)))
  server = bot.server((192481924655087616))
  members = server.online_members

  members.each do |name|
    puts name.display_name
  end
end

scheduler.every '30s' do
  server = bot.server((192481924655087616))
  members = server.online_members
  target = open('/Users/kptristan/Documents/dashboardstuff/boyz_monitor/assets/memes.txt', 'w')

  members.each do |name|
    target.write(name.display_name)
    target.write("\n")
  end
  target.close
end

bot.run :async
###new memes


SCHEDULER.every '10s' do
  puts "\n"
  puts "Querying Online Members..."
  puts "\n"

  members_online = {};
  server = bot.server((192481924655087616))
  members = server.online_members

  members.each do |name|
    members_online[name] = { label: name.display_name }
  end
  #puts "\n"
  #puts members_online.values
  #puts "\n"

  send_event('discord-data', {items: members_online.values})
end
