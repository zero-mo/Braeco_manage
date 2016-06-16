
# ====== 控制器 ======

angular.module 'ManageMarketActivity' .controller 'activity-main', ['$rootScope', '$scope', '$location', '$resource', '$activitySM', '$http', ($rootScope, $scope, $location, $resource, $activitySM, $http)!->

  # ====== 1 $scope变量初始化 ======
  init-scope-variable = !->
    # 活动数据
    $scope.activities =
      sales: null
      themes: null

    $scope.base-image-url = 'http://static.brae.co/images/activity/'
    $scope.pre-image-url = 'http://ww4.sinaimg.cn/large/ed796d65gw1f4etfd2bn8j20e807l0tw.jpg'

    # 编辑区域数据
    $scope.editor =
      activity-name: ''
      activity-expiry-type: '0'
      activity-start-date: null
      activity-end-date: null
      activity-upload-image: null
      activity-brief: ''
      activity-content: ''

    # 设置编辑区为空的数据
    $scope.empty-activity =
      title: ''
      date_end: '0'
      date_begin: '0'
      intro: ''
      content: ''
      pic: $scope.pre-image-url


    $scope.new-activity-type = null # 新建活动的类型
    $scope.current-activity = null
    $scope.is-image-change = null # 判断编辑图片是否发生更改

  # ====== 2 $rootScope变量初始化 ======
  init-rootScope-variable = !->

  # ====== 3 $resource变量初始化 ======
  init-resource-variable = !->
    $scope.resource = {}
    $scope.resource.activities-retrieve = $resource '/Activity/Get'
    $scope.resource.activities-deleting = $resource '/Activity/Remove/:id'
    $scope.resource.activities-creating = $resource '/Activity/Add/:type'
    $scope.resource.activities-update = $resource '/Activity/Update/:id'
    $scope.resource.image-add-token = $resource '/pic/upload/token/activityadd'
    $scope.resource.image-update-token = $resource '/pic/upload/token/activityupdate/:id'
    $scope.resource.image-upload = null

  # ====== 4 页面元素初始化 ======
  init-page-dom = !->
    init-datepicker!
    init-side-menu!
    init-letter-number-limit!
    init-image-previews!

  # ====== 5 页面数据初始化 ======
  init-page-data = !->
    retrieve-activity-data!

  # ====== 6 controller初始化接口 ======
  init-activity-main = !->
    init-scope-variable!
    init-rootScope-variable!
    init-resource-variable!

    init-page-data!
    init-page-dom!

  # ====== 7 $scope事件函数定义 ======
  $scope.cancle-the-edit = (event)!->
    if confirm '放弃正在编辑的内容'
      switch $scope.new-activity-type
      | 'sales', 'theme' => set-edit-area $scope.empty-activity
      | otherwise        => set-edit-area $scope.current-activity

  $scope.delete-activity = (event)!->
    if confirm '你确定删除该活动吗'
      delete-activity-by-id $scope.current-activity.id

  $scope.edit-activity = (event)!->
    editor-data = get-editor-data!
    editor-data.id = $scope.current-activity.id

    if $scope.is-image-change is null

      update-activity-by-id editor-data
    else
      update-activity-with-image editor-data

  $scope.create-activity = (event)!->
    if $scope.is-image-change is null
      alert '请上传图片'
      return

    data = get-editor-data!

    create-activity-by-image-and-data data

  $scope.new-activity = (event, type)!->
    switch type
    | 'sales' => $scope.new-activity-type = 'sales'
    | 'theme' => $scope.new-activity-type = 'theme'

    $scope.current-activity = null

    set-timeout !->
      $ '.reduce-activities-list' .animate {scrollTop: 9999}, 1000
      $ '.activity-items li' .remove-class 'activity-item-background-color'
      $ '.new-sale-activity' .add-class 'activity-item-background-color'

      set-edit-area $scope.empty-activity
    , 0

  $scope.set-current-activity = (event)!->
    $scope.current-activity = @activity
    $scope.new-activity-type = null

    $ '.activity-items li' .remove-class 'activity-item-background-color'
    $ event.current-target .add-class 'activity-item-background-color'

    set-edit-area @activity

  $scope.upload-canteen-photo = (event)!->
    alert '这部分内容还没有完成，还在写呢~'

  # ====== 8 工具函数定义 ======
  init-datepicker = !->
    $('[data-toggle="datepicker"]').datepicker {language: 'zh-CN', autohide: true}

    $ '#activity-start-date' .change !->
      $ '#activity-end-date' .datepicker 'setStartDate', @value

    $ '#activity-start-date' .on 'keydown' (event)->
      false
    $ '#activity-end-date' .on 'keydown' (event)->
      false

  init-side-menu = !->
    $("\#Activity-sub-menu").add-class "choose"

  init-editor = !->
    select-activity = null

    if $scope.activities.sales.length > 0
      select-activity = $scope.activities.sales[0]

      set-timeout !->
        $($ '.reduce-activities-list li' .0) .add-class 'activity-item-background-color'
      , 100

    else if $scope.activities.themes.length > 0
      select-activity = $scope.activities.themes[0]

      set-timeout !->
        $($ '.theme-activities-list li' .0) .add-class 'activity-item-background-color'
      , 100

    if select-activity
      set-edit-area select-activity
      $scope.current-activity = select-activity
    else
      set-edit-area $scope.empty-activity
      $scope.new-activity-type = 'sales'

  init-scope-activities = (results)!->
    $scope.activities.sales = []
    $scope.activities.themes = []

    results.for-each (item)!->
      if item.type is 'theme'
        $scope.activities.themes.push item
      else
        $scope.activities.sales.push item

  init-letter-number-limit = !->
    elements = [
      {input: '#activity-name', num: 10, letter-number: '.activity-name .letter-number'},
      {input: '#activity-brief', num: 40, letter-number: '.activity-brief .letter-number'},
      {input: '#activity-content', num: 200, letter-number: '.activity-content .letter-number'}
    ]

    elements.for-each (item)!->
      $ item.input .on 'input', (event)->
        total = get-total-num-length-of-cn-and-en-text @value
        $ item.letter-number .text total + ' / ' + item.num

      $ item.input .on 'change', (event)->
        total = get-total-num-length-of-cn-and-en-text @value
        if total > item.num
          cliped-text = get-cliped-text(@value, item.num)
          $ item.input .val cliped-text
          $ item.letter-number .text get-total-num-length-of-cn-and-en-text(cliped-text) + ' / ' + item.num

  init-image-previews = !->
    input-and-previews = [
      {input: '\#activity-upload-image', preview: '\#activity-image-preview'}
    ]

    input-and-previews.for-each (item)!->
      set-image-preview item.input, item.preview

  # 统计中英文字符个数
  get-total-num-length-of-cn-and-en-text = (str)->
    chineses = str.match(/[\u4E00-\u9FA5\uF900-\uFA2D]/g)
    cn-len = if chineses then chineses.length else 0
    other-len = str.length - cn-len
    total = cnLen * 2 + other-len
    total

  get-cliped-text = (text, num)->
    cliped-text = ''
    cliped-text-num = 0
    for i from 0 to num - 1
      if text[i].match(/[\u4E00-\u9FA5\uF900-\uFA2D]/g)
        cliped-text-num += 2
      else
        cliped-text-num += 1
      if cliped-text-num > num
        return cliped-text
      else
        cliped-text += text[i]
    cliped-text

  get-editor-data = ->
    data =
      title: $ '#activity-name' .val!
      intro: $ '#activity-brief' .val!
      content: $ '#activity-content' .val!
      type: $scope.new-activity-type

    if parse-int($scope.expiry-date) is 0
      data.date_begin = 0
      data.date_end = 0
    else
      data.date_begin = parse-int((new Date($ '#activity-start-date' .datepicker 'getDate')).value-of! / 1000)
      data.date_end = parse-int((new Date($ '#activity-end-date' .datepicker 'getDate')).value-of! / 1000)

    data

  get-base64-str = ->
    base64-src = $ '#activity-image-preview' .attr 'src'
    base64-src = base64-src .substr base64-src.indexOf(';base64,') + 8
    base64-src

  # 设置字数统计标签的值
  set-letter-number-label = (title, intro, content)!->
    $ '.activity-name .letter-number' .text get-total-num-length-of-cn-and-en-text(title) + ' / 10'
    $ '.activity-brief .letter-number' .text get-total-num-length-of-cn-and-en-text(intro) + ' / 40'
    $ '.activity-content .letter-number' .text get-total-num-length-of-cn-and-en-text(content) + ' / 200'

  # 设置编辑区的值
  set-edit-area = (activity)!->
    $ '#activity-name' .val activity.title
    $ '#activity-brief' .val activity.intro
    $ '#activity-content' .val activity.content

    if activity.title is '' then $scope.editor.activity-name = ''
    if activity.intro is '' then $scope.editor.activity-brief = ''

    if activity.pic.index-of('http://') is -1
      $ '#activity-image-preview' .attr 'src', $scope.base-image-url + activity.pic
    else
      $ '#activity-image-preview' .attr 'src', activity.pic

    $scope.is-image-change = null

    set-date-input-area activity.date_begin, activity.date_end
    set-letter-number-label activity.title, activity.intro, activity.content

  set-date-input-area = (date-begin, date-end)!->
    if parse-int(date-begin) is 0 and parse-int(date-end) is 0
      $scope.editor.activityExpiryType = '0'
      $ '#activity-start-date' .val ''
      $ '#activity-end-date' .val ''
    else
      $scope.editor.activityExpiryType = '1'
      $ '#activity-start-date' .datepicker 'setDate', new Date(parse-int(date-begin + '000'))
      $ '#activity-end-date' .datepicker 'setDate', new Date(parse-int(date-end + '000'))

  # 活动图片上传预览初始化
  set-image-preview = (input, image)->
    $ input .change !->
      $scope.is-image-change = true
      read-url @, image

    read-url = (input, image)!->
      if input.files && input.files[0]
        reader = new FileReader!
        reader.onload = (e)->
          $ image .attr 'src', e.target.result .css 'background-color', 'white'

        reader.readAsDataURL input.files[0]

  # ====== 9 数据访问函数 ======

  # Activity CRUD 数据操作

  # 取得Activity数据
  retrieve-activity-data = !->
    $activitySM.go-to-state ['\#activity-main', '\#activity-spinner']

    result = $scope.resource.activities-retrieve.save {}, {}, !->
      init-scope-activities result.data
      init-editor!
      $activitySM.go-to-state ['\#activity-main']

  # 通过Id删除activity
  delete-activity-by-id = (id)!->
    $activitySM.go-to-state ['\#activity-main', '\#activity-spinner']

    result = $scope.resource.activities-deleting.save {id: id}, {}, !->

      if result.message is 'success'
        alert '活动删除成功'
        retrieve-activity-data!
      else
        alert '活动删除失败'
        $activitySM.go-to-state ['\#activity-main']

  # 新建活动：1 先取服务器token和key，2 再通过token和key把图片上传到七牛云服务器，3 最后新建活动本身
  create-activity-by-image-and-data = (data)!->
    $activitySM.go-to-state ['\#activity-main', '\#activity-spinner']
    result = $scope.resource.image-add-token.save {}, !->
      if result.message is 'success'
        upload-image-to-qiniu result.token, result.key, data, create-activity-by-data
      else
        alert '图片上传失败，活动创建失败'
        $activitySM.go-to-state ['\#activity-main']

  upload-image-to-qiniu = (token, key, data, callback)!->
    base64-src = get-base64-str!

    fsize = -1
    key = btoa(key).replace("+", "-").replace("/", "_")
    url = "http://up.qiniu.com/putb64/#{fsize}/key/#{key}"

    req =
      method: 'POST'
      url: url
      headers:
        "Content-Type": "application/octet-stream"
        "Authorization": "UpToken #{token}"
      data: base64-src

    success = (response)!->
      console.log '图片成功上传到七牛服务器'
      callback? data

    error = (response)!->
      alert '图片上传失败，活动创建失败'
      $activitySM.go-to-state ['\#activity-main']

    $http req .then success, error

  create-activity-by-data = (data)!->
    result = $scope.resource.activities-creating.save {type: data.type}, data, !->
      if result.message is 'success'
        alert '活动创建成功'
        retrieve-activity-data!
        $scope.new-activity-type = null
        init-editor!
      else
        alert '活动创建失败'
        $activitySM.go-to-state ['\#activity-main']

  update-activity-by-id = (data)!->
    $activitySM.go-to-state ['\#activity-main', '\#activity-spinner']
    result = $scope.resource.activities-update.save {id: data.id}, data, !->
      if result.message is 'success'
        alert '活动修改成功'
        retrieve-activity-data!
      else
        alert '活动修改失败'
        $activitySM.go-to-state ['\#activity-main']

  update-activity-with-image = (data)!->
    $activitySM.go-to-state ['\#activity-main', '\#activity-spinner']
    base64-src = get-base64-str!

    result = $scope.resource.image-update-token.save {id: data.id}, {}, !->
      if result.message is 'success'
        upload-image-to-qiniu result.token, result.key, data, update-activity-by-id
      else
        alert '活动修改失败'
        $activitySM.go-to-state ['\#activity-main']

  # ====== 10 初始化函数执行 ======

  init-activity-main!

]