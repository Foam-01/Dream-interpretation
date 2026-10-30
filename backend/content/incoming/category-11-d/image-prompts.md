# หมวด ด — prompt สร้างภาพ (19 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-11-d/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (10 รายการ) ห้ามมีเลขในภาพ
- ด้วน / ดาบ / โดด เขียนให้ไม่มีภาพบาดเจ็บหรือเลือด
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ดม | `d-smelling.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | ด้วง | `d-beetle.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ด้วน | `d-maimed.jpg` | 11, 33, 131, 337 |
| 4 | ดอกไม้หอม | `d-fragrant-flowers.jpg` | 61, 62, 562, 761 |
| 5 | ดอกไม้บาน | `d-blooming-flowers.jpg` | 51, 52, 251, 256 |
| 6 | ด่า | `d-cursing.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 7 | ดาบ | `d-sword.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 8 | ดาว | `d-falling-stars.jpg` | 57, 59, 257, 259 |
| 9 | ดิน | `d-earth.jpg` | 40, 41, 241, 240 |
| 10 | ดื่ม | `d-drinking.jpg` | 82, 92, 282, 239 |
| 11 | เด็กอ้วน | `d-plump-child.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 12 | เด็กพิการ | `d-disabled-child.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 13 | เดินขึ้นเนิน | `d-walking-uphill.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 14 | เดินที่กว้าง | `d-walking-open-field.jpg` | 29, 39, 241, 293 |
| 15 | เดินบนฟ้า | `d-walking-on-sky.jpg` | 29, 39, 129, 239 |
| 16 | เดินในวัด | `d-walking-in-temple.jpg` | 29, 39, 291, 293 |
| 17 | เดือน | `d-moon.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 18 | แดด | `d-sunshine.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 19 | โดด | `d-jumping.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ดม — `d-smelling`

- ไฟล์ที่ต้องได้: `images/d-smelling.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้ดมกลิ่นที่หอมหวาน ความฝันนี้ท่านจะพบกับญาติมิตรที่จากไปทางไกลจะกลับมาพบกันในเร็ว ๆ วันนี้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person smelling a fragrant jasmine garland, a relative arriving from a long journey at the gate. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. ด้วง — `d-beetle`

- ไฟล์ที่ต้องได้: `images/d-beetle.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าท่านฝันเห็นตัวด้วง-แมลง ความฝันนี้ท่านจะพบกับความยุ่งยากอันเนื่องมาจากบุคคลอื่นนำมาให้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a large beetle and other insects crawling on a table, a person frowning as someone hands them a troublesome parcel. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ด้วน — `d-maimed`

- ไฟล์ที่ต้องได้: `images/d-maimed.jpg`
- เลข: 11, 33, 131, 337
- คำทำนาย (ต้นฉบับ): ฝันว่าอวัยวะในร่างกายของเราเกิดการด้วน-ขาด จนเป็นที่น่าอับอาย ความฝันนี้ต่อไปในอนาคตจะเจริญมีเกียรติยศชื่อเสียงต่อวงศ์ตระกูล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no injury shown: a person with a bandaged arm in a sling standing proudly beside a family shrine with honour plaques. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 11; top-right: 33; bottom-left: 131; bottom-right: 337. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 4. ดอกไม้หอม — `d-fragrant-flowers`

- ไฟล์ที่ต้องได้: `images/d-fragrant-flowers.jpg`
- เลข: 61, 62, 562, 761
- คำทำนาย (ต้นฉบับ): ฝันว่าได้เก็บดอกไม้ที่มีกลิ่นหอมและมีสีสันสวยงาม ความฝันนี้ท่านจะพบกับคู่ครองที่มีตระกูลดี หรือมิฉะนั้นก็จะได้บุตรที่ดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person picking colourful fragrant flowers in a garden, a well-dressed suitor smiling nearby. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 61; top-right: 62; bottom-left: 562; bottom-right: 761. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 5. ดอกไม้บาน — `d-blooming-flowers`

