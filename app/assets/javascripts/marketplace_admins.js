var coursemologyApp = angular.module('coursemologyApp');

coursemologyApp.factory('CoursePayoutData', function(){
  return {
    email: '',
    courses: [],
    coursePurchases: []
  }
});

coursemologyApp
    .controller('emailFormController', function($scope, $http, CoursePayoutData) {
      $scope.errorMessage = '';
      $scope.coursePayoutData= CoursePayoutData;

      $scope.processForm = function($event) {
        $http.get($("#email_input_form").attr('data-action'), {params: {email: $scope.coursePayoutData.email}})
            .success(function(data) {
              $scope.coursePayoutData.courses = data['courses'];
              $scope.errorEmail = '';
            })
            .error(function(data) {
              $scope.errorEmail = data['message'];
            });
        $event.preventDefault();
      }
    });

coursemologyApp
    .controller('coursePayoutsController', function($scope, $http, CoursePayoutData) {
      $scope.resetSelectedCoursePurchase = function() {
        $scope.selectedCoursePurchase = {
          purchase_records: [],
          all_purchases_amount: 0,
          unclaimed_purchases_amount: 0,
          number_of_students: 0,
          capacity: 0
        }
      };

      $scope.coursePayoutData = CoursePayoutData;
      $scope.course = null;
      $scope.selectedCoursePurchase;

      $scope.resetSelectedCoursePurchase();

      $scope.$watch('coursePayoutData.courses', function() {
        if ($scope.coursePayoutData.courses.length > 0) {
          $scope.course = $scope.coursePayoutData.courses[0];
          $scope.$evalAsync(function() {
            $(".selectpicker").selectpicker('refresh');
          });
        } else {
          $scope.course = null;
        }
      });

      $scope.$watch('course', function() {
        $http.get(
            $("#course_selector_for_payout_records").attr('data-action'),
            {params: {email: $scope.coursePayoutData.email, course_id: $scope.course.course_id}})
            .success(function(data) {
              $scope.coursePayoutData.coursePurchases = data.course_purchases;
              if ($scope.coursePayoutData.coursePurchases.length > 0) {
                $scope.selectedCoursePurchase = $scope.coursePayoutData.coursePurchases[0];
              } else {
                $scope.resetSelectedCoursePurchase();
              }
            });
      });

      $scope.selectCoursePurchase = function(coursePurchase) {
        $scope.selectedCoursePurchase = coursePurchase;
      };

      $scope.hasUnclaimedPurchases = function(coursePurchase) {
        return parseFloat(coursePurchase.unclaimed_purchases_amount) > 0;
      }
    });
