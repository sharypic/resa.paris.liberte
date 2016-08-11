#see: https://bootstrap-datepicker.readthedocs.io/en/latest/
((App, Turbolinks) ->
  class App.Datepicker
    constructor: ($element, url) ->
      @$element = $element
      @url = url

    setup: ->
      @makePicker()
      @bindEvents()

    tearDown: -> null

    makePicker: ->
      @datepicker = @$element.datepicker(daysOfWeekDisabled: "5,6")
      @datepicker

    bindEvents: ->
      @datepicker.on('changeDate', @onClick)

    padIntegerWithTwoZero: (str) ->
      "00#{str}".slice(-2)

    onClick: (event) =>
      year = event.date.getFullYear()
      month = event.date.getMonth() + 1
      day = event.date.getDate()

      Turbolinks.visit(@url.replace(':year', year)
                           .replace(':month', @padIntegerWithTwoZero(month))
                           .replace(':day', @padIntegerWithTwoZero(day)))
)(window.App, window.Turbolinks)
