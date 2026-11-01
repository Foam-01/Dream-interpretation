# หมวด ป — prompt สร้างภาพ (13 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-18-p/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (6 รายการ) ห้ามมีเลขในภาพ
- ปาดเนื้อ / ปืน เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีเลือดหรือคนถูกยิง
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ปราสาท | `p-palace.jpg` | 91, 92, 791, 892 |
| 2 | ปลวกขึ้นบ้าน | `p-termites.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ปลวก (จอมปลวก) | `p-termite-mound.jpg` | 78, 89, 178, 189 |
| 4 | ปลา | `p-fish.jpg` | 78, 88, 718, 818 |
| 5 | ปลิง | `p-leech.jpg` | 82, 83, 282, 283 |
| 6 | ป่วยเอง | `p-being-ill.jpg` | 87, 89, 187, 189 |
| 7 | ป่วย (เห็นคนป่วย) | `p-seeing-sick.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 8 | ป่า | `p-forest.jpg` | 80, 81, 280, 281 |
| 9 | ป่าช้า | `p-cemetery.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 10 | ปาดเนื้อ | `p-slicing-flesh.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 11 | ปีก | `p-wings.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 12 | ปืน | `p-gun.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 13 | เป่าแตร | `p-blowing-horn.jpg` | 83, 84, 283, 284 |

### 1. ปราสาท — `p-palace`

- ไฟล์ที่ต้องได้: `images/p-palace.jpg`
- เลข: 91, 92, 791, 892
- คำทำนาย (ต้นฉบับ): ฝันว่าได้อยู่หรือได้เข้าไปในปราสาทมหาราชวัง หรือได้พบเห็นมหาปราสาทราชวังโบราณหรือปัจจุบันก็ดี ท่านจะได้เลื่อนยศชั้นตำแหน่งหน้าที่อันใหญ่โตมโหฬาร

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking into a grand Thai royal palace hall with golden spires, being given a high rank sash. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 91; top-right: 92; bottom-left: 791; bottom-right: 892. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 2. ปลวกขึ้นบ้าน — `p-termites`

