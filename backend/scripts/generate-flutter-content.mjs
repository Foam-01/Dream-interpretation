// Generates lib/data/dreams_k.dart (the app's bundled หมวด ก data) from the import file, so the app and
// the database are filled from one source. Run from backend/:  node scripts/generate-flutter-content.mjs
// test/category_k_test.dart fails if the generated file is out of date.
import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..', '..');
const input = join(root, 'backend', 'content', 'incoming', 'category-01-k', 'dreams.json');
const output = join(root, 'lib', 'data', 'dreams_k.dart');

const dart = (s) => `'${s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\$/g, '\\$').replace(/\n/g, '\\n')}'`;
const list = (xs) => `[${xs.map(dart).join(', ')}]`;

const { dreams } = JSON.parse(readFileSync(input, 'utf8'));
const lines = dreams.map((d) => {
  const numbers = d.noLuckyNumbers
    ? 'LuckyNumbers.none()'
    : `LuckyNumbers(twoDigit: ${list(d.numbers.twoDigit)}, threeDigit: ${list(d.numbers.threeDigit)})`;
  const named = d.aliases?.length ? `, aliases: ${list(d.aliases)}` : '';
  return (
    `  Dream(${dart(d.id)}, ${dart(d.name)}, ${dart('หมวด ก')}, ${numbers}, ${list(d.digits ?? [])},\n` +
    `      ${dart(d.short)},\n      ${dart(d.meaning)},\n      null, null, null${named}),`
  );
});

writeFileSync(
  output,
  `// GENERATED from backend/content/incoming/category-01-k/dreams.json by
// backend/scripts/generate-flutter-content.mjs. Do not edit by hand.
//
// หมวด ก: ${dreams.length} predictions approved by the content owner. Text is verbatim from the source
// manuscript; no source citation, forecast scores, advice or omen were given, so none are set.
// LuckyNumbers.none() = the source says "ไม่ควรเสี่ยง".
// dart format off
import 'design_data.dart';

const dreamsK = <Dream>[
${lines.join('\n')}
];
`,
  'utf8',
);
console.log(`wrote ${dreams.length} dreams to lib/data/dreams_k.dart`);
