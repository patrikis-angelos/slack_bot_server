module Commands
  def hi(data)
    params = { token: ENV['SLACK_BOT_TOKEN'], channel: data['event']['channel'], text: 'Hello'}
    take_action('chat.postMessage', params)
  end

  def time(data)
    params = { token: ENV['SLACK_BOT_TOKEN'], channel: data['event']['channel'], text: "The time is #{Time.now}"}
    take_action('chat.postMessage', params)
  end
end