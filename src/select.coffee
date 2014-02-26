angular
.module("formstamp")
.directive "fsSelect", ['$compile', ($compile) ->
  restrict: "A"
  scope:
    invalid: '='
    items: '='
    limit: '='
    disabled: '='
    keyAttr: '@'
    freetext: '@'
    valueAttr: '@'
    class: '@'
  require: '?ngModel'
  replace: true
  template: (el)->
    itemTpl = el.html()
    template = """
<div class='fs-select fs-widget-root'>
  <div ng-hide="active" class="fs-select-sel" ng-class="{'btn-group': item}">
      <a class="btn btn-default fs-select-active"
         ng-class='{"btn-danger": invalid}'
         href="javascript:void(0)"
         ng-click="active = true"
         ng-disabled="disabled">
           <span ng-show='item'>#{itemTpl}</span>
           <span ng-hide='item'>none</span>
      </a>
      <button type="button"
              class="btn btn-default fs-select-clear-btn"
              aria-hidden="true"
              ng-show='item'
              ng-disabled="disabled"
              ng-click='unselectItem()'>&times;</button>
    </div>
  <div class="open" ng-show="active">
    <input class="form-control"
           fs-input='123'
           fs-focus-when='active'
           fs-on-blur='active = false'
           fs-hold-focus=''

           fs-down='move(1)'
           fs-up='move(-1)'
           fs-pgup='move(-11)'
           fs-pgdown='move(11)'
           fs-enter='onEnter($event)'
           type="search"
           placeholder='Search'
           ng-model="search" />
    <div ng-if="active && dropdownItems.length > 0">
      <div fs-list items="dropdownItems">
       #{itemTpl}
      </div>
    </div>
  </div>
</div>
    """

  controller: ($scope, $element, $attrs, $filter, $timeout) ->
    $scope.active = false

    if $scope.freetext
      $scope.getItemLabel = (item)-> item
      $scope.getItemValue = (item)-> item
      $scope.dynamicItems = ->
        if $scope.search then [$scope.search] else []
    else
      valueAttr = () -> $scope.valueAttr || "label"
      keyAttr = () -> $scope.valueAttr || "id"

      $scope.getItemLabel = (item)-> item && item[valueAttr()]
      $scope.getItemValue = (item)-> item && item[keyAttr()]
      $scope.dynamicItems = -> []

    $scope.$watch 'search', (q)->
      $scope.dropdownItems = $filter('filter')($scope.items, $scope.search).concat($scope.dynamicItems())

    $scope.selectItem = (item)->
      $scope.item = item
      $scope.search = ""
      $scope.active = false

    $scope.unselectItem = (item)->
      $scope.item = null

    $scope.onBlur = () ->
      $timeout((-> $scope.active = false), 0, true)

    $scope.move = (d) ->
      $scope.listInterface.move && $scope.listInterface.move(d)

    $scope.onEnter = (event) ->
      $scope.selectItem($scope.listInterface.selectedItem)

    $scope.listInterface =
      onSelect: (selectedItem) ->
        $scope.selectItem(selectedItem)

      move: () ->
        console.log "not-implemented listInterface.move() function"

  link: (scope, element, attrs, ngModelCtrl, transcludeFn) ->
    if ngModelCtrl
      scope.$watch 'item', (newValue, oldValue) ->
        if newValue isnt oldValue
          ngModelCtrl.$setViewValue(scope.item)

      ngModelCtrl.$render = ->
        scope.item = ngModelCtrl.$viewValue
]