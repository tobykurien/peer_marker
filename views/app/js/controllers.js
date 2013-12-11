'use strict';

/* Controllers */

var module = angular.module('myApp.controllers', []).
    controller('StudentController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$timeout', function ($scope, AssignmentService, UserService, $timeout) {

            UserService.get().then(function (result) {
                $scope.user = result.data;
            });

            AssignmentService.answers().then(function (result) {
                $scope.answers = result.data;
            });

            var fetch = function () {
                var checkAssignment = $timeout(function () {
                    AssignmentService.fetch().then(function (result) {
                        var data = result.data;
                        if (data.id) {
                            $scope.answer = result.data;
                            $timeout.cancel(checkAssignment);
                        }
                        else {
                            fetch();
                        }
                    })
                }, 2000);
            };

            fetch();

            $scope.submit = function (id, answer) {
                AssignmentService.createAnswer(id, answer).then(function () {
                    $scope.assignment = {};
                });
            };

        }])
    .controller('HomeController', [
        '$location',
        'UserService',
        function ($location, UserService) {
            UserService.get().then(function (result) {
                $location.path(result.data.type)
            });
        }])
    .controller('TeacherController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$location' ,
        '$timeout', function ($scope, AssignmentService, UserService, $location, $timeout) {

            UserService.get().then(function (result) {
                $scope.user = result.data;
                if (!$scope.user.type == "teacher") $location.path('/student');
            });

            AssignmentService.assignments().then(function (result) {
                $scope.assignments = result.data;
            });
        }])        
    .controller('TeacherNewController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$location' ,
        '$timeout', function ($scope, AssignmentService, UserService, $location, $timeout) {
            $scope.create = function (name, question) {
                AssignmentService.create(name, question).then(function (result) {
                    $scope.assignment = result.data;
                    $location.path('/teacher')
                });
            };
        }])        
    .controller('TeacherEditController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$location',
        '$routeParams',
        '$timeout', function ($scope, AssignmentService, UserService, $location, $routeParams, $timeout) {

            AssignmentService.get($routeParams.id).then(function (result) {
                $scope.assignment = result.data;
            });

        	$scope.update = function (id, name, question) {
                AssignmentService.update(id, name, question).then(function (result) {
                    $scope.assignment = result.data;
                    $location.path('/teacher')
                });
            };
        }])        
   .controller('MarkingController', [
        '$scope',
        'UserService',
        'AssignmentService' ,
        '$timeout' ,
        function ($scope, UserService, AssignmentService, $timeout) {
            UserService.get().then(function (result) {
                $scope.user = result.data;
            });

            AssignmentService.fetch().then(function (result) {
                $scope.assignment = result.data;
            });

            var observeMarking = function () {
                var checkMarking = $timeout(function () {
                    AssignmentService.marking().then(function (result) {
                        var data = result.data;
                        console.debug(result.data);
                        $scope.markingData = data;
                        observeMarking();
                    })
                }, 1000);
            };

            observeMarking();
        }])
    .controller('GradingController', [
        '$scope',
        'UserService',
        'AssignmentService',
        function ($scope, UserService, AssignmentService) {
            UserService.get().then(function (result) {
                $scope.user = result.data;
            });

        }]);
