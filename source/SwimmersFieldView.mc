using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;

class SwimmersFieldView extends Ui.DataField {

    function initialize() {
        DataField.initialize();
    }

    hidden var distVal;
    hidden var elapsedVal;

	hidden var isDistanceUnitsMetric;

    //! Set your layout here. Anytime the size of obscurity of
    //! the draw context is changed this will be called.
    function onLayout(dc) {
        isDistanceUnitsMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;

        // Top left quadrant so we'll use the top left layout
        if (DataField.getObscurityFlags() == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TwoFieldsLayout(dc));
        // Top right quadrant so we'll use the top right layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
        }

        setLabelText("lDist", "Distance");
        setLabelText("lElapsed", "Timer");
        setLabelText("lTime", "TOD");
        setLabelText("lTimeAmPm", System.getDeviceSettings().is24Hour ? "" :
            ((System.getClockTime().hour < 12) ? "am" : "pm"));
        var label = View.findDrawableById("lUnits");
        if (label != null) {
            label.setColor(Gfx.COLOR_DK_GRAY);
            if (!isDistanceUnitsMetric) {
                label.setFont(Gfx.FONT_NUMBER_MEDIUM);
            }
            label.setText((isDistanceUnitsMetric ? "m" : "yd"));
        }

        return true;
    }

    function setLabelText(id, value) {
      var label = View.findDrawableById(id);
      if (label != null) {
        label.setColor(Gfx.COLOR_DK_GRAY);
        label.setText(value);
      }
    }

    //! The given info object contains all the current workout
    //! information. calc a value and save it locally in this method.
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        distVal = calculateDistance(info);
        elapsedVal = calculateElapsedTime(info);
    }

    function calculateDistance(info) {
        if (info.elapsedDistance != null && info.elapsedDistance > 0) {
            var distanceInUnit = info.elapsedDistance * (isDistanceUnitsMetric ? 1 : 1.093);
            var distanceFullString = distanceInUnit.toString();
            var commaPos = distanceFullString.find(".");
            return distanceFullString.substring(0, commaPos);
        }
        return "0";
    }
    
       
    function calculateElapsedTime(info) {
        if (info.elapsedTime != null && info.elapsedTime > 0) {
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

    function calculateTime() {
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
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());
        setVal("vDist", distVal, Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        setVal("vElapsed", elapsedVal, Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        setVal("vTime", calculateTime(), Gfx.COLOR_DK_GRAY, Gfx.COLOR_LT_GRAY);
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    // Set the foreground color and value
    function setVal(id, value, whiteBgClr, blackBgClr) {
        var drawable = View.findDrawableById(id);
        if (drawable != null && value != null) {
            drawable.setColor(getBackgroundColor() == Gfx.COLOR_BLACK ? blackBgClr : whiteBgClr);
            drawable.setText(value);
        }
    }
}
