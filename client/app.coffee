
@Users = new Mongo.Collection "user_status_sessions"
@Me = new ReactiveVar

@Agents = {}
createAgent = (user) ->
	clippy.load user.agent, (agent) ->
		Agents[user._id] = agent
		agent.moveTo user.x, user.y
		agent.show()

		if user.message?
			agent.speak user.message
Users.find().observe 
	added: (user) ->

		unless Agents[user._id]?
			createAgent user

	
	changed: (user) ->
		unless Agents[user._id]?
			createAgent user

		Agents[user._id].speak user.message

	
	removed: (user) ->

		if Agents[user._id]?
			agent = Agents[user._id]
			$(agent._el).remove()
			delete Agents[user._id]

	

Meteor.startup ->
	Meteor.subscribe "users"
	Meteor.subscribe "messages"
	Meteor.call "getMyId", (error, id) -> Me.set id

			
Template.users.helpers
	me: -> Me.get()
	others: -> Users.find _id: $ne: Me.get()


Template.chat.events
	'submit form': (event) ->
		$input = $(event.currentTarget).find("input.message")
		message = $input.val()
		if message.length > 0
			Meteor.call "sendMessage", message
			$input.val ""


		return false