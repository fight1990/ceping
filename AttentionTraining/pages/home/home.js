// pages/home/home.js

var api = require("../../Api/api.js")
var config = require("../../config.js")

Page({

  /**
   * 页面的初始数据
   */
  data: {
    nickName: "", // 昵称
    avatar: "", // 头像
    itemList: [{
      imgUrl : "zhcp",
      gId: "zhpc",
      title : "综合测评",
      url : "/pages/zongheceping/zongheceping"
    },{
      imgUrl : "zzljtd",
      gId : "jtd",
      title : "专注力交通灯",
      url : "/pages/start/start"
    },{
      imgUrl : "xfh",
      gId : "xfh",
      title : "小符号",
      url : "/pages/xiaofuhao/xiaofuhao"
    },{
      imgUrl : "ksjy",
      gId : "ksjy",
      title : "快速记忆",
      url : "/pages/kuaisujiyi/kuaisujiyi"
    },{
      imgUrl : "strpcs",
      gId : "strp",
      title : "斯特如普",
      url : "/pages/siterupu/siterupu"
    },{
      imgUrl : "",
      gId : "zwkf",
      title : "暂未开放",
      url : ""
    },], // 图片
    hideShadow: true, // 无报告显示
    hasReports: false, // 是否有报告
    record:{},
    userInfo: false, // 是否有用户信息
    hideVip: true, // 显示vip
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

          that.checkBaogao(res.data.openid)

          // api.checkBaogao({
          //   data: { openid: res.data.openid },
          //   success: function (result) {
          //     var hasReports = false
          //     if (result.games.length > 0) {
          //       hasReports = true
          //       that.setData({
          //         record: result.record
          //       })
          //     } else {
          //       hasReports = false
          //     }

          //     that.setData({
          //       hasReports: hasReports
          //     })
          //   },
          //   fail: function (res) {

          //   }
          // })
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
              console.log("取得的openid==" + res.data.openid)
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
                  
                  that.checkBaogao(res.data.openid)
                  
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

  checkBaogao: function (openid) {
    var that = this
    api.checkBaogao({
      data: { openid: openid },
      success: function (result) {
        var hasReports = false
        if (result.games.length > 0) {
          hasReports = true
          that.setData({
            record: result.record
          })
        } else {
          hasReports = false
        }

        that.setData({
          hasReports: hasReports
        })

      },
      fail: function (res) {

      }
    })
  },


  /**
   * 隐藏阴影
   */
  hideShadowTap: function () {
    var that = this
    that.setData({
      hideShadow: true,
      hideVip: true
    })
  },

  /**
   * 报告
   */
  reportTap: function () {
    
    var that = this
    if (that.data.hasReports == true) {
      // 有报告
      wx.navigateTo({
        url: '/pages/report/report',
      })
    } else {
      // 无报告
      that.setData({
        hideShadow: false,
      })
    }
  },
  /**
   * 意见反馈
   */
  feedbackTap: function () {
    wx.navigateTo({
      url: '/pages/feedback/feedback',
    })
  },

  /**
   * 显示vip
   */
  showVip: function() {
    var that = this
    that.setData({
      hideVip: false
    })
  },

  /**
   * 游戏开始页面
   */
  gotoStart:function (event) {
    let gotoUrl = event.currentTarget.dataset['url'];
    wx.navigateTo({
      url: gotoUrl,
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
    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          that.setData({
            userInfo: true,
            "nickName": res.data.nickName,
            "avatar": res.data.avatarUrl
          })
          
          api.checkBaogao({
            data: { openid: res.data.openid },
            success: function (result) {
              var hasReports = false
              if (result.games.length>0) {
                hasReports = true
                that.setData({
                  record: result.record
                })
              } else {
                hasReports = false
              }

              that.setData({
                hasReports: hasReports
              })
            },
            fail: function (res) {

            }
          })
        }
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
    var that = this
    return {
      title: "分享。。。。",
      path: "/pages/analysis/analysis",
      imageUrl: "/style/images/share.png",
      success: (res) => {
        wx.showToast({
          title: '分享成功',
          icon: 'success',
          duration: 1000
        });
      }
    }
  }
})