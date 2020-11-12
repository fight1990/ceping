// 接口文件

var host = ""

var config = {
  // 版本号
  version: "V1.0",
  // host
  host: host,
  // appid
  appid: "wxeb2d317a282841f1",
  // 小程序短信验证接口
  wechatPhone: "https://a.jingsiedu.com/app/wechatPhone.json",
  // 小程序得到验证码登录接口
  wechatLogin: "https://a.jingsiedu.com/app/wechatLogin.json",
  // 小程序游戏保存接口
  saveWechatGames: "https://a.jingsiedu.com/app/saveWechatGames.json",
  // 
  getOpenId: 'https://a.jingsiedu.com/app/getOpenId.json',
  // getOpenId: 'https://a.jingsiedu.com/app/getOpenId.htm',
  // 小程序获取报告进入系统时登录页面左上角
  checkBaogao: "https://a.jingsiedu.com/app/checkBaogao.json",
  // 小程序展示报告
  zhanShiBaogao: "https://a.jingsiedu.com/app/zhanShiBaogao.json",
  // 小程序意见反馈
  weChatAdvice: "https://a.jingsiedu.com/app/weChatAdvice.json",
  // 小程序直接登录第二次
  goToWeChat: "https://a.jingsiedu.com/app/goToWeChat.json",
  // 小程序分享获取游戏信息
  shareGetGames: "https://a.jingsiedu.com/app/shareGetGames.json",
  //保存游戏数据
  saveGamesData: "https://a.jingsiedu.com/app/saveCombinationEvaluation.json",
  //验证码兑换
  validationCode: "https://a.jingsiedu.com/app/validationCode.json",
  //获取最新一组注意力综合测评信息
  getCombinationEvaluationByOpenid: "https://a.jingsiedu.com/app/getCombinationEvaluationByOpenid.json",
  //获取游戏最优数据
  getBestScaleWithGame: "https://a.jingsiedu.com/app/getScale.json"
  
}

module.exports = config