# หมวด ส — prompt สร้างภาพ (19 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-30-suea/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (10 รายการ) ห้ามมีเลขในภาพ
- สัปเหร่อ / สุนัข / เสือกัด / แส้ / ไส้พุง เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีเลือด ศพ หรือบาดแผลให้เห็น
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | สนาม | `suea-field.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | สมอเรือ | `suea-anchor.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | สระน้ำ | `suea-pond.jpg` | 48, 49, 448, 649 |
| 4 | สัปทน | `suea-parasol.jpg` | 18, 19, 218, 219 |
| 5 | สัปเหร่อ | `suea-undertaker.jpg` | 44, 46, 446, 449 |
| 6 | สามเณร | `suea-novice.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 7 | สามง่าม | `suea-trident.jpg` | 35, 37, 235, 237 |
| 8 | สายสะพาย | `suea-sash.jpg` | 34, 35, 243, 253 |
| 9 | สาว | `suea-young-woman.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 10 | สิงโต | `suea-lion.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 11 | สุนัข | `suea-dog.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 12 | เสากระโดง | `suea-mast.jpg` | 11, 14, 114, 411 |
| 13 | เสาเรือน | `suea-house-post.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 14 | เสือ | `suea-tiger.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 15 | เสือกัด | `suea-tiger-bite.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 16 | เสื้อผ้า | `suea-clothes.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 17 | แส้ | `suea-whip.jpg` | 33, 34, 233, 234 |
| 18 | แสง | `suea-light.jpg` | 33, 34, 233, 234 |
| 19 | ไส้พุง | `suea-intestines.jpg` | 04, 05, 304, 305 |

### 1. สนาม — `suea-field`

- ไฟล์ที่ต้องได้: `images/suea-field.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้วิ่งรอบ ๆ สนาม หรือวิ่งวนเป็นวงกลมบนพื้นที่ ทายว่า กิจการที่กำลังเริ่มลงมือทำจะประสบอุปสรรค หรือความล้มเหลว หรืออาจต้องเสียเงินทอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a tired person running round and round a big field, coins dropping from their pocket. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. สมอเรือ — `suea-anchor`

- ไฟล์ที่ต้องได้: `images/suea-anchor.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นสมอเรือวางทิ้งอยู่บนบกหรือสมอเก่า ๆ ผุพัง ทายว่า ท่านจะต้องรับเคราะห์แทนญาติมิตรหรือสหายโดยไม่รู้ตัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an old rusty ship anchor lying abandoned on the shore, a person carrying a heavy bundle for a friend. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. สระน้ำ — `suea-pond`

- ไฟล์ที่ต้องได้: `images/suea-pond.jpg`
- เลข: 48, 49, 448, 649
- คำทำนาย (ต้นฉบับ): ฝันเห็นสระน้ำ มีกอบัวชูดอกไสว หรือได้ลงไปอาบเล่นในสระน้ำไหลเย็น ทายว่า ท่านจะประสบกับความสุขและความเจริญในกิจการค้าหรือหน้าที่การงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a pond full of blooming lotus flowers, a person bathing happily in cool flowing water. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 48; top-right: 49; bottom-left: 448; bottom-right: 649. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 4. สัปทน — `suea-parasol`

- ไฟล์ที่ต้องได้: `images/suea-parasol.jpg`
- เลข: 18, 19, 218, 219
- คำทำนาย (ต้นฉบับ): ฝันเห็นสัปทนหรือร่มผ้าขนาดใหญ่ มีด้ามยาว ทายว่า จะได้รับโชคในกิจการหน้าที่ หรือได้เลื่อนตำแหน่งสูงขึ้น

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a large traditional Thai ceremonial parasol with a long handle held over a person receiving a promotion. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 18; top-right: 19; bottom-left: 218; bottom-right: 219. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 5. สัปเหร่อ — `suea-undertaker`