- ไฟล์ที่ต้องได้: `images/p-termites.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าปลวกขึ้นบ้าน หรือขึ้นตามสถานที่อยู่หรือที่ทำงาน ท่านจงระวังเคราะห์จะได้รับอันตราย ต้องโศกเศร้าเสียใจ หรืออาจเกิดอุบัติเหตุให้เดือดร้อน เสียเงินเสียทองของอันมีค่า

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: termites swarming up the wooden posts of a house, a worried person holding a broken valuable vase. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ปลวก (จอมปลวก) — `p-termite-mound`

- ไฟล์ที่ต้องได้: `images/p-termite-mound.jpg`
- เลข: 78, 89, 178, 189
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ขึ้นไปบนจอมปลวก จะได้เกียรติยศและตำแหน่งหน้าที่สูงขึ้นไปกว่าเดิมได้ ไม่มีงานทำก็จะได้ทำงานอันมีอำนาจราชศักดิ์ งานที่ทำจะราบรื่นแจ่มใส

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person standing proudly on top of a tall termite mound, an official handing them an appointment scroll. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 78; top-right: 89; bottom-left: 178; bottom-right: 189. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 4. ปลา — `p-fish`

- ไฟล์ที่ต้องได้: `images/p-fish.jpg`
- เลข: 78, 88, 718, 818
- คำทำนาย (ต้นฉบับ): ฝันว่าจับปลาได้ ฝันนี้มีความหมายว่า จะได้ทรัพย์สินแก้วแหวนเงินทอง การงานที่ทำขึ้นจะบังเกิดผลสมความปรารถนา ค้าขายจะมีกำไรดี ทวงหนี้สินจะได้ผลสมหวัง หรือจะทำการสิ่งใดก็เกิดผลเป็นเงินเป็นทองทั้งสิ้น

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person catching a big fish with a net, gold rings and coins in the basket beside them. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 78; top-right: 88; bottom-left: 718; bottom-right: 818. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 5. ปลิง — `p-leech`

- ไฟล์ที่ต้องได้: `images/p-leech.jpg`
- เลข: 82, 83, 282, 283
- คำทำนาย (ต้นฉบับ): ฝันว่าปลิงเกาะหรือปลิงกัด ความฝันนี้ท่านจะประสบกับความรัก หรือได้สัตว์ 2 เท้า 4 เท้า ได้คู่-ได้สมรส

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a leech on a person's leg near a pond, a smiling partner and a goat and a chicken nearby. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 82; top-right: 83; bottom-left: 282; bottom-right: 283. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. ป่วยเอง — `p-being-ill`

- ไฟล์ที่ต้องได้: `images/p-being-ill.jpg`
- เลข: 87, 89, 187, 189
- คำทำนาย (ต้นฉบับ): ฝันว่าตนเจ็บป่วยด้วยโรคหนึ่งโรคใด ความฝันนี้จะมีความหมายว่า ฐานะของตนจะบังเกิดความอัศจรรย์อย่างไม่นึกฝัน คือถ้ามั่งมีก็จะกลายเป็นยากจน ถ้ายากจนข้นแค้นก็จะกลับเป็นร่ำรวยขึ้น

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person lying ill in bed, half of the picture showing a poor hut turning into a rich house. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 87; top-right: 89; bottom-left: 187; bottom-right: 189. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. ป่วย (เห็นคนป่วย) — `p-seeing-sick`

- ไฟล์ที่ต้องได้: `images/p-seeing-sick.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นคนนอนป่วย ความฝันนี้ จะมีความหมายว่าผู้นั้นมีความสุขกายสบายใจ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person visiting someone resting in bed who looks calm and content. Do not draw any numbers, words or letters anywhere in the picture.
```

### 8. ป่า — `p-forest`

- ไฟล์ที่ต้องได้: `images/p-forest.jpg`
- เลข: 80, 81, 280, 281
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เดินเข้าไปในป่า หรือเที่ยวเล่นในป่า ในสวน มีใบไม้เขียวสดสว่างงามดี มีดอกและผลหรือไม่ก็ตาม แต่เป็นทิวทัศน์ที่เย็นระรื่น ชวนให้ชื่นสุข หมายความว่าจะได้งานทำอันเป็นหลักฐานมั่นคง หรือผลของงานจะเจริญเพิ่มผลิตผลให้อย่างพอใจ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking through a lush green forest garden with flowers and fruit trees, peaceful. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 80; top-right: 81; bottom-left: 280; bottom-right: 281. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 9. ป่าช้า — `p-cemetery`

- ไฟล์ที่ต้องได้: `images/p-cemetery.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เห็นป่าช้า หรือได้เดินไปในป่าช้า ฝันนี้มีความหมายว่า จะมีความสุขกายสบายใจ ปราศจากโรคภัยไข้เจ็บทั้งปวง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a calm person walking past white funeral stupas in a quiet temple cemetery, healthy and at peace. Do not draw any numbers, words or letters anywhere in the picture.
```

### 10. ปาดเนื้อ — `p-slicing-flesh`

- ไฟล์ที่ต้องได้: `images/p-slicing-flesh.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าปาดเนื้อของตนออก และมีคนมายื่นให้ตนอีกครั้ง ให้แก้ฝันกับคนผิวเนื้อสองสี (ดำแดง) โดยนั่งหันหลังให้ แล้วฝันนั้นจะกลายเป็นสิริมงคลแก่ตนเองดีนักแล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no blood or wound: a person sitting with their back to a dark-skinned elder performing a dream-cleansing ritual with candles. Do not draw any numbers, words or letters anywhere in the picture.
```

### 11. ปีก — `p-wings`

- ไฟล์ที่ต้องได้: `images/p-wings.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตนออกปีกออกหาง เป็นเครื่องหมายที่ไม่ดี ให้ขลิบผมออกเสียหน่อยจึงจะพ้นเคราะห์พ้นโศก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person with small feathered wings and a tail on their back, a barber trimming their hair. Do not draw any numbers, words or letters anywhere in the picture.
```

### 12. ปืน — `p-gun`

- ไฟล์ที่ต้องได้: `images/p-gun.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ยิงปืนหรือถือปืน ความฝันนี้ จะมีผลสำเร็จสมความประสงค์ คนโสดจะพบคู่ หรือมีคู่จะบังเกิดบุตร มิฉะนั้นจะประสบความสำเร็จในด้านของความรัก และการสมรส

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no one shot: a person holding an old rifle pointed at the sky, a wedding garland and a baby cradle nearby. Do not draw any numbers, words or letters anywhere in the picture.
```

### 13. เป่าแตร — `p-blowing-horn`

- ไฟล์ที่ต้องได้: `images/p-blowing-horn.jpg`
- เลข: 83, 84, 283, 284
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เป่าแตรสังข์ หรือแตรอย่างอื่นใด และมีเสียงระฆังฆ้องกลองดังสนั่น หรือฝันว่าได้ยินเสียงเขาเป่าแตร ปี่ ฆ้อง กลอง เป็นความฝันที่จะทำให้ตัวท่านมีอำนาจราชศักดิ์ ให้ตั้งมั่นบูชาสิ่งที่ตนยึดมั่นแล้วจะเจริญรุ่งเรืองถาวรดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person blowing a conch shell horn with gongs and drums sounding in a temple ceremony. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 83; top-right: 84; bottom-left: 283; bottom-right: 284. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```
