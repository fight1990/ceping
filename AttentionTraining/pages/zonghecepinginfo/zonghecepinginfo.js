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
    time_minute:0,
    time_second:0,
    userData: {
      userName: "",
      avatar: "", // 头像
      sex: "",
      age: "",
      mobile: ""
    },
    tiXian: [
      {
        'title': '反应能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
      },{
        'title': '认知灵活度\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
      },{
        'title': '信息处理能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
      },{
        'title': '记忆能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
      }
    ],
    games:[{
      title:'选择注意力训练：',
      scole:'--',
      info:'用时--秒 正确题数--题 正确率--',
    },{
      title:'工作记忆区训练：',
      scole:'--',
      info:'用时--秒 正确题数--题 正确率--',
    },{
      title:'注意力保持训练：',
      scole:'--',
      info:'用时--秒 正确题数--题 正确率--',
    },{
      title:'斯特如普训练：',
      scole:'--',
      info:'用时--秒 正确题数--题 正确率--',
    }],
    resultInfo:[]
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var gameResult = options.gameResult
    var gameData = options.gameData

    if (gameResult) {
      this.uploadGameData(gameResult)
      this.setData({
        gameData: JSON.parse(gameResult)
      })
    } else if (gameData) {
      this.dealWithGameData(JSON.parse(gameData))
    } else {
      this.getGameData()
    }
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    // this.getGameData()
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
    var that =this

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          api.goToWeChat({
            data: { openid: res.data.openid },
            success: function (result) {
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
                  that.getGameData()
                },
                fail: function (res) {
                  
                }
              })
            },
            fail: function(error) {
            }
          });
        }
      },
      fail:function (res){

      }
    })
  },

  dealWithGameData: function(gameData) {
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
                if (result.user.state == 1) { 
                  that.setData({
                    userData: {
                      userName: result.user.name,
                      avatar: res.data.avatarUrl,
                      sex: result.user.sex,
                      age: age + '岁',
                      mobile: result.user.phone
                    },
                  })

                  if (gameData) {
                    var fy_score = gameData.score0;
                    var rz_score = gameData.score1;
                    var xx_score = gameData.score2;
                    var jy_score = gameData.score3;

                    var fy_percentage = (gameData.percentage0 * 1).toFixed(2) + '%';
                    var rz_percentage = (gameData.percentage1* 1).toFixed(2) + '%';
                    var xx_percentage = (gameData.percentage2* 1).toFixed(2) + '%';
                    var jy_percentage = (gameData.percentage3* 1).toFixed(2) + '%';

                    var jtd_time = parseFloat(gameData.time0)
                    var xfh_time = parseFloat(gameData.time1)
                    var ksjy_time = parseFloat(gameData.time2)
                    var strp_time = parseFloat(gameData.time3)

                    var jtd_score = 0
                    var xfh_score = 0
                    var ksjy_score = 0
                    var strp_score = 0
                    var jtd_percent =0.0
                    var xfh_percent = 0.0
                    var ksjy_percent = 0.0
                    var strp_percent = 0.0

                    var jtd_list = gameData.scantron0.split(",");
                    var xfh_list = gameData.scantron1.split(",");
                    var ksjy_list = gameData.scantron2.split(",");
                    var strp_list = gameData.scantron3.split(",");

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

                    var times = jtd_time + xfh_time + ksjy_time + strp_time;
                    var minute = Math.floor(times/340/60);
                    var second = Math.floor(times/340%60)>0 ? Math.floor(times/340%60) : (times/340 - minute).toFixed(2);

                    that.setData({
                      time_minute: minute,
                      time_second: second,
                      games:[{
                        title:'选择注意力训练：',
                        scole:jtd_score,
                        info:'用时'+jtd_time+'秒 正确题数'+jtd_score+'题 正确率'+jtd_percent+'%'
                      },{
                        title:'工作记忆区训练：',
                        scole:xfh_score,
                        info:'用时'+xfh_time+'秒 正确题数'+xfh_score+'题 正确率'+xfh_percent+'%'
                      },{
                        title:'注意力保持训练：',
                        scole:ksjy_score,
                        info:'用时'+ksjy_time+'秒 正确题数'+ksjy_score+'题 正确率'+ksjy_percent+'%'
                      },{
                        title:'交斯特如普训练：',
                        scole:strp_score,
                        info:'用时'+strp_time+'秒 正确题数'+strp_score+'题 正确率'+strp_percent+'%'
                      }],
                      tiXian: [{
                          'title': '反应能力\n',
                          'scole': '分数'+fy_score+'分，百分比'+fy_percentage+'，标准分值：80分\n',
                          'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
                        },{
                          'title': '认知灵活度\n',
                          'scole': '分数'+rz_score+'分，百分比'+rz_percentage+'，标准分值：80分\n',
                          'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
                        },{
                          'title': '信息处理能力\n',
                          'scole': '分数'+xx_score+'分，百分比'+xx_percentage+'，标准分值：80分\n',
                          'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
                        },{
                          'title': '记忆能力\n',
                          'scole': '分数'+jy_score+'分，百分比'+jy_percentage+'，标准分值：80分\n',
                          'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
                        }]
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
                      avatar: res.data.avatarUrl,
                      sex: result.user.sex,
                      age: age + '岁',
                      mobile: result.user.phone
                    },
                  })

                  if (0) {
                  // if (that.data.gameData != undefined) {
                    var fy_score = that.data.gameData.score0;
                    var rz_score = that.data.gameData.score1;
                    var xx_score = that.data.gameData.score2;
                    var jy_score = that.data.gameData.score3;

                    var fy_percentage = (that.data.gameData.percentage0 * 1).toFixed(2) + '%';
                    var rz_percentage = (that.data.gameData.percentage1* 1).toFixed(2) + '%';
                    var xx_percentage = (that.data.gameData.percentage2* 1).toFixed(2) + '%';
                    var jy_percentage = (that.data.gameData.percentage3* 1).toFixed(2) + '%';

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

                    var times = jtd_time + xfh_time + ksjy_time + strp_time;
                    var minute = Math.floor(times/340/60);
                    var second = Math.floor(times/340%60)>0 ? Math.floor(times/340%60) : (times/340 - minute).toFixed(2);

                    that.setData({
                      time_minute: minute,
                      time_second: second,
                      games:[{
                        title:'选择注意力训练：',
                        scole:jtd_score,
                        info:'用时'+jtd_time+'秒 正确题数'+jtd_score+'题 正确率'+jtd_percent+'%'
                      },{
                        title:'工作记忆区训练：',
                        scole:xfh_score,
                        info:'用时'+xfh_time+'秒 正确题数'+xfh_score+'题 正确率'+xfh_percent+'%'
                      },{
                        title:'注意力保持训练：',
                        scole:ksjy_score,
                        info:'用时'+ksjy_time+'秒 正确题数'+ksjy_score+'题 正确率'+ksjy_percent+'%'
                      },{
                        title:'交斯特如普训练：',
                        scole:strp_score,
                        info:'用时'+strp_time+'秒 正确题数'+strp_score+'题 正确率'+strp_percent+'%'
                      }],
                      tiXian: [{
                          'title': '反应能力\n',
                          'scole': '分数'+fy_score+'分，百分比'+fy_percentage+'，标准分值：80分\n',
                          'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
                        },{
                          'title': '认知灵活度\n',
                          'scole': '分数'+rz_score+'分，百分比'+rz_percentage+'，标准分值：80分\n',
                          'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
                        },{
                          'title': '信息处理能力\n',
                          'scole': '分数'+xx_score+'分，百分比'+xx_percentage+'，标准分值：80分\n',
                          'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
                        },{
                          'title': '记忆能力\n',
                          'scole': '分数'+jy_score+'分，百分比'+jy_percentage+'，标准分值：80分\n',
                          'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
                        }]
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
  
                          var fy_percentage = (result.data.percentage0* 1).toFixed(2) + '%';
                          var rz_percentage = (result.data.percentage1* 1).toFixed(2) + '%';
                          var xx_percentage = (result.data.percentage2* 1).toFixed(2) + '%';
                          var jy_percentage = (result.data.percentage3* 1).toFixed(2) + '%';
  
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
  
                          var minute = Math.floor(result.data.times/340/60);
                          var second = Math.floor(result.data.times/340%60)>0 ? Math.floor(result.data.times/340%60) : (result.data.times/340 - minute).toFixed(2);

                          that.setData({
                            time_minute: minute,
                            time_second: second,
                            games:[{
                              title:'选择注意力训练：',
                              scole:jtd_score,
                              info:'用时'+jtd_time+'秒 正确题数'+jtd_score+'题 正确率'+jtd_percent+'%'
                            },{
                              title:'工作记忆区训练：',
                              scole:xfh_score,
                              info:'用时'+xfh_time+'秒 正确题数'+xfh_score+'题 正确率'+xfh_percent+'%'
                            },{
                              title:'注意力保持训练：',
                              scole:ksjy_score,
                              info:'用时'+ksjy_time+'秒 正确题数'+ksjy_score+'题 正确率'+ksjy_percent+'%'
                            },{
                              title:'交斯特如普训练：',
                              scole:strp_score,
                              info:'用时'+strp_time+'秒 正确题数'+strp_score+'题 正确率'+strp_percent+'%'
                            }],
                            tiXian: [{
                                'title': '反应能力\n',
                                'scole': '分数'+fy_score+'分，百分比'+fy_percentage+'，标准分值：80分\n',
                                'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
                              },{
                                'title': '认知灵活度\n',
                                'scole': '分数'+rz_score+'分，百分比'+rz_percentage+'，标准分值：80分\n',
                                'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
                              },{
                                'title': '信息处理能力\n',
                                'scole': '分数'+xx_score+'分，百分比'+xx_percentage+'，标准分值：80分\n',
                                'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
                              },{
                                'title': '记忆能力\n',
                                'scole': '分数'+jy_score+'分，百分比'+jy_percentage+'，标准分值：80分\n',
                                'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
                              }]
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