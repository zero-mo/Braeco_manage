do ->
	My-wrap = !->
		@wraps = $ '.wrap'
		@blues = $ '.blue'
		self = @
		# **********************************************************
		# ************************ todo  ***************************
		# **********************************************************
		for let temp in @wraps
			temp.valid = ->
				if($ temp .attr('id')=='wrap_pics')
					return true
				inputs = $ temp .find 'input'
				for x in inputs
					if !x.is-valid!
						return false
				if($ temp .attr('id')=='wrap_password')
					if inputs[0].value == inputs[1].value
						inputs[1].show-message '新密码不能和旧密码一样哦！'
						return false
					if inputs[1].value != inputs[2].value
						inputs[2].show-message '确认密码应该和新密码一样哦！'
						return false
				return true
			temp.get-my-data = ->
				data ={}
				if($ temp .attr('id')=='wrap_pics')
					return null
				inputs = $ temp .find 'input'
				for x in inputs
					name = x.getAttribute 'name'
					if name == 'oldpass'
						data[name] = $.md5 x.value
					else
						data[name] = x.value
				data
			if temp.getAttribute('id')!='wrap_pics'
				temp.mysubmit =(mydata,myurl)->
					util.ajax {
					type : 'post'
					url : '/Dinner/Update/Profile'
					async :'true'
					data : JSON.stringify mydata
					success : (result)!->
						ajax-callback result
					unavailabled : (result)!->
						show-global-message '提交失败，请重试！'
					}

		for let blue, i in @blues
			$ blue .click -> 
				showWrap(i,$ @ .parents '.info_li' .find '.info_value' .text!)

		@wraps.find '.close_wrap' .click !->
			closeWrap($(@).parents '.wrap' .index!)
		@wraps.find '.cancle' .click !->
			closeWrap($(@).parents '.wrap' .index!)
		@wraps.find '.btn.confirm' .click !->
			curr = $ @ .parents '.wrap' .get(0)
			if curr.valid!
				curr.mysubmit curr.get-my-data!
		showWrap =(index,str)!~>
			if index<@wraps.length
				w = @wraps.eq index 
				$ '#wrap_contianer' .show!
				w.fadeIn 300
				if index != 5
					w.find('input').val ''
				if index>0&&index<4
					w.find '.wrap_input span' .html str
		closeWrap = (index)!->
			$ '#wrap_contianer' .fadeOut 300
			self.wraps.eq index .hide!
		ajax-callback = (result)!->
			if result.message == 'success'
				location.reload true
			else if 'Wrong password'
				show-global-message '原密码<b>错误</b>,请重新输入'
				$ '#wrap_password input' .eq 0 .val ''
				$ '#wrap_password input' .eq 0 .focus!
			else
				show-global-message '提交失败，原因：'+result.message

	My-inputs = (input)!->
		# 特殊字符
		# myreg = /[~!<>#$%^&*()-+_=:]/g
		# 把四个特殊字符<>&\换成''
		myreg = /[<>&\\]/g
		@inputs = input
		self = @
		for let temp in @inputs
			temp.is-valid = (reg,str)->
				if @.getAttribute('type')== 'radio'
					if $ 'input[name=printer]' .val! == ''
						@show-message '请选择一个打印机'
						return false
					else
						return true
				else 
					if @value == '' || /^\s*$/g.test @value
						@show-message '输入不可为空！'
						return false
					else if (@getAttribute 'name' ) == 'email'
						if ! /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/.test @value
							@show-message '请输入正确的邮箱地址'
							return false
					# 固定电话和手机号码的验证太麻烦，此处略过
					# else if (@getAttribute 'name' ) == 'phone'
					# 	if ! /^[0-9\-\s]+$|^1[34578][0-9]{9}/.test @value
					# 		@show-message '只能输入固定座机或者手机号码哦！'
					# 		console.log 'phone'
					# 		return false
					return true
				
			$ temp .blur !->
				$ @ .val($ @ .val().replace myreg,'' )
			temp.show-message = (str)!->
				$ temp .focus!
				show-global-message str

	Wrap-pics = !->
		self = util.getById 'wrap_pics'
		self.mychange = {}
		$ self .find 'input[type=file]' .change !->
			ob = $ @ .parents '.little_pic_li' 
			index = ob.index!
			ob.addClass 'change'
			img-preview index,util.getObjectURL(@.files[0])
		$ self .find '.little_pic_li .delet_img' .click !->
			delete-img-input($ @ .parents('.little_pic_li').index!)
		
		self.mysubmit = !->
			show-loading!
			for x in $ self .find '.little_pic_li.change'
				index = $ x .index!
				self.mychange[index+''] = {}
				self.mychange[index+''].action = 'change'
			self._change_num =0
			console.log self.mychange
			for key of self.mychange
				self._change_num += 1
				if self.mychange[key].action == 'delete'
					ajax-for-delete key,self._change_num
				else if  self.mychange[key].action == 'change'
					ajax-for-token key,self._change_num
		afte-upload-img = ->
			text
			for key of self.mychange
				text = key + ':' + self.mychange[key].result+'<br>'
			show-global-message text
			close-loading!
		ajax-for-token = (n,file,order)!->
			util.ajax {
				type : 'post'
				url : '/pic/upload/token/cover/' + n
				async :'true'
				success : (result)!->
					result = JSON.parse result
					if result.message == 'success'
						ajax-for-qiniu data,n,order
				unavailabled : (result)!->
					self.mychange[i+''].result='上传失败，请重试'
				always : (result)!->
					
				}
		ajax-for-qiniu = (data,n,order)!->
			$ 'iframe' .eq(0).attr 'order',order
			$ '.form' .eq n .find 'input[name=token]' .val data.token
			$ '.form' .eq n .find 'input[name=key]' .val data.key
			$ '.form' .get n .submit!
			
		ajax-for-delete = (n,order)!->
			util.ajax {
				type : 'post'
				url : '/Dinner/Cover/Remove/'+n
				async :'true'
				success : (result)!->
					result = JSON.parse result
					if result.message == 'success'
						self.mychange[i+''].result='删除成功'
				always : (result)!->
					if order==self._change_num
						afte-upload-img!
				unavailabled : (result)!->
					self.mychange[i+''].result='删除失败，请重试!'
			}
		$ 'iframe' .load ->
			i = parseInt($ @ .attr 'order')
			if(i<=self._change_num)
				self.mychange[i+''].result = '上传成功！'
				if i == self._change_num
					afte-upload-img!

		img-preview = (index,src)!->
			$ '.little_pic_li' .eq index .find('img').attr 'src', src
			$ '.little_pic_li' .eq index .addClass 'pic'
			add-img-input!
		# **********************************************************
		# ************************ todo  ***************************
		# *************** 没有菊花图，家荣那里有一种 ***************
		# **********************************************************
		show-loading = (index)!->
			console.log '正在上传'
		close-loading = !->
			console.log '关闭菊花'
		add-img-input = !->
			n = ($ '.little_pic_li' .length) - ($ '.little_pic_li.pic' .length)
			if $ '.little_pic_li' .length < 5 && n<1
				last = $ '.little_pic_li:last'
				last.clone true .removeClass 'pic change' .insertAfter last
				i = $ '.little_pic_li.pic' .length-1
				last.find '.form' .attr 'target',('res'+i)
				last.find '.iframe' .attr 'name',('res'+i)
		delete-img-input = (n)!->
			ob = $ '.little_pic_li' .eq n
			if ob.hasClass 'change'  #删除刚添加的图片（还未保存的）
				delete self.mychange[n+'']
			else
				self.mychange[n+''] = {}
				self.mychange[n+''].action = 'delete'
			ob.remove!
			n = ($ '.little_pic_li' .length) - ($ '.little_pic_li.pic' .length)
			if(n == 0)
				add-img-input!
	My-carousel = (dom)!->
		@dom = dom
		@imgs = $ dom .find '.carousel_img'
		@interval-id = ''
		self = @

		$ @dom .find '.carousel_img' .eq 0 .addClass 'active'
		$ @dom .find '.carousel_dot' .eq 0 .addClass 'active'
		_add-carousel-animation = !~>
			if @imgs.length>1
				if @interval-id != ''
					clearInterval @interval-id
				
				@interval-id = setInterval(
					!->
						_an-animation($ self.dom .find '.carousel_img.active' .index!)
					,3000)
			else
				$ @imgs .show!
		$ @dom .find '.carousel_dot' .click ->
			i = $ @ .index!
			if i - 1 < 0
				vanish = self.imgs.length-1
			else
				vanish = i-1
			_an-animation vanish
			_add-carousel-animation self.interval-id
		_an-animation =(i)!~>
			if i+1>=@imgs.length
				show=0
			else
				show=i+1
			$ @dom .find '.carousel_img' .hide!
			_my-slide @imgs[i],'0','-100%',1,0
			_my-slide @imgs[show],'100%','0',0,1
			$ @dom .find '.carousel_img.active' .removeClass 'active'
			$ @dom .find '.carousel_dot.active' .removeClass 'active'
			$ @imgs[show] .addClass 'active'
			$ @dom .find '.carousel_dot' .eq(show).addClass 'active'

		_my-slide = (ob,origin,dest,op1,op2)!->
			$ ob .stop!
			$ ob .css {'left':origin,'display':'block','opacity':op1}
			$ ob .animate {'left':dest,'opacity':op2},1000
		_add-carousel-animation!


	time-out-id = ''
	# 显示全局信息提示
	show-global-message = (str)->
		ob = $ '#global_message' 
		ob.show!
		ob.html str 
		clearTimeout time-out-id
		time-out-id := setTimeout('$("#global_message").fadeOut(300)',2000)
	_uplad-imgs = new Wrap-pics!
	wrap = new My-wrap!

