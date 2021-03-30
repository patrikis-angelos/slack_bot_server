# slack_bot_server

## Built With

- Ruby

## Getting Started
To test the project in your own environment:

### You will need ngrok to tunnel to your localhost
- Download [ngrok](https://ngrok.com/).
- Unzip it.
- Move ngrok to the root directory of the project.
- Open a terminal from the root directory of the project.
- Type `./ngrok http 3000` to create a tunnel to your localhost:3000.

### You will need a slack account, a workspace, and a slack app
- Go to [slack](https://slack.com) and create a free account by pressing the `Try For Free` button.
- Create a new [workspace](https://slack.com/get-started#/create), You can find that under the `Launch Slack` button.
- Go to the [Slack API](https://api.slack.com/) page, if you are logged in you should see the `Your Apps` button on the top right.
- `Create New App` from there, enter a name for your bot and select the workspace you created to add it.
- Go to the `OAuth & Permissions` tab, and add `channels:history` and `chat:write` scopes.
- Then `Install to Workspace`, and you will receive a bot user token from there.
- Create a `.env` file in the project's root directory and add your bot token and sign in secret in that file like so:
  - SLACK_BOT_TOKEN=xoxb-...
  - SLACK_SIGNIN_SECRET=123... (You can find the sign-in secret on the `Basic Information tab`).
- Start a terminal from the project root directory and type `./ngrok http 3000`.
- Copy the Forwarding url. It will seem something like that `http://81a5d...ngrok.io`.
- Start another terminal and type `ruby bin/main.rb`.
- Go to the `Event Subscriptions` tab and enable events.
- Add the `message.channels` event from the `Subscribe to bot events` dropdown.
- Paste the ngrok url in the `Request URL` field and save the changes.
- From the `App Home` tab find the `Always Show My Bot as Online` field and turn it on.
- In your workspace press the `+ Add apps` button and add your app.
- Include the app in whichever channel you want and test it out.

## Author

👤 **Patrikis Angelos**

- GitHub: [@patrick-angelos](https://github.com/patrick-angelos)
- Twitter: [@AngelosPatrikis](https://twitter.com/AngelosPatrikis)
- LinkedIn: [Angelos Patrikis](https://www.linkedin.com/in/patrikis-angelos/)

## Acknowledgments

- To Microverse for their `README` template.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## Show your support

Give a ⭐️ if you like this project!

## 📝 License

MIT License
