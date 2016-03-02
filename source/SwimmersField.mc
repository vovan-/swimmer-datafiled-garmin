using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

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
    hidden var font;

    //! Constructor
    function initialize()
    {
        font = Ui.loadResource(Rez.Fonts.bigFont);
        DataField.initialize();
    }

    function compute(info) {
        dist = calcDist(info);
        elaps = calcElapsed(info);
    }

    function calcDist(info) {
        if (info != null && info.elapsedDistance != null && info.elapsedDistance > 0) {
            return info.elapsedDistance.format("%.0f");
        }
        return dist;
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
        return elaps;
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    function onUpdate(dc) {
        var bgWt = getBackgroundColor() != Gfx.COLOR_BLACK ;
    	dc.setColor(Gfx.COLOR_TRANSPARENT, getBackgroundColor());
    	dc.clear();
    	dc.setColor((bgWt ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_DK_GRAY), Graphics.COLOR_TRANSPARENT);

    	// Draw labels
		dc.drawText(174, 60, Gfx.FONT_XTINY, "Timer", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(174, 72, Gfx.FONT_XTINY, "Dist m", Gfx.TEXT_JUSTIFY_LEFT);

        // Draw time related labels and values
		dc.drawText(174, 153, Gfx.FONT_XTINY, "TOD", Gfx.TEXT_JUSTIFY_LEFT);
    	outlinedTxt(
    		dc.getWidth()/2,
    		139,
    		Gfx.FONT_NUMBER_HOT, 
    		Lang.format("$1$:$2$", [Toybox.System.getClockTime().hour, Toybox.System.getClockTime().min.format("%.2d")]),
    		Gfx.TEXT_JUSTIFY_CENTER, 
    		bgWt ? Gfx.COLOR_DK_GRAY : Gfx.COLOR_LT_GRAY,
    		bgWt ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE,
    		dc, 
    		1);
    	

    	// Draw values
    	dc.setColor((bgWt ? Gfx.COLOR_BLACK: Gfx.COLOR_WHITE), Graphics.COLOR_TRANSPARENT);
        dc.drawText(215, 73, font, dist, Gfx.TEXT_JUSTIFY_RIGHT);
        outlinedTxt(
        	dc.getWidth()/2,
        	-13,
        	Gfx.FONT_NUMBER_THAI_HOT,
        	elaps,
        	Gfx.TEXT_JUSTIFY_CENTER,
        	bgWt ? 0x101219: Gfx.COLOR_BLUE,
        	bgWt ? Gfx.COLOR_DK_BLUE: Gfx.COLOR_WHITE,
        	dc,
        	2);

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