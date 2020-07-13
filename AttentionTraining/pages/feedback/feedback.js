// pages/feedback/feedback.js

var config = require("../../config.js")
var api = require("../../Api/api.js")


Page({

  /**
   * 页面的初始数据
   */
  data: {
    value: "",
    feedbackValue: "",
    success: true, // 是否提交成功
    isCommit: false,
  },

  //事件处理函数
  getUserInfoClick: function (e) {

    var that = this
    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          that.setData({
            userInfo: true,
            "nickName": res.data.nickName,
            "avatar": res.data.avatarUrl
          })
          that.commitTap(res.data.openid)
        }
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
              wx.getUserInfo({
                success: function (response) {
                  obj = response.userInfo
                  obj.openid = res.data.openid
                  wx.setStorage({
                    key: 'userInfo',
                    data: obj,
                  })

                  that.setData({
                    userInfo: true,
                    "nickName": response.userInfo.nickName,
                    "avatar": response.userInfo.avatarUrl
                  })

                  that.commitTap(res.data.openid)

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

  /**
   * 提交
   */
  commitTap: function (openid) {
    var that = this
    that.setData({
      isCommit: false,
    })
    var params = {}
    wx.getStorage({
      key: 'feedback',
      success: function (res) {
        if (res.data.length > 0) {
          params = { openid: openid, advice: res.data }
        } else {
          params = { openid: openid, advice: "" }
        }
        api.weChatAdvice({
          data: params,
          success: function (res) {
            that.setData({
              isCommit: true,
              success: true,
            })
          },
          fail: function (res) {
            that.setData({
              isCommit: true,
              success: false,
            })
          }
        })
      },
      fail: function (res) {
        params = { openid: openid, advice: res.data }
        api.weChatAdvice({
          data: params,
          success: function (res) {
            that.setData({
              isCommit: true,
              success: true,
            })
          },
          fail: function (res) {
            that.setData({
              isCommit: true,
              success: false,
            })
          }
        })
      }
    })
  },

  /**
   * 文字输入
   */
  feedbackInput: function (e) {
    var that = this
    var newValue = e.detail.value
    that.data.feedbackValue = newValue
    wx.setStorage({
      key: 'feedback',
      data: newValue,
    })
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {

  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {

  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    var that = this
    wx.setNavigationBarTitle({
      title: '意见反馈',    //页面标题
    })
    wx.getStorage({
      key: 'feedback',
      success: function (res) {
        if (res.data.length > 0) {
          that.setData({
            value: res.data
          })
          that.data.feedbackValue = res.data
        } else {

        }
      },
      fail: function (res) {

      }
    })
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {

  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {

  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {

  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {

  }
})