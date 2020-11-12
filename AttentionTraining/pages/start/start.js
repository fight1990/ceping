// pages/start/start.js
const ctx2 = wx.createCanvasContext('runCanvas')

Page({

  /**
   * 页面的初始数据
   */
  data: {

  },

  /**
   * 开始阅读
   */
  
  readBtnAction: function (e) {
    var that = this
    wx.getStorage({
      key: 'hasGuide',
      success: function (res) {
        if (res.data == "true") {
          wx.navigateTo({
            url: '/pages/lights/lights',
          })
        } else {
          wx.navigateTo({
            url: '/pages/guide/guide',
          })
        }
      },
      fail: function () {
        wx.navigateTo({
          url: '/pages/guide/guide',
        })
      }
    })
  },

  isReadBtnAction:function (e) {
    var that = this
    var that = this
    if (wx.getStorageSync("hasGuide")) {
      wx.navigateTo({
        url: '/pages/lights/lights',
      })
    } else {
      wx.navigateTo({
        url: '/pages/guide/guide',
      })
    }
    // wx.getStorage({
    //   key: 'userInfo',
    //   success: function (result) {
    //     if (result.data) {
    //       wx.getStorage({
    //         key: 'hasGuide',
    //         success: function (res) {
    //           if (res.data == "true") {
    //             wx.navigateTo({
    //               url: '/pages/lights/lights',
    //             })
    //           } else {
    //             wx.navigateTo({
    //               url: '/pages/guide/guide',
    //             })
    //           }
    //         },
    //         fail: function () {
    //           wx.navigateTo({
    //             url: '/pages/guide/guide',
    //           })
    //         }
    //       })
    //     } else {
    //       that.getOpenid()
    //     }
        
    //   },
    //   fail: function (res) {
    //     that.getOpenid()
    //   }
    // })
    

  },
   
  getOpenid: function () {
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
                    url: '/pages/guide/guide',
                  })
                },
                fail: function (response) {
                  wx.navigateTo({
                    url: '/pages/guide/guide',
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
  },
  
  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: '选择注意力训练',    //页面标题
    })
    wx.setNavigationBarColor({
      frontColor: '#ffffff',
      backgroundColor: '#92DAAE',
    })
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
    // wx.navigateTo({
    //   url: '/pages/home/home',
    // })
    // wx.redirectTo({
    //   url: '/pages/home/home',
    // })
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