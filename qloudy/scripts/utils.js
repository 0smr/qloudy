//
/**
 * @param {Number} timezoneOffset custom timezone offset
 * @return {String} name of week.
 */
function isDay(secondOffset = undefined) {
    const offset = (secondOffset ?? new Date().getTimezoneOffset() * 60);
    const hours = new Date(Date.now() + offset).getUTCHours();
    return (hours >= 6 && hours < 18);
}

/**
 * @param {Number} timezoneOffset custom timezone offset
 * @return {String} name of week in locale.
 */
function dayOfWeekString(secondOffset = 0, utc = 0) {
    const week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    const time = utc || Date.now();
    const offset = secondOffset || (new Date().getTimezoneOffset() * 60);
    return week[new Date(time - offset * 1000).getUTCDay()];
}
