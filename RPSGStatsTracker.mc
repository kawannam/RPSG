using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as Act;
using Toybox.System as Sys;

class RPSGStatsTracker {

    static const ROCK = 0;
    static const PAPER = 1;
    static const SCISSOR = 2;

    hidden var stats = new [3];
    hidden var info;

    function initialize() {
        stats[ROCK] = 0;
        stats[PAPER] = 0;
        stats[SCISSOR] = 0;
    }

    function found( item, initStat ) {
        stats[item] = initStat;
    }

    function won( item, opponentsStat ) {
        stats[item] += opponentsStat;
    }

    function lost( item, opponentsStat ) {
        stats[item] -= opponentsStat;
    }

    function trackActivityPoints() {
        info = Act.getHistory();
        var minutes = info.activeMinutesDay;
        var total = minutes.total;
        var moderate = minutes.moderate;
        var vigorous = minutes.vigorous;
        //Will have to use time to tell what minutes have been tracked
        //Will have to use get and set properties to tell when last updated
        //Good luck
    }

}