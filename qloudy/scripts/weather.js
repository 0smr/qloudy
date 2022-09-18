const weatherIcons = {
    0  : "\ue307", //"Default: question mark",
    // Thunderstorm
    1 : { // Day
        // Thunderstorm
        // with light rain, with rain, with heavy rain, light, thunderstorm
        // heavy, ragged, with light drizzle, with drizzle, with heavy drizzle
        200: "\ue201", 201: "\ue201", 202: "\ue201", 210: "\ue204", 211: "\ue204",
        212: "\ue204", 221: "\ue204", 230: "\ue204", 231: "\ue204", 232: "\ue204",
        // Drizzle
        // light intensity, drizzle, heavy intensity, light intensity rain, rain
        // heavy intensity rain, shower rain, heavy shower rain and, shower
        300: "\ue241", 301: "\ue241", 302: "\ue241", 310: "\ue241", 311: "\ue241",
        312: "\ue241", 313: "\ue241", 314: "\ue241", 321: "\ue241",
        // Rain
        // light, moderate, heavy intensity, very heavy, extreme
        // freezing, light intensity shower, shower, heavy intensity shower, ragged shower
        500: "\ue240", 501: "\ue241", 502: "\ue242", 503: "\ue242", 504: "\ue242",
        511: "\ue242", 520: "\ue242", 521: "\ue242", 522: "\ue242", 531: "\ue242",
        // Snow
        // light, Snow, Heavy, Sleet, Light shower sleet
        // Shower sleet, Light rain, Rain, Light shower, Shower, Heavy shower
        600: "\ue260", 601: "\ue261", 602: "\ue262", 611: "\ue263", 612: "\ue263",
        613: "\ue263", 615: "\ue266", 616: "\ue267", 620: "\ue267", 621: "\ue267", 622: "\ue267",
        // Atmosphere
        // mist, Smoke, Haze, sand/ dust whirls, fog
        // sand, dust, volcanic ash, squalls, tornado
        701: "\ue282", 711: "\ue282", 721: "\ue282", 731: "\ue286", 761: "\ue284",
        741: "\ue286", 751: "\ue286", 762: "\ue286", 771: "\ue286", 781: "\ue289",
        // Clear sky
        800: "\ue300",
        // Cloudy
        // 25%, 50%, 75%, 100%
        801: "\ue301", 802: "\ue302", 803: "\ue302", 804: "\ue302"
    },
    "-1": { // Night
        800: "\ue310",
        // Cloudy
        // 25%, 50%, 75%, 100%
        801: "\ue311",
    }
}

const backgroundThemes = {
    1: {
        0: "qrc:/resources/backgrounds/clear.webp", // Default
        2: "qrc:/resources/backgrounds/storm.webp", // Thunderstorm
        3: "qrc:/resources/backgrounds/dark-cloud.webp", // Drizzle
        5: "qrc:/resources/backgrounds/dark-cloud.webp", // Rain
        6: "qrc:/resources/backgrounds/snowy.webp", // Snow
        7: { // Atmosphere
             1: "qrc:/resources/backgrounds/fog.webp", // mist
            11: "qrc:/resources/backgrounds/fog.webp", // Smoke
            21: "qrc:/resources/backgrounds/fog.webp", // Haze
            31: "qrc:/resources/backgrounds/dust.webp", // sand/ dust whirls
            41: "qrc:/resources/backgrounds/fog.webp", // fog
            51: "qrc:/resources/backgrounds/dust.webp", // sand
            61: "qrc:/resources/backgrounds/dust-2.webp", // dust
            62: "qrc:/resources/backgrounds/ash.webp", // volcanic ash
            71: "qrc:/resources/backgrounds/fog.webp", // squalls
            81: "qrc:/resources/backgrounds/tornado.webp", // tornado
        },
        8: "qrc:/resources/backgrounds/clear.webp", // Clear
        9: "qrc:/resources/backgrounds/cloudy-2.webp", // Cloudy
    },
    "-1": {
        0: "qrc:/resources/backgrounds/clear-night-2.webp", // Default
        8: {
            0: "qrc:/resources/backgrounds/clear-night-2.webp", // Clear
            1: "qrc:/resources/backgrounds/cloudy-night.webp", // Cloudy
            2: "qrc:/resources/backgrounds/cloudy-night.webp", // Cloudy
            3: "qrc:/resources/backgrounds/cloudy-night.webp", // Cloudy
            4: "qrc:/resources/backgrounds/cloudy-night.webp", // Cloudy
        }
    }
}

/**
 * @param {number} code Code for weather conditions.
 * @param {boolean} day The value used to determine whether it is day or night.
 * @return {CharacterData} Icon for weather condition code
 */
function icon(code, day = true) {
    return weatherIcons[day ? 1 : -1][code] ??
           weatherIcons[day ? -1 : 1][code] ?? // try opposite.
           weatherIcons[0]; // default icon
}

function theme(code, day) {

}

