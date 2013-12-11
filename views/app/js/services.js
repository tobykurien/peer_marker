'use strict';

'use strict';

/* Services */

// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('myApp.services', []).value('version', '0.1').factory(
		"AssignmentService", function($http) {
			return {
				answers : function() {
					return $http.get("api/answers");
				},
				assignments: function() {
					return $http.get("api/assignments");
				},
				submissions: function(assignmentId) {
					return $http.get("api/assignment/" + assignmentId + "/answers");
				},
				fetch : function() {
					return $http.get("api/answer");
				},
				create : function(name, question) {
					return $http.post("api/assignment", {
						name : name,
						question : question,
						status : 'EDITING'
					});
				},
				update : function(id, name, question) {
					return $http.put("api/assignment/" + id, {
						id : id,
						name : name,
						question : question
					});
				},
				del : function(id) {
					return $http.delete("api/assignment/" + id);
				},
				get : function(assignmentId) {
					return $http.get("api/assignment/" + assignmentId, null);
				},
				createAnswer : function(id, answer) {
					return $http.post("api/answer", {
						assignment : id,
						answer : answer
					});
				},
				mark : function(assignmentId) {
					return $http.put("api/assignment/" + assignmentId, {
						status : 'MARKING'
					});
				},
				grade : function(assignmentId) {
					return $http.put("api/assignment/" + assignmentId, {
						status : 'GRADING'
					});
				},
				marking : function() {
					return $http.get("api/marking");
				}
			};
		}).factory('UserService', function($http) {
	return {
		get : function() {
			return $http.get("api/user");
		}
	};
});