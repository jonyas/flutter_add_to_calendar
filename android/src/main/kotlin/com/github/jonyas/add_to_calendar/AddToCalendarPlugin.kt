package com.github.jonyas.add_to_calendar

import android.app.Activity
import android.content.Intent
import android.provider.CalendarContract
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.text.SimpleDateFormat
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
      val startTime = fromISO8601UTC(call.argument<String>("startTime")!!)

      // optional params
      val location = call.argument<String>("location")
      val description = call.argument<String>("description")
      val endTime = call.argument<String>("endTime")?.let { fromISO8601UTC(it) }
      val isAllDay = call.argument<Boolean>("isAllDay")

      val intent = Intent(Intent.ACTION_EDIT).apply {
        data = CalendarContract.Events.CONTENT_URI
        putExtra(CalendarContract.Events.TITLE, title)
        putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.time)
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

  private fun fromISO8601UTC(dateStr: String): Date {
    val df = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX", Locale.getDefault())
    return df.parse(dateStr)
  }
}
