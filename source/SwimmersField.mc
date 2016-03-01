using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;

class SwimmersField extends App.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new SwimmersFieldView() ];
    }
}

class SwimmersFieldView extends Ui.DataField {
    hidden var dist = "0";
    hidden var elaps = "0:00";
	hidden var isMetric = false;
    hidden var is24Hour = true;
    hidden var font;

    //! Constructor
    function initialize()
    {
        font = Ui.loadResource(Rez.Fonts.bigFont);
        isMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
        is24Hour = System.getDeviceSettings().is24Hour;
        DataField.initialize();
    }

    function compute(info) {
        dist = calcDist(info);
        elaps = calcElapsed(info);
    }

    function calcDist(info) {
        if (info != null && info.elapsedDistance != null && info.elapsedDistance > 0) {
            var distInUnit = info.elapsedDistance * (isMetric ? 1 : 1.093);
            var distStr = distInUnit.toString();
            var commaPos = distStr.find(".");
            return distStr.substring(0, commaPos);
        }
        return "0";
    }

    function calcElapsed(info) {
        if (info != null && info.elapsedTime != null && info.elapsedTime > 0) {
            var hours = null;
            var min = info.elapsedTime / 1000 / 60;
            var sec = info.elapsedTime / 1000 % 60;

            if (min >= 60) {
                hours = min / 60;
                min = min % 60;
            }

            if (hours == null) {
                return min.format("%d") + ":" + sec.format("%02d");
            } else {
                return hours.format("%d") + ":" + min.format("%02d");
            }
        }
        return "0:00";
    }

    function calcTime() {
        return Lang.format("$1$:$2$", [is24Hour ? System.getClockTime().hour : calcAmPmHour(System.getClockTime().hour), System.getClockTime().min.format("%.2d")]);
    }

    function calcAmPmHour(hour) {
        if (hour == 0) {
            return 12;
        } else if (hour > 12) {
            return hour - 12;
        }
        return hour;
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    function onUpdate(dc) {
        var bgColor = getBackgroundColor();
    	dc.clear();
    	dc.setColor((bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_DK_GRAY), Graphics.COLOR_TRANSPARENT);

    	// Draw labels
		dc.drawText(174, 60, Gfx.FONT_XTINY, "Timer", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(174, 72, Gfx.FONT_XTINY, "Dist " + (isMetric ? "m" : "yd"), Gfx.TEXT_JUSTIFY_LEFT);

    	// Draw values
    	dc.setColor((bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_BLACK: Gfx.COLOR_WHITE), Graphics.COLOR_TRANSPARENT);
        dc.drawText(215, 73, font, dist, Gfx.TEXT_JUSTIFY_RIGHT);
        outlinedTxt(dc.getWidth()/2, -13, Gfx.FONT_NUMBER_THAI_HOT, elaps, Gfx.TEXT_JUSTIFY_CENTER, (bgColor != Gfx.COLOR_BLACK ? 0x101219: Gfx.COLOR_BLUE), (bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_DK_BLUE: Gfx.COLOR_WHITE), dc, 2);

        // Draw time related labels and values
		dc.setColor((bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_DK_GRAY), Graphics.COLOR_TRANSPARENT);
		dc.drawText(174, 153, Gfx.FONT_XTINY, "TOD", Gfx.TEXT_JUSTIFY_LEFT);
		var amPm = is24Hour ? "" : ((System.getClockTime().hour < 12) ? "am" : "pm");
		dc.drawText(170, 165, Gfx.FONT_MEDIUM, amPm, Gfx.TEXT_JUSTIFY_CENTER);
    	outlinedTxt(dc.getWidth()/2, 139, Gfx.FONT_NUMBER_HOT, calcTime(), Gfx.TEXT_JUSTIFY_CENTER, (bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_DK_GRAY : Gfx.COLOR_LT_GRAY), (bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE), dc, 1);
    }
    
    function outlinedTxt(x, y, f, t, pos, outClr, tClr, dc, delta) {
    	dc.setColor(tClr, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + delta, y, f, t, pos);
        dc.drawText(x - delta, y, f, t, pos);
        dc.drawText(x, y + delta, f, t, pos);
        dc.drawText(x, y - delta, f, t, pos);
    	dc.setColor(outClr, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, f, t, pos);
    }
}