# ********************************************************************************
# *********************************** 初始  **************************************
# ********************************************************************************
	_main-init =(d)!->
		$ '.info_value' .eq(0).text d.data.phone
		$ '.info_value' .eq(1).text d.data.email
		$ '.info_value' .eq(2).text d.data.dinner_name
		$ '.info_value' .eq(3).text d.data.address
		$ '.info_value' .eq(4).text d.data.contact_phone
		$ '.info_value.info_img:eq(0) img' .attr 'src',d.data.covers[0]
		for x,i in d.data.covers
			$ '#carousel .carousel_imgs' .append('<img class="carousel_img" src="'+x+'"></img>')
			$ '#carousel .carousel_dots' .append('<div class="carousel_dot"></div>')
			newPic = $ '.little_pic_li:last' .clone(true)
			newPic.find 'img' .attr 'src',x
			newPic.addClass 'pic'
			newPic.find 'form' .attr('target','res'+i)
			newPic.find 'iframe' .attr('name','res'+i)
			newPic.insertBefore($ '.little_pic_li:last' )
		if d.data.wxpay
			$ '.info_value.info_img1 img' .attr 'src',d.data.wxpay.qrurl
			for x in d.data.wxpay.printer
				$ '.wrap_printers' .eq 0 .append('<label class="printer">'+x.remark+'<input value="' + x.id + '" name="printer" type="radio"></label>')
		carousel = new My-carousel $ '#carousel'
		inputs = new My-inputs $ '.wrap:not(#wrap_pics) input' 

	if window.all-data 
		then _main-init JSON.parse window.all-data; window.all-data = null;
	else 
		window.main-init = _main-init;

