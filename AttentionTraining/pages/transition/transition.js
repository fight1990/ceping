// pages/transition/transition.js
var config = require("../../config.js")
var api = require("../../Api/api.js")

Page({

  /**
   * 页面的初始数据
   */
  data: {
    rightCount: 0, //
    globalCount: 0, //
    hideResultShadow: true,
    from: '',
    gameResult:''
  },

  /**
   * 分享
   */
  shareTap: function () {
    var that = this
    wx.navigateTo({
      url: '/pages/analysis/analysis' + "?gameid=" + that.data.gameid + "&isShare=1",
    })
    that.data.share = false
  },

  /**
   * 再来一次
   */
  moreTap: function () {
    wx.navigateBack({
      
    })
  },

  /**
   * 显示结果弹框
   */
  showResultTap: function () {
    var that = this
    that.setData({
      hideResultShadow: false,
    })
  },

  /**
   * 关闭结果弹框
   */
  cancelResultTap: function () {
    var that = this
    that.setData({
      hideResultShadow: true,
    })
  },


  /**
   * 注册完善信息
   */
  registerTap: function () {
    var that = this
    if (that.data.gameResult != undefined) {
      wx.navigateTo({
        url: '/pages/information/information' + "?gameResult=" + that.data.gameResult+ "&from=" + that.data.from,
      }) 
    } else {
      wx.navigateTo({
        url: '/pages/information/information' + "?score=" + that.data.rightCount + "&times=" + that.data.globalCount,
      }) 
    }
  },

  getUserInfoClick: function (e) {
    var that = this

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          api.goToWeChat({
            data: { openid: res.data.openid },
            success: function (result) {
              if (result.user) { 
                if (result.user.state == 1) { // 已注册
                  wx.navigateBack({
                    delta: 1,
                  })
                } else {
                  wx.navigateTo({
                    url: '/pages/information/information' + "?from=" + that.data.from + '&gameResult='+that.data.gameResult
                  })
                }    
              } else {
                wx.navigateTo({
                  url: '/pages/information/information' + "?from=" + that.data.from + '&gameResult='+that.data.gameResult
                })
              }
            },
          })
        }
      },
      fail: function (res) {
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
    
                      api.goToWeChat({
                        data: { openid: res.data.openid },
                        success: function (result) {
                          if (result.user) { 
                            if (result.user.state == 1) { // 已注册
                              wx.navigateTo({
                                url: '/pages/home/home',
                              })
                            } else {
                              wx.navigateTo({
                                url: '/pages/information/information' + "?from=" + that.data.from + '&gameResult='+that.data.gameResult
                              })
                            }    
                          } else {
                            wx.navigateTo({
                              url: '/pages/information/information' + "?from=" + that.data.from + '&gameResult='+that.data.gameResult
                            })
                          }
                        }                        
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

                  api.goToWeChat({
                    data: { openid: res.data.openid },
                    success: function (result) {
                      if (result.user) {
                        if (result.user.state == 1) { // 已注册
                          var params = {
                            userid: result.user.id,
                            score: that.data.rightCount,
                            times: that.data.globalCount,
                            nickname: response.userInfo.nickName,
                            headUrl: response.userInfo.avatarUrl,
                            city: response.userInfo.city,
                            openid: res.data.openid
                          }
                          api.saveWechatGames({
                            data: params,
                            success: function (response) {
                              console.log(response)
                              that.data.gameid = response.gameid
                              if (result.games.length >= 2) { // 大于两次 - 分享
                                that.showResultTap()
                              } else { // 直接生成报告
                                wx.navigateTo({
                                  url: '/pages/analysis/analysis' + "?gameid=" + that.data.gameid + "&isShare=0",
                                })
                              }
                            },
                            fail: function (res) {

                            }
                          })
                        } else {
                          wx.navigateTo({
                            url: '/pages/information/information' + "?from=" + that.data.from + '&gameResult='+that.data.gameResult ,
                          })
                        }
                      } else {
                        wx.navigateTo({
                          url: '/pages/information/information' + "?from=" + that.data.from + '&gameResult='+that.data.gameResult
                        })
                      }
                    },
                    fail: function (res) {

                    }
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
   * 稍后再填
   */
  laterTap: function () {
    // wx.navigateBack({
      
    // })
    wx.navigateTo({
      url: '/pages/home/home',
    })
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var rightCount = options.score
    var globalCount = options.times
    var from = options.from
    var gameResult = options.gameResult

    this.setData({
      rightCount: rightCount,
      globalCount: globalCount,
      from: from,
      gameResult: gameResult
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
    var that = this
    if (that.data.share == true) {
      that.shareTap()
    } 
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
  onShareAppMessage: function (res) {
    var that = this
    that.data.share = true
    if (res.from == "button") {
      var title = "我的孩子已闯过" + that.data.rightCount + "题，让你的孩子也试试吧！"
      return {
        title: title,
        path: "/pages/home/home",
        imageUrl: "../../style/images/tupian.png",
        success: (res) => {
          console.log("转发成功", res);
        },
        fail: (res) => {
          console.log("转发失败", res);
        }
      }
    }
  }
})