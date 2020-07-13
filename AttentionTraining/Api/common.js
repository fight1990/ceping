var config = require("../config.js")

function getOpenId() {
  // 
  var that = this
  wx.login({
    success: function (res) {
      if (res.code) {
        var obj = {}
        // var appid = "wxeb2d317a282841f1"        //这里是我的appid，需要改成你自己的
        // var secret = "30698ad49b237a7897d393a51a61dcf9"    //密钥也要改成你自己的
        // var openid = ""
        // var l = 'https://api.weixin.qq.com/sns/jscode2session?appid=' + appid + '&secret=' + secret + '&js_code=' + res.code + '&grant_type=authorization_code';
        wx.request({
          url: config.getOpenId,
          data: {
            code: res.code
          },
          method: 'GET',
          success: function (res) {
            console.log("取得的openid==" + res.data.openid)
            wx.getUserInfo({
              success: function (response) {
                obj = response.userInfo
                obj.openid = res.data.openid
                wx.setStorage({
                  key: 'userInfo',
                  data: obj,
                })
              }
            });
          }
        });
      } else {
        console.log('获取用户登录态失败！' + res.errMsg)
      }
    }
  })
}

/**
 * 小程序短信验证接口
 * 手机号码	String	Phone
 * 姓名	string	name
 * 性别	String	Sex
 * 年龄	String	age
 */
function wechatPhone(params) {
  wx.request({
    url: config.wechatPhone,
    data: params.data,
    method: 'GET',
    header: {
      'content-type': 'application/json' // 默认值
    },
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}

/**
 * 小程序得到验证码登录接口
 * 手机号码	String	Phone
 * 验证码	String	verification
 * 用户唯一标示	String	openid	暂时不传
 */
function wechatLogin(params) {
  wx.request({
    url: config.wechatLogin,
    data: params.data,
    method: 'GET',
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}

/**
 * 小程序游戏保存接口
 * 用户id	string	Userid
 * 游戏等级	String	level
 * 得分	String	score
 * 消费时间	String	times
 */
function saveWechatGames(params) {
  wx.request({
    url: config.saveWechatGames,
    data: params.data,
    method: 'GET',
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}

/**
 * 小程序获取报告进入系统时登录页面左上角
 * openid
 */
function checkBaogao(params) {
  wx.request({
    url: config.checkBaogao,
    data: params.data,
    method: 'GET',
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}
/**
 * 小程序展示报告
 * openid
 * gameid
 */
function zhanShiBaogao(params) {
  wx.request({
    url: config.zhanShiBaogao,
    data: params.data,
    method: 'GET',
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}

/**
 * 小程序意见反馈
 * openid
 * advice
 */
function weChatAdvice (params) {
  wx.request({
    url: config.weChatAdvice,
    data: params.data,
    method: 'GET',
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}
/**
 * 小程序直接登录第二次
 */
function goToWeChat(params) {
  wx.request({
    url: config.goToWeChat,
    data: params.data,
    method: 'GET',
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}

/**
 * // 小程序分享获取游戏信息
 * 
 */
function shareGetGames(params) {
  wx.request({
    url: config.shareGetGames,
    data: params.data,
    method: 'GET',
    success: function (res) {
      params.success(res.data)
    },
    fail: function (res) {
      params.fail(res.data)
    }
  })
}

module.exports = {
  saveWechatGames: saveWechatGames,
  wechatLogin: wechatLogin,
  wechatPhone: wechatPhone,
  getOpenId: getOpenId,
  checkBaogao: checkBaogao,
  zhanShiBaogao: zhanShiBaogao,
  weChatAdvice: weChatAdvice,
  goToWeChat: goToWeChat,
  shareGetGames: shareGetGames
}