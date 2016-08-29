using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class RPSGGameView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here 
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

	hidden const OPTION_HEIGHT = 30;

	function drawOptions(dc) {
		dc.fillRectangle(10, 0, dc.getWidth(), OPTION_HEIGHT);
		dc.fillRectangle((10 + OPTION_HEIGHT), 0, dc.getWidth(), OPTION_HEIGHT);
		dc.fillRectangle((20 + OPTION_HEIGHT), 0, dc.getWidth(), OPTION_HEIGHT);
		dc.drawBitmap(10, (dc.getWidth()/2), Resource.Bitmap.Rock);
		dc.drawBitmap((10 + OPTION_HEIGHT), (dc.getWidth()/2), Resource.Bitmap.Paper);
		dc.drawBitmap((20 + OPTION_HEIGHT), (dc.getWidth()/2), Resource.Bitmap.Scissors);
		//dc.drawText(x, y, font, text, Gfx.TEXT_JUST)
	}
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
}