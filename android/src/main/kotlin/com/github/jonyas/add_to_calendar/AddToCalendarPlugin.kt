package com.github.jonyas.add_to_calendar

import android.app.Activity
import android.content.Intent
import android.provider.CalendarContract
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

class AddToCalendarPlugin(private val activity: Activity) : MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "add_to_calendar")
      channel.setMethodCallHandler(AddToCalendarPlugin(registrar.activity()))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "addToCalendar") {
      // compulsory params
      val title = call.argument<String>("title")!!
      val startTime = Date(call.argument<Long>("startTime")!!)

      // optional params
      val location = call.argument<String>("location")
      val description = call.argument<String>("description")
      val endTime = call.argument<Long>("endTime")?.let { Date(it) }
      val isAllDay = call.argument<Boolean>("isAllDay")
      val frequency = call.argument<Int>("frequency")
      val frequencyType = call.argument<String>("frequencyType")?.capitalize().let {
        frequencyTypeName -> FrequencyType.values().firstOrNull { it.toString() == frequencyTypeName }
      }
      val rrule = toRRule(frequency, frequencyType)

      val intent = Intent(Intent.ACTION_EDIT).apply {
        data = CalendarContract.Events.CONTENT_URI
        putExtra(CalendarContract.Events.TITLE, title)
        putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.time)
        if (rrule != null) putExtra("rrule", rrule)
        if (location?.isNotEmpty() == true) putExtra(CalendarContract.Events.EVENT_LOCATION, location)
        if (description?.isNotEmpty() == true) putExtra(CalendarContract.Events.DESCRIPTION, description)
        if (endTime != null) putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.time)
        if (isAllDay != null) putExtra(CalendarContract.EXTRA_EVENT_ALL_DAY, isAllDay)
      }

      activity.startActivity(intent)
      result.success(true)
    } else {
      result.notImplemented()
    }
  }

  private fun toRRule(frequency: Int?, frequencyType: FrequencyType?): String? {
    if (frequency == null || frequencyType == null)
      return null
    // For some reason, weekly intervals only work for frequency 1. Add daily multiplier
    return when (frequencyType) {
      FrequencyType.WEEKLY -> {
        if (frequency == 1)
          "FREQ=${frequencyType.name};INTERVAL=$frequency"
        else
          "FREQ=${FrequencyType.DAILY.name};INTERVAL=${frequency * 7}"
      }
      else -> "FREQ=${frequencyType.name};INTERVAL=$frequency"
    }
  }
}
