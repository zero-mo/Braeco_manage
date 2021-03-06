main = null
page = null
edit-manage = let

    _full-cover-dom = $ "\#full-cover"
    
    _full-cover-close-btn-dom = $ "\#full-cover .close-btn"
    _full-cover-cancel-btn-dom = $ "\#full-cover .cancel-btn"
    _full-cover-save-btn-dom = $ "\#full-cover .save-btn"
    _full-cover-password-input-dom = $ "\#full-cover input[name='password']"
    _full-cover-comfirm-password-input-dom = $ "\#full-cover input[name='comfirm-password']"

    _edited-staff = null
    _all-roles = null
    _new-password = null
    
    _manage-permission-btn-dom = $ "\#staff-account-edit .manage-permission-btn"
    
    _cancel-btn-dom = $ "\#staff-account-edit .cancel-btn"
    _save-btn-dom = $ "\#staff-account-edit .save-btn"
    
    _name-input-dom = $ "\#staff-account-edit input[name='name']"
    _gender-select-dom = $ "\#staff-account-edit select[name='gender']"
    _phone-input-dom = $ "\#staff-account-edit input[name='phone']"
    _reset-password-btn-dom = $ "\#staff-account-edit button.reset-password-btn"
    _role-select-dom = $ "\#staff-account-edit select[name='role']"

    _error-message-block-dom = $ "\#staff-account-edit .error-message-block"
    
    _reset-password-btn-click-event = !->
        _full-cover-dom.fade-in 100
        
    _full-cover-close-btn-click-event = !->
        _full-cover-password-input-dom.val ""
        _full-cover-comfirm-password-input-dom.val ""
        _full-cover-dom.fade-out 100
    
    _full-cover-cancel-btn-click-event = !->
        _full-cover-password-input-dom.val ""
        _full-cover-comfirm-password-input-dom.val ""
        _full-cover-dom.fade-out 100
    
    _full-cover-save-btn-click-event = !->
        password = _full-cover-password-input-dom.val!
        comfirm-password = _full-cover-comfirm-password-input-dom.val!
        re = /^[\w]{6,16}$/
        if password === ''
            alert "请输入密码"
        else if (re.test password) === false
            alert "请输入6至12位由数字和字母组成的密码"
        else if comfirm-password === ''
            alert '请确认密码'
        else if password !== comfirm-password
            alert "两次输入的密码不一致"
        else if password === comfirm-password
            _new-password := password
            _full-cover-password-input-dom.val ""
            _full-cover-comfirm-password-input-dom.val ""
            _full-cover-dom.fade-out 100
    
    _manage-permission-btn-click-event = !->
        current-url = location.href
        sub-current-url = current-url.substr 0,current-url.lastIndexOf '/'
        target-url = sub-current-url+'/Role'
        win = window.open(target-url, '_blank')
        win.focus!
    
    _cancel-btn-click-event = !->
        _reset-dom!
        page.toggle-page "main"
        
    _save-btn-click-event = !->
        name = _name-input-dom.val!
        gender = _gender-select-dom.val!
        phone = _phone-input-dom.val!
        role = parse-int _role-select-dom.val!
        if _check-input-field!
            if gender === 'male'
                gender := "男"
            else
                gender := "女"
            data = {
                "phone": phone,
                "name": name,
                "role": role,
                "sex": gender
            }
            if _new-password !== null and _new-password !== ''
                data.password = _new-password
            data = JSON.stringify data
            $.ajax {type: "POST", url: "/Waiter/update/"+_edited-staff.id, data: data,\
                    dataType: "JSON", contentType: "application/json", success: _save-post-success, error: _save-post-fail}
            _set-save-btn-disable!
        # page.toggle-page "main"
    
    _check-input-field = ->
        error-message = []
        name = _name-input-dom.val!
        gender = _gender-select-dom.val!
        phone = _phone-input-dom.val!
        role = _role-select-dom.val!
        if name === ''
            alert "请输入姓名"
            return false
        if phone === ''
            alert "请输入电话号码"
            return false
        if phone !== ''
            re = /(^(13\d|15[^4,\D]|17[13678]|18\d)\d{8}|170[^346,\D]\d{7})$/
            if not re.test(phone)
                alert "电话号码格式不正确"
                return false
        if role === 'default'
            alert "请选择角色"
            return false
        return true

    _display-error-message = (error-message)!->
        _error-message-block-dom.show!
        _error-message-block-dom.empty!
        for err in error-message
            _error-message-block-dom.append "<p>"+err+"</p>"

    _save-post-success = (data)!->
        _set-save-btn-able!
        if data.message === 'success'
            location.reload!
        else if data.message === 'Waiter role not found'
            alert "未找到该角色"
        else if data.message === 'User not found'
            alert "该店员不存在"
        else if data.message === 'Is not waiter of current dinner'
            alert "该店员并不是当前餐厅的店员"
        else
            alert "添加失败"

    _save-post-fail = (data)!->
        _set-save-btn-able!
        alert "请求修改店员失败"

    _set-save-btn-disable = !->
        _save-btn-dom.prop "disabled",true
        _save-btn-dom.add-class "save-btn-disable"

    _set-save-btn-able = !->
        _save-btn-dom.prop "disabled",false
        _save-btn-dom.remove-class "save-btn-disable"

    _reset-dom = !->
        _name-input-dom.val ""
        _gender-select-dom.val ""
        _phone-input-dom.val ""
        _role-select-dom.empty!.append $ "<option value='default'>请选择角色</option>"
        _error-message-block-dom.empty!.hide!

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _manage-permission-btn-dom.click !-> _manage-permission-btn-click-event!
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _reset-password-btn-dom.click !-> _reset-password-btn-click-event!
        _full-cover-close-btn-dom.click !-> _full-cover-close-btn-click-event!
        _full-cover-cancel-btn-dom.click !-> _full-cover-cancel-btn-click-event!
        _full-cover-save-btn-dom.click !-> _full-cover-save-btn-click-event!
        
    _init-role-select-dom = !->
        for role in _all-roles
            _role-select-dom.append $ "<option value='"+role.id+"''>"+role.name+"</option>"
    
    _init-form-field = !->
        _name-input-dom.val _edited-staff.name
        selected = ($ _gender-select-dom.find "option").filter ->
            if ($ this).text! === _edited-staff.gender
                true
            else
                false
        ($ selected).prop 'selected',true
        _phone-input-dom.val _edited-staff.phone
        selected = ($ _role-select-dom.find "option").filter ->
            if ($ this).val! === _edited-staff.role.id.to-string!
                true
            else
                false
        ($ selected).prop "selected",true

    get-staff-and-init: (staff, roles) !->
        _all-roles := roles
        _edited-staff := staff
        _init-role-select-dom!
        _init-form-field!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = edit-manage