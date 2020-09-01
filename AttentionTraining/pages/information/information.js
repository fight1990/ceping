// pages/information/information.js

var api = require("../../Api/api.js")

Page({

  /**
   * 页面的初始数据
   */
  data: {
    showSex: true, // 显示性别
    sexItemList: ['男孩', '女孩'],
    name: "", // 孩子姓名
    showSex: false,
    sex: "确保正确以便结果的正确性", // 孩子性别
    showAge: false,
    age: "确保正确以便结果的正确性", // 孩子年龄
    hideDate: true, // 显示时间选择器
    phone: "", // 联系电话
    code: "", // 验证码 
    count: 300, // 倒计时
    timer: "", // 计时器
    codeDisabled: true, // 获取验证码按钮是否可以点击
    hideCountDown: true, // 隐藏倒计时
    commitDisable: true, // 提交按钮是否可以点击
    hideShadow: true, // 隐藏提示框
    rightCount: 0, //
    globalCount: 0, //
    from: '',
    gameResult: ''
  },

  /**
   * 提交
   */
  commitTap: function () {
    var that = this
 
    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          var params = {
            phone: that.data.phone,
            verification: that.data.code,
            nickname: res.data.nickName,
            headUrl: res.data.avatarUrl,
            city: res.data.city
          }
          api.wechatLogin({
            data: params,
            success: function (result) {
              if (result.msg == 0) { // 注册成功
                wx.showToast({
                  title: '注册成功',
                  icon: 'none',
                  duration: 1000
                })
                wx.setStorage({
                  key: 'hasInformation',
                  data: true,
                })

                wx.getUserInfo({
                  success: function (response) {
                    obj = response.userInfo
                    obj.openid = res.data.openid
                    wx.setStorage({
                      key: 'userInfo',
                      data: obj,
                    })                   
                  }
                });

                // if (that.data.from == "ceping") {
                //   wx.redirectTo({
                //     url: '/pages/zongheceping/zongheceping',
                //   })
                // } else {
                //   wx.redirectTo({
                //     url: '/pages/home/home',
                //   })
                // }
                
                if (that.data.gameResult != undefined) {
                // if (that.data.from == "ceping") {
                  wx.navigateTo({
                    url: '/pages/zonghecepinginfo/zonghecepinginfo' + '?gameResult=' + that.data.gameResult +'&from=ceping',
                  })
                } else {
                  wx.redirectTo({
                    url: '/pages/home/home',
                  })
                }




                // var param = {
                //   userid: result.user.id,
                //   score: that.data.rightCount,
                //   times: that.data.globalCount,
                //   nickname: res.data.nickName,
                //   headUrl: res.data.avatarUrl,
                //   city: res.data.city,
                //   openid: res.data.openid
                // }
                // api.saveWechatGames({
                //   data: param,
                //   success: function (response) {
                //     console.log(response)
                //     wx.navigateTo({
                //       url: '/pages/analysis/analysis' + "?gameid=" + response.gameid + "&isShare=0",
                //     })
                //   },
                //   fail: function (res) {

                //   }
                // })



              } else { // 验证码超时
                wx.showToast({
                  title: '验证码超时',
                  icon: 'none',
                  duration: 1000
                })
                that.setData({
                  codeDisabled: false,
                  hideCountDown: true,
                })
                clearInterval(that.data.timer)
              }
              
            },
            fail: function (result) {

            }
          })
        }
      }
    })
    
  },

  /**
   * 倒计时
   */
  countDown: function () {
    var that = this;
    let count = that.data.count;//获取倒计时初始值
    that.setData({
      codeDisabled: true,
      hideCountDown: false,
      count: count
    })
    that.setData({
      timer: setInterval(function () {
        count--;
        that.setData({
          count: count
        })
        if (count == 0) {
          that.setData({
            codeDisabled: false,
            hideCountDown: true,
          })
          clearInterval(that.data.timer)
        }
      }, 1000)
    })
  },

  /**
   * 孩子姓名
   */
  nameInput: function (e) {
    var that = this
    that.setData({
      name: e.detail.value,
    })
    if (e.detail.value.length>0) {
      that.setData({
        codeDisabled: true,
      })
    }
    if (that.data.code.length > 0 && that.data.phone.length > 0 && that.data.name.length > 0 && that.data.sex.length > 0 && that.data.age.length > 0) {
      that.setData({
        commitDisable: false
      })
    }
  },

  /**
   * 联系电话
   */
  phoneInput: function (e) {
    var that = this
    that.setData({
      phone: e.detail.value
    })
    if (e.detail.value.length > 0) {
      that.setData({
        codeDisabled: false,
      })
    }
    if (that.data.code.length > 0 && that.data.phone.length > 0 && that.data.name.length > 0 && that.data.sex.length > 0 && that.data.age.length > 0) {
      that.setData({
        commitDisable: false
      })
    }
  },

  /**
   * 验证码
   */
  codeInput: function (e) {
    var that = this
    that.setData({
      code: e.detail.value
    })
    if (e.detail.value.length > 0) {
      // that.setData({
      //   codeDisabled: false,
      // })
    }

    if (that.data.code.length > 0 && that.data.phone.length > 0 && that.data.name.length>0 && that.data.sex.length>0 && that.data.age.length>0) {
      that.setData({
        commitDisable: false
      })
    }
  },

  /**
   * 显示性别
   */
  showSexTap: function () {
    var that = this
    wx.showActionSheet({
      itemList: that.data.sexItemList,
      itemColor: "#00B461",
      success(res) {
        that.setData({
          sex: that.data.sexItemList[res.tapIndex]
        })
        if (that.data.sex.length > 0) {
          that.setData({
            showSex: true,
            codeDisabled: true,
          })
        }
      },
      fail(res) {
        console.log(res.errMsg)
      }
    })
    if (that.data.code.length > 0 && that.data.phone.length > 0 && that.data.name.length > 0 && that.data.sex.length > 0 && that.data.age.length > 0) {
      that.setData({
        commitDisable: false
      })
    }

  },

  //  点击日期组件确定事件  
  bindDateChange: function (e) {
    var that = this
    console.log(e.detail.value)
    that.setData({
      age: e.detail.value
    })
    if (e.detail.value.length > 0) {
      that.setData({
        showAge: true,
        codeDisabled: true,
      })
    }

    var date = new Date(that.data.age);
    console.log('------' + date.getTime())
    if (that.data.code.length > 0 && that.data.phone.length > 0 && that.data.name.length > 0 && that.data.sex.length > 0 && that.data.age.length > 0) {
      that.setData({
        commitDisable: false
      })
    }
  },

  /**
   * 获取验证码
   */
  getCodeTap: function () {
    var that = this
    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          var date = new Date(that.data.age)
          var params = {
            name: that.data.name,
            phone: that.data.phone,
            sex: that.data.sex == "男孩" ? "男" : "女",
            age: that.data.age,
            nickname: res.data.nickName,
            headUrl: res.data.avatarUrl,
            openid: res.data.openid,
            city: res.data.city
          }
          api.wechatPhone({
            data: params,
            success: function (result) {
              console.log(result.msg)
              if (result.msg == 2) { // 验证码发送成功
                wx.showToast({
                  title: '成功',
                  icon: 'none',
                  duration: 1000
                })

                that.setData({
                  hideCountDown: false,
                  codeDisabled: true
                })
              } else if (result.msg == 1) { // 手机已注册
                wx.showToast({
                  title: '手机已注册',
                  icon: 'none',
                  duration: 2000
                })

              } else {
                wx.showToast({
                  title: '服务器故障',
                  icon: 'none',
                  duration: 1000
                })

              }
              that.setData({
                count: 300,
              })
              that.countDown()
            },
            fail: function (result) {

            }
          })
        }
      }
    })
    
  },

  /**
   * 继续
   */
  goOnTap: function () {
    var that = this
    that.setData({
      hideShadow: true,
    })
  },

  /**
   * 放弃
   */
  giveUpTap: function () {
    wx.navigateBack({
      
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
    var that = this
    that.setData({
      hideShadow: false,
    })
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