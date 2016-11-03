require 'slack-ruby-bot'
require 'httparty'
require 'pp'
require 'yaml'

class PongBot < SlackRubyBot::Bot
  
def self.get_image(query)

@client_id = YAML.load_file('secrets.yaml')['client_id']
@api_key = YAML.load_file('secrets.yaml')['api_key']
array = []

puts query
puts 
puts 
puts
 
res = HTTParty.get("https://api.imgur.com/3/gallery/search/?q=#{query}", :query => query,  :headers => {'Authorization' => 'Client-ID ' + @client_id})

pp res

 if res['data'].class  == Hash 
   if res['data'].has_key?('error')
     puts "imgur's api has sh*t the bed"
    sleep 2
    get_image(query)
   end
 else
  res['data'].each do |post|
    if post['nsfw'] == false && post['is_album'] == false
      array << post['link']
    end
 end
  end
if array.sample == nil
	"I'm still learning, but i dont have an image for you"
else
	array.sample
end
end

command 'animate me' do |client, data, match|
    image = match.to_s.gsub('bender','').gsub('image me','').split(' ').join('+')
    url = HTTParty.get(URI.escape("http://api.giphy.com/v1/gifs/search?q=#{image}&api_key=#{@api_key}"))['data'].sample['url']
    client.say(text: url , channel: data.channel)
  end

  command 'image me' do |client, data, match|
    image = match.to_s.gsub('bender ','').gsub('image me ','')
    client.say(text: self.get_image(URI.escape(image)), channel: data.channel )
  end
  
  command 'i love you' do |client,data,match|
    client.say(text: 'https://media.giphy.com/media/l41lThzPudACYOzPG/giphy.gif', channel: data.channel)
  end

  command 'kiss my ass' do |client,data,match|
    client.say(text: 'https://media.giphy.com/media/Fml0fgAxVx1eM/giphy.gif', channel: data.channel)
  end
  command 'make it rain' do |client, data, match|
    gif = [
        "http://i.imgur.com/lnK1nBF.gif",
        "http://i.imgur.com/ptqA6dW.gif",
        "http://i.imgur.com/r1o0uyH.gif",
        "http://i.imgur.com/N0aYJTJ.gif",
        "http://i.imgur.com/j25gaOc.gif",
        "http://i.imgur.com/tkbHsDZ.gif",
        "http://i.imgur.com/HaNu5ka.gif",
        "http://i.imgur.com/5ZcUxTg.gif",
        "http://i.imgur.com/5CiZA5v.gif",
        "http://i.imgur.com/nDUasjq.gif",
        "http://i.imgur.com/8ExBVb4.gif",
        "http://i.imgur.com/cskbcM2.gif",

        "http://i.imgur.com/49tP7pc.gif",
        "http://i.imgur.com/28bfK1I.gif",
        "http://i.imgur.com/ERyoPf3.gif",
        "http://i.imgur.com/PbADlZW.gif",
        "http://i.imgur.com/dgBtPpD.gif",
        "http://i.imgur.com/2BgTeUI.gif",
        "http://i.imgur.com/OYAgYcf.gif",
        "http://i.imgur.com/gh7uW50.gif",
        "http://i.imgur.com/6fYah3Z.gif",
        "http://i.imgur.com/JeEHZL9.gif",
        "http://i.imgur.com/BxFlFvv.gif",
        "http://i.imgur.com/n6K78PG.gif",
        "http://i.imgur.com/AbHWKoc.gif"
    ].sample
    client.say(text: gif, channel: data.channel)
  end

  command 'i need more cowbell' do |client, data, match|

    client.say(text: 'http://i.imgur.com/2CVpF.gif', channel: data.channel)
  end


  command 'magic eight ball me' do |client,data,match|
    option = ["It is certain",
 	"It is decidedly so",
 	"Without a doubt",
	 "Yes, definitely",
 	"You may rely on it",
	"As I see it, yes",
	 "Most likely",
	 "Outlook good",
	 "Yes",
	 "Signs point to yes",
 	"Reply hazy try again",
	 "Ask again later",
	 "Better not tell you now",
 	"Cannot predict now",
 	"Concentrate and ask again",
	 "Don't count on it",
	 "My reply is no",
	 "My sources say no",
	 "Outlook not so good",
 	"Very doubtful"].sample
    client.say(text: option, channel: data.channel)
  end
    
  command 'help' do |client, data, match|
    client.say(text: "You need help? Here's the code, which if you're smart enough can see the commands and what they do \n https://github.com/seanrclayton/bender_the_slack_bot/blob/master/bot.rb \n if you need a list of commands I can do stuff. Just say my name first and follow it with these commands (eg. typing 'bender image me cat' will HOPEFULLY return a cat) \n animate me - searches and finds a animated gif with your phrase \n make it rain - makes it rain \n magic eight ball me -  will look into your future (with a yes or no question, of course) \n i need more cowbell - Gives you more cowbell \n meme me - will return you a meme (if you're lucky) I'm really crummy at this now \n You can even tell me you love me or to kiss your ass. ", channel: data.channel)
  end
    
command 'meme me' do |client, data, match|
    image = match.to_s.gsub('bender ','').gsub('meme me ','')
    client.say(text: self.get_image(URI.escape(image + ' and subreddit:adviceanimals')), channel: data.channel )
  end
end

    

PongBot.run

