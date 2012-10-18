$ ->


  $('#schedule-form').modal({
    show: false,
    backdrop: true
  })

  $('#schedule-form').on('hide',
    ->
      $(this).children(".modal-body").html('')
  )

  $(".edit-schedule").live("click",
    ->
      $.get(
        $(this).attr("href"),
        (data) ->
          $("#schedule-form .modal-body").html(data)
          $("#update-schedule").show()
          $('#schedule-form').modal('show')
      )

      false
  )

  $("#update-schedule").live("click", 
    ->
      #$("#schedule-form").find("form:first").submit()

      $.ajax(
        type: 'PUT',
        url: $("#schedule-form").find("form:first").attr("action"),
        data: parse_schedule_form(),
        success: (data) ->
          period = $(".period[schedule_id=#{data.schedule_id}]")
          period.find(".from").text(data.start_time)
          period.find(".to").text(data.end_time)
          period.find(".sale").text("#{data.sale}%")
          $("#schedule-form").modal("hide")
          $("#update-schedule").hide()
      )
  )

  $("#new-schedule").bind("click",
    ->
      $.get(
        $(this).attr("href"),
        (data) ->
          $("#schedule-form .modal-body").html(data)
          $("#create-schedule").show()
          $('#schedule-form').modal('show')
      )

      false
  )

  $("#create-schedule").bind("click"
    ->
      $.ajax(
        type: 'POST',
        url: $("#schedule-form").find("form:first").attr("action"),
        data: parse_schedule_form(),
        success: (data) ->
          

          $.get(
            "/account/schedules?place_id=#{data.place_id}",
            (data) ->
              $("#schedule").html(data)
          )

          $("#schedule-form").modal("hide")
          $("#create-schedule").hide()
      )

      false
  )

  window.parse_schedule_form = ->
    start_hour = $("#schedule_start_time_4i").val()
    start_minute = $("#schedule_start_time_5i").val()

    end_hour = $("#schedule_end_time_4i").val()
    end_minute = $("#schedule_end_time_5i").val()

    sale = $("#schedule_sale").val()

    fields = {
      'schedule[start_time]': "#{start_hour}:#{start_minute}",
      'schedule[end_time]': "#{end_hour}:#{end_minute}",
      'schedule[sale]': sale
    }

    if $("#schedule_day_of_week")
      fields['schedule[day_of_week]'] = $("#schedule_day_of_week").val()

    if $("#schedule_place_id")
      fields['schedule[place_id]'] = $("#schedule_place_id").val()

    fields