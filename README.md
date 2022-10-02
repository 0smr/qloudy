# <img src="extra/logo/logo.svg" width="35px"></img> Qloudy
<p><img src="https://img.shields.io/github/v/tag/smr76/qloudy?sort=semver&label=version&labelColor=0bd&color=07b" alt="version tag">
<img src="https://img.shields.io/github/license/smr76/qloudy?color=36b245" alt="license">
<a href="https://www.blockchain.com/bch/address/bitcoincash:qrnwtxsk79kv6mt2hv8zdxy3phkqpkmcxgjzqktwa3">
<img src="https://img.shields.io/badge/BCH-Donate-f0992e?logo=BitcoinCash&logoColor=f0992e" alt="BCH donate"></a></p>

Qloudy is a Qt based gui weather application which uses the [open weather map](https://openweathermap.org) free API.

<div align="center">
    <img src="extra/logo/logo.svg" width="200px" height="100px"> <br>
    <i>Qloudy <sub>A free openweather-based GUI app.</sub></i>
</div>
<br>

<!-- # Preview -->

> **Warning**
> + *You may need to set a custom **scale factor** on the environment since this app uses pixels for component size.* (e.g., `QT_SCALE_FACTOR=2 ./qloudy`)
> + *This app might be bit buggy as it isn't yet in a stable state.*

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
- [ ] Add preview images to README.
- [ ] Add *contribution* note.
- [ ] Fix scale factor.

## Dependencies
- [Qt](https://www.qt.io) (LGPLV3) <sub>Core & GUI</sub>

## Attribution
- [Unsplash.com](https://unsplash.com) ([Unsplash License](https://unsplash.com/license)) <sub>Background Images</sub>
- [materialdesignicons.com](https://materialdesignicons.com) (Apache 2.0) <sub>Icons</sub>