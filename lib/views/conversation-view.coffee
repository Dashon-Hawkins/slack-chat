
ChannelView = require './conversations/channel-view'
MemberView = require './conversations/member-view'
{$, ScrollView} = require 'atom-space-pen-views'

module.exports =
class ConversationView extends ScrollView
  @content: ->
    @div id: 'conversations', =>
      @div class: 'title', outlet: 'title'
      @ul id: 'channels', outlet: 'channelElements'
      @ul id: 'members', outlet: 'memberElements'

  initialize: (@stateController, @client) ->
    super
    @currentConversation = null
    @channelViews ||= []
    @memberViews ||= []
    @getChannels()
    @getMembers()
    @getTeamInfo()

  getChannels: () =>
    @channels = @stateController.team.channels
    for channel in @channels
      @channelViews.push new ChannelView(@stateController, channel)
      @stateController.preloadChat(channel)
    @channelElements.append(view) for view in @channelViews

  getMembers: (callback) =>
    @members = @stateController.team.membersNotMe()
    for member in @members
      @memberViews.push new MemberView(@stateController, member)
      @stateController.preloadChat(member)
    @memberElements.append(view) for view in @memberViews

  getTeamInfo: =>
    @client.get 'team.info', {}, (err, resp) =>
      @title.append(@titleElement(resp.body.team))

  nextConversation: =>
    convos = $('li', '#conversations')
    if @currentConversation?
      index = convos.index(@currentConversation)
      @setCurrentConversation($(convos[index + 1])) if index < convos.length - 1
    else
      @setCurrentConversation $('li', '#conversations').first()

  prevConversation: =>
    convos = $('li', '#conversations')
    if @currentConversation?
      index = convos.index(@currentConversation)
      @setCurrentConversation($(convos[index - 1])) if index > 0
    else
      @setCurrentConversation convos.last()

  openConversation: =>
    @convos = @channelViews.concat(@memberViews)
    index = $('li', '#conversations').index @currentConversation
    @currentConversation.removeClass('unread')
    @convos[index].showConversation()

  setCurrentConversation: ($convo) =>
    $(el).removeClass('selected') for el in $('li', '#conversations')
    $convo.addClass('selected')
    @currentConversation = $convo

  refresh: ->
    view.eventHandlers() for view in @memberViews
    view.eventHandlers() for view in @channelViews

  titleElement: (team) ->
    "<img id='teamIcon' src='#{team.icon.image_44}' /><h1>#{team.name}</h1>"
