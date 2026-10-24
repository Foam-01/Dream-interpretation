# หมวด ข — prompt สร้างภาพ (25 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-02-kh/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (11 รายการ) ห้ามมีเลขในภาพ
- ของลับ / ขาด / ขี้ เขียนให้เป็นภาพเชิงสัญลักษณ์: ไม่มีภาพโป๊ ไม่มีภาพรุนแรง
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ขนม | `kh-dessert.jpg` | 22, 44, 224, 244 |
| 2 | ขมิ้น | `kh-turmeric.jpg` | 25, 26, 251, 256 |
| 3 | ขโมย | `kh-thief.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | ของหาย | `kh-lost-belongings.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 5 | ของมีค่า | `kh-valuables.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 6 | ของลับ | `kh-private-parts.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 7 | ขอนไม้ | `kh-floating-log.jpg` | 11, 12, 181, 182 |
| 8 | ขัง | `kh-imprisoned.jpg` | 42, 44, 421, 442 |
| 9 | ขา | `kh-broken-leg.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 10 | ขา | `kh-shackled-leg.jpg` | 22, 24, 240, 262 |
| 11 | ขาด | `kh-severed.jpg` | 22, 24, 122, 124 |
| 12 | ขาย | `kh-selling-goods.jpg` | 23, 25, 27, 235, 237 |
| 13 | ข้าว | `kh-cooking-rice.jpg` | 19, 29, 119, 229 |
| 14 | ข้าวสาร | `kh-uncooked-rice.jpg` | 20, 64, 66, 609, 660 |
| 15 | ขี่ | `kh-riding-mighty-animal.jpg` | 21, 41, 142, 144 |
| 16 | ขี่ควาย | `kh-riding-buffalo.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 17 | ขี่คอคน | `kh-riding-shoulders.jpg` | 14, 18, 148, 181 |
| 18 | ขี่ม้า | `kh-riding-horse.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 19 | ขี้ | `kh-excrement.jpg` | 13, 15, 17, 137, 157 |
| 20 | ขี้เถ้า | `kh-ashes.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 21 | ขึ้น | `kh-climbing.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 22 | ขุด | `kh-digging.jpg` | 10, 12, 101, 121 |
| 23 | เขย่ง | `kh-limping.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 24 | เขา | `kh-mountain-trip.jpg` | 91, 92, 291, 292 |
| 25 | เขา | `kh-falling-from-mountain.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ขนม — `kh-dessert`

- ไฟล์ที่ต้องได้: `images/kh-dessert.jpg`
- เลข: 22, 44, 224, 244
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าได้บริโภคขนมที่มีรสอร่อย ทายว่าจะพบกับเนื้อคู่ ท่านมีความสุขสบายทั้งครอบครัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person happily eating Thai desserts (kanom) from a tray, with a family smiling around a low table. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 22, 44, 224, 244. Do not draw any other numbers, words or letters.
```

### 2. ขมิ้น — `kh-turmeric`

- ไฟล์ที่ต้องได้: `images/kh-turmeric.jpg`
- เลข: 25, 26, 251, 256
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าผัดหน้าทาขมิ้น ความฝันนี้จะทำให้ท่านได้รับผลสำเร็จทุก ๆ ประการ ถ้าท่านกำลังเจ็บป่วยก็จะหาย จะมีความสุข

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person applying turmeric paste to their face in front of a small mirror, fresh turmeric roots and a stone mortar beside them. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 25, 26, 251, 256. Do not draw any other numbers, words or letters.
```

### 3. ขโมย — `kh-thief`

- ไฟล์ที่ต้องได้: `images/kh-thief.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่า ขโมยขึ้นบ้านท่าน ความฝันนี้ท่านจะได้รับความเดือดร้อน เพราะคนในครอบครัวท่านอาจทำให้ท่านต้องเสียเงินทองสิ่งของเป็นเครื่องตอบแทนไป

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a masked thief climbing in through the window of a wooden Thai house at night, carrying a cloth sack. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. ของหาย — `kh-lost-belongings`

- ไฟล์ที่ต้องได้: `images/kh-lost-belongings.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าของท่านหาย ความฝันนี้หมายความว่าท่านจะต้องระวังตัว จะเกิดการเดือดร้อนยุ่งยากใจ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a worried person searching through an empty open bag and an overturned basket on the floor. Do not draw any numbers, words or letters anywhere in the picture.
```

