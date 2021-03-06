main-manage = let
	page = require_ = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	_coupons = []
	_length = ""
	_upsum = null
	_upnow = null
	_downsum = null
	_downnow = null
	_jumpPage = null
	_apply-dom = $ "\.apply input"
	_face-value-dom = $ "\._face-value"
	_valid-period-dom = $ "\._valid-period"
	_distribute-coupon-dom = $ "\._distribute-coupon"
	_valid-day-dom = $ "\._valid-day"
	_use-condition-dom = $ "\._use-condition"
	_max-coupon-dom = $ "\._max-coupon"
	_distribute-coupon-dom = $ "\._distribute-coupon"
	_max-own-dom = $ "\._max-own"
	_get-frequency-dom = $ "\._get-frequency"
	_multiple-use-dom = $ "\._multiple-use"
	_date-period-start-dom = $ "\._date-period-start"
	_date-period-end-dom = $ "\._date-period-end"
	_run-btn-dom = $ "\.run-btn"
	_stop-btn-dom = $ "\.stop-btn"
	_new-btn-dom = $ "\.new-btn"
	_cancel-btn-dom = $ "\.cancel-btn"
	_save-btn-dom = $ "\.save-btn"
	_run-content-dom = $ "\#run-content-field"
	_pass-content-dom = $ "\#pass-content-field"
	_confirm-btn-dom = $ "\#stop-coupon .confirm-btn"
	_confirm-cancel-btn = $ "\#stop-coupon .confirm-cancel-btn"
	_up-page-select-dom = $ '._up'
	_up-last-dom = $ "\._up .lastPage.btn"
	_up-next-dom = $ "\._up .nextPage.btn"
	_up-jump-dom = $ "\._up .jump-btn"
	_down-page-select-dom = $ '._down'
	_down-last-dom = $ "\._down .lastPage.btn"
	_down-next-dom = $ "\._down .nextPage.btn"
	_down-jump-dom = $ "\._down .jump-btn"
	_return-dom = $ "\.return-btn"
	_statistics-btn-dom = $ "\.statistics-btn"

	class Coupon
		(options)->
			deep-copy options, @
			@init!
			_coupons.push @
		init: !->

	_init-all-coupon = !->
		couponArrJSON = $('#json-field').html!
		# console.log "couponArrJSON", couponArrJSON
		_test = '{"0":[{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/2eb8f0fd16faedf3c823542e1512ffb22e0e5b73.png","fun":"7","couponid":"19","indate":"2016-06-062016-06-06"},{"quantity":"3","remain":"3","cost":"3","cost_reduce":"12","description":null,"status":"0","daily":"0","max":"2","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/f86eb3aef5c7f98b14365d559e3c4acff9ff3d92.png","fun":"3","couponid":"18","indate":"3"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"2","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/32fba3f289c338ca3d276c553aace573dad54fb1.png","fun":"7","couponid":"17","indate":"2016-06-062016-06-29"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/0a0c6242d75b3964c79125ae54584fc5941274ba.png","fun":"3","couponid":"16","indate":"2016-06-062016-06-08"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/2eb8f0fd16faedf3c823542e1512ffb22e0e5b73.png","fun":"7","couponid":"19","indate":"2016-06-062016-06-06"},{"quantity":"3","remain":"3","cost":"3","cost_reduce":"12","description":null,"status":"0","daily":"0","max":"2","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/f86eb3aef5c7f98b14365d559e3c4acff9ff3d92.png","fun":"3","couponid":"18","indate":"3"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"2","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/32fba3f289c338ca3d276c553aace573dad54fb1.png","fun":"7","couponid":"17","indate":"2016-06-062016-06-29"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/0a0c6242d75b3964c79125ae54584fc5941274ba.png","fun":"3","couponid":"16","indate":"2016-06-062016-06-08"}],"upsum":10,"upnow":1,"downsum":1}'
		all-coupons = []
		all-coupons = JSON.parse(couponArrJSON)[0]
		_upsum := JSON.parse(couponArrJSON)['upsum']
		_upnow := JSON.parse(couponArrJSON)['upnow']
		_downsum := JSON.parse(couponArrJSON)['downsum']
		_downnow := JSON.parse(couponArrJSON)['downnow']
		# console.log "all-coupons", all-coupons
		for coupon in all-coupons
			new Coupon {
				couponid 			:		coupon.couponid
				status 				:		coupon.status
				cost 				: 		coupon.cost
				cost_reduce 		:		coupon.cost_reduce
				max 				:		coupon.max
				limit 				:		coupon.limit
				max_use 			:		coupon.max_use
				indate 				:		coupon.indate
				remain				:		coupon.remain
				fun 				: 		coupon.fun
				pay 				:		coupon.pay
				quantity 			:		coupon.quantity
				url					:		coupon.url
			}

	_init-coupon-view = !->
		_length = _coupons.length
		if _upsum < 2
			_up-page-select-dom.hide!
		if _upsum == 0
			$ '\#run-coupon' .hide!
		if _downsum < 2
			_down-page-select-dom.hide!
		if _downsum == 0
			$ '\#pass-coupon' .hide!
		$("._up .page").html("#{_upnow}/#{_upsum}")
		$("._up ._jump-input").attr("max", "#{_upsum}")
		$("._down .page").html("#{_downnow}/#{_downsum}")
		$("._down ._jump-input").attr("max", "#{_downsum}")
		if _upnow > 1 then $(document).scrollTop(233)
		if _downnow > 1 then $(document).scrollTop(465)
		for i from 0 to _length-1 by 1
			_new-dom = $ "<div class='coupon' class='btn'>
							<div class='coupon-identify'>
								<span class='coupon-batch-number'></span>
								<span class='coupon-status'></span>
							</div>
							<div class='coupon-info'>
								<p class='coupon-value'></p>
								<p class='coupon-max-use'></p>
								<p class='coupon-valid-period'></p>
							</div>
						</div>"
			_new-dom.find(".coupon-batch-number").html("批次号：#{_coupons[i].couponid}")
			_new-dom.find(".coupon-max-use").html("最多可叠加使用 #{_coupons[i].max_use} 张")
			_new-dom.find(".coupon-value").html("#{_coupons[i].cost_reduce/100}元（满 #{_coupons[i].cost/100} 元可用）")
			if _coupons[i].indate.length is 20
				_new-dom.find(".coupon-valid-period").html("#{_coupons[i].indate.substr(0, 10)} 至 #{_coupons[i].indate.substr(10,20)}")
			else if _coupons[i].indate.length < 10
				_new-dom.find(".coupon-valid-period").html("领取后 #{_coupons[i].indate} 天有效，过期无效")
			if _coupons[i].status == "0"
				_new-dom.find(".coupon-status").html("发放中")
				_new-dom.find(".coupon-status").css("color","#00C049")
				_run-content-dom.last().append _new-dom
			else if _coupons[i].status == "1"
				_new-dom.find(".coupon-status").html("已过期")
				_pass-content-dom.last().append _new-dom
			else if _coupons[i].status == "2"
				_new-dom.find(".coupon-status").html("停用中")
				_new-dom.find(".coupon-status").css("color","rgb(235,79,16)")
				_run-content-dom.last().append _new-dom
			_new-dom.click !->
				_hello = 0
				for j from 0 to _length-1 by 1
					_checkid = $(@).find('.coupon-batch-number').html!
					if Number(_checkid.substr(4,20)) is Number(_coupons[j].couponid)
						if Number(_coupons[j].status) is 0
							$(".run-btn p").html("启用发放中")
							$(".stop-btn p").html("停止发放")
							$(".detailCoupon-wrapper").removeClass "stop"
							$(".detailCoupon-wrapper").removeClass "pass"
							$(".detailCoupon-wrapper").addClass "run"
						else if Number(_coupons[j].status) is 1
							$(".detailCoupon-wrapper").removeClass "run"
							$(".detailCoupon-wrapper").removeClass "stop"
							$(".detailCoupon-wrapper").addClass "pass"
						else if Number(_coupons[j].status) is 2
							$(".run-btn p").html("启用发放")
							$(".stop-btn p").html("停止发放中")
							$(".detailCoupon-wrapper").removeClass "run"
							$(".detailCoupon-wrapper").removeClass "pass"
							$(".detailCoupon-wrapper").addClass "stop"
						$("._pre-batch-number").html("#{_coupons[j].couponid}")
						$("._pre-coupon-inventory").html("#{_coupons[j].remain}")
						$("._pre-face-value").html("#{_coupons[j].cost_reduce/100}")
						if _coupons[j].indate.length is 20
							$("._pre-valid-period").html("#{_coupons[j].indate.substr(0,10)} 至 #{_coupons[j].indate.substr(10,20)}")
						else if _coupons[j].indate.length isnt 20
							$("._pre-valid-period").html("领取后 #{_coupons[j].indate} 天有效，过期无效")
						$("._pre-use-condition").html("订单额满 #{_coupons[j].cost/100} 元可使用")
						if Number(_coupons[j].pay) is 0
							$("._left-distribute-coupon").html("顾客点餐前发券")
							$("._pre-distribute-coupon").html("顾客点餐前发券")
						else if Number(_coupons[j].pay) isnt 0
							$("._left-distribute-coupon").html("顾客支付订单后发券 消费满 #{_coupons[j].pay/100} 元领券")
							$("._pre-distribute-coupon").html("顾客支付订单后发券")
						$("._pre-max-coupon").html("#{_coupons[j].quantity} 张")
						$("._pre-max-own").html("每人最多领取 #{_coupons[j].max} 张")
						$("._pre-get-frequency").html("每隔 #{_coupons[j].limit} 分钟可领取")
						_fun = []
						_func = ["堂食", "外带", "外卖", "预点"]
						_hello = parseInt(_coupons[j].fun).toString(2)
						for x from _hello.length-1 to 0 by -1
							if _hello[x] is "1"
								_fun.push _func[_hello.length-1-x]
						_fun-text = _fun.join " "
						$("._pre-apply-area").html(_fun-text)
						$("._pre-multiple-use").html("每笔订单最多同时叠加使用#{_coupons[j].max_use}张")
						$("._QRcode").attr("src", "#{_coupons[j].url}")
				page.toggle-page "detail"

	_set-coupon-run = !->
		$(".detailCoupon-wrapper").removeClass "stop"
		$(".detailCoupon-wrapper").addClass "run"
		$(".run-btn p").html("启用发放中")
		$(".stop-btn p").html("停止发放")

	_set-coupon-stop = !->
		$(".stop-confirm").fade-out 100
		$(".detailCoupon-wrapper").removeClass "run"
		$(".detailCoupon-wrapper").addClass "stop"
		$(".run-btn p").html("启用发放")
		$(".stop-btn p").html("停止发放中")

	_init-all-event = !->
		$.fn.datepicker.languages['zh-CN'] = {
			days: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
			daysShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
			daysMin: ['日', '一', '二', '三', '四', '五', '六'],
			months: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
			monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
			weekStart: 1,
			startView: 0,
			yearFirst: true,
			yearSuffix: '年'
		}
		_date-period-start-dom.datepicker {
			format: 'yyyy-mm-dd',
			autohide: 'true',
			autopick: 'true',
			language: 'zh-CN',
			trigger: $('.date-period-start')
		}
		_date-period-end-dom.datepicker {
			format: 'yyyy-mm-dd',
			startDate: new Date(),
			autohide: 'true',
			autopick: 'true',
			language: 'zh-CN',
			trigger: $('.date-period-end')
		}

		$("._up ._jump-input").keyup !->
			if event.keyCode is 13 then _up-jump-dom.trigger "click"

		$("._down ._jump-input").keyup !->
			if event.keyCode is 13 then _down-jump-dom.trigger "click"
		
		_up-last-dom.click !->
			if _upnow > 1 then _upnow--
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"
			$(document).scrollTop(233)

		_down-last-dom.click !->
			if _downnow > 1 then _downnow--
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

		_up-next-dom.click !->
			if _upnow < _upsum then _upnow++
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"
			$(document).scrollTop(233)

		_down-next-dom.click !->
			if _downnow < _downsum then _downnow++
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

		_up-jump-dom.click !->
			if $("._up ._jump-input").val() isnt ''
				if $("._up ._jump-input").val() >= 1 and $("._up ._jump-input").val() <= _upsum
					_jumpPage = $("._up ._jump-input").val!
					location.href = "/Manage/Market/Coupon/Basic?uppn=#{_jumpPage}&downpn=#{_downnow}"
				else
					alert('请输入正确页码')
			else alert('请输入正确页码')

		_down-jump-dom.click !->
			if $("._down ._jump-input").val() isnt ''
				if $("._down ._jump-input").val() >= 1 and $("._down ._jump-input").val() <= _downsum
					_jumpPage = $("._down ._jump-input").val!
					location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_jumpPage}"
				else alert('请输入正确页码')
			else alert('请输入正确页码')

		_apply-dom.click !->
			_apply = $(this).parent()
			if _apply.hasClass("true")
				_apply.removeClass "true"
				_apply.addClass "false"
			else if _apply.hasClass("false")
				_apply.removeClass "false"
				_apply.addClass "true"

		_statistics-btn-dom.click !->
			_sta-coupon-id = $("._pre-batch-number").html!
			location.href = "/Manage/Data/Analysis#" + _sta-coupon-id

		_new-btn-dom.click !->
			page.toggle-page "new"
			$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")
			$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")

		_cancel-btn-dom.click !->
			$('#btn-filed .stop-confirm').fade-in 100
			$('#btn-filed .confirm-mask').fade-in 100

		$('#btn-filed .stop-confirm .confirm-btn').click !->
			$('#btn-filed .stop-confirm').fade-out 100
			$('#btn-filed .confirm-mask').fade-out 100

		$('#btn-filed .stop-confirm .confirm-cancel-btn').click !->
			$('#btn-filed .stop-confirm').fade-out 100
			$('#btn-filed .confirm-mask').fade-out 100
			page.toggle-page "basic"


		_save-btn-dom.click !->
			d1 = new Date _date-period-start-dom.val!
			d2 = new Date _date-period-end-dom.val!
			if d1 > d2
				alert "请选择合法的日期区间"
				return
			isValid = 0
			$("._multiple-use").val(1)
			for p from 0 to 6 by 1
				if $(".check-input").eq(p).val() is '' then isValid = 1
			_init-all-blur!
			addCoupon = {}
			fun = []
			_sum = 0
			addCoupon.cost_reduce = $("._face-value").val!*100
			addCoupon.cost = $("._use-condition").val!*100
			if $("._valid-period").val! is "0"
				addCoupon.indate = _date-period-start-dom.val!
				addCoupon.indate += _date-period-end-dom.val!
			else if $("._valid-period").val! is "1"
				addCoupon.indate = $("._valid-day").val!
			if $("._fun1").is(':checked') is true
				fun.push(1)
			else if $("._fun1").is(':checked') isnt true
				fun.push(0)
			_sum += fun[0]
			if $("._fun2").is(':checked') is true
				fun.push(1)
			else if $("._fun2").is(':checked') isnt true
				fun.push(0)
			_sum += fun[1]*2
			if $("._fun3").is(':checked') is true
				fun.push(1)
			else if $("._fun3").is(':checked') isnt true
				fun.push(0)
			_sum += fun[2]*4
			if $("._fun4").is(':checked') is true
				fun.push(1)
			else if $("._fun4").is(':checked') isnt true
				fun.push(0)
			_sum += fun[3]*8
			addCoupon.fun = _sum
			addCoupon.quantity = $("._max-coupon").val!
			addCoupon.max_use = $("._multiple-use").val!
			addCoupon.max = $("._max-own").val!
			addCoupon.limit = $("._get-frequency").val!
			if $("._distribute-coupon").val! is "0"
				addCoupon.pay = $("._distribute-coupon").val!
			else if $("._distribute-coupon").val! is "1"
				addCoupon.pay = $("._meal-ticket").val!*100
			request-object = {}
			request-object = addCoupon
			if isValid is 0
				require_.get("add").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
					}
					callback 	:		(result)!-> alert('新建成功', true);setTimeout('location.reload()', 2000)
				}
				_save-btn-dom.unbind 'click'
			else if isValid is 1 
				alert('保存失败，尚有未填写项目')

		_run-btn-dom.click !->
			request-object = {}
			request-object.status = 0
			_object = {}
			_couponid = $("._pre-batch-number")html!
			request-object.couponlist = []
			_object = {"couponid": _couponid}
			request-object.couponlist.push(_object)
			require_.get("modify").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				callback    :       (result)!-> _set-coupon-run!
			}

		_stop-btn-dom.click !->
			if $(".detailCoupon-wrapper").hasClass "run"
				$(".stop-confirm").fade-in 100

		_confirm-btn-dom.click !->
			request-object = {}
			request-object.status = 2
			_couponid = $("._pre-batch-number")html!
			request-object.couponlist = []
			_object = {"couponid": _couponid}
			request-object.couponlist.push(_object)
			require_.get("modify").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				callback    :       (result)!-> _set-coupon-stop!
			}

		_confirm-cancel-btn.click !->
			$(".stop-confirm").fade-out 100

		_return-dom.click !->
			location.href = "/Manage/Market/Coupon/Basic"

	_init-all-blur = !->
		_face-value-dom.blur !->
			if $('._face-value').val() == '' or /^[0-9]+(.[0-9]{1,2})?$/.test($('._face-value').val())
				return true
			else
				$('._face-value').val('')
				alert('面值只能为数字，最多两位小数')
				return false;

		_use-condition-dom.blur !->
			if $('._use-condition').val() == '' or /^[0-9]+(.[0-9]{1,2})?$/.test($('._use-condition').val())
				return true
			else
				$('._use-condition').val('')
				alert('使用门槛只能为数字，最多两位小数')
				return false;

		_valid-day-dom.blur !->
			if $('._valid-day').val() == '' or /^[1-9]\d*$/.test($('._valid-day').val())
				return true
			else
				$('._valid-day').val('')
				alert('有效天数只能为数字')
				return false;

		_max-coupon-dom.blur !->
			if $('._max-coupon').val() == '' or /^[1-9]\d*$/.test($('._max-coupon').val())
				return true
			else
				$('._max-coupon').val('')
				alert('发放上限只能为数字')
				return false;

		_max-own-dom.blur !->
			if $('._max-own').val() == '' or /^[1-9]\d*$/.test($('._max-own').val())
				return true
			else
				$('._max-own').val('')
				alert('领取上限只能为数字')
				return false;

		_get-frequency-dom.blur !->
			if $('._get-frequency').val() == '' or /^[1-9]\d*$/.test($('._get-frequency').val())
				return true
			else
				$('._get-frequency').val('')
				alert('领取上限只能为数字')
				return false;

		_multiple-use-dom.blur !->
			if $('._multiple-use').val() == '' or /^[1-9]\d*$/.test($('._multiple-use').val())
				return true
			else
				$('._multiple-use').val('')
				alert('叠加使用只能为数字')
				return false;


	_init-all-keyup = !->
		_face-value-dom.keyup !->
			$("._pre-face-value").html($("._face-value").val!)
		_valid-period-dom.change !->
			if Number($(@).val!) is 0
				$('._valid-day').val('1')
				$('#valid-day').fade-out 100
				$('#date-period').fade-in 100
			else if Number($(@).val!) is 1
				$('._valid-day').val('')
				$('#date-period').fade-out 100
				$('#valid-day').fade-in 100
		_distribute-coupon-dom.change !->
			if Number($(@).val!) is 0
				$('._meal-ticket').val('1')
				$('#meal-ticket').fade-out 100
			else if Number($(@).val!) is 1
				$('._meal-ticket').val('')
				$('#meal-ticket').fade-in 100
		_valid-day-dom.keyup !->
			$(".valid-day-input-tip").html("领取后 #{_valid-day-dom.val!} 天有效，过期无效")
		_use-condition-dom.keyup !->
			$(".pre-condition-value").html($("._use-condition").val!)
			$(".tip-3-content").html("3. 订单消费满 ￥#{$("._use-condition").val!} 可用，最多可同时使用 #{$("._multiple-use").val!} 张。")
		_distribute-coupon-dom.change !->
			if Number($(@).val!) is 0
				console.log "11", 11
			else if Number($(@).val!) is 1
				console.log "22", 22
		reg=new RegExp("(^| )Dname=([^;]*)(;|$)")
		a1 = decodeURIComponent(document.cookie.match(reg)[2])
		$(".tip-1-content").html("1. 本券仅在："+a1+" 使用;")
		_max-own-dom.keyup !->
			$(".tip-2-content").html("2. 每个微信号限领取 #{$("._max-own").val!} 张代金券；")
		_multiple-use-dom.keyup !->
			$(".tip-3-content").html("3. 订单消费满 ￥#{$("._use-condition").val!} 可用，最多可同时使用 #{$("._multiple-use").val!} 张。")
			$(".multiple-use-tip").html("每笔订单最多可同时叠加使用#{$("._multiple-use").val!}张")
		_date-period-start-dom.change !->
			$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")
		_date-period-end-dom.change !->
			$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"

	time-out-id = ''
	# 显示全局信息提示
	show-global-message = (str)->
		ob = $ '\#global_message' 
		ob.show!
		ob.html str 
		clearTimeout time-out-id
		time-out-id := setTimeout('$("#global_message").fadeOut(300)',2000)

	initial: !->
		_init-all-coupon!
		_init-coupon-view!
		_init-depend-module!
		_init-all-event!
		_init-all-keyup!
		_init-all-blur!

 
module.exports = main-manage