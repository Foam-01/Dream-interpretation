# หมวด ล — prompt สร้างภาพ (10 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-27-l/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (7 รายการ) ห้ามมีเลขในภาพ
- เลือด เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีเลือดให้เห็น; ลอตเตอรี่ห้ามมีตัวเลขบนสลาก
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ลังไม้ | `l-crate.jpg` | 44, 46, 446, 447 |
| 2 | ลอตเตอรี่ | `l-lottery.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ลูกประคำและลูกปัด | `l-beads.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | ลูกล้อ | `l-wheel.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 5 | ลูกสัตว์ | `l-baby-animals.jpg` | 34, 35, 347, 358 |
| 6 | ลูกเหน็บ | `l-hairpin.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 7 | เลี้ยงโต๊ะ | `l-banquet.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 8 | เลือด | `l-blood.jpg` | 22, 23, 422, 523 |
| 9 | แลบลิ้น | `l-tongue.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 10 | โล่ | `l-shield.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ลังไม้ — `l-crate`

- ไฟล์ที่ต้องได้: `images/l-crate.jpg`
- เลข: 44, 46, 446, 447
- คำทำนาย (ต้นฉบับ): ฝันว่าปีนขึ้นไปนั่งหรือยืนอยู่บนลังไม้หรือขอนไม้ ทายว่าจะได้ลาภลอยจากการเสี่ยงเล็ก ๆ น้อย ๆ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person climbing up to sit on a big wooden crate and a log, a few coins glinting nearby. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 44; top-right: 46; bottom-left: 446; bottom-right: 447. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 2. ลอตเตอรี่ — `l-lottery`

- ไฟล์ที่ต้องได้: `images/l-lottery.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าถูกลอตเตอรี่ หรือเล่นการพนันร่ำรวย ความฝันนี้ ท่านจะต้องเสียการพนันอย่าพยายามเสี่ยงโชค

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person celebrating with a blank lottery ticket at a gambling table, then looking sad with empty pockets. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ลูกประคำและลูกปัด — `l-beads`

- ไฟล์ที่ต้องได้: `images/l-beads.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นลูกประคำคอ หรือลูกปัดคล้องคอตกเกลื่อนกลาดในท้องถนน ทายว่าจะได้ลาภเป็นสัตว์สี่เท้าหรือสองเท้าเข้ามาอยู่ภายในบ้าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a broken string of prayer beads and glass beads scattered across a village road, a goat and a chicken walking into a yard. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. ลูกล้อ — `l-wheel`

- ไฟล์ที่ต้องได้: `images/l-wheel.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นล้อยางรถ หรือลูกล้อวงกลม ทายว่าจะได้รับเคราะห์จากการหักหลังของเพื่อนหรือได้รับความล้มเหลวในกิจการงานหรือหน้าที่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an old rubber car tyre and a round wooden wheel rolling away, a friend turning their back. Do not draw any numbers, words or letters anywhere in the picture.
```

### 5. ลูกสัตว์ — `l-baby-animals`

- ไฟล์ที่ต้องได้: `images/l-baby-animals.jpg`
- เลข: 34, 35, 347, 358
- คำทำนาย (ต้นฉบับ): ฝันว่าได้อุ้มลูกสัตว์ต่าง ๆ ความฝันนี้ ท่านจะได้เลื่อนตำแหน่งหน้าที่การงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person cuddling a puppy, a kitten and a baby goat, smiling. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 34; top-right: 35; bottom-left: 347; bottom-right: 358. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. ลูกเหน็บ — `l-hairpin`

- ไฟล์ที่ต้องได้: `images/l-hairpin.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเก็บลูกเหน็บตก ความฝันนี้ทายว่าจะมีคนนำลาภมาให้ถึงบ้านท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person picking up a fallen traditional Thai hairpin from the floor, a visitor arriving at the door with a gift. Do not draw any numbers, words or letters anywhere in the picture.
```

### 7. เลี้ยงโต๊ะ — `l-banquet`

- ไฟล์ที่ต้องได้: `images/l-banquet.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ไปในงานการเลี้ยงโต๊ะ ซึ่งจัดเป็นพิธีต้อนรับแขกจำนวนมาก ทายว่า จะประสบกับเคราะห์หรือโชคร้ายในหน้าที่การงาน หรือการค้าขาย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a big Chinese-style round-table banquet with many guests, a worried host looking at bills. Do not draw any numbers, words or letters anywhere in the picture.
```

### 8. เลือด — `l-blood`

- ไฟล์ที่ต้องได้: `images/l-blood.jpg`
- เลข: 22, 23, 422, 523
- คำทำนาย (ต้นฉบับ): ฝันว่าอาเจียนเลือดออกมาสด ๆ หรือเห็นเลือด ความฝันนี้ ท่านจะบังเกิดโชคลาภอย่างใหญ่หลวง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no blood shown: a person holding their stomach in surprise, gold coins pouring down from above. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 22; top-right: 23; bottom-left: 422; bottom-right: 523. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 9. แลบลิ้น — `l-tongue`

- ไฟล์ที่ต้องได้: `images/l-tongue.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่านั่งแลบลิ้นปลิ้นตา ความฝันนี้ท่านจะต้องเดือดร้อน ถูกคนหลอกลวงให้เสียเงินทอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person sticking out their tongue and rolling their eyes, a sly trickster taking their money bag. Do not draw any numbers, words or letters anywhere in the picture.
```

### 10. โล่ — `l-shield`

- ไฟล์ที่ต้องได้: `images/l-shield.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นโล่ หรืออาร์มของนักรบในสมัยโบราณ ทายว่า จะได้รับความเดือดเนื้อร้อนใจจากเพื่อนบ้านในระยะหนึ่ง แต่จะเป็นฝ่ายชนะเพราะศัตรูที่คิดร้ายพ่ายแพ้ไป

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an ancient warrior shield and coat of arms leaning on a wall, a person standing victorious as rivals walk away. Do not draw any numbers, words or letters anywhere in the picture.
```
