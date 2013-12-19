'use strict';

/* Controllers */

var module = angular.module('myApp.controllers', [])
    .controller('HomeController', [
        '$location',
        'UserService',
        function ($location, UserService) {
            UserService.get().then(function (result) {
                $location.path(result.data.type)
            });
        }])
	.controller('StudentController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$timeout',
        '$location',function ($scope, AssignmentService, UserService, $timeout, $location) {

            UserService.get().then(function (result) {
                $scope.user = result.data;
            });

            AssignmentService.answers().then(function (result) {
                $scope.answers = result.data;
            });

            var fetch = function () {
                var checkAssignment = $timeout(function () {
                    AssignmentService.currentEditing().then(function (result) {
                        var data = result.data;
                        if (data.assignment && data.assignment.id) {
                            $scope.answer = result.data;
                            $timeout.cancel(checkAssignment);
                        }
                        else {
                            fetch();
                        }
                    })
                    AssignmentService.currentMarking().then(function (result) {
                        var data = result.data;
                        if (data.assignment && data.assignment.id) {
                            $scope.marking = result.data;
                            $timeout.cancel(checkAssignment);
                            $location.path("/student/mark")
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
	.controller('StudentMarkController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$timeout',
        '$location',function ($scope, AssignmentService, UserService, $timeout, $location) {
        	function loadPair() {
                AssignmentService.markPair().then(function (result) {
                    $scope.answers = result.data;
                	$scope.formData = {
            			'score': 6,
            			'answer1_id': result.data[0].id,
            			'answer2_id': result.data[1].id,
            			'disable': false
                	}
                });
        	}
        	loadPair();
        	
            $scope.submit = function (formData) {
            	formData.disable = true;
            	AssignmentService.postMarking(formData).then(function (result){
            		if (!result.data.success) {
            			alert('Oops, try saving again ' + result.data.error);
                    	formData.disable = false;
            		} else {
                		// load another pair for marking
                		loadPair();
            		}
            	});
            };

        }])
    .controller('TeacherController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$location' ,
        '$timeout', function ($scope, AssignmentService, UserService, $location, $timeout) {
        	$timeout.cancel();
        	
            UserService.get().then(function (result) {
                $scope.user = result.data;
                if (!$scope.user.type == "teacher") $location.path('/student');
            });

            function loadAssignments(){
                AssignmentService.assignments().then(function (result) {
                    $scope.assignments = result.data;
                    for (var i=0; i < $scope.assignments.length; i++) {
                        if ($scope.assignments[i].status == "EDITING") $scope.assignments[i].rowClass = "success";
                        if ($scope.assignments[i].status == "MARKING") $scope.assignments[i].rowClass = "danger";
                        if ($scope.assignments[i].status == "GRADING") $scope.assignments[i].rowClass = "warning";
                    }
                });
            }
            loadAssignments();
            
            $scope.start = function(id) {
            	if (confirm("Are you sure you want to start this assignment? Current assignment will be stopped.")) {
                    AssignmentService.start(id).then(function (result) {
                        $scope.assignments = result.data;
                		$location.path("/teacher/view/" + id);
                    });
            	}
            }

            $scope.del = function(id) {
            	if (confirm("Are you sure?")) {
                    AssignmentService.del(id).then(function (result) {
                        $scope.assignment = result.data;
                    	loadAssignments();
                    });
            	}
            }
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
    .controller('TeacherViewController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$location',
        '$routeParams',
        '$timeout', function ($scope, AssignmentService, UserService, $location, $routeParams, $timeout) {

        	var observeEditing = function () {
                AssignmentService.submissions($routeParams.id).then(function (result) {
                    $scope.answers = result.data;
                    if ($scope.answers.length > 0) $scope.assignmentId = $scope.answers[0].assignment_id
                });
                if ($location.path().startsWith("/teacher/view/")) $timeout(observeEditing, 1000);
            };        	
            observeEditing();
            
            $scope.view = function(content) {
            	alert(content);
            }

            $scope.mark = function(id) {
            	if (confirm("Are you sure you want to start the peer marking?")) {
                	$timeout.cancel();
                    AssignmentService.mark(id).then(function (result) {
                        $scope.assignments = result.data;
                		$location.path("/teacher/mark/" + id);
                    });
            	}
            }
    	}])        
    .controller('TeacherMarkController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$location',
        '$routeParams',
        '$timeout', function ($scope, AssignmentService, UserService, $location, $routeParams, $timeout) {

            AssignmentService.get($routeParams.id).then(function (result) {
                $scope.assignment = result.data;
            });

            var observeMarking = function () {
                AssignmentService.marking().then(function (result) {
                    var data = result.data;
                    $scope.markingData = [];
                    for (var k in data) {
                    	$scope.markingData[$scope.markingData.length] = {
                    		"answers": data[k],
                    		"evaluations": k
                    	};
                    }
                    if ($location.path().startsWith("/teacher/mark/")) $timeout(observeMarking, 1000);
                })
            };
            observeMarking();
            
            $scope.grade = function(id) {
            	if (confirm("Are you sure you want to stop peer marking and start grading?")) {
                    AssignmentService.grade(id).then(function (result) {
                        $scope.assignments = result.data;
                		$location.path("/teacher/grade/" + id);
                    });
            	}
            }
        }])        
    .controller('TeacherGradeController', [
        '$scope',
        'AssignmentService',
        'UserService',
        '$location',
        '$routeParams',
        '$timeout', function ($scope, AssignmentService, UserService, $location, $routeParams, $timeout) {

            AssignmentService.get($routeParams.id).then(function (result) {
                $scope.assignment = result.data;
            });

            $scope.complete = function(id) {
            	if (confirm("Are you sure you want to apply the selected grades?")) {
            	}
            }
        }])        
   .controller('MarkingController', [
        '$scope',
        'UserService',
        'AssignmentService' ,
        '$timeout' ,
        function ($scope, UserService, AssignmentService, $timeout) {
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
