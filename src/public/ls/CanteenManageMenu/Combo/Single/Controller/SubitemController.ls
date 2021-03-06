eventbus 			= require "../eventbus.js"
Subitem 			= require "../Model/Subitem.js"

class SubitemController
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@datas 			= 	options.datas
		@length 		= 	0

	init: !->
		@init-all-prepare!
		@init-all-datas!

	init-all-prepare: !->
		@subitems  			= {}

	init-all-datas: !->
		for data in @datas when data.type isnt "property"
			subitem = new Subitem data
			@subitems[data.id] = subitem
			@length++
		console.log @subitems

	get-subitem-length: (subitem-id)-> return @subitems[subitem-id].get-content!.length

	get-subitem-name: (subitem-id)-> return @subitems[subitem-id].get-name!

	get-subitem-content: (subitem-id)-> return @subitems[subitem-id].get-content!

	get-all-subitems: -> return @subitems

	get-all-subitems-length: -> return @length

module.exports = SubitemController
