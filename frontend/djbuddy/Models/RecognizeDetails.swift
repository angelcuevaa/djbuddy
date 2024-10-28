//
//  RecognizeDetails.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/18/24.
//

//
//  TrackDetails.swift
//  djbuddy
//
//  Created by Angel Cueva on 10/10/24.
//
//

import Foundation

struct RecognizeDetails: Codable {
    let matches: Array<Match>
    let track: Track?
    let tagid: String?

}
struct Match: Codable{
    let id: String
    let offset: Float
    let timeskew: Float
    let frequencyskew : Float
}
struct Track: Codable{
    let layout: String
    let type: String
    let key: String
    let title : String
    let subtitle: String
    let isrc: String
    let images: ImageObj
    let genres: Genre
    let share: ShareObj



}
struct ImageObj: Codable{
    let background: String
    let coverart: String
    let coverarthq : String
    let joecolor: String
}
struct Genre: Codable{
    let primary: String
}
struct ShareObj: Codable{
    let avatar: String
    let href: String
    let html : String
    let image: String
    let snapchat: String
    let subject: String
    let text : String
    let twitter: String

}


//    let camelot: String
//{"matches":[{"id":"431256154","offset":20.131626952999998,"timeskew":0.016396046,"frequencyskew":0.00068485737},{"id":"328984401","offset":15.932855468,"timeskew":0.017403722,"frequencyskew":0.000874877},{"id":"292396142","offset":19.56571289,"timeskew":0.004355073,"frequencyskew":0.0017198324},{"id":"316447162","offset":3.360868652,"timeskew":0.0018868446,"frequencyskew":0.0013298988},{"id":"309568277","offset":20.323578125,"timeskew":0.018686295,"frequencyskew":0.00012087822},{"id":"311791233","offset":3.423260253,"timeskew":-0.0016030669,"frequencyskew":-0.0006441474},{"id":"337441473","offset":19.593585937,"timeskew":0.007925034,"frequencyskew":0.0003222227}],"location":{"accuracy":0.01},"timestamp":2690777959,"timezone":"Europe/Moscow","track":{"layout":"5","type":"MUSIC","key":"276475110","title":"Ocean Drive","subtitle":"Duke Dumont","images":{"background":"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/26/c0/a5/26c0a5a4-758f-a033-1f10-c32f1aabf79f/pr_source.png/800x800cc.jpg","coverart":"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/5c/10/0e/5c100e40-fb5d-f974-7abb-9d0c3eebef9e/19UMGIM92121.rgb.jpg/400x400cc.jpg","coverarthq":"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/5c/10/0e/5c100e40-fb5d-f974-7abb-9d0c3eebef9e/19UMGIM92121.rgb.jpg/400x400cc.jpg","joecolor":"b:010101p:e7e7e7s:ff0808t:b9b9b9q:cc0606"},"share":{"subject":"Ocean Drive - Duke Dumont","text":"Ocean Drive by Duke Dumont","href":"https://www.shazam.com/track/276475110/ocean-drive","image":"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/5c/10/0e/5c100e40-fb5d-f974-7abb-9d0c3eebef9e/19UMGIM92121.rgb.jpg/400x400cc.jpg","twitter":"I used @Shazam to discover Ocean Drive by Duke Dumont.","html":"https://www.shazam.com/snippets/email-share/276475110?lang=en-US&country=GB","avatar":"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/26/c0/a5/26c0a5a4-758f-a033-1f10-c32f1aabf79f/pr_source.png/800x800cc.jpg","snapchat":"https://www.shazam.com/partner/sc/track/276475110"},"hub":{"type":"APPLEMUSIC","image":"https://images.shazam.com/static/icons/hub/android/v5/applemusic_{scalefactor}.png","actions":[{"name":"apple","type":"applemusicplay","id":"1499516628"},{"name":"apple","type":"uri","uri":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/82/5b/ad/825bad09-bc60-3bd1-6f92-0a827130c813/mzaf_6719813418316234038.plus.aac.ep.m4a"}],"options":[{"caption":"OPEN IN","actions":[{"name":"hub:applemusic:deeplink","type":"intent","uri":"intent://music.apple.com/gb/album/ocean-drive/1499516437?i=1499516628&mttnagencyid=s2n&mttnsiteid=125115&mttn3pid=Apple-Shazam&mttnsub1=Shazam_android_am&mttnsub2=5348615A-616D-3235-3830-44754D6D5973&itscg=30201&app=music&itsct=Shazam_android_am#Intent;scheme=http;package=com.apple.android.music;action=android.intent.action.VIEW;end"},{"name":"hub:applemusic:connect","type":"applemusicconnect","id":"1499516628","uri":"https://unsupported.shazam.com"},{"name":"hub:applemusic:androidstore","type":"uri","uri":"https://play.google.com/store/apps/details?id=com.apple.android.music&referrer=utm_source=https%3A%2F%2Fmusic.apple.com%2Fsubscribe%3Fmttnagencyid%3Ds2n%26mttnsiteid%3D125115%26mttn3pid%3DApple-Shazam%26mttnsub1%3DShazam_android_am%26mttnsub2%3D5348615A-616D-3235-3830-44754D6D5973%26itscg%3D30201%26app%3Dmusic%26itsct%3DShazam_android_am"}],"beacondata":{"type":"open","providername":"applemusic"},"image":"https://images.shazam.com/static/icons/hub/android/v5/overflow-open-option_{scalefactor}.png","type":"open","listcaption":"Open in Apple Music","overflowimage":"https://images.shazam.com/static/icons/hub/android/v5/applemusic-overflow_{scalefactor}.png","colouroverflowimage":false,"providername":"applemusic"}],"providers":[{"caption":"Open in Spotify","images":{"overflow":"https://images.shazam.com/static/icons/hub/android/v5/spotify-overflow_{scalefactor}.png","default":"https://images.shazam.com/static/icons/hub/android/v5/spotify_{scalefactor}.png"},"actions":[{"name":"hub:spotify:searchdeeplink","type":"uri","uri":"spotify:search:Ocean%20Drive%20Duke%20Dumont"}],"type":"SPOTIFY"},{"caption":"Open in YouTube Music","images":{"overflow":"https://images.shazam.com/static/icons/hub/android/v5/youtubemusic-overflow_{scalefactor}.png","default":"https://images.shazam.com/static/icons/hub/android/v5/youtubemusic_{scalefactor}.png"},"actions":[{"name":"hub:youtubemusic:androiddeeplink","type":"uri","uri":"https://music.youtube.com/search?q=Ocean+Drive+Duke+Dumont&feature=shazam"}],"type":"YOUTUBEMUSIC"},{"caption":"Open in Deezer","images":{"overflow":"https://images.shazam.com/static/icons/hub/android/v5/deezer-overflow_{scalefactor}.png","default":"https://images.shazam.com/static/icons/hub/android/v5/deezer_{scalefactor}.png"},"actions":[{"name":"hub:deezer:searchdeeplink","type":"uri","uri":"deezer-query://www.deezer.com/play?query=%7Btrack%3A%27Ocean+Drive%27%20artist%3A%27Duke+Dumont%27%7D"}],"type":"DEEZER"}],"explicit":false,"displayname":"APPLE MUSIC"},"sections":[{"type":"SONG","metapages":[{"image":"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/26/c0/a5/26c0a5a4-758f-a033-1f10-c32f1aabf79f/pr_source.png/800x800cc.jpg","caption":"Duke Dumont"},{"image":"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/5c/10/0e/5c100e40-fb5d-f974-7abb-9d0c3eebef9e/19UMGIM92121.rgb.jpg/400x400cc.jpg","caption":"Ocean Drive"}],"tabname":"Song","metadata":[{"title":"Album","text":"Duality"},{"title":"Label","text":"EMI"},{"title":"Released","text":"2015"}]},{"type":"RELATED","url":"https://cdn.shazam.com/shazam/v3/en-US/GB/android/-/tracks/track-similarities-id-276475110?startFrom=0&pageSize=20&connected=","tabname":"Related"}],"url":"https://www.shazam.com/track/276475110/ocean-drive","artists":[{"id":"42","adamid":"257148267"}],"isrc":"GBUM71504503","genres":{"primary":"Electronic"},"urlparams":{"{tracktitle}":"Ocean+Drive","{trackartist}":"Duke+Dumont"},"highlightsurls":{},"relatedtracksurl":"https://cdn.shazam.com/shazam/v3/en-US/GB/android/-/tracks/track-similarities-id-276475110?startFrom=0&pageSize=20&connected=","albumadamid":"1499516437"},"tagid":"766BE797-7C92-4845-963E-CC146BE14480"}


