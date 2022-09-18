# <img src="extra/logo/logo.svg" width="35px"></img> Qloudy
<img src="https://img.shields.io/badge/version-0.2.0-37c248"><br>

Qloudy is a Qt based gui weather application which uses the [open weather map](https://openweathermap.org) free API.

<div align="center">
    <img src="extra/logo/logo.svg" width="200px" height="100px"> <br>
    <i>Qloudy <sub>A free openweather-based GUI app.</sub></i>
</div>
<br>

<!-- # Preview -->

## Notes <sub><small>*some important notes*!!</small></sub>
1. *You may need to set a custom **scale factor** on the environment since this app uses pixels for component size.*<br>
   Like this: `QT_SCALE_FACTOR=2 ./qloudy`
2. *This app might be bit buggy as it isn't yet in a stable state.*

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
cd qloudy
mkdir build
cd build
qmake CONFIG+=release ../qloudy/qloudy/
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
- [ ] Add tooltip.
- [ ] Add more weather condition effects.
- [ ] Add data chart.
- [ ] Add preview images to `README`.
- [ ] Add *contribution* note.
- [ ] Fix scale factor.

## Dependencies
- [Qt](https://www.qt.io) (LGPLV3) <sub>Core & GUI</sub>

## References
- [Unsplash.com](https://unsplash.com) ([Unsplash License](https://unsplash.com/license)) <sub>background images</sub>