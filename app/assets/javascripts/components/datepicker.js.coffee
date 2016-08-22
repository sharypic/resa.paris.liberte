# Decorator for bootstrap datetipicker so on click it redirects to an url
# see: https://bootstrap-datepicker.readthedocs.io/en/latest/
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
      @datepicker = @$element.datepicker(
        daysOfWeekDisabled: '0,6'
        weekStart: 1
        language: 'fr',
        todayBtn: 'linked',
        autoclose: true,
        todayHighlight: true
      )
      @datepicker

    bindEvents: ->
      @datepicker.on('changeDate', @onClick)

    padIntegerWithTwoZero: (str) ->
      "00#{str}".slice(-2)

    rewriteUrl: (date) ->
      year = date.getFullYear()
      month = date.getMonth() + 1
      day = date.getDate()

      @url.replace(':year', year)
          .replace(':month', @padIntegerWithTwoZero(month))
          .replace(':day', @padIntegerWithTwoZero(day))

    onClick: (event) => Turbolinks.visit(@rewriteUrl(event.date),
                                         action: 'replace')

)(window.App, window.Turbolinks)