- ไฟล์ที่ต้องได้: `images/d-blooming-flowers.jpg`
- เลข: 51, 52, 251, 256
- คำทำนาย (ต้นฉบับ): ฝันเห็นดอกไม้ในบ้านของเราออกดอกบานสะพรั่ง ความฝันนี้ท่านจะเจริญด้วยกิจการงานและกิจการค้าขายต่าง ๆ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: flowering plants in full bloom inside a house, a busy shop counter with goods in the background. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 51; top-right: 52; bottom-left: 251; bottom-right: 256. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. ด่า — `d-cursing`

- ไฟล์ที่ต้องได้: `images/d-cursing.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าด่าหรือทะเลาะวิวาทกันด้วยถ้อยคำที่หยาบคาย ความฝันนี้ท่านจะพบกับสหายหน้าใหม่ ต่อมาจะเกิดการผิดใจกันขึ้น อาจถึงขั้นขึ้นโรงขึ้นศาล

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: two people quarrelling loudly with angry faces, a courthouse building in the distance. Do not draw any numbers, words or letters anywhere in the picture.
```

### 7. ดาบ — `d-sword`

- ไฟล์ที่ต้องได้: `images/d-sword.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าถือดาบ ความฝันนี้ท่านจงระวังตัวให้มาก เพราะจะมีผู้นำความเดือดร้อน และอันตรายมาสู่ท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person holding an old Thai sword with a worried look, a shadowy figure approaching in the background (no blood). Do not draw any numbers, words or letters anywhere in the picture.
```

### 8. ดาว — `d-falling-stars`

- ไฟล์ที่ต้องได้: `images/d-falling-stars.jpg`
- เลข: 57, 59, 257, 259
- คำทำนาย (ต้นฉบับ): ฝันเห็นดาวเดือนตกจากท้องฟ้า ความฝันนี้ ถ้าผู้ที่ยังมิได้สมรสก็จะได้สมรสในเร็ววันนี้ ถ้าสมรสแล้วก็จะเกิดบุตร

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: shooting stars and a falling moon across the night sky above a village, a young couple watching hand in hand. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 57; top-right: 59; bottom-left: 257; bottom-right: 259. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 9. ดิน — `d-earth`

- ไฟล์ที่ต้องได้: `images/d-earth.jpg`
- เลข: 40, 41, 241, 240
- คำทำนาย (ต้นฉบับ): ถ้าฝันว่าได้รับประทานดิน หรือเก็บมาเล่น ความฝันนี้ ท่านจะพบกับโชคลาภ จากคนที่สนิทสนมกับท่าน แล้วแต่ฐานะของคน ๆ นั้น

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person scooping up handfuls of soil and playing with it, a close friend handing them a pouch of coins. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 40; top-right: 41; bottom-left: 241; bottom-right: 240. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 10. ดื่ม — `d-drinking`

- ไฟล์ที่ต้องได้: `images/d-drinking.jpg`
- เลข: 82, 92, 282, 239
- คำทำนาย (ต้นฉบับ): ฝันว่าดื่มน้ำที่ใสสะอาด ความฝันนี้ท่านจะบังเกิดความสุขสดชื่นในร่างกายของท่าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person drinking clear water from a clay cup beside a well, looking refreshed. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 82; top-right: 92; bottom-left: 282; bottom-right: 239. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 11. เด็กอ้วน — `d-plump-child`

- ไฟล์ที่ต้องได้: `images/d-plump-child.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเด็กขาวอ้วนสมบูรณ์ ความฝันนี้ท่านจะได้รับบำเหน็จจากผู้ใหญ่ทางด้านการงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a plump, healthy, happy baby being held up, an elder giving the parent a reward envelope. Do not draw any numbers, words or letters anywhere in the picture.
```

### 12. เด็กพิการ — `d-disabled-child`

