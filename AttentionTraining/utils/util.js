const formatTime = date => {
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours()
  const minute = date.getMinutes()
  const second = date.getSeconds()

  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

const formatNumber = n => {
  n = n.toString()
  return n[1] ? n : '0' + n
}

function sortArray(arr) {
  for(let i = 0,len = arr.length; i < len; i++){
    let currentRandom = parseInt(Math.random() * (len - 1));
    let current = arr[i];
    arr[i] = arr[currentRandom];
    arr[currentRandom] = current;
  }
  return arr
}

module.exports = {
  formatTime: formatTime,
  sortArray: sortArray
}
