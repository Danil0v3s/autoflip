const fs = require('fs');

// const rail = {}
// for (let index = 0; index < 5; index++) {
//     const csv = fs.readFileSync(`./output/${index}_3:4.csv`).toString().split('\n');
//     rail[index] = [];
//     for (const line of csv) {
//         const split = line.split(',')
//         rail[index].push(split)
//     }
// }

// fs.writeFileSync('./output/file.json', JSON.stringify(rail))

// const csv = fs.readFileSync(`./debugger/output_low.csv`).toString().split('\r\n');
// const rail = []
// rail["epi-f21456d2-0d73-38fb-b479-f1ef8cd90701"] = [];
// for (const line of csv) {
//     const split = line.split(',')
//     rail.push([split[0], split.pop()])
// }

// fs.writeFileSync('./debugger/office.json', JSON.stringify(rail))
const csv = fs.readFileSync(`./output/ryan_general_params.csv`).toString().split('\n');
rail = [];
for (const line of csv) {
    const split = line.split(',')
    rail.push([split[0], split.pop()])
}
fs.writeFileSync('./debugger/ryan.json', JSON.stringify(rail))