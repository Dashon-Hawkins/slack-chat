{$, EditorView, View} = require 'atom'

SlackAPI = require './slack-api'
MessageView = require './message-view'

module.exports =
  class ConversationView extends View
    @content: (member) ->
      @div class: 'conversation-view',  =>
        @div class: 'conversation-header', outlet: 'header', =>
          @span class: 'back glyphicon glyphicon-chevron-left'
          @div "#{member.name}", class: 'title'
        @ol 
          id: 'message_list'
          class: 'slack-chat messages full-menu list-tree has-collapsable-children focusable-panel'
          tabindex: -1
          outlet: 'messages'

        @div id: 'message_input', outlet: "messageInput", =>
          @subview 'miniEditor', new EditorView(mini: true)

    initialize: (@member, @parent) ->
      console.log @member
      @slack = new SlackAPI()
      @load()

      @on 'click', "#message_input", ->
        @focus()

      @command 'core:confirm', => 
        @slack.sendMessage(@member.im.id, @miniEditor.getText())
        @miniEditor.setText('')
        @miniEditor.height(34)
        
      @command 'slack-chat:new-line', =>
        @miniEditor.setText(@miniEditor.getText() + '\n')
        @miniEditor.height(@miniEditor.height() + 25)

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
      @detach()

    getMessages: ->
      for m in @slack.messages(@member.im.id, @member.im.channel)
        m = m.message if m.message
        @messages.append new MessageView(m, @parent)
        
    focus: ->
      @miniEditor.height(34)
      @miniEditor.focus()
      
    hasFocus: ->
      @messageInput.is(':focus')
      
    closeConversation: ->
      @parent.closeConversation()
      