- ไฟล์ที่ต้องได้: `images/d-disabled-child.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเด็กพิการ ความฝันนี้ ท่านจะพบกับความยุ่งยากจากผู้ที่มีอายุอ่อนกว่าท่าน จงระวังตัวให้มาก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a child on crutches looking sad, a worried adult nearby (gentle, respectful). Do not draw any numbers, words or letters anywhere in the picture.
```

### 13. เดินขึ้นเนิน — `d-walking-uphill`

- ไฟล์ที่ต้องได้: `images/d-walking-uphill.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเดินขึ้นบนเนินหรือบันได ความฝันนี้ท่านจะต้องเปลี่ยนแปลงสถานที่อยู่อาศัย จากที่เลวไปที่ดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking up a hill path and stairs towards a nicer house at the top. Do not draw any numbers, words or letters anywhere in the picture.
```

### 14. เดินที่กว้าง — `d-walking-open-field`

- ไฟล์ที่ต้องได้: `images/d-walking-open-field.jpg`
- เลข: 29, 39, 241, 293
- คำทำนาย (ต้นฉบับ): ฝันว่าเดินเล่นในที่กว้างใหญ่ ความฝันนี้ท่านจะพบกับลาภลอย โดยไม่รู้สึกตัวในระยะเวลาเร็ววันนี้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person strolling across a wide open field, a pouch of coins lying in the grass ahead. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 29; top-right: 39; bottom-left: 241; bottom-right: 293. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 15. เดินบนฟ้า — `d-walking-on-sky`

- ไฟล์ที่ต้องได้: `images/d-walking-on-sky.jpg`
- เลข: 29, 39, 129, 239
- คำทำนาย (ต้นฉบับ): ฝันว่าเดินขึ้นบนฟ้าหรือเดินได้ในน้ำ ความฝันนี้จะพบกับความสำเร็จทุกประการ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking on clouds in the sky and on the surface of water, arms raised in triumph. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 29; top-right: 39; bottom-left: 129; bottom-right: 239. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 16. เดินในวัด — `d-walking-in-temple`

- ไฟล์ที่ต้องได้: `images/d-walking-in-temple.jpg`
- เลข: 29, 39, 291, 293
- คำทำนาย (ต้นฉบับ): ฝันว่าเดินเล่นภายในวัดหรือป่าช้า ความฝันนี้ท่านจะพบกับลาภใหญ่ หรือของกำนัลจากคนไกลในเร็ว ๆ วันนี้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking calmly through a temple courtyard with chedis, a messenger bringing a gift from afar. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 29; top-right: 39; bottom-left: 291; bottom-right: 293. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 17. เดือน — `d-moon`

- ไฟล์ที่ต้องได้: `images/d-moon.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเดือนหงายแจ่มกระจ่าง ความฝันนี้ท่านจะพบกับสิ่งที่ไม่ดี คู่ครองของท่านจะทรยศคบชู้สู่สาว (สู่ชาย) ให้ระวัง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a bright full moon over a house at night, a worried person watching a silhouette of their partner leaving with someone else. Do not draw any numbers, words or letters anywhere in the picture.
```

### 18. แดด — `d-sunshine`

- ไฟล์ที่ต้องได้: `images/d-sunshine.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ถ้าฝันว่าตากแดดซึ่งร้อนจัด ความฝันนี้ท่านจะเกิดการเจ็บไข้ภายในบ้าน หรือมิฉะนั้นจะเกิดการแตกร้าวภายในครอบครัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person sweating under a blazing hot sun, a family quarrelling inside the house behind them. Do not draw any numbers, words or letters anywhere in the picture.
```

### 19. โดด — `d-jumping`

- ไฟล์ที่ต้องได้: `images/d-jumping.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้โดดจากที่สูงลงมา ความฝันนี้ทายว่า ท่านจะมีเคราะห์ การงานที่ได้ติดต่อไว้จะเกิดการคดโกงหักหลังในด้านการเงินได้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person jumping down from a high place, coins and papers scattering, a shadowy figure grabbing a money bag (no injury). Do not draw any numbers, words or letters anywhere in the picture.
```
