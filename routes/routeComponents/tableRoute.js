'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.get("/Manage/Settings/Business/Table/Data", getCallbackHandleForRequest("GET"));

  return router;
};
