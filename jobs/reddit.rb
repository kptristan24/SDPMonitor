require 'net/http'
require 'json'
require 'uri'

class Reddit
  def initialize()
    # add your desired subreddits here
    @subreddits = {
      '/r/programming' => 'https://www.reddit.com/r/programming.json',
      '/r/gaming' => 'https://www.reddit.com/r/gaming.json',
      '/r/politics' => 'https://www.reddit.com/r/politics.json',
      '/r/ruby' => 'https://www.reddit.com/r/ruby.json'
    }

    # the limit per subreddit to grab
    @maxcount = 5
  end

  def getTopPostsPerSubreddit()
    posts = [];

    @subreddits.each do |subreddit, url|

      puts "Check this fat meme:"
      puts subreddit
      puts url
      puts "\n"

      sleep(10)
      http_response = Net::HTTP.get(URI(url))
      puts http_response
      response = JSON.parse(http_response)

      if !response
        puts "reddit communication error for #{@subreddit} (shrug)"
      else
        items = []

        for i in 0..@maxcount
          title = response['data']['children'][i]['data']['title']
          trimmed_title = title[0..85].gsub(/\s\w+$/, '...')

          items.push({
            title: trimmed_title,
            score: response['data']['children'][i]['data']['score'],
            comments: response['data']['children'][i]['data']['num_comments']
          })
        end

        posts.push({ label: 'Current top posts in "' + subreddit + '"', items: items })
      end
    end

    posts
  end
end

@Reddit = Reddit.new();

SCHEDULER.every '2m', :first_in => 0 do |job|
  posts = @Reddit.getTopPostsPerSubreddit
  send_event('reddit', { :posts => posts })
end
