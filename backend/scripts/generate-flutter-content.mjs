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
  { dir: 'category-10-y', file: 'dreams_y.dart', cat: 'หมวด ญ', constName: 'dreamsY' },
  { dir: 'category-11-d', file: 'dreams_d.dart', cat: 'หมวด ด', constName: 'dreamsD' },
  { dir: 'category-12-t', file: 'dreams_t.dart', cat: 'หมวด ต', constName: 'dreamsT' },
  { dir: 'category-13-thung', file: 'dreams_thung.dart', cat: 'หมวด ถ', constName: 'dreamsThung' },
  { dir: 'category-14-thahan', file: 'dreams_thahan.dart', cat: 'หมวด ท', constName: 'dreamsThahan' },
  { dir: 'category-15-thong', file: 'dreams_thong.dart', cat: 'หมวด ธ', constName: 'dreamsThong' },
  { dir: 'category-16-n', file: 'dreams_n.dart', cat: 'หมวด น', constName: 'dreamsN' },
  { dir: 'category-17-b', file: 'dreams_b.dart', cat: 'หมวด บ', constName: 'dreamsB' },
  { dir: 'category-18-p', file: 'dreams_p.dart', cat: 'หมวด ป', constName: 'dreamsP' },
  { dir: 'category-19-phueng', file: 'dreams_phueng.dart', cat: 'หมวด ผ', constName: 'dreamsPhueng' },
  { dir: 'category-20-f', file: 'dreams_f.dart', cat: 'หมวด ฝ', constName: 'dreamsF' },
  { dir: 'category-21-phan', file: 'dreams_phan.dart', cat: 'หมวด พ', constName: 'dreamsPhan' },
  { dir: 'category-22-fan', file: 'dreams_fan.dart', cat: 'หมวด ฟ', constName: 'dreamsFan' },
  { dir: 'category-23-samphao', file: 'dreams_samphao.dart', cat: 'หมวด ภ', constName: 'dreamsSamphao' },
  { dir: 'category-24-m', file: 'dreams_m.dart', cat: 'หมวด ม', constName: 'dreamsM' },
  { dir: 'category-25-yak', file: 'dreams_yak.dart', cat: 'หมวด ย', constName: 'dreamsYak' },
  { dir: 'category-26-r', file: 'dreams_r.dart', cat: 'หมวด ร', constName: 'dreamsR' },
  { dir: 'category-27-l', file: 'dreams_l.dart', cat: 'หมวด ล', constName: 'dreamsL' },
  { dir: 'category-28-w', file: 'dreams_w.dart', cat: 'หมวด ว', constName: 'dreamsW' },
  { dir: 'category-29-sala', file: 'dreams_sala.dart', cat: 'หมวด ศ', constName: 'dreamsSala' },
  { dir: 'category-30-suea', file: 'dreams_suea.dart', cat: 'หมวด ส', constName: 'dreamsSuea' },
  { dir: 'category-31-hip', file: 'dreams_hip.dart', cat: 'หมวด ห', constName: 'dreamsHip' },
  { dir: 'category-32-ang', file: 'dreams_ang.dart', cat: 'หมวด อ', constName: 'dreamsAng' },
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
