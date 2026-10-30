// Generates the app's bundled letter-category data (lib/data/dreams_k.dart = หมวด ก, dreams_kh.dart = หมวด ข,
// dreams_khw.dart = หมวด ค, dreams_khr.dart = หมวด ฆ, dreams_ng.dart = หมวด ง, dreams_ch.dart = หมวด จ,
// dreams_chg.dart = หมวด ฉ)
// from the import files, so the app and the database are filled from one source.
// Run from backend/:  node scripts/generate-flutter-content.mjs
// The test/category_*_test.dart files fail if a generated file is out of date.
import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..', '..');
const categories = [
  { dir: 'category-01-k', file: 'dreams_k.dart', cat: 'หมวด ก', constName: 'dreamsK' },
  { dir: 'category-02-kh', file: 'dreams_kh.dart', cat: 'หมวด ข', constName: 'dreamsKh' },
  { dir: 'category-03-khw', file: 'dreams_khw.dart', cat: 'หมวด ค', constName: 'dreamsKhw' },
  { dir: 'category-04-khr', file: 'dreams_khr.dart', cat: 'หมวด ฆ', constName: 'dreamsKhr' },
  { dir: 'category-05-ng', file: 'dreams_ng.dart', cat: 'หมวด ง', constName: 'dreamsNg' },
  { dir: 'category-06-ch', file: 'dreams_ch.dart', cat: 'หมวด จ', constName: 'dreamsCh' },
  { dir: 'category-07-chg', file: 'dreams_chg.dart', cat: 'หมวด ฉ', constName: 'dreamsChg' },
  { dir: 'category-08-chc', file: 'dreams_chc.dart', cat: 'หมวด ช', constName: 'dreamsChc' },
  { dir: 'category-09-s', file: 'dreams_s.dart', cat: 'หมวด ซ', constName: 'dreamsS' },
];

const dart = (s) => `'${s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\$/g, '\\$').replace(/\n/g, '\\n')}'`;
const list = (xs) => `[${xs.map(dart).join(', ')}]`;

for (const { dir, file, cat, constName } of categories) {
  const { dreams } = JSON.parse(readFileSync(join(root, 'backend', 'content', 'incoming', dir, 'dreams.json'), 'utf8'));
  const lines = dreams.map((d) => {
    const numbers = d.noLuckyNumbers
      ? 'LuckyNumbers.none()'
      : `LuckyNumbers(twoDigit: ${list(d.numbers.twoDigit)}, threeDigit: ${list(d.numbers.threeDigit)})`;
    const named = d.aliases?.length ? `, aliases: ${list(d.aliases)}` : '';
    return (
      `  Dream(${dart(d.id)}, ${dart(d.name)}, ${dart(cat)}, ${numbers}, ${list(d.digits ?? [])},\n` +
      `      ${dart(d.short)},\n      ${dart(d.meaning)},\n      null, null, null${named}),`
    );
  });

  writeFileSync(
    join(root, 'lib', 'data', file),
    `// GENERATED from backend/content/incoming/${dir}/dreams.json by
// backend/scripts/generate-flutter-content.mjs. Do not edit by hand.
//
// ${cat}: ${dreams.length} predictions approved by the content owner. Text is verbatim from the source
// manuscript; no source citation, forecast scores, advice or omen were given, so none are set.
// LuckyNumbers.none() = the source says "ไม่ควรเสี่ยง".
// dart format off
import 'design_data.dart';

const ${constName} = <Dream>[
${lines.join('\n')}
];
`,
    'utf8',
  );
  console.log(`wrote ${dreams.length} dreams to lib/data/${file}`);
}
