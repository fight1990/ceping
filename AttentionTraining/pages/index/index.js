//index.js
//获取应用实例
const app = getApp()
var config = require("../../config.js")
var api = require("../../Api/api.js")

Page({
  data: {
    loading: true,
  },

  onLoad: function () {
    var that = this
    setTimeout(function () {
      that.setData({
        loading: false,
      })
    }, 3000);

    // if (app.globalData.userInfo) {
    //   this.setData({
    //     userInfo: app.globalData.userInfo,
    //     hasUserInfo: true
    //   })
    // } else if (this.data.canIUse){
    //   // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
    //   // 所以此处加入 callback 以防止这种情况
    //   app.userInfoReadyCallback = res => {
    //     this.setData({
    //       userInfo: res.userInfo,
    //       hasUserInfo: true
    //     })
    //   }
    // } else {
    //   // 在没有 open-type=getUserInfo 版本的兼容处理
    //   wx.getUserInfo({
    //     success: res => {
    //       app.globalData.userInfo = res.userInfo
    //       this.setData({
    //         userInfo: res.userInfo,
    //         hasUserInfo: true
    //       })
    //     }
    //   })
    // }
  },



  //事件处理函数
  getUserInfoClick: function (e) {

    var that = this

    wx.getStorage({
      key: 'userInfo',
      success: function(res) {
        // wx.navigateTo({
        //   url: '/pages/home/home',
        // })
        wx.navigateTo({
          url: '/pages/start/start',
        })
      },
      fail: function (res) {
        that.getOpenId()
      }
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
                  wx.navigateTo({
                    url: '/pages/start/start',
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

})
