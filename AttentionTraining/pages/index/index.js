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
    

  },

  onShow: function () {
    var that = this
    setTimeout(function () {
      that.setData({
        loading: false,
      })
    }, 3000);
    // 判断是否已经注册
    that.getStatus()
  },

  getStatus: function () {
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
              api.goToWeChat({
                data: { openid: res.data.openid },
                success: function (result) {
                  if (result.user) { 
                    if (result.user.state == 1) { // 已注册
                      wx.navigateTo({
                        url: '/pages/home/home',
                      })
                      // wx.navigateTo({
                      //   url: '/pages/transition/transition' + "?from=" + "index",
                      // })
                    } else {
                      wx.navigateTo({
                        url: '/pages/transition/transition' + "?from=" + "index",
                      })
                    }    
                  } else {
                    wx.navigateTo({
                      url: '/pages/transition/transition' + "?from=" + "index",
                    })
                  }
                },
              })
            }
          });
        } else {
          console.log('获取用户登录态失败！' + res.errMsg)
        }
      },
      fail: function (result) {
        console.log('获取用户登录态失败！')
        wx.navigateTo({
          url: '/pages/transition/transition' + "?from=" + "index"
        })
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
