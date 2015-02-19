var routeManagerApp = angular.module('routeManagerApp', ['ngRoute']);

routeManagerApp.controller("RoutesController", function($scope, $http, $routeParams){
  $http.get('/routes').
    success(function(data, status, headers, config) {
      $scope.routes = data;
    }).
    error(function(data, status, headers, config) {
      // log error
    });

  
});

routeManagerApp.controller("StepController", function($scope, $http, $routeParams){
  $http.get('/routes').
    success(function(data, status, headers, config) {
      $scope.routes = data;
    }).
    error(function(data, status, headers, config) {
      // log error
    });

  $scope.selectRoute = function(id){
    $location.path("/route/"+ id)
  }

  
});

routeManagerApp.controller("RouteController", function($scope, $http, $routeParams){

  $http.get('/routes/'+$routeParams.id).
    success(function(data, status, headers, config) {
      $scope.route = data[0];
      console.log($scope.route);
    }).
    error(function(data, status, headers, config) {
      // log error
    });

  
});

routeManagerApp.config(function($routeProvider, $locationProvider) {
        $routeProvider
          .when('/', {
              templateUrl : 'public/routes.html',
              controller  : 'RoutesController'
          })
          .when('/route/:id', {
              templateUrl : 'public/route.html',
              controller  : 'RouteController'
          })
          .when('/step/:id', {
              templateUrl : 'public/step.html',
              controller  : 'StepController'
          });
        //routing DOESN'T work without html5Mode
        // $locationProvider.html5Mode(true);
    });