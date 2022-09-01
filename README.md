# <img src="extra/logo/logo.svg" width="35px"></img> Qloudy
<img src="https://img.shields.io/badge/version-0.1.0-37c248"><br>

Qloudy is a Qt based gui weather application which uses the [open weather map](https://openweathermap.org) free API.

Note: *Take notice that this software was just used as a task to apply for a job.*

<div align="center">
    <img src="extra/logo/logo.svg" width="200px" height="100px"> <br>
    <i>Qloudy <sub>free gui using openweather api</sub></i>
</div>
<br>

<!-- # Preview -->

## Building from source

**Dependencies**

`Qt >= 5.15.2`, `GCC >= 8.0`, `qmake >= 3.1`, `C++ >= 17`.
```bash
sudo apt install g++ build-essential qt5-default qttools5-dev qttools5-dev-tools qtdeclarative5-dev*
```

**Clone repository**
```bash
git clone --recursive https://github.com/SMR76/qloudy.git
```

**‌Build**
```bash
cd knight-pen
mkdir build
cd build
qmake CONFIG+=release ../src/qloudy/
make
```

## Scripts

### Data collector

Weather conditions can find on weather [conditions-page](https://openweathermap.org/weather-conditions).

<details>
<summary>Code</summary>
The JavaScript code below will collect this data and save it in a json variable.

```javascript
var json = {};
var tables = [...document.getElementsByTagName('table')];
tables.forEach((table, idx) => {
	let rows = table.getElementsByTagName('tbody')[0]?.children;
	if(!rows || idx == 0) return; // skip icon table
	rows = [...rows];
	rows.forEach(row => {
		const id = Number(row.children[0].innerHTML.trim());
		const main = row.children[1].innerHTML.trim();
		const desc = row.children[2].innerHTML.trim();
		if(id && main) { json[main] ??= {}; json[main][id] = desc; }
	});
})
```
</details>

## TO-DO
- [ ] App Specific icon set.
- [ ] Clean files and codes.
- [ ] Add tooltip.
- [ ] Add tray icon.
- [ ] Weather condition effect.
- [ ] Data chart.
- [ ] Add previews to `README`.
- [ ] Add *contribution* template.

## Dependencies
- [Qt](https://www.qt.io) (LGPLV3) <sub>Core & GUI</sub>