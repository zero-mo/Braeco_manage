MBase 		= require "../Utils/MBase.js"
eventbus 	= require "../eventbus.js"

class SubitemModifyModel extends MBase
	(options)!-> super options

	assign: (options)!->
		@datas = options.datas

	init-all-prepare: !->
		@is-all-choose 				= false
		@is-category-choose 	= {}
		@is-category-active 	= {}
		@is-dish-choose 			= {}
		@config-data 					= null
		@all-choose-dish-ids 	= []
		@state 								= null
		@id 									= null

	init-all-datas: !->
		for data, i in @datas when data.dishes.length > 0
			@is-category-choose[data.id] 				= false
			@is-category-active[data.id] 				= false
			@is-dish-choose[data.id] 						= {}
			for dish in data.dishes when dish.type is "normal"
				@is-dish-choose[data.id][dish.id] = false

	set-is-all-choose: (is-choose)!->
		@is-all-choose = is-choose
		eventbus.emit "model:subitem-modify:is-all-choose-change", is-choose
		for id, category of @is-dish-choose
			@set-is-category-choose id, is-choose

	get-is-all-choose: -> return @is-all-choose

	set-is-category-choose: (category-id, is-choose)!->
		@is-category-choose[category-id] = is-choose
		eventbus.emit "model:subitem-modify:is-category-choose-change", category-id, is-choose
		for id, dish of @is-dish-choose[category-id]
			@set-is-dish-choose category-id, id, is-choose

	set-is-category-active: (category-id, is-active)!->
		@is-category-active[category-id] = is-active
		eventbus.emit "model:subitem-modify:is-category-active-change", category-id, is-active

	get-is-category-choose: (category-id)-> return @is-category-choose[category-id]

	get-is-category-active: (category-id)-> return @is-category-active[category-id]

	set-is-dish-choose: (category-id, dish-id, is-choose)!->
		@is-dish-choose[category-id][dish-id] = is-choose
		eventbus.emit "model:subitem-modify:is-dish-choose-change", category-id, dish-id, is-choose

	get-is-dish-choose: (category-id, dish-id)-> return @is-dish-choose[category-id][dish-id]

	update-all-choose-dish-ids: !->
		@all-choose-dish-ids.length = 0
		for category-id, category of @is-dish-choose
			for dish-id, is-choose of category when is-choose
				@all-choose-dish-ids.push dish-id

	get-all-choose-dish-ids: -> return @all-choose-dish-ids

	set-state: (state)!->
		@state = state
		eventbus.emit "model:subitem-modify:state-change", state

	get-state: -> return @state

	set-config-data: (config-data)!->
		@config-data = config-data

	get-config-data: -> return @config-data

	check-self-config-data-is-valid: ->
		err-msg = ""; valid-flag = true
		if @config-data.name.length <= 0 or @config-data.name.length > 32 then err-msg += "子项名称长度应为1~32位\n"; valid-flag = false
		if @config-data.remark.length > 32 then err-msg += "子项备注长度应为0~32位\n"; valid-flag = false
		if @config-data.combo-type is "discount"
			if Number @config-data.price < 0 or Number @config-data.price > 10000 then err-msg += "子项折扣应为0~10000"; valid-flag = false
		else
			if Number @config-data.discount < 0 or Number @config-data.discount > 100000 then err-msg += "子项价格应为0~100000元"; valid-flag = false
		if @config-data.content.length < 0 then err-msg += "子项需选择至少一个单品"; valid-flag = false
		if not valid-flag then alert err-msg
		return valid-flag

	reset: !->
		@set-is-all-choose false
		for category-id, category-is-active of @is-category-active
			@set-is-category-active category-id, false
		eventbus.emit "model:subitem-modify:reset"

	read-from-subitem: (subitem)!->
		@id = subitem.id
		eventbus.emit "model:subitem-modify:read-from-subitem", subitem

module.exports = SubitemModifyModel

