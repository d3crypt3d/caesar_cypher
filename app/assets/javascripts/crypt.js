// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
angular.module('crypt', ['ui.chart'])
.controller('MainCtrl', ['$http', function($http) {
  var self = this;

  function helperMethod(response) {
    var frequencyArr = response.data.frequency;
    var frequencyArrLength = frequencyArr.length;
    if (frequencyArrLength) self.cryptChart = [frequencyArr]; 
  }

  self.validate = /^\d{1,3}$/;
  self.encrypt = function() {
    $http.post('/encrypt',
               {'crypt': {'text': self.plain, 'shift':self.rot}})
      .then(function(response) {
        self.encrypted = response.data.encrypted;
        self.plain = '';
        helperMethod(response);
        //HelperMethods.populateArray(response);
      });
  };
  self.decrypt = function() {
    $http.post('/decrypt',
               {'crypt': {'text': self.encrypted, 'shift':self.rot}})
      .then(function(response) {
        self.plain = response.data.plain;
        self.encrypted = '';
        helperMethod(response);
        //HelperMethods.populateArray(response);
      });
  };
  self.cryptChart = [[
      ['Foo',4], ['Bar',3], ['Baz',2], ['Qux',1]
    ]];
  self.chartOptions = {
    title: 'Frequency analisys',
    seriesDefaults: {
      // Make this a Bar chart
      renderer: jQuery.jqplot.BarRenderer,
      rendererOptions: {
        varyBarColor: true
      }
    },
    axes: {
      xaxis: {
        renderer: jQuery.jqplot.CategoryAxisRenderer
      }
    }
  };
}])
//.factory('HelperMethods', [function() {
//  return {
//    populateArray: function(response) {
//      var frequencyArr = response.data.frequency;
//      var frequencyArrLength = frequencyArr.length;
//      if (frequencyArrLength) MainCtrl.cryptChart = [frequencyArr]; 
//    }
//  };
//}])
.config(['$httpProvider', function($httpProvider) {
  $httpProvider.defaults.headers.common['Accept'] = 'application/json';
  $httpProvider.defaults.headers.post['Content-Type'] = 'application/json';
}]);

