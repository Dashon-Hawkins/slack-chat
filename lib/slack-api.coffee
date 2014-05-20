{$, ScrollView} = require 'atom'
_ = require 'underscore-plus'

module.exports =
  class SlackAPI
    constructor: ->
      @getChannels()
      @getTeam()

    channels: ->
      @slackChannels
    
    team: ->
      @slackTeam
      
    messages: (channel, is_channel) ->
      @getMessages(channel, is_channel)
      @slackMessages.reverse()

    #################################################################################
    #
    # GET Methods
    # Should probably switch to deferreds or something later
    #################################################################################
    sendRequest: (params) ->
      $.ajax
        async: false
        type: 'GET'
        url: "https://slack.com/api/im.history?token=#{atom.config.get('slack-chat.token')}&channel=#{channel}"
        success: (data) =>
          params.success()

    getMessages: (channel, is_channel) ->
      t = if is_channel then 'channels' else 'im'
      $.ajax
        async: false
        type: 'GET'
        url: "https://slack.com/api/#{t}.history?token=#{atom.config.get('slack-chat.token')}&channel=#{channel}"
        success: (data) =>
          @slackMessages = data.messages if data.ok

    getChannels: ->
      @slackChannels ||= []
      unless @slackChannels.length > 0
        $.ajax
          async: false
          type: 'GET'
          url: "https://slack.com/api/channels.list?token=#{atom.config.get('slack-chat.token')}"
          success: (data) =>
            if data.ok is true
              @slackChannels.push c for c in data.channels

    getTeam: ->
      @slackTeam ||= []
      unless @slackTeam.length > 0
        $.ajax
          async: false
          type: 'GET'
          url: "https://slack.com/api/users.list?token=#{atom.config.get('slack-chat.token')}"
          success: (data) =>
            if data.ok is true
              @slackTeam.push m for m in data.members
              @getIMs()

    getIMs: ->
      unless @slackTeam.length > 0 and @slackTeam[0].im
        $.get 'https://slack.com/api/im.list', { token: atom.config.get('slack-chat.token') }
         .done (data) =>
            if data.ok is true
              for i in data.ims
                m = _.findWhere(@slackTeam, {id: i.user})
                m.im = i if m
      
    sendMessage: (im, message) ->
      regex = /:.{1,}:/
      icon = atom.config.get('slack-chat.icon_emoji_or_image')
      args = {
        token: atom.config.get('slack-chat.token')
        channel: im
        text: message
        username: atom.config.get('slack-chat.username')
      }
      if regex.test(icon)
        args.icon_emoji = icon
      else
        args.icon_url = icon
        
      $.get('https://slack.com/api/chat.postMessage', args).done (data) =>
        console.log data

        # Set mark when message is sent
        $.get('https://slack.com/api/channels.mark?', {token: atom.config.get('slack-chat.token'), channel: im, ts: Date.now()}).done (data) ->
          console.log data
