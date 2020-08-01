var common = require("../Api/common.js")
var index = require("../Api/ports/index.js")



module.exports = {
  // 获取token
  getOpenId: common.getOpenId,
  // 小程序得到验证码登录接口
  wechatLogin: common.wechatLogin,
  // 小程序短信验证接口
  wechatPhone: common.wechatPhone,
  // 小程序游戏保存接口
  saveWechatGames: common.saveWechatGames,
  // 
  checkBaogao: common.checkBaogao,
  // 小程序展示报告
  zhanShiBaogao: common.zhanShiBaogao,
  // 小程序意见反馈
  weChatAdvice: common.weChatAdvice,
  //小程序直接登录第二次
  goToWeChat: common.goToWeChat,
  // 小程序分享获取游戏信息
  shareGetGames: common.shareGetGames,
  //保存游戏数据
  saveGamesData: common.saveGamesData,
  //验证码兑换
  validationCode: common.validationCode
}