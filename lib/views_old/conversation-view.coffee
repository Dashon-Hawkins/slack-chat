{$, EditorView, View} = require 'atom-space-pen-views'
SlackClient = require('./slack_client.coffee')
RTMClient = require('./rtm-client')

MessageView = require './message-view'
# {allowUnsafeEval} = require 'loophole'
# ScrollTo = allowUnsafeEval -> require 'jquery-scrollto'

module.exports =
  class ConversationView extends View
    @content: (member) ->
      @div class: 'conversation-view',  =>
        @div class: 'conversation-header', outlet: 'header', =>
          @span '<', class: 'back'
          @div "#{member.name}", class: 'title'
        @ol
          id: 'message_list'
          class: 'slack-chat messages full-menu list-tree has-collapsable-children focusable-panel'
          tabindex: -1
          outlet: 'messages'

        # @div id: 'message_input', outlet: "messageInput", =>
        #   @subview 'miniEditor', new EditorView(mini: true)

    initialize: (@member, @parent) ->
      @client = SlackClient.getInstance()
      @rtm = RTMClient.getInstance()
      @load()

      # @on 'click', "#message_input", ->
      #   @focus()

      # @command 'core:confirm', =>
      #   @slack.sendMessage(@member.im.id, @miniEditor.getText())
      #   @getMessages()
      #   @miniEditor.setText('')
      #   @miniEditor.height(34)

      # @command 'slack-chat:new-line', =>
      #   @miniEditor.setText(@miniEditor.getText() + '\n')
      #   @miniEditor.height(@miniEditor.height() + 25)


    load: ->
      @header.hide()
      @parent.title.html @header.html()
      $('.back').click (e) =>
        @closeConversation()
      @getMessages()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
      # @slack.removeMessageSubscription(@appendMessage)
      # @detach()

    appendMessage: (messages) =>
      # @getMessages()

    getMessages: ->
      @messages.html('')
      method = 'im.history'
      method = 'channels.history' if @member.is_channel
      @client.get method, { channel: @member.channel }
      .done (resp) =>
        @messages.append new MessageView(m, @parent) for m in resp.messages

    focus: ->
      # @miniEditor.height(34)
      # @miniEditor.focus()

    hasFocus: ->
      # @messageInput.is(':focus')

    closeConversation: ->
      @parent.closeConversation()