
const dplayer_div = document.getElementById('dplayer');
var dplayer = null;
function play_channel(channel) {
    if (dplayer != null)
        dplayer.destroy();
    dplayer = new DPlayer({
        container: dplayer_div,
        video: channel,
        live: true,
        autoplay: true,
        lang: 'en'
    });
}

var channels_panel = new Vue({
    el: '#channels-panel',
    data: {
        channels: null
    },
    methods: {
        switchChannel: function(channel) {
            play_channel(channel);
        }
    }
})

var first = true;
function update_channels() {
    fetch('/channels/all')
        .then(function(resp) { 
            return resp.json(); 
        }).then(function(channels_info) {
            channels_panel.channels = channels_info.channels;
            if (first && channels_info.channels.length > 0) {
                first = false;
                play_channel(channels_info.channels[0]);
            }
        });
}
update_channels();
setInterval(update_channels, 30000);
