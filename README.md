
# Slack Chat - Atom package *Beta*

Slack Chat is an Atom package that integrates the slack messaging client into the editor.
#### With slack chat you can:
- Send and receive messages in real time
- View message history

# Installation
- Install slack-chat from the atom package manager
- Log in to slack with the window that was opened in your browser and authorize the sc-client application

  <img src="http://drive.google.com/uc?export=view&id=0B_FMiWCp_bLQems3NTlIUjlzWWM" width="325px" />
  <img src="http://drive.google.com/uc?export=view&id=0B_FMiWCp_bLQYm9HSi0xY2RMQVU" width="325px" />

- Restart atom

# Usage

### Keybindings
```cson
'atom-workspace':
  'cmd-m': 'slack-chat:toggle'
  'ctrl-j': 'slack-chat:move-down'
  'ctrl-k': 'slack-chat:move-up'
  'ctrl-l': 'slack-chat:open-conversation'
  'ctrl-o': 'slack-chat:close-conversation'
```


# Settings

### Token
This is your token for your team. Slack Chat should manage this for you. If you need to sign in with a different account/team, remove this token and reload Atom.

# Preview
<img src="http://drive.google.com/uc?export=view&id=0B_FMiWCp_bLQNlluR2MwRkNWVG8" width="325px" />
<img src="http://drive.google.com/uc?export=view&id=0B_FMiWCp_bLQOEM1ZjZvUDRhVEk" width="325px" />

# Todo
- [ ] Fix real time messaging
- [ ] Real time message notification system
- [ ] User Status (online/offline)
- [x] Create Keybindings for selection
- [x] Parse markdown
- [ ] Display emoticons
- [ ] Send a selection of text as a message/file
- [ ] Upload files
- [ ] Fix markdown differences between github flavored and Slack
- [ ] Code highlight for markdown
- [ ] Display images/files

