const fs = require('fs');

function parseCSV(content) {
  const rows = [];
  let i = 0, row = [], field = '', inQ = false;
  const s = content.replace(/\r\n/g,'\n').replace(/\r/g,'\n');
  while (i < s.length) {
    const c = s[i];
    if (inQ) {
      if (c==='"') { if (s[i+1]==='"') { field+='"'; i++; } else inQ=false; }
      else field+=c;
    } else {
      if (c==='"') inQ=true;
      else if (c===',') { row.push(field); field=''; }
      else if (c==='\n') { row.push(field); rows.push(row); row=[]; field=''; }
      else field+=c;
    }
    i++;
  }
  if (field||row.length) { row.push(field); rows.push(row); }
  return rows;
}

function q(v) { return '"' + String(v).replace(/"/g,'""') + '"'; }

const inputFile = process.argv[2];
const outputFile = process.argv[3];
const textsFile = process.argv[4];

const raw = fs.readFileSync(inputFile,'utf8');
const rows = parseCSV(raw);
const newTexts = JSON.parse(fs.readFileSync(textsFile,'utf8'));

const out = rows.map((row,idx) => {
  if (idx===0) return row.map(q).join(',');
  if (row.length < 4) return row.map(q).join(',');
  const key = row[0]+'_'+row[3];
  if (newTexts[key]) {
    const n = newTexts[key];
    const r = [...row];
    r[4] = n.text || r[4];
    if (n.overlay !== undefined) r[9] = n.overlay;
    if (n.link !== undefined) r[5] = n.link;
    return r.map(q).join(',');
  }
  return row.map(q).join(',');
}).join('\n');

fs.writeFileSync(outputFile, out, 'utf8');
console.log('Done: ' + outputFile + ' (' + rows.length + ' rows)');
