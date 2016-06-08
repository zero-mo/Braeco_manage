eventbus 				= require "../eventbus.js"

[			get-object-URL] =
	[		util.get-object-URL]

class NewController
	(options)->
		@assign options
		@init!

	assign: (options)!->
	
	init: !->
		@init-all-prepare!
		@init-all-event!
		@reset!

	init-all-prepare: !->
		@config-data 				= null
		@upload-pic-flag 		= null
		@pic 								= null

	init-all-event: !->

	reset: !->
		@upload-pic-flag 		= false
		@pic 								= null
		@config-data 				= 
			name 					: null
			name2 				: null
			type 					: null
			price 				: null
			groups			 	: []
			tag 					: null
			detail 				: null
			dc_type 			: null
			dc 						: null

	pic-change: (file)!->
		@upload-pic-flag 	= true
		@pic 							= get-object-URL file
		even.emit "controller:new:pic-change", @pic

	add-subitem: !->
		@config-data.groups.push {}
		even.emit "controller:new:add-subitem"

	top-subitem: (index)!->
		if index <= 0 or index >= @groups.length then return alert "非法操作"
		subitem = @groups.splice index, 1
		@groups.unshift subitem
		eventbus.emit "controller:new:top-subitem", subitem, index

	remove-subitem: (index)!->
		if index < 0 or index >= @groups.length then return alert "非法操作"
		subitem = @groups.splice index, 1
		eventbus.emit "controller:new:remove-subitem" index

	get-config-data: (options)!-> @config-data = options

	check-is-valid: !->






module.exports = NewController