- ไฟล์ที่ต้องได้: `images/suea-undertaker.jpg`
- เลข: 44, 46, 446, 449
- คำทำนาย (ต้นฉบับ): ฝันเห็นสัปเหร่อกำลังชำแหละศพ หรือทำการเผาศพภายในบริเวณวัด ทายว่า จะได้รับข่าวดีในหน้าที่การงาน หรือได้โชคลาภเล็ก ๆ น้อย ๆ โดยไม่คาดฝัน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no body shown: a temple undertaker tending a funeral pyre with gentle smoke, a messenger with good news. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 44; top-right: 46; bottom-left: 446; bottom-right: 449. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. สามเณร — `suea-novice`

- ไฟล์ที่ต้องได้: `images/suea-novice.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นสามเณร แต่มิเห็นภิกษุ ทายว่า ถ้าท่านตั้งครรภ์ บุตรที่เกิดจะเป็นผู้ชาย และจะเป็นผู้นำความเจริญมาสู่ครอบครัวของท่าน หรือมิฉะนั้นท่านจะได้ลาภลอยจากผู้อ่อนอายุกว่า

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a young Buddhist novice monk in orange robes walking alone, a pregnant woman smiling at him. Do not draw any numbers, words or letters anywhere in the picture.
```

### 7. สามง่าม — `suea-trident`

- ไฟล์ที่ต้องได้: `images/suea-trident.jpg`
- เลข: 35, 37, 235, 237
- คำทำนาย (ต้นฉบับ): ฝันเห็นสามง่ามหรือได้จับสามง่าม ทายว่า สิ่งที่คิดไว้จะเป็นผลสำเร็จ หรืองานที่ทำค้างไว้ จะมีผู้คอยช่วยเหลือให้สำเร็จลุล่วงไปได้ด้วยดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person holding a three-pronged trident, friends helping to finish building a house. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 35; top-right: 37; bottom-left: 235; bottom-right: 237. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 8. สายสะพาย — `suea-sash`

- ไฟล์ที่ต้องได้: `images/suea-sash.jpg`
- เลข: 34, 35, 243, 253
- คำทำนาย (ต้นฉบับ): ฝันว่าท่านได้สวมสายสะพายยศ คล้องบนบ่าข้างใดข้างหนึ่ง ทายว่า ถ้าผู้ฝันเป็นสตรีสาวโสดก็จะได้พบกับชายเนื้อคู่ผู้มีตระกูลหรือยศศักดิ์ แต่ถ้าผู้ฝันเป็นชายก็ทายว่าจะได้เลื่อนยศหรือหน้าที่ในการงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person wearing an honour sash across one shoulder at a ceremony, a noble partner beside them. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 34; top-right: 35; bottom-left: 243; bottom-right: 253. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 9. สาว — `suea-young-woman`

- ไฟล์ที่ต้องได้: `images/suea-young-woman.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นสาว ได้พบสาว หรือสาวมาหา ทายว่า จะพบกับมิตรที่นำความสุขมาให้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a young woman visiting a person's house, both smiling as friends. Do not draw any numbers, words or letters anywhere in the picture.
```

### 10. สิงโต — `suea-lion`

- ไฟล์ที่ต้องได้: `images/suea-lion.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นสิงโตหรือเสือไล่ ทายว่า จะได้รับความเดือดร้อน หรือเจ็บไข้ได้ป่วย แต่ถ้าฝันว่าถูกกัดจะได้พบกับเพศตรงข้าม ซึ่งอาจเป็นคู่มากกว่าเนื้อคู่แท้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a lion chasing a frightened person, and on the other side the person meeting someone of the opposite sex. Do not draw any numbers, words or letters anywhere in the picture.
```

### 11. สุนัข — `suea-dog`

- ไฟล์ที่ต้องได้: `images/suea-dog.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกสุนัขกัด ทายว่า จะมีศัตรูคิดร้ายหรือมีผู้ทำร้ายเราให้ต้องได้รับบาดเจ็บ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no wound: a barking dog chasing a person, a shadowy enemy watching from behind a wall. Do not draw any numbers, words or letters anywhere in the picture.
```

### 12. เสากระโดง — `suea-mast`

