var coursemologyApp = angular.module('coursemologyApp');
coursemologyApp.controller('enrolRequestListController', function($scope, $http, $timeout) {
  $scope.enrolledStudentCount = 0;
  $scope.courseCapacity = 0;
  $scope.availableSeatCount = 0;

  $scope.studentRequests = [];
  $scope.staffRequests = [];
  $scope.loading = false;
  $scope.studentRequestsCheckAll = false;
  $scope.staffRequestsCheckAll = false;

  $scope.alertMessage = null;
  $scope.alertSuccess = null;
  $scope.timeoutPromise = null;

  $scope.updateCourseInfo = function(data) {
    $scope.enrolledStudentCount = data.enrolledStudentCount;
    $scope.courseCapacity = data.courseCapacity;
    $scope.availableSeatCount = data.availableSeatCount;
  };

  $scope.updateList = function() {
    $scope.loading = true;
    var updateCheckedStatus = function(requests) {
      for (request in requests) {
        request.checked = false;
      }
    };
    $http.get(enrol_requests_path)
        .success(function(data) {
          $scope.updateCourseInfo(data);
          $scope.studentRequests = data.student_requests;
          $scope.staffRequests = data.staff_requests;
          updateCheckedStatus($scope.studentRequests);
          updateCheckedStatus($scope.staffRequests);
          $scope.loading = false;
        });
  };

  angular.element(document).ready($scope.updateList);

  $scope.deleteRequest = function(request, fromList) {
    var i = fromList.indexOf(request);
    if (i != -1) {
      // There should be only one request in fromList. So this is safe
      fromList.splice(i, 1);
    }
  };

  $scope.deleteRequestsWithIds = function(fromList, ids) {
    if (ids.constructor === Array && ids.length > 0) {
      fromList
          .filter(function(request) {
            return ids.indexOf(request.id) != -1;
          })
          .forEach(function(request) {
            $scope.deleteRequest(request, fromList);
          });
    }
  };

  $scope.startAlertTimeout = function() {
    if ($scope.timeoutPromise) {
      $timeout.cancel($scope.timeoutPromise);
    }

    $scope.timeoutPromise = $timeout(function() {
      $scope.alertMessage = null;
      $scope.timeoutPromise = null;
    }, 5000);
  };

  $scope.showSuccessAlert = function(msg) {
    $scope.alertMessage = msg;
    $scope.alertSuccess = true;
    $scope.startAlertTimeout();
  };

  $scope.showErrorAlert = function(msg) {
    $scope.alertMessage = msg;
    $scope.alertSuccess = false;
    $scope.startAlertTimeout();
  };

  $scope.deleteButtonClicked = function(request, fromList, isApproved) {
    $http.delete(request.path, {params: {approved: isApproved}})
        .success(function(data) {
          $scope.updateCourseInfo(data);
          $scope.deleteRequest(request, fromList);
          $scope.showSuccessAlert(data.message);
        })
        .error(function(data) {
          $scope.updateCourseInfo(data);
          $scope.showErrorAlert(data.message);
        });
  };

  $scope.checkAll = function(shouldCheckAll, requests) {
    requests.forEach(function(request) {
      request.checked = shouldCheckAll;
    });
  };

  $scope.deleteSelected = function(path, requests, isApproved) {
    var request_ids = requests
        .filter(function(request) {
          return request.checked
        })
        .map(function(request) {
          return request.id
        });
    if (request_ids.length > 0) {
      $http.post(path, {ids: request_ids}, {params: {approved: isApproved}})
          .success(function(data) {
            $scope.updateCourseInfo(data);
            $scope.showSuccessAlert(data.message);
            $scope.deleteRequestsWithIds(requests, data.approved_ids);
          })
          .error(function(data) {
            $scope.updateCourseInfo(data);
            $scope.showErrorAlert(data.message);
            $scope.deleteRequestsWithIds(requests, data.approved_ids);
          });
    }
  };

  $scope.deleteAll = function(path, requests, isApproved) {
    requests.forEach(function(request) {
      request.checked = true;
    });
    $scope.deleteSelected(path, requests, isApproved);
  }
});
