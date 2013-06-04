// dep1-for-moduleA.js
define(function () {

  var randomNumber = function () {
    return Math.floor(Math.random() * 10) + 1;
  };

  return randomNumber;
  
});
