using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;

class swimmerdafafieldgarminView extends Ui.DataField {

    function initialize() {
        DataField.initialize();
    }

    hidden var distanceValue;
    hidden var elapsedTimeValue;
    hidden var timeValue;

    hidden var is24Hour;
	hidden var isDistanceUnitsMetric;

    //! Set your layout here. Anytime the size of obscurity of
    //! the draw context is changed this will be called.
    function onLayout(dc) {
        populateConfigFromDeviceSettings();
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags ==  (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TwoFieldsLayout(dc));
        // Top right quadrant so we'll use the top right layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
        }
        var label = View.findDrawableById("labelDistance");
        if (label != null) {
            label.setText(Rez.Strings.labelDistance);
        }
        label = View.findDrawableById("labelElapsedTime");
        if (label != null) {
            label.setText(Rez.Strings.labelElapsedTime);
        }
        label = View.findDrawableById("labelTime");
        if (label != null) {
            label.setText(Rez.Strings.labelTime);
        }
        label = View.findDrawableById("labelTimeAmPm");
        if (label != null) {
            label.setText(calculateAmPm());
        }
        label = View.findDrawableById("labelUnits");
        if (label != null) {
            if (!isDistanceUnitsMetric) {
                label.setFont(Gfx.FONT_NUMBER_MEDIUM);
            }
            label.setText(calculateDistanceUnit());
        }
        return true;
    }

    function populateConfigFromDeviceSettings() {
        isDistanceUnitsMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
        is24Hour = System.getDeviceSettings().is24Hour;
    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and save it locally in this method.
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        distanceValue = calculateDistance(info);
        elapsedTimeValue = calculateElapsedTime(info);
        timeValue = calculateTime();
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
        if (is24Hour) {
            return Lang.format("$1$:$2$", [System.getClockTime().hour, System.getClockTime().min.format("%.2d")]);
        } else {
            return Lang.format("$1$:$2$", [calculateAmPmHour(System.getClockTime().hour), System.getClockTime().min.format("%.2d")]);
        }
    }

    function calculateAmPm() {
        if (is24Hour) {
            return "";
        } else {
            return (System.getClockTime().hour < 12) ? "am" : "pm";
        }
    }

    function calculateDistanceUnit() {
        return (isDistanceUnitsMetric ? "m" : "yd");
    }

    function calculateAmPmHour(hour) {
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

        unUpdateValue("valueDistance", distanceValue, Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        unUpdateValue("valueElapsedTime", elapsedTimeValue, Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        unUpdateValue("valueTime", timeValue, Gfx.COLOR_DK_GRAY, Gfx.COLOR_LT_GRAY);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    // Set the foreground color and value
    function unUpdateValue(id, value, whiteBgClr, blackBgClr) {
        var drawable = View.findDrawableById(id);
        if (drawable != null) {
            if (getBackgroundColor() == Gfx.COLOR_BLACK) {
                drawable.setColor(blackBgClr);
            } else {
                drawable.setColor(whiteBgClr);
            }
            drawable.setText(value);
        }
    }
}
