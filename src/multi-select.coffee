hash_key = (item)->
  angular.toJson(item)

difference = (a, b)->
  return a unless b && a
  hash = {}
  hash[hash_key(b_element)] = true for b_element in b
  a.filter ((a_element)-> not hash[hash_key(a_element)])

angular.module('angular-w').filter 'exclude', ->
  (input, selected) ->
    input.filter (item)->
      selected.indexOf(item) < 0

angular.module("angular-w")
.directive "wMultiSelect", ['$window', ($window) ->
    restrict: "A"
    scope:
      invalid: '='
      items: '='
      keyAttr: '@'
      valueAttr: '@'
      disabled: '@'
      freetext: '@'
    require: '?ngModel'
    replace: true
    transclude: true
    templateUrl: "/templates/multi-select.html"
    controller: ($scope, $element, $attrs) ->
      unless $scope.freetext
        valueAttr = () -> $scope.valueAttr || "label"
        keyAttr = () -> $scope.valueAttr || "id"

        $scope.getItemLabel = (item)-> item && item[valueAttr()]
        $scope.getItemValue = (item)-> item && item[keyAttr()]

        updateDropDown = ->
          if $scope.search
            items = filter($scope.search, $scope.items, valueAttr())
          else
            items = $scope.items

          $scope.shownItems = difference(items, $scope.selectedItems)
          $scope.activeItem = $scope.shownItems[0]
      else
        $scope.getItemLabel = (item)-> item
        $scope.getItemValue = (item)-> item

        updateDropDown = ->
          $scope.shownItems = filter($scope.search, $scope.items)

          if $scope.shownItems.indexOf($scope.search) < 0
            $scope.shownItems.push($scope.search)

          $scope.activeItem = $scope.shownItems[0]

      $scope.selectItem = (item)->
        if item? and indexOf($scope.selectedItems, item) == -1
          $scope.selectedItems.push(item)

        $scope.search = ""
        updateDropDown()

      $scope.unselectItem = (item)->
        index = indexOf($scope.selectedItems, item)
        if index > -1
          $scope.selectedItems.splice(index, 1)
          updateDropDown()

      $scope.move = (d) ->
        $scope.highlightIndex = Math.abs($scope.highlightIndex + d)

      $scope.onEnter = (event) ->
        $scope.selectItem($scope.activeItem)
        false

      $scope.onPgup = (event) ->
        $scope.move(-11)
        false

      $scope.onPgdown = (event) ->
        $scope.move(11)
        false

      # TODO move to init
      $scope.selectedItems = []
      $scope.active = false
      $scope.highlightIndex = 0

    link: ($scope, element, attrs, ngModelCtrl, transcludeFn) ->
      if ngModelCtrl
        setViewValue = (newValue, oldValue)->
          unless angular.equals(newValue, oldValue)
            ngModelCtrl.$setViewValue($scope.selectedItems)

        $scope.$watch 'selectedItems', setViewValue, true

        ngModelCtrl.$render = ->
          $scope.selectedItems = ngModelCtrl.$modelValue || []

      # TODO: make this a separate directive
      scroll = ->
        delayedScrollFn = ->
          ul = element.find('ul')[0]
          li = ul.querySelector('li.active')
          scrollToTarget(ul, li)
        setTimeout(delayedScrollFn, 0)
  ]
