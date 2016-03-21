require 'sinatra'
require 'json'
require 'octokit'

set :port, 3000
get '/' do
  "Hello World"
end

post '/event_handler' do
    ACCESS_TOKEN = "ENTER_YOUR_ACCESS_TOKEN"
    
      @client ||= Octokit::Client.new(:access_token => ACCESS_TOKEN)

     request.body.rewind
  request_payload = JSON.parse request.body.read
 
     case request.env['HTTP_X_GITHUB_EVENT']
  when "pull_request"
    if request_payload["action"] == "opened"
         pull_request = request_payload["pull_request"]
        puts "It's #{pull_request['title']}"
        
        puts "Processing pull request..."
      @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'pending')
      sleep 2 # do busy work...
      @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'success')
      puts "Pull request processed!"
        
    end
  end
    
    
   
       logger.info "Action == #{request_payload['action']} with #{request_payload['ref']}"
   
   
  

    
   "Well, it worked!"
end
