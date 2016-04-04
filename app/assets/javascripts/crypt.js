// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
angular.module('crypt', [])
.controller('MainCtrl', ['$http', function($http) {
  var self = this;
  self.encrypt = function() {
    $http.post('/encrypt',
               {'crypt': {'text': self.plain, 'shift':self.rot}})
      .then(function(response) {
        self.encrypted = response.data.encrypted;
        self.plain = '';
      });
  };
  self.decrypt = function() {
    $http.post('/decrypt',
               {'crypt': {'text': self.encrypted, 'shift':self.rot}})
      .then(function(response) {
        self.plain = response.data.plain;
        self.encrypted = '';
      });
  };
}])
.config(['$httpProvider', function($httpProvider) {
  $httpProvider.defaults.headers.common['Accept'] = 'application/json';
  $httpProvider.defaults.headers.post['Content-Type'] = 'application/json';
}]);
