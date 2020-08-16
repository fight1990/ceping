
var xiaofuhao = {
  /**
   * 开始 - 按钮
   */
  hideShadowOneView: function () {
    var that = this
    that.setData({
      hideShadowOne: true,
      hideShadowThree: true,
      hideShadowTwo: false,
    })
  },

 /**
   * 开始 - 按钮
   */
  hideShadowTwoView: function () {
    var that = this
    that.setData({
      hideShadowOne: true,
      hideShadowTwo: true,
      hideShadowThree: false,
    })
    
  },

  /**
   * 开始 - 按钮
   */
  hideShadowThreeView: function () {
    var that = this
    that.setData({
      hideShadowOne: true,
      hideShadowTwo: true,
      hideShadowThree: true,
      hideGuoduye: false,
    })

    that.countDownTwo()
  },

  countDownTwo: function() {
    wx.setStorageSync('xiaofuhao_guide', true)
    this.setData({
      stepText: 5,
      isShowTimer: true
    })
    this.timerCircleReady();
    this.startCircleTime();
  }
  
}

export default xiaofuhao

  