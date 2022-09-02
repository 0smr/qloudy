function isDay() {
    const hours = (new Date()).getHours();
    return (hours >= 6 && hours < 18);
}

function dayOfWeek() {
    const weekday =["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
    return weekday[(new Date()).getDay()];
}

function utcIsDay() {
    const hours = (new Date()).getHours();
    return (hours >= 6 && hours < 18);
}

function utcDayOfWeek(utc = 0) {
    const weekday =["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
    return weekday[(new Date(utc * 1000)).getDay()];
}