- ไฟล์ที่ต้องได้: `images/suea-mast.jpg`
- เลข: 11, 14, 114, 411
- คำทำนาย (ต้นฉบับ): ฝันเห็นเสากระโดงเรือ หรือเสาธงสูงตระหง่าน ทายว่า จะได้เลื่อนหน้าที่ขึ้นสูงจากเดิม และอาจมีการเคลื่อนย้ายหน้าที่หรือที่อยู่ใหม่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a tall ship mast and a tall flagpole, a person carrying boxes to a new office. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 11; top-right: 14; bottom-left: 114; bottom-right: 411. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 13. เสาเรือน — `suea-house-post`

- ไฟล์ที่ต้องได้: `images/suea-house-post.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันเห็นเสาเรือนในบ้านตกน้ำมัน หรือมีรอยมอดกัดผุกร่อน ทายว่าท่านกับครอบครัวจะได้รับทุกข์ร้อนใจ ควรเร่งรีบทำบุญสะเดาะเคราะห์เสีย หรือนิมนต์พระมาสวดมนต์ทำบุญบ้านจึงจะพ้นจากโชคร้าย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a wooden house post with termite holes, monks chanting a house blessing. Do not draw any numbers, words or letters anywhere in the picture.
```

### 14. เสือ — `suea-tiger`

- ไฟล์ที่ต้องได้: `images/suea-tiger.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเสือหรือเสือไล่ ทายว่า ท่านจะได้รับความเดือดร้อนและเจ็บป่วย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a tiger chasing a worried person through the jungle. Do not draw any numbers, words or letters anywhere in the picture.
```

### 15. เสือกัด — `suea-tiger-bite`

- ไฟล์ที่ต้องได้: `images/suea-tiger-bite.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเสือกัด ท่านจะได้รับสิ่งสมหวังจากเพศตรงข้าม แต่ให้ระมัดระวังจะเกิดความยุ่งยากลำบากใจ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no wound: a tiger playfully nipping a person's sleeve, a hopeful partner nearby looking uneasy. Do not draw any numbers, words or letters anywhere in the picture.
```

### 16. เสื้อผ้า — `suea-clothes`

- ไฟล์ที่ต้องได้: `images/suea-clothes.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเสื้อผ้า หรือได้สวมเสื้อผ้าใหม่ ทายว่า จะพ้นจากเคราะห์หรือโรคภัยไข้เจ็บ แต่ยังไม่มีโชคในการเสี่ยง ถ้าเป็นความก็จะชนะ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person trying on brand-new clothes, a judge giving them a winning verdict. Do not draw any numbers, words or letters anywhere in the picture.
```

### 17. แส้ — `suea-whip`

- ไฟล์ที่ต้องได้: `images/suea-whip.jpg`
- เลข: 33, 34, 233, 234
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกเฆี่ยนด้วยแส้จากคนแปลกหน้า หรือผู้บังคับบัญชาอย่างหนัก ทายว่า ถ้าท่านป่วยอยู่จะหายจากโรคภัยไข้เจ็บ และจะได้รับโชคลาภ ให้ระวังจะถูกใส่ความ หรือคนใกล้ชิดจะให้ร้ายคดโกงทรยศ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no wound: a stern boss holding a whip, a person recovering in health holding a gift, a gossip whispering behind. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 33; top-right: 34; bottom-left: 233; bottom-right: 234. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 18. แสง — `suea-light`

- ไฟล์ที่ต้องได้: `images/suea-light.jpg`
- เลข: 33, 34, 233, 234
- คำทำนาย (ต้นฉบับ): ฝันเห็นแสงเป็นลำสว่าง ทายว่า จะสำเร็จผลในกิจการงานของตน ถ้าฝันว่าตนมีแสงออกมา ทายว่า จะมีอำนาจราชศักดิ์

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a bright beam of light shining down on a person, light glowing from the person's body, a crown above. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 33; top-right: 34; bottom-left: 233; bottom-right: 234. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 19. ไส้พุง — `suea-intestines`

- ไฟล์ที่ต้องได้: `images/suea-intestines.jpg`
- เลข: 04, 05, 304, 305
- คำทำนาย (ต้นฉบับ): ฝันว่าไส้พุงออกมานอกท้อง ทายว่า จะมีโชคลาภ ได้สิ่งของอันพึงพอใจ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no gore: a person happily holding a basket full of pleasing gifts, a cartoon-like belly patch. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 04; top-right: 05; bottom-left: 304; bottom-right: 305. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```
