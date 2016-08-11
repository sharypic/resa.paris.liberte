# include spec/javascripts/helpers/some_helper_file.js and app/assets/javascripts/foo.js
#= require application

describe 'Datepicker', ->
  url = null
  $element = null

  beforeEach ->
    url = 'url'
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
    it 'call datepicker() on given $element', ->
      datepicker = new App.Datepicker($element, url)
      spyOn($element, 'datepicker')
      datepicker.makePicker()

      expect($element.datepicker)
        .toHaveBeenCalledWith(daysOfWeekDisabled: "5,6")

    it 'bind events', ->
      appDatepicker = new App.Datepicker($element, url)
      BS3Datepicker = appDatepicker.makePicker()
      spyOn(BS3Datepicker, 'on')

      appDatepicker.bindEvents()

      expect(BS3Datepicker.on).toHaveBeenCalledWith('changeDate',
                                                    appDatepicker.onClick)

  describe '.onClick', ->
    it 'delegates visit to turbolink', ->
      spyOn(window.Turbolinks, 'visit')
      datepicker = new App.Datepicker($element, url)

      datepicker.onClick()

      expect(window.Turbolinks.visit).toHaveBeenCalledWith(url)
