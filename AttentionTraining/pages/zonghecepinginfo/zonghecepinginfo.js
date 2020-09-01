// pages/zonghecepinginfo/zonghecepinginfo.js
var api = require("../../Api/api.js")
const util = require("../../utils/util.js");

Page({

  /**
   * 页面的初始数据
   */
  data: {
    gameData:undefined,
    screenWidth: 710 / util.getRpx() * 1.0,
    userData: {
      userName: "",
      sex: "",
      age: "",
      mobile: ""
    },
    deFen: {
      jtd: '交通灯：用时-秒，正确数-题，正确率-，得分-分；\n',
      xfh: '小符号：用时-秒，正确数-题，正确率-，得分-分；\n',
      ksjy: '快速记忆：用时-秒，正确数-题，正确率-，得分-分；\n',
      strp: '斯特如普：用时-秒，正确数-题，正确率-，得分-分；\n',
      zsc: '总用时长：-秒\n'
    },
    tiXian: {
      'fy': {
        'title': '反应能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
      },
      'rz': {
        'title': '认知灵活度\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
      },
      'xx': {
        'title': '信息处理能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
      },
      'jy': {
        'title': '记忆能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
      }
    }
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var gameResult = options.gameResult
    if (gameResult) {
      this.uploadGameData(gameResult)
      this.setData({
        gameData: JSON.parse(gameResult)
      })
    }
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    this.getGameData()
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

  },

  uploadGameData: function(gameResult) {

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          var params = {
            openid: res.data.openid,
            userid: result.user.id,
            nickname: res.data.nickName,
            headUrl: res.data.avatarUrl,
            data: gameResult
          }
          api.saveGamesData({
            data: params,
            success: function (response) {
              console.log(response)
            },
            fail: function (res) {
              
            }
          })
        }
      },
      fail:function (res){

      }
    })
  },

  getGameData: function() {
    var that = this
    let age = util.getAge(wx.getStorageSync('age_player'))

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          api.goToWeChat({
            data: { openid: res.data.openid },
            success: function (result) {
              if (result.user) { 
                if (result.user.state == 1) { // 已注册
                  // if (result.user.age != undefined && age <= 0) {
                  //   age = result.user.age
                  // }
                  that.setData({
                    userData: {
                      userName: result.user.name,
                      sex: result.user.sex,
                      age: age + '岁',
                      mobile: result.user.phone
                    },
                  })

                  if (that.data.gameData != undefined) {
                    var fy_score = that.data.gameData.score0;
                    var rz_score = that.data.gameData.score1;
                    var xx_score = that.data.gameData.score2;
                    var jy_score = that.data.gameData.score3;

                    var fy_percentage = that.data.gameData.percentage0;
                    var rz_percentage = that.data.gameData.percentage1;
                    var xx_percentage = that.data.gameData.percentage2;
                    var jy_percentage = that.data.gameData.percentage3;

                    var jtd_time = that.data.gameData.time0
                    var xfh_time = that.data.gameData.time1
                    var ksjy_time = that.data.gameData.time2
                    var strp_time = that.data.gameData.time3

                    var jtd_score = 0
                    var xfh_score = 0
                    var ksjy_score = 0
                    var strp_score = 0
                    var jtd_percent =0.0
                    var xfh_percent = 0.0
                    var ksjy_percent = 0.0
                    var strp_percent = 0.0

                    var jtd_list = that.data.gameData.scantron0.split(",");
                    var xfh_list = that.data.gameData.scantron1.split(",");
                    var ksjy_list = that.data.gameData.scantron2.split(",");
                    var strp_list = that.data.gameData.scantron3.split(",");

                    for (var index in jtd_list) {
                      if (jtd_list[index] == '1') {
                        jtd_score += 1;
                      }
                    }
                    jtd_percent = ((jtd_score/jtd_list.length) * 100).toFixed(2)

                    for (var index in xfh_list) {
                      if (xfh_list[index] == '1') {
                        xfh_score += 1;
                      }
                    }
                    xfh_percent = ((xfh_score/xfh_list.length) * 100).toFixed(2)

                    for (var index in ksjy_list) {
                      if (ksjy_list[index] == '1') {
                        ksjy_score += 1;
                      }
                    }
                    ksjy_percent = ((ksjy_score/ksjy_list.length) * 100).toFixed(2)

                    for (var index in strp_list) {
                      if (strp_list[index] == '1') {
                        strp_score += 1;
                      }
                    }
                    strp_percent = ((strp_score/strp_list.length) * 100).toFixed(2)

                    that.setData({
                      deFen: {
                        jtd: '交通灯：用时'+jtd_time+'秒，正确数'+jtd_score+'题，正确率'+jtd_percent+'%，得分'+jtd_score+'分；\n',
                        xfh: '小符号：用时'+xfh_time+'秒，正确数'+xfh_score+'题，正确率'+xfh_percent+'%，得分'+xfh_score+'分；\n',
                        ksjy: '快速记忆：用时'+ksjy_time+'秒，正确数'+ksjy_score+'题，正确率'+ksjy_percent+'%，得分'+ksjy_score+'分；\n',
                        strp: '斯特如普：用时'+strp_time+'秒，正确数'+strp_score+'题，正确率'+strp_percent+'%，得分'+strp_score+'分；\n',
                        zsc: '总用时长：'+ that.data.gameData.times +'秒'
                      },
                      tiXian: {
                        'fy': {
                          'title': '反应能力\n',
                          'scole': '分数'+fy_score+'分，百分比'+fy_percentage+'，标准分值：80分\n',
                          'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
                        },
                        'rz': {
                          'title': '认知灵活度\n',
                          'scole': '分数'+rz_score+'分，百分比'+rz_percentage+'，标准分值：80分\n',
                          'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
                        },
                        'xx': {
                          'title': '信息处理能力\n',
                          'scole': '分数'+xx_score+'分，百分比'+xx_percentage+'，标准分值：80分\n',
                          'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
                        },
                        'jy': {
                          'title': '记忆能力\n',
                          'scole': '分数'+jy_score+'分，百分比'+jy_percentage+'，标准分值：80分\n',
                          'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
                        }
                      }
                    })
                  } else {
                    api.getCombinationEvaluationByOpenid({
                      data: { openid: res.data.openid },
                      success: function (result) {
                        if (result.code == 1) { 
                          var fy_score = result.data.score0;
                          var rz_score = result.data.score1;
                          var xx_score = result.data.score2;
                          var jy_score = result.data.score3;
  
                          var fy_percentage = result.data.percentage0;
                          var rz_percentage = result.data.percentage1;
                          var xx_percentage = result.data.percentage2;
                          var jy_percentage = result.data.percentage3;
  
                          var jtd_time = result.data.time0
                          var xfh_time = result.data.time1
                          var ksjy_time = result.data.time2
                          var strp_time = result.data.time3
  
                          var jtd_score = 0
                          var xfh_score = 0
                          var ksjy_score = 0
                          var strp_score = 0
                          var jtd_percent =0.0
                          var xfh_percent = 0.0
                          var ksjy_percent = 0.0
                          var strp_percent = 0.0
  
                          var jtd_list = result.data.scantron0.split(",");
                          var xfh_list = result.data.scantron1.split(",");
                          var ksjy_list = result.data.scantron2.split(",");
                          var strp_list = result.data.scantron3.split(",");
  
                          for (var index in jtd_list) {
                            if (jtd_list[index] == '1') {
                              jtd_score += 1;
                            }
                          }
                          jtd_percent = ((jtd_score/jtd_list.length) * 100).toFixed(2)
  
                          for (var index in xfh_list) {
                            if (xfh_list[index] == '1') {
                              xfh_score += 1;
                            }
                          }
                          xfh_percent = ((xfh_score/xfh_list.length) * 100).toFixed(2)
  
                          for (var index in ksjy_list) {
                            if (ksjy_list[index] == '1') {
                              ksjy_score += 1;
                            }
                          }
                          ksjy_percent = ((ksjy_score/ksjy_list.length) * 100).toFixed(2)
  
                          for (var index in strp_list) {
                            if (strp_list[index] == '1') {
                              strp_score += 1;
                            }
                          }
                          strp_percent = ((strp_score/strp_list.length) * 100).toFixed(2)
  
                          that.setData({
                            deFen: {
                              jtd: '交通灯：用时'+jtd_time+'秒，正确数'+jtd_score+'题，正确率'+jtd_percent+'%，得分'+jtd_score+'分；\n',
                              xfh: '小符号：用时'+xfh_time+'秒，正确数'+xfh_score+'题，正确率'+xfh_percent+'%，得分'+xfh_score+'分；\n',
                              ksjy: '快速记忆：用时'+ksjy_time+'秒，正确数'+ksjy_score+'题，正确率'+ksjy_percent+'%，得分'+ksjy_score+'分；\n',
                              strp: '斯特如普：用时'+strp_time+'秒，正确数'+strp_score+'题，正确率'+strp_percent+'%，得分'+strp_score+'分；\n',
                              zsc: '总用时长：'+ result.data.times +'秒'
                            },
                            tiXian: {
                              'fy': {
                                'title': '反应能力\n',
                                'scole': '分数'+fy_score+'分，百分比'+fy_percentage+'，标准分值：80分\n',
                                'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
                              },
                              'rz': {
                                'title': '认知灵活度\n',
                                'scole': '分数'+rz_score+'分，百分比'+rz_percentage+'，标准分值：80分\n',
                                'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
                              },
                              'xx': {
                                'title': '信息处理能力\n',
                                'scole': '分数'+xx_score+'分，百分比'+xx_percentage+'，标准分值：80分\n',
                                'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
                              },
                              'jy': {
                                'title': '记忆能力\n',
                                'scole': '分数'+jy_score+'分，百分比'+jy_percentage+'，标准分值：80分\n',
                                'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
                              }
                            }
                          })
                        }
                      },
                      fail: function (res) {
          
                      }
                    })

                  }
                }
              }
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
  normalDistribution:function(x) {
    var a = 1.0 / Math.sqrt(2*Math.PI);
    var b = (-0.5 * x * x ).toFixed(2);
    var c = Math.exp(b).toFixed(2);
    var result = Math.floor((a * c * 6.16) * 100);

    return result + '%';
  }
})