### 5. ของมีค่า — `kh-valuables`

- ไฟล์ที่ต้องได้: `images/kh-valuables.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่า ท่านเก็บของมีค่าได้ ความฝันนี้ท่านจะพบกับคดีความ จะเป็นปากเสียงกับผู้ใหญ่หรือคู่ครอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person picking up a jewellery box and gold ornaments found on the ground along a path. Do not draw any numbers, words or letters anywhere in the picture.
```

### 6. ของลับ — `kh-private-parts`

- ไฟล์ที่ต้องได้: `images/kh-private-parts.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่า ได้เห็นของลับของคนอื่นหรือของตัวท่านเอง ความฝันนี้ทายว่า ท่านจะพบกับความเดือดร้อนยุ่งยาก ถ้าติดต่อการงานไว้อาจถูกคดโกง และหักหลังกัน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no nudity: a closed folding screen and a drawn curtain in front of a small locked wooden chest. Do not draw any numbers, words or letters anywhere in the picture.
```

### 7. ขอนไม้ — `kh-floating-log`

- ไฟล์ที่ต้องได้: `images/kh-floating-log.jpg`
- เลข: 11, 12, 181, 182
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่า เห็นขอนไม้ลอยน้ำมา ความฝันนี้จะทำให้ท่านได้รับลาภลอย โดยมิได้คิดฝันมาก่อน หรือถ้าท่านค้าขาย ได้อาศัยขอนไม้ข้ามฟากไปอีกฝั่งหนึ่ง หมายความว่าการงานที่ท่านติดต่อไว้ จะได้รับความสำเร็จ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a large log floating down a river, and a person crossing the river to the far bank holding on to the log. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 11, 12, 181, 182. Do not draw any other numbers, words or letters.
```

### 8. ขัง — `kh-imprisoned`

- ไฟล์ที่ต้องได้: `images/kh-imprisoned.jpg`
- เลข: 42, 44, 421, 442
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าท่านถูกขัง ความฝันของท่านนี้จะทำให้ท่านประสบโชคและความสำเร็จผลในด้านกิจการงาน ตลอดจนประสบผลสมดังความปรารถนา

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a calm person sitting behind wooden jail bars, a beam of light falling through a small window. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 42, 44, 421, 442. Do not draw any other numbers, words or letters.
```

### 9. ขา — `kh-broken-leg`

- ไฟล์ที่ต้องได้: `images/kh-broken-leg.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าขาของท่านหัก หรือโลหิตตก ข้อเท้า ความฝันนี้จะต้องทำให้ท่านเกิดความเจ็บป่วยขึ้น หรือต้องเสียทรัพย์สินเงินตรา

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person sitting with one leg in a wooden splint and bandages, a walking stick beside them (no blood). Do not draw any numbers, words or letters anywhere in the picture.
```

### 10. ขา — `kh-shackled-leg`

- ไฟล์ที่ต้องได้: `images/kh-shackled-leg.jpg`
- เลข: 22, 24, 240, 262
- คำทำนาย (ต้นฉบับ): ถ้าฝันว่าขาของท่านได้รับการจองจำใส่ตรวน ทำนายว่าท่านจะสิ้นทุกข์พ้นจากอันตราย จะมีความสุขความเจริญมั่นคงขึ้น

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an ankle bound with an old iron shackle and chain, the chain lying loose on the ground. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 22, 24, 240, 262. Do not draw any other numbers, words or letters.
```

### 11. ขาด — `kh-severed`

- ไฟล์ที่ต้องได้: `images/kh-severed.jpg`
- เลข: 22, 24, 122, 124
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่า ถูกตัดมือ หรืออวัยวะส่วนใดในร่างกายของท่าน จะทำให้ท่านได้รับยศหรือเลื่อนตำแหน่งในด้านการงาน ถ้าทำการค้าขายจะได้รับกำไรงาม

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no gore: a person with a bandaged wrist receiving a new uniform jacket and a rank badge from an elder. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 22, 24, 122, 124. Do not draw any other numbers, words or letters.
```

