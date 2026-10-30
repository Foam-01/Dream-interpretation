# หมวด ต — prompt สร้างภาพ (29 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-12-t/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (16 รายการ) ห้ามมีเลขในภาพ
- ตกกองไฟ / ตกเลือด / ตัด / ตัดศีรษะ / ตับไต / ตาย เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีเลือด ไม่มีภาพรุนแรงหรือศพ
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ตกที่สูง | `t-falling-high.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | ตกกองไฟ | `t-falling-fire.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ตกข้าว | `t-sowing-rice.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | ตกช้าง | `t-falling-elephant.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 5 | ตกทุกข์ | `t-hardship.jpg` | 34, 36, 134, 236 |
| 6 | ตกเบ็ด | `t-fishing.jpg` | 36, 39, 236, 239 |
| 7 | ตกปลัก | `t-mud-wallow.jpg` | 13, 15, 153, 157 |
| 8 | ตกเลือด | `t-bleeding.jpg` | 19, 29, 129, 149 |
| 9 | ตกหลุม | `t-pit.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 10 | ปลูกต้นไม้ | `t-planting-tree.jpg` | 18, 19, 318, 319 |
| 11 | ต้นไม้แห้ง | `t-withered-tree.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 12 | ตะกวด | `t-monitor-lizard.jpg` | 55, 56, 556, 656 |
| 13 | ตะราง (ตาราง) | `t-jail.jpg` | 44, 48, 044, 048 |
| 14 | ตักน้ำ | `t-scooping-water.jpg` | 32, 52, 253, 257 |
| 15 | ตัด | `t-cut-limbs.jpg` | 37, 38, 227, 238 |
| 16 | ตัดผม | `t-haircut.jpg` | 09, 19, 309, 319 |
| 17 | ตัดศีรษะ | `t-beheaded.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 18 | ตับไต | `t-organs.jpg` | 30, 33, 530, 433 |
| 19 | แว่นตาดำ | `t-dark-glasses.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 20 | ตาบอด | `t-blind.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 21 | ตาย | `t-death.jpg` | 04, 05, 104, 605 |
| 22 | ตุ้มหู | `t-earrings.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 23 | เต้นรำ | `t-dancing.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 24 | ไฟในเตา | `t-glowing-stove.jpg` | 40, 44, 844, 480 |
| 25 | เตาไฟดับ | `t-dead-stove.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 26 | เต่า | `t-turtle.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 27 | แต่งตัว | `t-dressing-up.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 28 | แตนต่อย | `t-wasp-sting.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 29 | ไต่ | `t-climbing-rope.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ตกที่สูง — `t-falling-high`

- ไฟล์ที่ต้องได้: `images/t-falling-high.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตกจากที่สูง ความฝันนี้ท่านจะมีเคราะห์ ให้ระวังการทะเลาะภายในบ้านของท่านเอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person slipping off a high ledge (no injury shown), family members arguing inside the house below. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. ตกกองไฟ — `t-falling-fire`

- ไฟล์ที่ต้องได้: `images/t-falling-fire.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตกไปในกองไฟหรือน้ำร้อนที่กำลังเดือดจัด ความฝันนี้ท่านจะเดือดร้อนเพราะอารมณ์ของท่านเป็นต้นเหตุ ควรหาน้ำมนต์มาสะเดาะเคราะห์เสีย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no burns: a person stumbling at the edge of a campfire and a pot of boiling water, looking flustered, a monk sprinkling holy water nearby. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ตกข้าว — `t-sowing-rice`

