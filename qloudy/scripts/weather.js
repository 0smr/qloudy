let weatherIcons = {
    0  : "\uefcc", //"Default: question mark",
    // Thunderstorm
    1 : { // Day
        // Thunderstorm
        200: "\uee78", 201: "\uee69", 202: "\uee69", 210: "\uee84", 211: "\uee64",
        212: "\uee60", 221: "\uee60", 230: "\uee77", 231: "\uee77", 232: "\uee77",
        // Drizzle
        300: "\uee5b", 301: "\uee61", 302: "\uee60", 310: "\uee5c", 311: "\uee5c",
        312: "\uee5c", 313: "\uee5c", 314: "\uee5c", 321: "\uee61",
        // Rain
        500: "\uee6a", 501: "\uee6a", 502: "\uee6a", 503: "\uee6a", 504: "\uee6a",
        511: "\uee73", 520: "\uee6a", 521: "\uee6a", 522: "\uee6a", 531: "\uee6a",
        // Snow
        600: "\uee7d", 601: "\uee6b", 602: "\uee79", 611: "\uee79", 612: "\uee79",
        613: "\uee79", 615: "\uee73", 616: "\uee73", 620: "\uee7d", 621: "\uee7d", 622: "\uee7d",
        // Atmosphere
        701: "\ue89b", 711: "\uee56", 721: "\ue89b", 731: "\uee9f", 761: "\uee53",
        741: "\ue89b", 751: "\uee9f", 762: "\uee88", 771: "\uee64", 781: "\uee85",
        // Clear
        800: "\uee7e",
        // Cloudy
        801: "\uee51", 802: "\uee51", 803: "\uee52", 804: "\uee52"
    },
    "-1": { // Night
        800: "\uef9e",
    }
}

function icon(code, day = true) {
    return weatherIcons[day ? 1 : -1][code] ??
           weatherIcons[day ? -1 : 1][code] ?? // try opposite.
           weatherIcons[0]; // default icon
}