### 12. ขาย — `kh-selling-goods`

- ไฟล์ที่ต้องได้: `images/kh-selling-goods.jpg`
- เลข: 23, 25, 27, 235, 237
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าเดินเร่ขายของ ความฝันนี้ทายว่าจะทำให้ท่านพบกับโชคดี ได้รับการช่วยเหลือจากญาติมิตรผู้ใหญ่ การงานจะสำเร็จลุล่วงไปโดยได้รับการช่วยเหลือเป็นอย่างดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a street vendor standing beside a basket of goods, selling to friendly relatives and an elder. Draw exactly 5 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 23, 25, 27, 235, 237. Do not draw any other numbers, words or letters.
```

### 13. ข้าว — `kh-cooking-rice`

- ไฟล์ที่ต้องได้: `images/kh-cooking-rice.jpg`
- เลข: 19, 29, 119, 229
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าได้หุงข้าว ความฝันนี้จะทำให้ท่านได้รับของกำนัลจากญาติมิตร ผู้ใหญ่ หรือเป็นข่าวดีจากทางไกล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person cooking rice in a clay pot over a charcoal stove, steam rising. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 19, 29, 119, 229. Do not draw any other numbers, words or letters.
```

### 14. ข้าวสาร — `kh-uncooked-rice`

- ไฟล์ที่ต้องได้: `images/kh-uncooked-rice.jpg`
- เลข: 20, 64, 66, 609, 660
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่า เห็นข้าวสารอยู่ภายในบ้านหรือตามทาง ความฝันนี้จะทำให้ท่านพบกับญาติมิตรหรือลูกหลานที่จากกันไปช้านานโดยไม่นึกฝัน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a large sack of uncooked rice in a house, with a relative arriving at the door after a long journey. Draw exactly 5 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 20, 64, 66, 609, 660. Do not draw any other numbers, words or letters.
```

### 15. ขี่ — `kh-riding-mighty-animal`

- ไฟล์ที่ต้องได้: `images/kh-riding-mighty-animal.jpg`
- เลข: 21, 41, 142, 144
- คำทำนาย (ต้นฉบับ): ฝันว่า ได้ขี่สัตว์ที่มีอำนาจหรือมีพาหนะของผู้ใหญ่ สัตว์ที่มีอำนาจได้แก่ ช้าง หรือเสือ ความฝันนี้ ท่านจะได้เลื่อนฐานะท่านจะได้รับความสุข ตลอดทั้งครอบครัวของท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person riding proudly on the back of a large elephant, a tiger walking calmly alongside. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 21, 41, 142, 144. Do not draw any other numbers, words or letters.
```

### 16. ขี่ควาย — `kh-riding-buffalo`

- ไฟล์ที่ต้องได้: `images/kh-riding-buffalo.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าขี่ควายแล้วตกลงมา ความฝันนี้จะทำให้ท่านต้องได้รับอันตรายจากศัตรู หรือมีคนคิดปองร้าย ท่านจะต้องรดน้ำมนต์ขอความคุ้มครองจากคุณพระ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person falling off the back of a water buffalo in a rice field. Do not draw any numbers, words or letters anywhere in the picture.
```

### 17. ขี่คอคน — `kh-riding-shoulders`

- ไฟล์ที่ต้องได้: `images/kh-riding-shoulders.jpg`
- เลข: 14, 18, 148, 181
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าขี่คอคน ความฝันนี้ท่านจะได้รับความสุขสบายสำราญ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a child riding happily on the shoulders of an adult. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 14, 18, 148, 181. Do not draw any other numbers, words or letters.
```

### 18. ขี่ม้า — `kh-riding-horse`

- ไฟล์ที่ต้องได้: `images/kh-riding-horse.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าขี่ม้า ความฝันนี้ทายว่า ท่านจะพบกับความขัดใจจากญาติ มิตรสหาย หรือคนรัก ด้วยการเข้าใจผิดกัน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person riding a horse along a country road. Do not draw any numbers, words or letters anywhere in the picture.
```

### 19. ขี้ — `kh-excrement`

- ไฟล์ที่ต้องได้: `images/kh-excrement.jpg`
- เลข: 13, 15, 17, 137, 157
- คำทำนาย (ต้นฉบับ): ฝันว่าขี้เปื้อนร่างกาย หรือปัสสาวะ และอุจจาระ ความฝันท่านได้ฝันนี้ ทายว่าท่านจะประสบโชคลาภเงินทองข้าวของ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, tasteful, no bodily detail: a person washing a muddy stain off their clothes beside a water jar, coins scattered on the ground nearby. Draw exactly 5 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 13, 15, 17, 137, 157. Do not draw any other numbers, words or letters.
```

