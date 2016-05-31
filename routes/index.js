'use strict';

var express = require('express');
var app = express();
var router = express.Router();
var renew = require('../renew');

module.exports = function(passport) {

	router.get('/', function(req, res) {
		res.redirect('/Manage/Config');
	});

	router.get('/Manage/Config', function(req, res) {
		res.render('./CanteenManage/develop');
	});

	router.get('/Manage/Menu/Category', function(req, res) {
		res.render('./CanteenManageMenu/Category/develop');
	});

	router.get('/Manage/Menu/Food', function(req, res) {
		res.render('./CanteenManageMenu/Food/develop');
	});

	router.get('/Manage/Menu/Food/Single', function(req, res) {
		res.render('./CanteenManageMenu/Food/Single/develop');
	});

	router.get('/Manage/Menu/Food/Property', function(req, res) {
		res.render('./CanteenManageMenu/Food/Property/develop');
	});

	router.get('/Manage/Menu/Food/Shelves', function(req, res) {
		res.render('./CanteenManageMenu/Food/Shelves/develop');
	});

	// router.get('/Manage/Market/Activity', function(req, res) {
	// 	res.render('./CanteenManageMarket/Activity/develop');
	// });

	router.get('/Manage/Market/Member/Recharge', function(req, res) {
		res.render('./CanteenManageMarket/Member/Recharge/develop');
	});

	router.get('/Manage/Market/Member/Level', function(req, res) {
		res.render('./CanteenManageMarket/Member/Level/develop');
	});

	router.get('/Manage/Market/Member/List', function(req, res) {
		res.render('./CanteenManageMarket/Member/List/develop');
	});

	router.get('/Manage/Market/Promotion/Single', function(req, res) {
		res.render('./CanteenManageMarket/Promotion/Single/develop');
	});

	router.get('/Manage/Business/HallOrder/Basic', function(req, res) {
		res.render('./CanteenManageBusiness/HallOrder/Basic/develop');
	});

	router.get('/Manage/Data/Statistics', function(req, res) {
		res.render('./CanteenManageData/develop');
	});

	router.get('/renew', function(req, res) {
		renew.renew(res);
	});

	router.get('/Manage/Menu/Food/Data', function(req, res) {
		setTimeout(function() {
			res.send("var allData = '"+'{"message":"success","data":{"categories":[{"dishes":[{"id":545,"name":"\u7ea2\u8336","name2":"milk tea","tag":null,"like":0,"dc_type":"sale","dc":1,"groups":[1,6],"pic":null,"detail":"\u5475\u5475\u5475","able":true,"default_price":12},{"id":558,"name":"sadsad","name2":"dadqw","tag":"\u5916\u5e26","like":0,"dc_type":"limit","dc":12,"groups":[1,6],"pic":"http:\/\/static.brae.co\/images\/dish\/cebc23ztvsqtwb7nv449b4inwuc8ex2q","detail":"\u554a\u662f\u7684\u7eef\u95fb\u554a\u5e08\u5085\u989d\u6211\u53d1","able":true,"default_price":12},{"id":561,"name":"\u963f\u65af\u8fbe","name2":"12","tag":"\u662f\u7684","like":0,"dc_type":"sale","dc":2,"groups":[1,6],"pic":null,"detail":"\u5b89\u9632","able":true,"default_price":12}],"id":236,"name":"\u6d4b\u8bd51","pic":"http:\/\/static.brae.co\/images\/category\/gaddhhtxi80tnnabfnl9fzxby7w6s299"},{"dishes":[{"id":559,"name":"\u5496\u5561","name2":"coffee","tag":"\u6d4b\u8bd5","like":0,"dc_type":"none","dc":null,"groups":[],"pic":null,"detail":"\u5566\u5566\u5566\u5566\u5566\u5566","able":true,"default_price":10},{"id":560,"name":"\u5976\u8336","name2":"milk tea","tag":null,"like":0,"dc_type":"none","dc":null,"groups":[],"pic":null,"detail":"\u5475\u5475\u5475","able":true,"default_price":12}],"id":264,"name":"asd","pic":"http:\/\/static.brae.co\/images\/category\/2z4h1xfwspa57r1xwx8vq07mrcbsjvwm"}],"groups":[{"id":1,"name":"\u6e29\u5ea6","belong_to":[545,558,561],"type":"property","content":[{"name":"\u51b7","price":0},{"name":"\u51b0","price":1.5},{"name":"\u70ed","price":2}]},{"id":3,"name":"\u65e9\u9910\u996e\u54c1","belong_to":[],"type":"discount_combo","require":1,"discount":5000,"content":[]},{"id":5,"name":"\u5348\u9910\u996e\u54c1","belong_to":[],"type":"static_combo","require":1,"price":20,"content":[]},{"id":6,"name":"\u5305\u88c5","belong_to":[545,558,561],"type":"property","content":[{"name":"\u5802\u98df","price":0},{"name":"\u5916\u5e26","price":1}]}]}}'+"';"+
			"if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;allData = null;}");
		}, 0);
	});

	router.get('/Manage/Business/HallOrder/Basic/Data', function(req, res) {
		setTimeout(function() {
			res.send("var allData = '"+'{"message":"success","data":{"dish":[{"dishes":[],"categoryid":234,"categoryname":"a","categorypic":"http:\/\/static.brae.co\/images\/category\/8hicrfu2qp8areusucya3ruu322sskn0"},{"dishes":[{"groups":[],"dishid":535,"dishname":"\u5957\u99102","dishname2":"name2","dishpic":null,"defaultprice":2147,"tag":null,"like":0,"detail":null,"dc_type":"combo_sum","able":true,"combo":[{"discount":40,"require":2,"name":"\u7ec4a","content":[517,518,519]},{"discount":60,"require":1,"name":"\u7ec4b","content":[522,524,526,527,502]},{"discount":80,"require":0,"name":"abc","content":[510,511,521,531]}]},{"groups":[{"groupname":"\u5c5e\u6027\u7ec41","property":[{"name":"45","price":3},{"name":"4","price":6},{"name":"222","price":5},{"name":"asd","price":23},{"name":"\u963f\u65af\u987f\u62c9\u79d1\u6280","price":3},{"name":"\u65b9\u6cd5","price":34},{"name":"\u5341\u4e09\u4e2a\u662f\u7684\u8d76","price":3},{"name":"\u5b89\u9759\u591a\u4e86\u5c81\u6570\u5927\u4e86","price":4},{"name":"\u5723\u8bde\u5feb\u4e50\u526f\u4e66\u8bb0\u7684\u798f\u5229","price":6},{"name":"\u963f\u65af\u5229\u5eb7\u5927\u5bb6\u554a\u5584\u826f\u7684","price":5}]},{"groupname":"\u5c5e\u6027\u7ec42","property":[{"name":"\u54c8\u54c8","price":2},{"name":"\u5565\u6765\u5f97\u53ca","price":2}]},{"groupname":"\u5c5e\u6027\u7ec43","property":[{"name":"\u4f60\u624d\u64e6","price":23},{"name":"\u6211\u54e6","price":3}]},{"groupname":"\u5c5e\u6027\u7ec44","property":[{"name":"\u6492\u65e6","price":4},{"name":"\u548c\u6cd5\u56fd\u548c\u6cd5\u56fd","price":5}]},{"groupname":"\u5c5e\u6027\u7ec45","property":[{"name":"\u963f\u8428\u8fbe\u662f","price":3},{"name":"\u7684\u98ce\u683c\u7684\u5b64\u72ec\u611f","price":5}]},{"groupname":"\u5c5e\u6027\u7ec46","property":[{"name":"\u963f\u5927\u58f0\u9053","price":3},{"name":"\u6062\u590d\u548c\u6cd5\u56fd\u548c","price":4}]},{"groupname":"\u5c5e\u6027\u7ec47","property":[{"name":"\u98ce\u683c\u7684\u98ce\u683c\u7684\u98ce\u683c","price":3},{"name":"\u6c34\u7535\u8d39\u723d\u80a4\u6c34","price":66},{"name":"\u6cd5\u56fd\u6062\u590d\u540e\u53d1\u8d27","price":4}]},{"groupname":"\u5c5e\u6027\u7ec48","property":[{"name":"\u963f\u6492\u5927\u58f0\u5730","price":66},{"name":"\u963f\u65af\u987f\u6492\u6253\u7b97\u6253\u7b97","price":5}]},{"groupname":"\u5c5e\u6027\u7ec49","property":[{"name":"\u548c\u6cd5\u56fd\u548c\u6cd5\u56fd\u548c","price":45}]},{"groupname":"\u5c5e\u6027\u7ec410","property":[{"name":"\u54c8\u54c8\u54c8","price":52},{"name":"\u5361\u89c6\u89d2\u7684","price":345},{"name":"\u963f\u91cc\u662f\u770b\u5f97\u89c1\u963f\u91cc\u770b","price":4}]},{"groupname":"\u5c5e\u6027\u7ec411","property":[{"name":"\u4f60\u731c\u731c","price":4},{"name":"\u963f\u65af\u8fbe","price":4}]}],"dishid":528,"dishname":"3","dishname2":"yingyingying","dishpic":"http:\/\/static.brae.co\/images\/dish\/6tck2d0imvvgpvh1sxb7fzhobi8qzdt5","defaultprice":0.01,"tag":null,"like":0,"detail":"\u8d39\u7389\u6e05 \u563f\u563f\u563f","dc_type":"discount","dc":80,"able":true},{"groups":[{"groupname":"\u5c5e\u6027\u7ec41","property":[{"name":"1","price":1},{"name":"2","price":2}]},{"groupname":"\u5c5e\u6027\u7ec42","property":[{"name":"33","price":33}]}],"dishid":502,"dishname":"\u86cb\u7cd5\u86cb\u7cd5\u86cb\u7cd5","dishname2":"4","dishpic":"http:\/\/static.brae.co\/images\/dish\/ktkmkmdyw759m4xqwwegqn6b2kvvagdv","defaultprice":6666,"tag":"1221","like":0,"detail":"\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a","dc_type":"half","able":true},{"groups":[],"dishid":526,"dishname":"2(aa)\uff08bb\uff09","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/uo9mq4iynxx9f77vu5h6fwj129euty0n","defaultprice":2,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":527,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/85jhyfsteveqm66ax6sqm4ixzonis5l1","defaultprice":2,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[{"groupname":"\u5c5e\u6027\u7ec41","property":[{"name":"1","price":3}]}],"dishid":501,"dishname":"haha","dishname2":"sad","dishpic":"http:\/\/static.brae.co\/images\/dish\/76q9jqs6lnmai3bb1nihmz6yiepirjoy","defaultprice":23,"tag":null,"like":0,"detail":null,"dc_type":"limit","dc_num":1,"able":true,"dc":1},{"groups":[],"dishid":510,"dishname":"1","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/dz7eh22mpd8h6x8kj8huxn0an1m66gej","defaultprice":1,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":511,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/88zlxj9m0tm9nsnur1afqxqu2jz5q08z","defaultprice":2,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":512,"dishname":"3","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/x7juhxm6n0hckbtetc4ovvwayw4axmhu","defaultprice":3,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":513,"dishname":"213","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/o461mhjcu5ul6cug45dnvdrqxs70dca2","defaultprice":123,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":517,"dishname":"3","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/ps3nq2dh4dmhdpbjrnj96flngco8xjgm","defaultprice":3,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":518,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/bja2mokr178fwkzn8iwexi2euqnsa3em","defaultprice":2,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":519,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/z17xdpjophj09t5d7yegoona34t53602","defaultprice":2,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":521,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/npo9e80fg9uctt01cxgafio98b1jfg52","defaultprice":2,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":522,"dishname":"233","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/iq1omei4v9plfxkrvqqih8lryfwfogv7","defaultprice":3,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":524,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/81o8y3jdjlhuuqkkeyi4sxyplrc2ov9w","defaultprice":22,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":530,"dishname":"22","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/wx5v1p8lapf5gzpuy7zq5ygrqstfo3bl","defaultprice":22,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true}],"categoryid":214,"categoryname":"\u5662\u54c8\u554a\u597d\u54c8\u563f\u563f","categorypic":"http:\/\/static.brae.co\/images\/category\/lodkbx7vqwkiymwqf5x7nzecuc1u2sgo"},{"dishes":[{"groups":[],"dishid":531,"dishname":"123","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/uuzlh870r8aye5y288vegxoitq9jj18e","defaultprice":213,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":529,"dishname":"4","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/maadesb1q9b5gi1aojh3g05iajd4her3","defaultprice":4,"tag":null,"like":0,"detail":null,"dc_type":"none","able":false}],"categoryid":215,"categoryname":"\u5496\u5561","categorypic":"http:\/\/static.brae.co\/images\/category\/avemumn6pgi8nev4ozr7mshivk9zo23z"},{"dishes":[{"groups":[],"dishid":503,"dishname":"222","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/12q49zfdkr17tmliggoupvbn8rdlpzir","defaultprice":2,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true},{"groups":[],"dishid":504,"dishname":"111","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/elrvazq4qvqnzjaa65ucjdedgwph9gxo","defaultprice":1,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true}],"categoryid":216,"categoryname":"\u86cb\u7cd5","categorypic":"http:\/\/static.brae.co\/images\/category\/1ljfqmfl28fzfyi4ckf6bhdn2yqbn1to"},{"dishes":[{"groups":[],"dishid":534,"dishname":"name","dishname2":"name2","dishpic":null,"defaultprice":12,"tag":null,"like":0,"detail":null,"dc_type":"combo_static","able":true,"combo":[{"require":2,"name":"\u7ec4a","content":[517,518,519,502]},{"require":1,"name":"\u7ec4b","content":[522,524,526,527]}]},{"groups":[],"dishid":536,"dishname":"haha","dishname2":"hehe","dishpic":null,"defaultprice":15,"tag":null,"like":0,"detail":null,"dc_type":"none","able":true}],"categoryid":217,"categoryname":"\u5976\u8336","categorypic":"http:\/\/static.brae.co\/images\/category\/mnw6fnwsish5ogkz2bimxqgeq5rznmla"}]}}'+"';"+
			"if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;allData = null;}");
		}, 0);
	});

	// router.get('/Manage/Market/Activity/Data', function(req, res) {
	// 	setTimeout(function() {
	// 		res.send("var allData = '"+'{"message":"success","data":[{"id":1,"title":"圣诞狂欢1","intro":"\\u5723\\u8bde\\u8282\\u5feb\\u5230\\u5566\\uff0c\\u6709\\u6ca1\\u6709\\u51c6\\u5907\\u597d\\u793c\\u7269\\u5462~","content":"merry christmas ~","pic":"http://ww3.sinaimg.cn/large/ed796d65gw1f4de17pytwj205k02zt8v.jpg","date_begin":"2015-12-24","date_end":"2015-12-25","type":"theme"},{"id":2,"title":"圣诞狂欢2","intro":"\\u5723\\u8bde\\u8282\\u5feb\\u5230\\u5566\\uff0c\\u6709\\u6ca1\\u6709\\u51c6\\u5907\\u597d\\u793c\\u7269\\u5462~","content":"merry christmas ~","pic":"http://ww3.sinaimg.cn/large/ed796d65gw1f4de17pytwj205k02zt8v.jpg","date_begin":"2015-12-24","date_end":"2015-12-25","type":"theme"},{"id":3,"title":"圣诞狂欢3","intro":"\\u5723\\u8bde\\u8282\\u5feb\\u5230\\u5566\\uff0c\\u6709\\u6ca1\\u6709\\u51c6\\u5907\\u597d\\u793c\\u7269\\u5462~","content":"merry christmas ~","pic":"http://ww3.sinaimg.cn/large/ed796d65gw1f4de17pytwj205k02zt8v.jpg","date_begin":"2015-12-24","date_end":"2015-12-25","type":"theme"},{"id":4,"title":"圣诞狂欢4","intro":"\\u5723\\u8bde\\u8282\\u5feb\\u5230\\u5566\\uff0c\\u6709\\u6ca1\\u6709\\u51c6\\u5907\\u597d\\u793c\\u7269\\u5462~","content":"merry christmas ~","pic":"http://ww3.sinaimg.cn/large/ed796d65gw1f4de17pytwj205k02zt8v.jpg","date_begin":"2015-12-24","date_end":"2015-12-25","type":"reduce"}]}'+"';"+
	// 		"if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;allData = null;}");
	// 	}, 0);
	// });

	router.post('/Category/Add', function(req, res) {
	    res.json({
	        message 	: 		"success" 	,
	        id 			: 		Number(Math.floor(100000 + Math.random() * 100000))
	    });
	});

	router.post('/Category/Remove', function(req, res) {
	    res.json({
	        message: "success"
	    });
	});

	router.post('/Category/Update/Profile', function(req, res) {
	    res.json({
	        message: "success"
	    });
	});


	router.post('/Category/Update/Top/:id', function(req, res) {
	    res.json({
	        message: 	"success"
	    });
	});

	router.post('/pic/upload/token/category/:id', function(req, res) {
	    res.json({
	        message 	: 		"success"	,
	        key 		: 		100 		,
	        token 		: 		"heihei"
	    });
	});

	router.post('/Dish/Add/:categoryId', function(req, res) {
		res.json({
	        message 	: 		"success"	,
	        id 			: 		Number(Math.floor(100000 + Math.random() * 100000))
	    });
	});

	router.post('/Dish/Remove', function(req, res) {
		res.json({
	        message 	: 		"success"
	    });
	});

	router.post('/Dish/Copy', function(req, res) {
		var _getNewDishIdMap = function(currentDishId) {
			var newDishIdMap = {};
			for (var id in currentDishId) {
				if (currentDishId.hasOwnProperty(id)) {
					newDishIdMap[id] = Number(Math.floor(100000 + Math.random() * 100000));
				}
			}
			return newDishIdMap;
		}
		var newDishIdMap = _getNewDishIdMap(req.body);
		res.json({
			message 	: 		"success",
			result 		: 		newDishIdMap
		});
	});

	router.post('/Dish/Update/Top', function(req, res) {
		res.json({
			message 	: 		"success"
		});
	});

	router.post('/Dish/Update/Category', function(req, res) {
		res.json({
			message 	: 		"success"
		});
	});

	router.post('/Dish/Update/All/:dishId', function(req, res) {
		res.json({
			message 	: 		"success"
		});
	});

	router.post('/Dish/Update/Able/:flag', function(req, res) {
		res.json({
			message 	: 		"success"
		});
	});

	router.post('/pic/upload/token/dishupdate/:dishId', function(req, res) {
		res.json({
	        message 	: 		"success"	,
	        key 		: 		100 		,
	        token 		: 		"heihei"
	    });
	});

	return router;
};
