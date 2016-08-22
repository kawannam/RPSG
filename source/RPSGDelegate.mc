using Toybox.WatchUi as Ui;

class RPSGDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new RPSGMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}