### 20. ขี้เถ้า — `kh-ashes`

- ไฟล์ที่ต้องได้: `images/kh-ashes.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันนั่งเขี่ยขี้เถ้าอยู่ในเตาไฟ ทายว่าท่านจะประสบกับความเดือดร้อน หรือจะได้รับข่าวร้ายจากทางไกล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person sitting in front of a traditional clay stove, stirring grey ashes with a stick. Do not draw any numbers, words or letters anywhere in the picture.
```

### 21. ขึ้น — `kh-climbing`

- ไฟล์ที่ต้องได้: `images/kh-climbing.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าได้ขึ้นต้นไม้ หรือขึ้นเขา ขึ้นเครื่องบิน หรือขับขี่ยานพาหนะใด ๆ ความฝันนี้จะทำให้ท่านได้รับผลสำเร็จในด้านการงาน การเงิน ได้รับเกียรติยศชื่อเสียงเลื่อนตำแหน่ง ความฝันนี้ตรงกันข้าม ถ้าท่านตกจากต้นไม้หรือยานพาหนะ ท่านจะต้องประสบกับความเคราะห์ร้าย เดือดร้อน คนใส่ร้าย ท่านต้องระวังตัวใส่บาตร ทำบุญบูชาพระ สะเดาะเคราะห์เสียบ้าง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person climbing up a tall tree, with a mountain and a small aeroplane in the distance. Do not draw any numbers, words or letters anywhere in the picture.
```

### 22. ขุด — `kh-digging`

- ไฟล์ที่ต้องได้: `images/kh-digging.jpg`
- เลข: 10, 12, 101, 121
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่า ขุดดิน ถ้าเป็นพื้นดินที่สะอาดจะทำให้ท่านได้รับโชคลาภอย่างดี ถ้าเป็นพื้นดินสกปรกจะทำให้พบกับความยุ่งยากร้อนใจจากมิตร

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person digging into clean earth with a hoe, the soil turned over beside a shallow hole. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 10, 12, 101, 121. Do not draw any other numbers, words or letters.
```

### 23. เขย่ง — `kh-limping`

- ไฟล์ที่ต้องได้: `images/kh-limping.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าเดินเขย่ง หรือ ขาพิการ ความฝันนี้ขอให้ท่านจงระวังตัวจะพบกับการใส่ร้ายป้ายสีจากผู้อื่น ทำให้ท่านได้รับความอับอายในชีวิต แต่ไม่เกี่ยวกับอันตราย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking on tiptoe and limping with a crutch along a path. Do not draw any numbers, words or letters anywhere in the picture.
```

### 24. เขา — `kh-mountain-trip`

- ไฟล์ที่ต้องได้: `images/kh-mountain-trip.jpg`
- เลข: 91, 92, 291, 292
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เข้าไปเที่ยวตามเขา หรือตามถ้ำในไพรป่า ฝันนี้ท่านจะได้พบเนื้อคู่ หรือมิตรสหายเพื่อนฝูงที่ถูกใจ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: two people walking happily together into a cave entrance on a forested mountain. Draw exactly 4 numbers in bold rounded dark-brown digits around the subject, each number exactly once, no repeats: 91, 92, 291, 292. Do not draw any other numbers, words or letters.
```

### 25. เขา — `kh-falling-from-mountain`

- ไฟล์ที่ต้องได้: `images/kh-falling-from-mountain.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันว่าตกเขาหรือตกเหว ตกน้ำ ตกรถ ความฝันนี้จะทำให้ท่านต้องจากที่อยู่อาศัย พลัดพรากจากมิตร หรือคู่ครอง ระวังการเจ็บไข้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person slipping off the edge of a mountain cliff towards a ravine (no injury shown). Do not draw any numbers, words or letters anywhere in the picture.
```
