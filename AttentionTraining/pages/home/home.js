// pages/home/home.js

var api = require("../../Api/api.js")
var config = require("../../config.js")
const app = getApp()

Page({

  /**
   * 页面的初始数据
   */
  data: {
    nickName: "", // 昵称
    name: "", // 注册name
    avatar: "", // 头像
    statusBarHeight: wx.getSystemInfoSync()['statusBarHeight'],  //顶部导航适配
    navigationBarHeight:210,
    gameScore: {
      zhpc: {
        corNum: 0,
        allNum: 0,
        pourcentage:'0/--',
        rank: 0,
        useTime: 0.0
      },
      jtd: {
        corNum: 0,
        allNum: 100,
        pourcentage:'0/100',
        rank: 0,
        useTime: 0.0
      },
      xfh: {
        corNum: 0,
        allNum: 100,
        pourcentage:'0/100',
        rank: 0,
        useTime: 0.0
      },
      ksjy: {
        corNum: 0,
        allNum: 100,
        pourcentage:'0/100',
        rank: 0,
        useTime: 0.0
      },
      strp: {
        corNum: 0,
        allNum: 100,
        pourcentage:'0/100',
        rank: 0,
        useTime: 0.0
      }
    },
    itemList: [{
      imgUrl : "zhcp",
      gId: "zhpc",
      title : "注意力综合测评",
      subTitle: "Attention Abilities Test",
      // url: "/pages/zongheceping/zongheceping"
      url : "/pages/cePingGame/cePingGame",
      url_guide: "",
      guide_key: ""
    },{
      imgUrl : "zzljtd",
      gId : "jtd",
      title : "选择注意力训练",
      subTitle: "Selective Attention Training",
      url : "/pages/start/start",
      url_guide: "/pages/start/start",
      guide_key: ""
    },{
      imgUrl : "xfh",
      gId : "xfh",
      title : "工作记忆区训练",
      subTitle: "Working Memory Training",
      url: "/pages/xiaofuhaostart/xiaofuhaostart",
      url_guide: "/pages/xiaofuhaostart/xiaofuhaostart",
      guide_key: ""
    },{
      imgUrl : "ksjy",
      gId : "ksjy",
      title : "注意力保持训练",
      subTitle: "etaining Attention Training",
      url : "/pages/kuaisujiyistart/kuaisujiyistart",
      url_guide: "/pages/kuaisujiyistart/kuaisujiyistart",
      guide_key: ""
    },{
      imgUrl : "strpcs",
      gId : "strp",
      title : "斯特如普训练",
      subTitle: "Stroop Interference Training",
      url: "/pages/siterupustart/siterupustart",
      url_guide: "/pages/siterupustart/siterupustart",
      guide_key: ""
    }], // 图片
    hideShadow: true, // 无报告显示
    hasReports: false, // 是否有报告
    record:{},
    userInfo: false, // 是否有用户信息
    hideVip: true, // 显示vip
    vipCodeString: '', //VIP码
    iamVip: false, // 是否是VIP
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
          that.getBestScole(res.data.openid)
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
                  that.getBestScole(res.data.openid)
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
        if ((result.games && result.games.length>0) || (result.ceping && result.ceping.length>0)) {
          hasReports = true
          that.setData({
            record: result.record,
            name: result.user.name
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

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          that.setData({
            userInfo: true,
            "nickName": res.data.nickName,
            "avatar": res.data.avatarUrl
          })
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
        }
      },
      fail: function (res) {
        that.getOpenId()
      }
    })
  
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
   * 是否是vip
   */
  checkVIP:function () {
    var that = this
  
    wx.getStorage({
      key: 'IAMVIP',
      success: function (res) {
        if (res.data) {
          that.setData({
            iamVip: true,
          })
        }
      },
      fail: function (res) {
        that.setData({
          iamVip: false,
        })
      }
    })
  },

  /**
   * 游戏开始页面
   */
  gotoStart:function (event) {
    var that = this
    
    let gotoUrl = event.currentTarget.dataset['url'];
    let guide_key = event.currentTarget.dataset['guidekey'];
    let guide_url = event.currentTarget.dataset['guideurl'];

    if (gotoUrl == undefined || gotoUrl.length <= 0) {
      return
    }

    if (that.data.userInfo != true) {
      // 提示登录
      wx.showToast({
        title: '请登录！',
        icon: 'none',
      })
      return
    }

    // 是否显示vip弹框
    if (gotoUrl != '/pages/cePingGame/cePingGame' && gotoUrl != '/pages/start/start' && gotoUrl != " ") { 
      // that.checkVIP()
      let vipStatus = wx.getStorageSync('IAMVIP')
      if (vipStatus != '') {
        that.data.iamVip = vipStatus
        if (that.data.iamVip != true) { // 不是vip
          that.showVip()
          return
        } else { // vip
          that.hideShadowTap()
        }
      } else {
        that.showVip()
          return
      }
 
    } 
      
    let age =  wx.getStorageSync('age_player')
    if((gotoUrl == '/pages/cePingGame/cePingGame') && (age == undefined || age.length == 0 )) {
      wx.redirectTo({
        url: '/pages/cePingInfo/cePingInfo',
      })
    } else {
      if (((guide_key.length > 0) && wx.getStorageSync(guide_key)) || (guide_key.length == 0)) {
        wx.navigateTo({
          url: gotoUrl,
        })
      } else {
        wx.navigateTo({
          url: guide_url,
        })
      }
    }
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
              if ((result.games && result.games.length>0) || (result.ceping && result.ceping.length>0)) {
                hasReports = true
                that.setData({
                  record: result.record,
                  name: result.user.name
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
          
          that.getBestScole(res.data.openid);
        }
      }
    })
  },

  getBestScole: function(openid)  {
    var that = this
    api.getBestScaleWithGame({
      data: { openid: openid },
      success: function (result) {
        
        var gameScole = that.data.gameScore;
        var corNum = 0;
        var allNum = 340;
        var rank = 0;
        var times = 0;
        if(result.ceping) {
          corNum = result.ceping.score_0 + result.ceping.score_1 + result.ceping.score_2 + result.ceping.score_3;
          allNum = result.ceping.scantron0.split(",").length + result.ceping.scantron1.split(",").length + result.ceping.scantron2.split(",").length + result.ceping.scantron3.split(",").length;
          rank = result.ceping.scale;
          times = (result.ceping.times/allNum).toFixed(2);
        }
        
        gameScole.zhpc = {
          corNum: corNum,
          allNum: allNum,
          pourcentage:corNum+'/'+allNum,
          rank: rank,
          useTime: times
        }
        
        for (var i=0;i<result.games.length;i++) {
            var game = result.games[i];
            var element = game['type'];
            switch (element) {
              case 0: {
                gameScole.jtd= {
                  corNum: game.score,
                  allNum: 100,
                  pourcentage:game.score+'/'+'100',
                  rank: game.scale,
                  useTime: (game.times/100).toFixed(2)
                }
              }
                break;
              case 1: {
                gameScole.xfh= {
                  corNum: game.score,
                  allNum: '100',
                  pourcentage:game.score+'/'+'100',
                  rank: game.scale,
                  useTime: (game.times/100).toFixed(2)
                }
              }
                break;
              case 2: {
                gameScole.ksjy= {
                  corNum: game.score,
                  allNum: '100',
                  pourcentage:game.score+'/'+'100',
                  rank: game.scale,
                  useTime: (game.times/100).toFixed(2)
                }
              }
                break;
              case 3: {
                gameScole.strp= {
                  corNum: game.score,
                  allNum: '100',
                  pourcentage:game.score+'/'+'100',
                  rank: game.scale,
                  useTime: (game.times/100).toFixed(2)
                }
              }
                break;
              default:
                break;
            }
        }
        that.setData({
          gameScore: gameScole
        })
      },
      fail: function (res) {

      }
    })
  },

  /**
   * 提交验证码
   */
  submitVipCodeAction: function() {
    var that = this
    if (that.data.vipCodeString.length == 0) {
      wx.showToast({
        title: '请输入VIP特权码！',
        icon: 'none',
      })
      return
    }

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          api.validationCode({
            data: { 
              openid: res.data.openid,
              code: that.data.vipCodeString
            },
            success: function (result) {
              wx.showToast({
                title: 'VIP特权码提交成功！',
              })
              that.setData({
                hideVip: true
              })

              var vip = false
              if (result.code == 1) { //vip
                vip = true
                that.setData({
                  iamVip: true,
                })
              } 
              wx.setStorageSync('IAMVIP', vip)

            },
            fail: function (res) {
      
            }
          })
        }
      },
      fail: function (res) {

      }
    })
  },

  vipCodeInput: function(e) {
    this.setData({
      vipCodeString: e.detail.value
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