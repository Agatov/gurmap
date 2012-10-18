class window.AccountPhotoUploader

  constructor: (options, input_el) ->
    @upload_params = options
    @input_el = $(input_el)
    @url = @input_el.attr('rel')

  initialize: ->

    total_size = 0
    bytes_upload = 0

    @input_el.uploadify({
      'uploader': '/assets/uploadify.swf',
      'script': @url,
      'fileDataName': 'photo[image]',
      'fileExt': '*.png;*.jpg;*.gif',
      'cancelImg': '/images/cancel.png',
      'multi': true,
      'scriptData': @upload_params,
      'auto': true,
      onSelect: (event, id, file_obj) ->
        total_size += file_obj.size
        $("#photo-upload-progress").show()

      onComplete: (e, id, file_obj, response, data) ->
        $("#photos").append(response)
        bytes_upload += file_obj.size

      onProgress: (event, id, file_obj, data) ->
        progress = (data.bytesLoaded + bytes_upload) / total_size
        $("#photo-upload-progress .bar").css("width", "#{progress*100}%")

      onAllComplete: (event, data) ->
        $("#photo-upload-progress").hide()
        $("#photo-upload-container").hide()
        $('#toggle-photo-upload-container').show()
    })

$ ->
  $(".photo-item").live('mouseover'
    ->
      slide = $(this).children(".slide2")
      slide.show()
  )
  $(".photo-item").live('mouseout'
    ->
      slide = $(this).children(".slide2")
      slide.hide()
  )

  $(".remove-photo").live("click",
    ->
      $.ajax(
        type: "DELETE"
        url: $(this).attr('rel')
        success: (data) ->
          if data.status == 'ok'
            $(".photo-item[photo-id=" + data.id + "]").remove()
      )
  )
