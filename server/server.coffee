Meteor.publish "users", -> 
	UserStatus.connections.find {}, fields: {ipAddr: no, userAgent: no}
	
UserStatus.connections.find().observe 
	added: (user) ->
		Math.seedrandom user._id
		$set = 
			agent:  _.first _.sample ["Bonzi", "Clippy", "F1", "Genie", "Genius", "Links", "Merlin", "Peedy", "Rocky", "Rover"], 1
			x: _.random(20,400)
			y: _.random(20,400)
		UserStatus.connections.update user._id, $set: $set 
	



Meteor.methods 
	getMyId: -> @connection.id
	sendMessage: (message)->
		UserStatus.connections.update @connection.id, $set: message: message
		