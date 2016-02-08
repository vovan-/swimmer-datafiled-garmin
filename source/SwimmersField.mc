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
    hidden var distVal = "0";
    hidden var elapsedVal = "0:00";
	hidden var isMetric = false; 
    hidden var is24Hour = true;
    hidden var font;

    //! Constructor
    function initialize()
    {
        font = Ui.loadResource(Rez.Fonts.bigFont);
        DataField.initialize();
    }

    //! Set your layout here. Anytime the size of obscurity of
    //! the draw context is changed this will be called.
    function onLayout(dc) {
        isMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
        is24Hour = System.getDeviceSettings().is24Hour;
    }

    function compute(info) {
        distVal = calcDist(info);
        elapsedVal = calcElapsed(info);
    }

    function calcDist(info) {
        if (info != null && info.elapsedDistance != null && info.elapsedDistance > 0) {
            var distanceInUnit = info.elapsedDistance * (isMetric ? 1 : 1.093);
            var distanceFullString = distanceInUnit.toString();
            var commaPos = distanceFullString.find(".");
            return distanceFullString.substring(0, commaPos);
        }
        return "0";
    }

    function calcElapsed(info) {
        if (info != null && info.elapsedTime != null && info.elapsedTime > 0) {
            var hours = null;
            var minutes = info.elapsedTime / 1000 / 60;
            var seconds = info.elapsedTime / 1000 % 60;

            if (minutes >= 60) {
                hours = minutes / 60;
                minutes = minutes % 60;
            }

            if (hours == null) {
                return minutes.format("%d") + ":" + seconds.format("%02d");
            } else {
                return hours.format("%d") + ":" + minutes.format("%02d");
            }
        }
        return "0:00";
    }

    function calcTime() {
        if (System.getDeviceSettings().is24Hour) {
            return Lang.format("$1$:$2$", [System.getClockTime().hour, System.getClockTime().min.format("%.2d")]);
        } else {
            return Lang.format("$1$:$2$", [calcAmPmHour(System.getClockTime().hour), System.getClockTime().min.format("%.2d")]);
        }
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
    	dc.setColor(Gfx.COLOR_TRANSPARENT, bgColor);
    	dc.clear();
    	dc.setColor((bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_DK_GRAY), Graphics.COLOR_TRANSPARENT);

    	// Draw labels
		dc.drawText(174, 60, Gfx.FONT_XTINY, "Timer", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(174, 72, Gfx.FONT_XTINY, "Dist", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(200, 72, Gfx.FONT_XTINY, (isMetric ? "m" : "yd"), Gfx.TEXT_JUSTIFY_LEFT);
    	
    	// Draw values
    	dc.setColor((bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_BLACK: Gfx.COLOR_WHITE), Graphics.COLOR_TRANSPARENT);
        dc.drawText(215, 73, font, distVal, Gfx.TEXT_JUSTIFY_RIGHT);
    	//dc.setColor((bgColor != Gfx.COLOR_BLACK ? 0x000070: Gfx.COLOR_BLUE), Graphics.COLOR_TRANSPARENT);
        txtVsOutline(dc.getWidth()/2, -13, Gfx.FONT_NUMBER_THAI_HOT, elapsedVal, Gfx.TEXT_JUSTIFY_CENTER, (bgColor != Gfx.COLOR_BLACK ? 0x101219: Gfx.COLOR_BLUE), (bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_DK_BLUE: Gfx.COLOR_WHITE), dc, 2);
        
        // Draw time related labels and values, if there is enough space on screen for time
        if (dc.getHeight() > 180) {
    		dc.setColor((bgColor != Gfx.COLOR_BLACK ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_DK_GRAY), Graphics.COLOR_TRANSPARENT);
			dc.drawText(174, 153, Gfx.FONT_XTINY, "TOD", Gfx.TEXT_JUSTIFY_LEFT);
			var amPm = is24Hour ? "" : ((System.getClockTime().hour < 12) ? "am" : "pm");
			dc.drawText(170, 165, Gfx.FONT_MEDIUM, amPm, Gfx.TEXT_JUSTIFY_CENTER);
    		//dc.setColor((getBackgroundColor() != Gfx.COLOR_BLACK ? Gfx.COLOR_DK_GRAY : Gfx.COLOR_LT_GRAY), Graphics.COLOR_TRANSPARENT);
        	txtVsOutline(dc.getWidth()/2, 139, Gfx.FONT_NUMBER_HOT, calcTime(), Gfx.TEXT_JUSTIFY_CENTER, (getBackgroundColor() != Gfx.COLOR_BLACK ? Gfx.COLOR_DK_GRAY : Gfx.COLOR_LT_GRAY), (getBackgroundColor() != Gfx.COLOR_BLACK ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE), dc, 1);
        }
    }
    
    function txtVsOutline(x, y, font, text, pos, outClr, txtClr, dc, delta) {
    	dc.setColor(txtClr, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + delta, y, font, text, pos);
        dc.drawText(x - delta, y, font, text, pos);
        dc.drawText(x, y + delta, font, text, pos);
        dc.drawText(x, y - delta, font, text, pos);
    	dc.setColor(outClr, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, text, pos);
    }
}