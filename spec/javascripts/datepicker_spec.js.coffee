# include spec/javascripts/helpers/some_helper_file.js and app/assets/javascripts/foo.js
#= require application

describe 'Datepicker', ->
  url = null
  $element = null

  beforeEach ->
    url = '/rooms/:year/:month/:day'
    $element = $("""<input class="datepicker" />""")

  describe 'new', ->
    it "works", ->
      datepicker = new App.Datepicker($element, url)
      expect(datepicker).not.toBe(null)

    it 'assigns properties', ->
      datepicker = new App.Datepicker($element, url)
      expect(datepicker.url).toBe(url)
      expect(datepicker.$element).toBe($element)

  describe '.makePicker', ->
    it 'instanciate datepicker() on given $element', ->
      datepicker = new App.Datepicker($element, url)
      spyOn($element, 'datepicker')
      datepicker.makePicker()

      expect($element.datepicker)
        .toHaveBeenCalledWith(daysOfWeekDisabled: "5,6")

  describe '.bindEvents', ->
    it 'listens on changeDate', ->
      appDatepicker = new App.Datepicker($element, url)
      BS3Datepicker = appDatepicker.makePicker()
      spyOn(BS3Datepicker, 'on')

      appDatepicker.bindEvents()

      expect(BS3Datepicker.on).toHaveBeenCalledWith('changeDate',
                                                    appDatepicker.onClick)
  describe '.rewriteUrl', ->
    it 'replace :year, :month, :day with date values', ->
      appDatepicker = new App.Datepicker($element, url)
      date = new Date()

      expect(appDatepicker.rewriteUrl(date))
        .toEqual([
                    '/rooms',
                    date.getFullYear(),
                    appDatepicker.padIntegerWithTwoZero(date.getMonth() + 1),
                    appDatepicker.padIntegerWithTwoZero(date.getDate())
                  ].join("/"))

  describe '.onClick', ->
    it 'delegates visit to turbolink', ->
      spyOn(window.Turbolinks, 'visit')
      datepicker = new App.Datepicker($element, url)
      event = date: new Date()
      datepicker.onClick(event)

      expect(window.Turbolinks.visit)
        .toHaveBeenCalledWith(datepicker.rewriteUrl(event.date))
