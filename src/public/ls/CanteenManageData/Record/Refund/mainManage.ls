main-manage = let
    [deep-copy]    =    [util.deep-copy]

    _json-refund-data-dom = $ "\#json-refund-data"
    _json-page-data-dom = $ "\#json-page-data"

    _start-datepicker-dom = $ '\#record-refund-main .start-datepicker-field'
    _end-datepicker-dom = $ '\#record-refund-main .end-datepicker-field'
    _start-date-input-dom = $ '\#record-refund-main .start-date'
    _end-date-input-dom = $ '\#record-refund-main .end-date'
    _search-btn-dom = $ "\#record-refund-main .search-btn"
    _export-form-dom = $ "\#record-refund-main \#export-form"
    _export-form-st-dom = $ "\#record-refund-main \#export-form-st"
    _export-form-en-dom = $ "\#record-refund-main \#export-form-en"
    _export-btn-dom = $ "\#record-refund-main .export-btn"

    _pre-page-url-dom = $ ".rr-container-paginate .pre-page-url"
    _current-page-dom = $ ".rr-container-paginate .current-page"
    _total-page-dom = $ ".rr-container-paginate .total-page"
    _next-page-url-dom = $ ".rr-container-paginate .next-page-url"
    _target-page-input-dom = $ ".rr-container-paginate .target-page-input"
    _jump-btn-dom = $ ".rr-container-paginate .jump-btn"

    _table-body-dom = $ ".rr-container-table > tbody"

    _page-data-obj = null

    _is-one-pinned = false

    _int-to-string =(number)->
        if number >= 10
            number.to-string!
        else
            "0"+number.to-string!

    _unix-timestamp-to-date = (timestamp)->
        d = new Date timestamp*1000
        year = d.get-full-year!.to-string!
        month = _int-to-string d.get-month!+1
        date = _int-to-string d.get-date!
        hour = _int-to-string d.get-hours!
        minute = _int-to-string d.get-minutes!
        second = _int-to-string d.get-seconds!
        year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second
    
    _unix-timestamp-to-only-date = (timestamp)->
        d = new Date timestamp*1000
        year = d.get-full-year!.to-string!
        month = _int-to-string d.get-month!+1
        date = _int-to-string d.get-date!
        year+"-"+month+"-"+date

    _unix-timestamp-to-only-time = (timestamp)->
        d = new Date timestamp*1000
        hour = _int-to-string d.get-hours!
        minute = _int-to-string d.get-minutes!
        second = _int-to-string d.get-seconds!
        hour+":"+minute+":"+second

    _date-to-unix-timestamp = (date)->
        date.get-time! / 1000

    _construct-url = (st,en,pn,type)->
        if st === null
            st = ''
        if en === null
            en = ''
        "/Manage/Data/Record/Refund?st="+st+"&en="+en+"&pn="+pn

    _search-btn-click-event = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = 1
        location.href = _construct-url st,en,pn

    _export-btn-click-event = (event)!->
        st = _page-data-obj.st
        en = _page-data-obj.en
        if st === null
            st = _page-data-obj.today
        else
            st = _page-data-obj.st
        if en === null
            en = _page-data-obj.today + 24*3600-1
        else
            en = _page-data-obj.en
        _export-form-st-dom.val st
        _export-form-en-dom.val en
        if st > en
            event.prevent-default!
            alert "结束日期不能小于开始日期"

    _jump-btn-click-event = !->
        st = _page-data-obj.old-st
        en = _page-data-obj.old-en
        pn = parse-int _target-page-input-dom.val!
        location.href = _construct-url st,en,pn

    _start-date-input-dom-change-event = !->
        start-date = _start-date-input-dom.val!
        _page-data-obj.st = _date-to-unix-timestamp new Date start-date
        _page-data-obj.st = _page-data-obj.st-8*3600
    
    _end-date-input-dom-change-event = !->
        end-date = _end-date-input-dom.val!
        _page-data-obj.en = _date-to-unix-timestamp new Date end-date
        _page-data-obj.en = _page-data-obj.en-8*3600+24*3600-1

    _tr-hover-event = (event) !->
        if _is-one-pinned
            return
        target = $ event.target
        while not target.is('tr')
            target = $ target.parent!
        td-water-number = target.find '.td-water-number'
        order-details-container = td-water-number.find '.order-details-container'
        order-details-container.show!
    
    _tr-leave-event = (event) !->
        if _is-one-pinned
            return
        target = $ event.target
        while not target.is('tr')
            target = $ target.parent!
        td-water-number = target.find '.td-water-number'
        order-details-container = td-water-number.find '.order-details-container'
        order-details-container.hide!

    _gene-order-details-container =(data-obj)->
        container-dom = $ "<div class='order-details-container'></div>"
        if data-obj.serial === '推送失败'
            order-details-header-dom = $ "<div class='order-details-header order-details-header-image'><p>"+"接单失败"+
            "</p></div>"
        else
            order-details-header-dom = $ "<div class='order-details-header order-details-header-image'><p>"+data-obj.serial+
            "</p></div>"
        pin-icon-dom = "<icon class='pin-icon unpinned-icon'></icon>"
        order-details-header-dom.append pin-icon-dom
        container-dom.append order-details-header-dom
        order-details-body-dom = $ "<div class='order-details-body'></div>"
        order-details-body-dom.append $ "<p class='order-pay-method'>"+data-obj.channel+"</p>"
        if data-obj.type == "堂食" or data-obj.type == '外带'
            if data-obj.table != null
                order-details-body-dom.append $ "<p class='order-table'>"+data-obj.table+"号桌</p>"
       
        infomation-dom = $ "<div class='order-infomation info-number'></div>"
        if data-obj.eaterid_of_dinner === null
            infomation-dom.append $ "<span>会员编号： </span><span>"+'-'+"</span>"
        else
            infomation-dom.append $ "<span>会员编号： </span><span>"+data-obj.eaterid_of_dinner+"</span>"
        order-details-body-dom.append infomation-dom
        
        if data-obj.phone !== '-'
            infomation-dom = $ "<div class='order-infomation info-phone'></div>"
            infomation-dom.append $ "<span>手机号码： </span><span>"+data-obj.phone+"</span>"
            order-details-body-dom.append infomation-dom
        
        infomation-dom = $ "<div class='order-infomation info-order-pay-time'></div>"
        unix-timestamp = parse-int data-obj.create_date
        date = _unix-timestamp-to-date unix-timestamp
        infomation-dom.append $ "<span>成交时间： </span><span>"+date+"</span>"
        order-details-body-dom.append infomation-dom
        
        infomation-dom = $ "<div class='order-infomation info-order-number'></div>"
        infomation-dom.append $ "<span>订单号： </span>"
        infomation-dom.append $ "<span>"+data-obj.id+"</span>"
        order-details-body-dom.append infomation-dom

        if data-obj.describtion !== null
            infomation-dom = $ "<div class='order-infomation'></div>"
            infomation-dom.append $ "<span>备注： </span>"
            infomation-dom.append $ "<span>"+data-obj.describtion+"</span>"
            order-details-body-dom.append infomation-dom

        order-details-body-dom.append _gene-food-block-dom data-obj.content

        order-details-body-dom.append _gene-promotion-block-dom data-obj.content
       
        order-details-body-dom.append _gene-sum-block-dom data-obj.content, data-obj.price

        container-dom.append order-details-body-dom
        container-dom.click (event)!-> _order-details-container-click-event event
        container-dom

    _gene-food-block-dom = (content-obj) ->
        food-block-dom = $ "<div class='details-block'></div>"
        food-block-dom.append "<p>------------------ 餐品 -------------------</p>"
        food-block-dom.append _gene-order-food-table content-obj
        $ food-block-dom

    _gene-promotion-block-dom = (content-obj) ->
        promotion-block-dom = $ "<div class='details-block'></div>"
        first-promition = true
        for single-promotion in content-obj
            if single-promotion.cat === 0
                if first-promition
                    promotion-block-dom.append $ "<p>------------------ 优惠 -------------------</p>"
                    first-promition = false
                promotion-block-dom.append $ "<span class='left-span'>"+single-promotion.name+"</span>"
                promotion-block-dom.append $ "<span class='right-span'>"+single-promotion.property[0]+"</span>"
                promotion-block-dom.append "<div class='clear'></div>"
        $ promotion-block-dom

    _gene-sum-block-dom = (content-obj, price) ->
       sum-block-dom = $ "<div class='details-block'></div>"
       sum-block-dom.append "<p>------------------ 总计 -------------------</p>"
       sum = _get-food-number-sum content-obj
       sum-block-dom.append "<span class='left-span'>餐品数："+sum.to-string!+"</span>"
       sum-block-dom.append "<span class='right-span'>总价："+price+"</span>"
       sum-block-dom.append "<div class='clear'></div>"
       $ sum-block-dom

    _gene-order-food-table = (content-obj) ->
        table-dom = $ "<table class='order-food-table'></table>"
        table-dom.append $ "<thead>
        <tr>
        <td class='table-cat-col'>项目</td>
        <td class='table-num-col'>数量</td>
        <td class='table-pri-col'>单价（元）</td>
        </tr>
        </thead>"
        table-body-dom = $ "<tbody></tbody>"
        current-cat = 0
        for single-food in content-obj
            if single-food.cat === 0
                continue
            if current-cat !== 0 and current-cat !== single-food.cat
                table-body-dom.append "<tr><td colspan='3'>-----------------------------------------</td></tr>"
            current-cat := single-food.cat
            table-body-dom.append _gene-food-table-row single-food
        table-dom.append table-body-dom
        $ table-dom

    _gene-food-table-row = (single-food) ->
        row-dom = $ "<tr></tr>"
        if single-food.type === 0
            td-name = $ "<td class='table-cat-col'>"+single-food.name+"</td>"
            if single-food.property.length > 0
                td-name.append $ "<span class='sub-food-item'>"+'（'+(single-food.property.join '、')+"）"+"</span>"
            row-dom.append td-name
        if single-food.type === 1
            td-name = $ "<td class='table-cat-col'>"+single-food.name+"</td>"
            for food in single-food.property
                if food instanceof Array and food.length === 1 and food[0].name === '属性'
                    td-name.append $ "<span class='sub-food-item'>"+'（'+(food[0].p.join '、')+"）"+"</span>"
            for food in single-food.property
                if food instanceof Array
                    if food.length === 1 and food[0].name === '属性'
                        continue
                    for food-item in food
                        if food-item.p.length === 0
                            td-name.append $ "<div class='sub-food-item'>"+food-item.name+"</div>"
                        else
                            td-name.append $ "<div class='sub-food-item'>"+food-item.name+"<span>"+'（'+(food-item.p.join '、')+"）"+"</span>"+"</div>"
                            
            row-dom.append td-name
        row-dom.append "<td class='table-num-col'>"+single-food.sum+"</td>"
        row-dom.append "<td class='table-pri-col'>"+single-food.price+"</td>"
        $ row-dom

    _get-food-number-sum = (content-obj) ->
        sum = 0
        for single-food in content-obj
            if single-food.cat === 0
                continue
            sum += single-food.sum
        sum

    _tr-click-event = (event) !->
        if _is-one-pinned
            return
        target = $ event.target
        while not target.is 'tr'
            target = $ target.parent!
        td-water-number = target.find '.td-water-number'
        container-dom = td-water-number.find '.order-details-container'
        icon = container-dom.find ".order-details-header .pin-icon"
        icon.remove-class 'unpinned-icon'
        icon.add-class 'pinned-icon'
        _is-one-pinned := true
        container-dom.attr "id","pinned-order-container"
        event.stop-propagation!

    _order-details-container-click-event = (event)!->
        # target = $ event.target
        # while not target.has-class 'order-details-container'
        #     target = $ target.parent!
        # container-dom = target
        # target = $ event.target
        # if target.is "icon" and target.has-class "pin-icon"
        #     if _is-one-pinned
        #         target.remove-class 'pinned-icon'
        #         target.add-class 'unpinned-icon'
        #         container-dom.remove-attr 'id'
        #         _is-one-pinned := false
        #         return
        # icon = container-dom.find ".order-details-header .pin-icon"
        # icon.remove-class 'unpinned-icon'
        # icon.add-class 'pinned-icon'
        # _is-one-pinned := true
        # container-dom.attr "id","pinned-order-container"

    _html-click-event = (event)!->
        if _is-one-pinned === false
            return
        target = $ event.target
        is-outside = true
        while (not target.is 'html') and _is-one-pinned
            if (target.attr 'id') === 'pinned-order-container'
                is-outside := false
            target = target.parent!
        if is-outside
            pinned-container-dom = $ "\#pinned-order-container"
            icon = pinned-container-dom.find ".order-details-header .pin-icon"
            icon.remove-class 'pinned-icon'
            icon.add-class 'unpinned-icon'
            pinned-container-dom.hide!
            _is-one-pinned := false
            pinned-container-dom.remove-attr "id"
            target = $ event.target
            while not target.is 'html'
                if target.is 'tr' and target.parent!.is 'tbody'
                    target.trigger 'mouseenter'
                    break
                target = target.parent!
        else
            target = $ event.target
            while not target.has-class 'order-details-container'
                target = $ target.parent!
            container-dom = target
            target = $ event.target
            if target.is "icon" and target.has-class "pin-icon"
                target.remove-class 'pinned-icon'
                target.add-class 'unpinned-icon'
                _is-one-pinned := false
                container-dom.remove-attr 'id'

    class Refund
        (refund) ->
            deep-copy refund, @
            @gene-tr-dom!

        unix-timestamp-to-date: (timestamp)->
            d = new Date timestamp*1000
            year = d.get-full-year!.to-string!
            month = _int-to-string d.get-month!+1
            date = _int-to-string d.get-date!
            hour = _int-to-string d.get-hours!
            minute = _int-to-string d.get-minutes!
            second = _int-to-string d.get-seconds!
            year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second

        gene-tr-dom: !->
            tr-dom = $ "<tr></tr>"
            tr-dom.hover ((event)!-> _tr-hover-event event), ((event)!-> _tr-leave-event event)
            tr-dom.click (event)!-> _tr-click-event event
            date-string = _unix-timestamp-to-only-date @.start_time
            time-string = _unix-timestamp-to-only-time @.start_time
            tr-dom.append $ "<td><div>"+date-string+"</div><div>"+time-string+"</div></td>"

            td-water-number-dom = $ "<td class='td-water-number'></td>"
            td-water-number-dom.append $ "<p>"+@.order+"</p>"
            td-water-number-dom.append $ _gene-order-details-container @.order_detail
            tr-dom.append td-water-number-dom

            tr-dom.append @gene-refund-items-dom!
            tr-dom.append $ "<td>"+@.amount+"</td>"
            td-dom = $ "<td></td>"
            channel-p-dom = $ "<p>"+@.channel+"</p>"
            status-p-dom = $ "<p>"+@.status+"</p>"
            if @.status === '退款成功'
                status-p-dom.add-class "status-content-green"
            else if @.status === '退款中'
                status-p-dom.add-class "status-content-yellow"
            else if @.status === '退款失败'
                status-p-dom.add-class "status-content-red"
            td-dom.append channel-p-dom
            td-dom.append status-p-dom
            tr-dom.append td-dom
            tr-dom.append $ "<td>"+@.description+"</td>"
            _table-body-dom.append tr-dom

        gene-refund-items-dom: ->
            td-dom = $ "<td class='refund-items'></td>"
            for content in @.content
                refund-item-dom = $ "<div class='refund-item'></div>"
                refund-item-dom.append $ "<span class='refund-item-name'>"+content.name+"</span>"
                refund-item-dom.append $ "<span class='refund-item-sum'> × "+content.sum+"</span>"
                td-dom.append refund-item-dom
            td-dom

    _gene-data = !->
        _refund-data-obj-array = $.parseJSON _json-refund-data-dom.text!
        _page-data-obj := $.parseJSON _json-page-data-dom.text!
        for refund in _refund-data-obj-array
            refund_ = new Refund refund

    _init-datepicker = !->
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
        _start-date-input-dom.datepicker {format: 'yyyy-mm-dd', language: 'zh-CN', autohide: true, trigger: _start-datepicker-dom}
        _end-date-input-dom.datepicker {format: 'yyyy-mm-dd', language: 'zh-CN', autohide: true, trigger: _end-datepicker-dom}

    _init-page-info = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = parse-int _page-data-obj.pn
        
        if en !== null
            en := en + 24*3600-1
            _page-data-obj.en = en
        _page-data-obj.old-en = _page-data-obj.en
        _page-data-obj.old-st = _page-data-obj.st
        if st !== null
            _start-date-input-dom.val _unix-timestamp-to-only-date st
        if en !== null
            _end-date-input-dom.val _unix-timestamp-to-only-date en

        _current-page-dom.text pn.to-string!
        _total-page-dom.text _page-data-obj.sum_pages.to-string!
        _target-page-input-dom.val pn
        if pn > 1
            pre-pn = pn-1
        else
            pre-pn = pn
        _pre-page-url-dom.attr 'href', _construct-url _page-data-obj.st,_page-data-obj.en,pre-pn
        if pn < _page-data-obj.sum_pages
            next-pn = pn+1
        else
            next-pn = pn
        _next-page-url-dom.attr 'href', _construct-url _page-data-obj.st,_page-data-obj.en,next-pn

    _init-all-event = !->
        _search-btn-dom.click !-> _search-btn-click-event!
        _export-btn-dom.click (event)!-> _export-btn-click-event event
        _jump-btn-dom.click !-> _jump-btn-click-event!
        _start-date-input-dom.change !-> _start-date-input-dom-change-event!
        _end-date-input-dom.change !-> _end-date-input-dom-change-event!
        ($ "html").click (event)!-> _html-click-event event

    initial: !->
        _gene-data!
        _init-datepicker!
        _init-all-event!
        _init-page-info!

module.exports = main-manage