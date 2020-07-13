//app.js
var config = require("config.js")

App({
  onLaunch: function () { 
    // // 登录
    // wx.login({
    //   success: res => {
    //     // 发送 res.code 到后台换取 openId, sessionKey, unionId
    //   }
    // })

    // // 获取用户信息
    // wx.getSetting({
    //   success: res => {
    //     if (res.authSetting['scope.userInfo']) {
    //       // 已经授权，可以直接调用 getUserInfo 获取头像昵称，不会弹框
    //       wx.getUserInfo({
    //         success: res => {
    //           // 可以将 res 发送给后台解码出 unionId              
    //           this.globalData.userInfo = res.userInfo
    //           // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
    //           // 所以此处加入 callback 以防止这种情况
    //           if (this.userInfoReadyCallback) {
    //             this.userInfoReadyCallback(res)
    //           }
    //         }
    //       })
    //     }
    //   }
    // })
    // this.getOpenId()
  },
  onShow: function (options) {
    var that = this
    wx.getSystemInfo({
      success: function (res) {
        var v = res.windowHeight / res.windowWidth
        if (v > 1.7) {
          that.globalData.isX = true;
        }
        that.globalData.isIOS = res.system.startsWith("iOS")
        that.globalData.windowHeight = res.windowHeight
      },
    })
  },
  getOpenId: function () {
    var that = this
    wx.login({
      success: function (res) {
        if (res.code) {
          var obj = {}
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
                  // wx.navigateTo({
                  //   url: '/pages/start/start',
                  // })
                }
              });
            }
          });
        } else {
          console.log('获取用户登录态失败！' + res.errMsg)
        }
      }
    })
  },
  globalData: {
    userInfo: null,
    windowHeight: 0,
    isX: false,
    windowWidth: 0,
    isIOS: false
  }
})