- ไฟล์ที่ต้องได้: `images/t-sowing-rice.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตกข้าวในนา ความฝันนี้ท่านจะเดือดร้อนเสียเงินทองจากการช่วยเหลือผู้อื่นเอาไว้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a farmer sowing rice seedlings in a paddy field, a neighbour asking them for money. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. ตกช้าง — `t-falling-elephant`

- ไฟล์ที่ต้องได้: `images/t-falling-elephant.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตกมาจากหลังช้างหรือคอช้าง ฝันนี้มีความหมายว่าจะได้รับราชภัย ได้รับความเดือดร้อนยุ่งยาก ถูกไล่ออกจากงาน หรือทำงานผิดพลาด ขาดทุน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person falling off the back of an elephant (no injury shown), papers and coins scattering, an official pointing angrily. Do not draw any numbers, words or letters anywhere in the picture.
```

### 5. ตกทุกข์ — `t-hardship`

- ไฟล์ที่ต้องได้: `images/t-hardship.jpg`
- เลข: 34, 36, 134, 236
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวของเราเกิดการตกทุกข์ได้ยากกว่าเดิม ความฝันนี้จะทำให้ท่านมีโชคลาภเพิ่มพูนขึ้นกว่าเดิมอีก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a poor person in a humble hut, a beam of light and a growing pile of coins in front of them. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 34; top-right: 36; bottom-left: 134; bottom-right: 236. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. ตกเบ็ด — `t-fishing`

- ไฟล์ที่ต้องได้: `images/t-fishing.jpg`
- เลข: 36, 39, 236, 239
- คำทำนาย (ต้นฉบับ): ฝันว่าตกเบ็ดเล่นและได้ปลา ความฝันนี้ท่านจะพบกับโชคลาภอย่างใหญ่หลวง หรือผลกำไรจากการค้าขาย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person fishing with a rod by a river and pulling up a big fish, a basket of coins beside them. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 36; top-right: 39; bottom-left: 236; bottom-right: 239. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. ตกปลัก — `t-mud-wallow`

- ไฟล์ที่ต้องได้: `images/t-mud-wallow.jpg`
- เลข: 13, 15, 153, 157
- คำทำนาย (ต้นฉบับ): ฝันว่าตกลงในสิ่งที่โสโครก ความฝันนี้ท่านจะพบกับความสำเร็จทางการงานโชคลาภ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person slipping into a muddy buffalo wallow, laughing, a bag of gold coins on the bank. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 13; top-right: 15; bottom-left: 153; bottom-right: 157. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 8. ตกเลือด — `t-bleeding`

- ไฟล์ที่ต้องได้: `images/t-bleeding.jpg`
- เลข: 19, 29, 129, 149
- คำทำนาย (ต้นฉบับ): ฝันว่าตกเลือดมาก ความฝันนี้ท่านจะได้รับการช่วยเหลือ โชคลาภจากคนอื่น

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no blood: a person lying down weakly while friends bring help and gifts. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 19; top-right: 29; bottom-left: 129; bottom-right: 149. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 9. ตกหลุม — `t-pit`

- ไฟล์ที่ต้องได้: `images/t-pit.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตกร่อง ตกหลุม ตกบ่อ ตกเหว ความฝันนี้จะทำให้ท่านเกิดการผิดหวังขัดใจโต้แย้งในด้านการติดต่อ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person falling into a ditch by the road, looking frustrated, another person arguing above. Do not draw any numbers, words or letters anywhere in the picture.
```

### 10. ปลูกต้นไม้ — `t-planting-tree`

- ไฟล์ที่ต้องได้: `images/t-planting-tree.jpg`
- เลข: 18, 19, 318, 319
- คำทำนาย (ต้นฉบับ): ฝันว่าปลูกต้นไม้ เป็นต้นไม้ที่ใหญ่โต ท่านจะบังเกิดความร่มเย็นในครอบครัวของท่าน ของกำนัลจะไม่ขาด

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person planting a sapling beside a large shady tree in front of a peaceful family home, gifts on the porch. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 18; top-right: 19; bottom-left: 318; bottom-right: 319. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 11. ต้นไม้แห้ง — `t-withered-tree`

- ไฟล์ที่ต้องได้: `images/t-withered-tree.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นต้นไม้แห้งแล้วร่วงโรย ความฝันนี้ท่านจงระวังการลงทุนติดต่ออะไร จะเกิดการเสียหายหนักใจแก่ท่านเอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a withered tree dropping dry leaves, a worried merchant looking at an empty money box. Do not draw any numbers, words or letters anywhere in the picture.
```

### 12. ตะกวด — `t-monitor-lizard`

- ไฟล์ที่ต้องได้: `images/t-monitor-lizard.jpg`
- เลข: 55, 56, 556, 656
- คำทำนาย (ต้นฉบับ): ฝันเห็นตะกวดหรือเหี้ยขึ้นบ้าน ความฝันนี้จะมีผู้นำของกำนัลมาให้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a large monitor lizard climbing onto the veranda of a wooden house, a visitor arriving with a gift. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 55; top-right: 56; bottom-left: 556; bottom-right: 656. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 13. ตะราง (ตาราง) — `t-jail`

- ไฟล์ที่ต้องได้: `images/t-jail.jpg`
- เลข: 44, 48, 044, 048
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวเองไปติดตะราง ความฝันนี้ท่านจะหายจากการเจ็บไข้ได้ป่วย จะมีการงานมาสู่ในทางที่ดีอย่างล้นมือ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a calm person behind wooden jail bars, papers of work offers being passed to them, looking healthy. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 44; top-right: 48; bottom-left: 044; bottom-right: 048. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 14. ตักน้ำ — `t-scooping-water`

- ไฟล์ที่ต้องได้: `images/t-scooping-water.jpg`
- เลข: 32, 52, 253, 257
- คำทำนาย (ต้นฉบับ): ฝันว่าตักน้ำใส่ในภาชนะต่าง ๆ ความฝันนี้ ท่านจะพบกับโชคลาภจากผู้ใกล้ชิด ความร่มเย็นในบ้านของท่านเอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person scooping water from a large jar into bowls and pots, a relative handing them a gift. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 32; top-right: 52; bottom-left: 253; bottom-right: 257. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 15. ตัด — `t-cut-limbs`

- ไฟล์ที่ต้องได้: `images/t-cut-limbs.jpg`
- เลข: 37, 38, 227, 238
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกตัดอวัยวะต่าง ๆ ในร่างกาย ท่านจะประสบกับความสำเร็จทางด้านการงาน หุ้นส่วนจะมีผลกำไรดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no gore: a person with a bandaged arm shaking hands with business partners over a profit ledger. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 37; top-right: 38; bottom-left: 227; bottom-right: 238. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 16. ตัดผม — `t-haircut`

- ไฟล์ที่ต้องได้: `images/t-haircut.jpg`
- เลข: 09, 19, 309, 319
- คำทำนาย (ต้นฉบับ): ฝันว่าตัดผมใหม่สวย ความฝันนี้ท่านจะหายจากโรคภัยไข้เจ็บ จะสิ้นเคราะห์ ความสุขกำลังจะเดินทางมาสู่ท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person getting a neat new haircut at a barber, smiling, looking healthy. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 09; top-right: 19; bottom-left: 309; bottom-right: 319. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 17. ตัดศีรษะ — `t-beheaded`

- ไฟล์ที่ต้องได้: `images/t-beheaded.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกตัดศีรษะ ความฝันนี้ท่านจะมีอำนาจวาสนาในอนาคตต่อไปข้างหน้า (ควรรอให้ผ่านพ้นเดือนเกิดของท่านไปเสียก่อน)

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no violence or blood: a crown floating above a calm person meditating, a calendar showing the birth month on the wall. Do not draw any numbers, words or letters anywhere in the picture.
```

### 18. ตับไต — `t-organs`

- ไฟล์ที่ต้องได้: `images/t-organs.jpg`
- เลข: 30, 33, 530, 433
- คำทำนาย (ต้นฉบับ): ฝันว่าโดนล้วงตับไตไส้พุงออกจากร่างกาย ความฝันนี้ท่านจะได้ลาภอันถูกใจ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no gore: an old Thai medical anatomy scroll on a table and a person receiving a gift box happily. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 30; top-right: 33; bottom-left: 530; bottom-right: 433. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 19. แว่นตาดำ — `t-dark-glasses`

- ไฟล์ที่ต้องได้: `images/t-dark-glasses.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าท่านได้ใส่แว่นตาดำ ความฝันนี้ ท่านจะพบกับความยุ่งยากใจเกี่ยวกับคนอาศัยหรือท่านจะเดือดร้อนเรื่องที่อยู่อาศัย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person wearing dark sunglasses looking troubled at a crowded house of lodgers. Do not draw any numbers, words or letters anywhere in the picture.
```

### 20. ตาบอด — `t-blind`

- ไฟล์ที่ต้องได้: `images/t-blind.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตาบอด ตาพิการ ความฝันนี้จะเกิดการเจ็บป่วยขึ้นในบ้าน บางทีก็อาจจะเป็นตัวของท่านเอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person with a cloth over their eyes resting in bed, a relative caring for them. Do not draw any numbers, words or letters anywhere in the picture.
```

### 21. ตาย — `t-death`

- ไฟล์ที่ต้องได้: `images/t-death.jpg`
- เลข: 04, 05, 104, 605
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวของเราตาย ความฝันนี้จะทำให้เราไม่เจ็บไข้ อายุยืนนานต่อไป ถ้าฝันเห็นญาติมิตรตาย ความฝันนี้ท่านจะบังเกิดผลดี ได้รับของกำนัลจากมิตรสหาย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, peaceful, no corpse: a person lying asleep under a white sheet peacefully, friends bringing gifts and flowers, a long-life symbol. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 04; top-right: 05; bottom-left: 104; bottom-right: 605. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 22. ตุ้มหู — `t-earrings`

- ไฟล์ที่ต้องได้: `images/t-earrings.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ตุ้มหูอะไรก็ตามแต่ ความฝันนี้ท่านจะพบกับเนื้อคู่สมรสที่มีเกียรติวงศ์ตระกูลดีกว่าท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person trying on a pair of beautiful earrings, an elegant suitor from a noble family nearby. Do not draw any numbers, words or letters anywhere in the picture.
```

### 23. เต้นรำ — `t-dancing`

- ไฟล์ที่ต้องได้: `images/t-dancing.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเต้นรำ-ระบำสนุกสนานร่าเริง ความฝันนี้จะมีเพื่อนต่างเพศ หรือต่างชาติมาก่อความยุ่งยากในทางชู้สาวให้ท่าน ต้องยุ่งยากใจภายหลังจากการติดต่อกันแล้ว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: people dancing happily at a party, a foreign stranger flirting, a worried partner in the background. Do not draw any numbers, words or letters anywhere in the picture.
```

### 24. ไฟในเตา — `t-glowing-stove`

- ไฟล์ที่ต้องได้: `images/t-glowing-stove.jpg`
- เลข: 40, 44, 844, 480
- คำทำนาย (ต้นฉบับ): ฝันว่ามีไฟอยู่ในเตาแดง ความฝันนี้ท่านจะได้รับมรดกหรือเงินปันผลอย่างที่ไม่เคยคาดคิดมาก่อน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a clay stove with red glowing coals, an inheritance chest of money being opened. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 40; top-right: 44; bottom-left: 844; bottom-right: 480. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 25. เตาไฟดับ — `t-dead-stove`

- ไฟล์ที่ต้องได้: `images/t-dead-stove.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าก่อไฟไว้ในเตา เกิดดับไม่ติด ความฝันนี้ท่านจะพบกับความผิดหวังจากคนรัก หรือกิจการงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person trying to light a clay stove that will not catch fire, looking disappointed. Do not draw any numbers, words or letters anywhere in the picture.
```

### 26. เต่า — `t-turtle`

- ไฟล์ที่ต้องได้: `images/t-turtle.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเต่า หรือจับได้ ความฝันนี้ท่านจะได้สิ่งที่มีชีวิตเข้ามาสู่ครอบครัวของท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person holding a turtle, a family with a new baby goat at home. Do not draw any numbers, words or letters anywhere in the picture.
```

### 27. แต่งตัว — `t-dressing-up`

- ไฟล์ที่ต้องได้: `images/t-dressing-up.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้แต่งตัวสวยสดงดงาม ความฝันนี้ตัวของท่านจะเกิดการเจ็บป่วยอย่างกะทันหัน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person dressed in beautiful clothes in front of a mirror, holding their forehead as if suddenly feeling unwell. Do not draw any numbers, words or letters anywhere in the picture.
```

### 28. แตนต่อย — `t-wasp-sting`

- ไฟล์ที่ต้องได้: `images/t-wasp-sting.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าแตนหรือต่อต่อย ความฝันนี้ท่านจะเสียเงินทองสิ่งของ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a wasp flying at a person who drops their coin purse, coins spilling. Do not draw any numbers, words or letters anywhere in the picture.
```

### 29. ไต่ — `t-climbing-rope`

- ไฟล์ที่ต้องได้: `images/t-climbing-rope.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าไต่ลวด ไต่เชือก ไต่ที่สูง ความฝันนี้ทายว่า ท่านจะได้รับการงานและการเงินจากคนหน้าใหม่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person climbing a rope up a high wall, a new employer at the top offering work and money. Do not draw any numbers, words or letters anywhere in the picture.
```
