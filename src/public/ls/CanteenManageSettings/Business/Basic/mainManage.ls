page = null
edit = null
main-manage = let
    
    _all-business = null
    _eatin-data = null
    _takeout-data = null
    _takeaway-data = null
    _reserve-data = null
    _url = null

    _method-map = {
        "p2p_wx_pub": "微信支付",
        "cash": "现金支付"
    }
    _date-map = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']

    # common
    _copy-to-clipboard = (text)!->
        hidden-textarea = $ "<textarea></textarea>"
        hidden-textarea.val text
        $ 'body' .append hidden-textarea
        hidden-textarea.select!
        try
            successful = document.execCommand 'copy'
            msg = successful ? 'successful' : 'unsuccessful'
            console.log 'Copying text command was ' + msg
            alert "复制成功",true
        catch error
            console.log 'Unable to copy'
        hidden-textarea.remove!

    _download-qrcode = (business-type, qrcode-src)!->
        a = $ "<a></a>" .attr "href", qrcode-src .attr "download", business-type+".png" .attr "target","_blank" .appendTo "body"
        a[0].click!
        a.remove!

    _tran-time-num-to-arr = (time-num)->
        time-array = []
        time-string = time-num.toString 2
        len = time-string.length
        is-zero = true
        for i from len-1 to 0 by -1
            if (time-string[i] == '1')
                if (is-zero == true)
                    time-array.push len-1-i
                if i == 0
                    time-array.push len-1-i
                else if (i - 1 >= 0) and (time-string[i-1] == '0')
                    time-array.push len-1-i
                is-zero = false
            if (time-string[i] == '0')
                is-zero = true
        time-array

    _tran-time-num-to-strings = (time-num)->
        string-arr = []
        time-array = _tran-time-num-to-arr(time-num)
        len = time-array.length
        if len % 2 == 1
            return
        for i from 0 to len-1 by 2
            string-arr.push _tran-time-num-to-string time-array[i]
            string-arr.push _tran-time-num-to-string time-array[i+1]+1
        string-arr

    _tran-time-num-to-string = (num)->
        t = parse-int num / 2
        if t < 10
            hour = '0' + t.toString!
        else
            hour = t.toString!
        if (num % 2) == 0
            minu = '00'
        else
            minu = '30'
        return hour + ' : ' + minu

    _gene-time-content = (business-type, time-num)!->
        time-strings = _tran-time-num-to-strings time-num
        business-time-content-dom = $ "\#"+business-type+"-time-content"
        len = time-strings.length
        for i from 0 to len-1 by 2
            business-time-content-dom.append $ "<div class='business-time-period'>" + time-strings[i]\
                + " 至 " + time-strings[i+1] + "</div>"

    _set-stopping-status = (start-btn, stop-btn, click-event)!->
        start-btn.remove-class "business-start-btn-able"
        start-btn.add-class "business-start-btn-disable"
        start-btn.text "启用业务"
        start-btn.click click-event
        stop-btn.remove-class "business-stop-btn-able"
        stop-btn.add-class "business-stop-btn-disable"
        stop-btn.text "业务停用中"
        stop-btn.unbind "click"

    _set-starting-status = (start-btn, stop-btn, click-event)!->
        start-btn.remove-class "business-start-btn-disable"
        start-btn.add-class "business-start-btn-able"
        start-btn.text "业务启用中"
        start-btn.unbind "click"
        stop-btn.remove-class "business-stop-btn-disable"
        stop-btn.add-class "business-stop-btn-able"
        stop-btn.text "停止业务"
        stop-btn.click click-event

    _set-business-method-content-dom = (business-type, business-method)!->
        business-method-content-dom = $ "\#"+business-type+"-method-content"
        method-strings = []
        for method, value of business-method
            if value == 1
                method-strings.push _method-map[method]
        business-method-content-dom.text (method-strings.join '、')

    _set-business-date-content-dom = (business-type, business-date)!->
        business-date-content-dom = $ "\#"+business-type+"-date-content"
        date-strings = []
        for i from 1 to 6
            value = Math.pow(2, i)
            if (value .&. business-date) == value
                date-strings.push _date-map[i]
        if (Math.pow(2, 0) .&. business-date) == 1
            date-strings.push _date-map[0]
        business-date-content-dom.text (date-strings.join '、')

    _business-turn-on = (business-type, alert-block-dom)!->
        $.ajax {type: "POST", url: "/Dinner/Manage/Firm/Turn/"+business-type+"/On",\
            dataType: "JSON", contentType: "application/json", success: _business-turn-success, error: _business-trun-fail}
        alert-block-dom.hide!

    _business-turn-off = (business-type, alert-block-dom)!->
        $.ajax {type: "POST", url: "/Dinner/Manage/Firm/Turn/"+business-type+"/Off",\
            dataType: "JSON", contentType: "application/json", success: _business-turn-success, error: _business-trun-fail}
        alert-block-dom.hide!
    
    _business-turn-success = (data)!->
        location.reload!

    _business-trun-fail = (error)!->
        alert "请求失败"
        set-timeout (!-> location.reload), 1000
    # common finish

    # eatin
    _eatin-start-btn-dom = $ "\#eatin-start-btn"
    _eatin-stop-btn-dom = $ "\#eatin-stop-btn"
    _eatin-start-alert-block-dom = $ "\#eatin-start-alert-block"
    _eatin-start-commfirm-btn-dom = $ "\#eatin-start-comfirm-btn"
    _eatin-start-cancel-btn-dom = $ "\#eatin-start-cancel-btn"
    _eatin-stop-alert-block-dom = $ "\#eatin-stop-alert-block"
    _eatin-stop-comfirm-btn-dom = $ "\#eatin-stop-comfirm-btn"
    _eatin-stop-cancel-btn-dom = $ "\#eatin-stop-cancel-btn"
    _eatin-edit-btn-dom = $ "\#eatin-edit-btn"
    _eatin-business-block-dom = $ "\#eatin-business-block"

    _init-eatin = !->
        _init-eatin-status!
        _set-business-date-content-dom _eatin-data.type, _eatin-data.able_peroid_week
        _set-business-method-content-dom _eatin-data.type, _eatin-data.channels
        # console.log _eatin-data.able_peroid_day.toString(2)
        # console.log _tran-time-num-to-strings _eatin-data.able_peroid_day
        _gene-time-content _eatin-data.type,_eatin-data.able_peroid_day

    _init-eatin-status = !->
        if _eatin-data.able
            _set-starting-status _eatin-start-btn-dom,_eatin-stop-btn-dom, _eatin-stop-btn-click-event
        else
            _eatin-business-block-dom.add-class "disable-business-block"
            _set-stopping-status _eatin-start-btn-dom,_eatin-stop-btn-dom, _eatin-start-btn-click-event

    _eatin-start-btn-click-event = !->
        _eatin-start-alert-block-dom.show!

    _eatin-start-comfirm-btn-click-event = !->
        _business-turn-on _eatin-data.type, _eatin-stop-alert-block-dom

    _eatin-start-cancel-btn-click-event = !->
        _eatin-start-alert-block-dom.hide!

    _eatin-stop-btn-click-event = !->
        _eatin-stop-alert-block-dom.show!

    _eatin-stop-comfirm-btn-click-event = !->
        _business-turn-off _eatin-data.type, _eatin-stop-alert-block-dom

    _eatin-stop-cancel-btn-click-event = !->
        _eatin-stop-alert-block-dom.hide!

    _eatin-edit-btn-click-event = !->
        edit.get-business-and-init _eatin-data,_url
        page.toggle-page 'edit'

    _init-eatin-event = !->
        _init-eatin!
        _eatin-start-commfirm-btn-dom.click !-> _eatin-start-comfirm-btn-click-event!
        _eatin-start-cancel-btn-dom.click !-> _eatin-start-cancel-btn-click-event!
        _eatin-stop-comfirm-btn-dom.click !-> _eatin-stop-comfirm-btn-click-event!
        _eatin-stop-cancel-btn-dom.click !-> _eatin-stop-cancel-btn-click-event!
        _eatin-edit-btn-dom.click !-> _eatin-edit-btn-click-event!
    # eatin finish

    # takeaway
    _takeaway-start-btn-dom = $ "\#takeaway-start-btn"
    _takeaway-stop-btn-dom = $ "\#takeaway-stop-btn"
    _takeaway-start-alert-block-dom = $ "\#takeaway-start-alert-block"
    _takeaway-start-comfirm-btn-dom = $ "\#takeaway-start-comfirm-btn"
    _takeaway-start-cancel-btn-dom = $ "\#takeaway-start-cancel-btn"
    _takeaway-stop-alert-block-dom = $ "\#takeaway-stop-alert-block"
    _takeaway-stop-comfirm-btn-dom = $ "\#takeaway-stop-comfirm-btn"
    _takeaway-stop-cancel-btn-dom = $ "\#takeaway-stop-cancel-btn"
    _takeaway-edit-btn-dom = $ "\#takeaway-edit-btn"
    _takeaway-content-qrcode-dom = $ "\#takeaway-content-qrcode"
    _takeaway-download-dom = $ "\#takeaway-download-btn"
    _takeaway-content-link-dom = $ "\#takeaway-content-link"
    _takeaway-copy-btn-dom = $ "\#takeaway-copy-btn"
    _takeaway-business-block-dom = $ "\#takeaway-business-block"

    _init-takeaway = !->
        _init-takeaway-status!
        _set-business-method-content-dom _takeaway-data.type, _takeaway-data.channels
        _set-business-date-content-dom _takeaway-data.type, _takeaway-data.able_peroid_week
        _takeaway-content-qrcode-dom.attr "src",_takeaway-data.qr
        _takeaway-content-link-dom.text _takeaway-data.url
        _gene-time-content _takeaway-data.type,_takeaway-data.able_peroid_day

    _init-takeaway-status = !->
        if _takeaway-data.able
            _set-starting-status _takeaway-start-btn-dom,_takeaway-stop-btn-dom, _takeaway-stop-btn-click-event
        else
            _takeaway-business-block-dom.add-class "disable-business-block"
            _set-stopping-status _takeaway-start-btn-dom,_takeaway-stop-btn-dom, _takeaway-start-btn-click-event

    _takeaway-start-btn-click-event = !->
        _business-turn-on _takeaway-data.type

    _takeaway-start-btn-click-event = !->
        _takeaway-start-alert-block-dom.show!

    _takeaway-start-comfirm-btn-click-event = !->
        _business-turn-on _takeaway-data.type, _takeaway-start-alert-block-dom

    _takeaway-start-cancel-btn-click-event = !->
        _takeaway-start-alert-block-dom.hide!

    _takeaway-stop-btn-click-event = !->
        _takeaway-stop-alert-block-dom.show!

    _takeaway-stop-comfirm-btn-click-event = !->
        _business-turn-off _takeaway-data.type, _takeaway-stop-alert-block-dom

    _takeaway-stop-cancel-btn-click-event = !->
        _takeaway-stop-alert-block-dom.hide!

    _takeaway-edit-btn-click-event = !->
        edit.get-business-and-init _takeaway-data, _url
        page.toggle-page 'edit'

    _takeaway-copy-btn-click-event = !->
        _copy-to-clipboard _takeaway-content-link-dom.text!

    _takeaway-download-btn-click-event = !->
        _download-qrcode _takeaway-data.type, _takeaway-data.qr

    _init-takeaway-event = !->
        _init-takeaway!
        _takeaway-start-comfirm-btn-dom.click !-> _takeaway-start-comfirm-btn-click-event!
        _takeaway-start-cancel-btn-dom.click !-> _takeaway-start-cancel-btn-click-event!
        _takeaway-stop-comfirm-btn-dom.click !-> _takeaway-stop-comfirm-btn-click-event!
        _takeaway-stop-cancel-btn-dom.click !-> _takeaway-stop-cancel-btn-click-event!
        _takeaway-edit-btn-dom.click !-> _takeaway-edit-btn-click-event!
        _takeaway-copy-btn-dom.click !-> _takeaway-copy-btn-click-event!
        _takeaway-download-dom.click !-> _takeaway-download-btn-click-event!
    # takeaway finish

    # takeout
    _takeout-start-btn-dom = $ "\#takeout-start-btn"
    _takeout-stop-btn-dom = $ "\#takeout-stop-btn"
    _takeout-start-alert-block-dom = $ "\#takeout-start-alert-block"
    _takeout-start-comfirm-btn-dom = $ "\#takeout-start-comfirm-btn"
    _takeout-start-cancel-btn-dom = $ "\#takeout-start-cancel-btn"
    _takeout-stop-alert-block-dom = $ "\#takeout-stop-alert-block"
    _takeout-stop-comfirm-btn-dom = $ "\#takeout-stop-comfirm-btn"
    _takeout-stop-cancel-btn-dom = $ "\#takeout-stop-cancel-btn"
    _takeout-edit-btn-dom = $ "\#takeout-edit-btn"
    _takeout-content-qrcode-dom = $ "\#takeout-content-qrcode"
    _takeout-download-dom = $ "\#takeout-download-btn"
    _takeout-content-link-dom = $ "\#takeout-content-link"
    _takeout-copy-btn-dom = $ "\#takeout-copy-btn"
    _takeout-business-block-dom = $ "\#takeout-business-block"

    _init-takeout = !->
        _init-takeout-status!
        _set-business-date-content-dom _takeout-data.type, _takeout-data.able_peroid_week
        _set-business-method-content-dom _takeout-data.type, _takeout-data.channels
        _takeout-content-qrcode-dom.attr "src",_takeout-data.qr
        _takeout-content-link-dom.text _takeout-data.url
        _gene-time-content _takeout-data.type,_takeout-data.able_peroid_day

    _init-takeout-status = !->
        if _takeout-data.able
            _set-starting-status _takeout-start-btn-dom,_takeout-stop-btn-dom, _takeout-stop-btn-click-event
        else
            _takeout-business-block-dom.add-class "disable-business-block"
            _set-stopping-status _takeout-start-btn-dom,_takeout-stop-btn-dom, _takeout-start-btn-click-event

    _takeout-start-btn-click-event = !->
        _business-turn-on _takeout-data.type

    _takeout-start-btn-click-event = !->
        _takeout-start-alert-block-dom.show!

    _takeout-start-comfirm-btn-click-event = !->
        _business-turn-on _takeout-data.type, _takeout-start-alert-block-dom

    _takeout-start-cancel-btn-click-event = !->
        _takeout-start-alert-block-dom.hide!

    _takeout-stop-btn-click-event = !->
        _takeout-stop-alert-block-dom.show!

    _takeout-stop-comfirm-btn-click-event = !->
        _business-turn-off _takeout-data.type, _takeout-stop-alert-block-dom

    _takeout-stop-cancel-btn-click-event = !->
        _takeout-stop-alert-block-dom.hide!

    _takeout-edit-btn-click-event = !->
        edit.get-business-and-init _takeout-data,_url
        page.toggle-page 'edit'

    _takeout-copy-btn-click-event = !->
        _copy-to-clipboard _takeout-content-link-dom.text!

    _takeout-download-btn-click-event = !->
        _download-qrcode _takeout-data.type, _takeout-data.qr

    _init-takeout-event = !->
        _init-takeout!
        _takeout-start-comfirm-btn-dom.click !-> _takeout-start-comfirm-btn-click-event!
        _takeout-start-cancel-btn-dom.click !-> _takeout-start-cancel-btn-click-event!
        _takeout-stop-comfirm-btn-dom.click !-> _takeout-stop-comfirm-btn-click-event!
        _takeout-stop-cancel-btn-dom.click !-> _takeout-stop-cancel-btn-click-event!
        _takeout-edit-btn-dom.click !-> _takeout-edit-btn-click-event!
        _takeout-copy-btn-dom.click !-> _takeout-copy-btn-click-event!
        _takeout-download-dom.click !-> _takeout-download-btn-click-event!
    # takeout finish

    _init-data = (_get-business-JSON)!->
        _all-business := JSON.parse _get-business-JSON!
        for data in _all-business
            if data.type == 'eatin'
                _eatin-data := data
            if data.type == 'takeout'
                _takeout-data := data
            if data.type == 'takeaway'
                _takeaway-data := data
                delete _takeaway-data.channels['cash']
            if data.type == 'reserve'
                _reserve-data := data

    _init-depend-module = !->
        page := require "./pageManage.js"
        edit := require "./editManage.js"

    _init-all-event = !->
        _init-eatin-event!
        _init-takeaway-event!
        _init-takeout-event!

    initial: (_get-business-JSON, url)!->
        _init-data _get-business-JSON
        _url := url
        _init-depend-module!
        _init-all-event!

module.exports = main-manage
