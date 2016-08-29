using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Math as Math;
using Toybox.Lang as Lang;

class RPSGCommunication extends Ant.GenericChannel {

    hidden const DEVICE_NUMBER = 1;
    hidden const DEVICE_TYPE = 1;
    hidden const FREQUENCY = 57;
    hidden const HIGH_PRIORITY = 2;
    hidden const LOW_PRIORITY = 10;
    hidden const SEARCH_THRESHOLD = 0;
    hidden const TRANSMISSION_TYPE = 0;
    hidden const DEVICE_PERIOD = 8088;

    hidden var chanAssign;
    hidden var deviceConfig;
    hidden var channelHasbeenCreated;

    function initialize() {

        channelHasBeenCreated = false;
        deviceConfig = new Ant.DeviceConfig( {
                :deviceNumber => DEVICE_NUMBER,
                :deviceType => DEVICE_TYPE,
                :transmissionType => TRANSMISSION_TYPE,
                :messagePeriod => DEVICE_PERIOD,
                :radioFrequency => FREQUENCY,
                :searchTimeoutLowPriority => LOW_PRIORITY,
                :searchTimeoutHighPriority => HIGH_PRIORITY,
                :searchThreshold => SEARCH_THRESHOLD
            });
    }

    hidden function createBackgroundChannel() {
            if( channelHasBeenCreated ) {
            GenericChannel.release();
        }
        chanAssign = new Ant.ChannelAssignment(
                Ant.CHANNEL_TYPE_RX_ONLY,
                Ant.NETWORK_PRIVATE );
        chanAssign.setBackgroundScan( true );
        GenericChannel.initialize( method(:onMessage), chanAssign );
        GenericChannel.setDeviceConfig( createDeviceConfig() );
        channelHasBeenCreated = true;
        lastSensorType = sensorType;
        lastDeviceType = deviceType;
        GenericChannel.open();
    }

    function onMessage( msg ) {
        //BattleRequest MessageNumber-Name-Stat
            //GenericChannel.sendBroadcast(data);
        //Player Info MessageNumber-Name-Stat
        //BattleAccept MessageNumber-Accept/Reject
        //Choice MessageNumber-Choice-XP
        //Result MessageNumber-Win/Loss-XP
    }

    function sendBattleRequest() {
        var data = 0;
        GenericChannel.sendBroadcast(data);
    }

}