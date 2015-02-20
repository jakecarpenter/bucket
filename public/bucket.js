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

routeManagerApp.controller("RouteNavController", function($scope, $http, $routeParams, $location){
  $scope.addRoute = function(){
    $location.path("/route/add");
  }
  
});

routeManagerApp.controller("StepController", function($scope, $http, $routeParams, $location){
  $scope.addStep = function(){
    var step = {
      cast: $scope.cast ,
      startMile: $scope.startMile ,
      endMile: $scope.endMile ,
      instruction: $scope.instruction ,
      notes: $scope.notes
    };

    $http.post('/routes/'+ $routeParams.id +'/steps', step).
      success(function(data, status, headers, config){
        $location.path("/route/"+$routeParams.id);
      })
    error(function(data, status, headers, config) {
      // log error
    });
  }

  
});

routeManagerApp.controller("RouteController", function($scope, $http, $routeParams, $location){

  $http.get('/routes/'+$routeParams.id).
    success(function(data, status, headers, config) {
      $scope.route = data[0];
      console.log($scope.route);
    }).
    error(function(data, status, headers, config) {
      // log error
    });
  $scope.addStep = function(){
    $location.path("/route/"+$routeParams.id+"/step/add");
  }
  $scope.newRoute = function(){
    var route = {
      startMile: $scope.startMile,
      startTime: $scope.startTime,
      name: $scope.name,
      description: $scope.description
    };

    $http.post('/routes', route).
      success(function(data, status, headers, config){
        $location.path("/route/"+data.id);
      })
    error(function(data, status, headers, config) {
      // log error
    });
  }
  
});

routeManagerApp.config(function($routeProvider, $locationProvider) {
        $routeProvider
          .when('/', {
              templateUrl : 'public/routes.html',
              controller  : 'RoutesController'
          })
          .when('/route/add', {
              templateUrl : 'public/route_add.html',
              controller  : 'RouteController'
          })
          .when('/route/:id', {
              templateUrl : 'public/route.html',
              controller  : 'RouteController'
          })
          .when('/route/:id/step/add', {
              templateUrl : 'public/step_add.html',
              controller  : 'StepController'
          });
        //routing DOESN'T work without html5Mode
        // $locationProvider.html5Mode(true);
    });