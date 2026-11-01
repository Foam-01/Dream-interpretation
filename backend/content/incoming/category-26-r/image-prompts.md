# หมวด ร — prompt สร้างภาพ (16 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-26-r/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (10 รายการ) ห้ามมีเลขในภาพ
- รายการเรือ / เรือน เขียนให้ไม่มีคนจมน้ำหรือบาดเจ็บ; ราหูอมจันทร์วาดแบบศิลปะไทย ไม่น่ากลัว
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | รถไฟ | `r-train.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | รองเท้า | `r-shoes.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ร้องรำ | `r-singing-dancing.jpg` | 55, 56, 256, 356 |
| 4 | ร้องไห้ | `r-crying.jpg` | 56, 57, 256 |
| 5 | ระนาด | `r-ranat.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 6 | รังนก | `r-nest.jpg` | 90, 92, 290, 390 |
| 7 | ราชสิงห์ | `r-royal-lion.jpg` | 39, 79, 459, 479 |
| 8 | ราตรี | `r-night-jasmine.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 9 | ราหู | `r-rahu.jpg` | 50, 60, 050, 060 |
| 10 | ร่ำรวย | `r-rich.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 11 | รุ้งกินน้ำ | `r-rainbow.jpg` | 74, 75, 274, 375 |
| 12 | เรือล่ม | `r-boat-sinking.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 13 | เรือกลางพายุ | `r-boat-storm.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 14 | เรือหลุดลอย | `r-boat-drifting.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 15 | เรือน | `r-house-collapse.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 16 | ไรและมด | `r-mites.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. รถไฟ — `r-train`

- ไฟล์ที่ต้องได้: `images/r-train.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าได้นั่งรถไฟเล่น ความฝันนี้ คนที่อยู่ห่างไกลกำลังจะเดินทางมาหาท่านในเร็ววัน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person sitting by the window of an old train, a friend from far away waving at the station. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. รองเท้า — `r-shoes`

- ไฟล์ที่ต้องได้: `images/r-shoes.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นรองเท้า หรือได้สวมรองเท้าคู่ใหม่ หรือฝันเห็นรองพระบาทของกษัตริย์ ทายว่า ถ้าเป็นสตรีสาวโสด จะได้พบกับคู่ครอง แต่ถ้าเป็นชายจะมีการเปลี่ยนแปลงโยกย้ายหน้าที่การงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a pair of new shoes on a stand, a young woman trying them on, a man carrying boxes to a new office. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ร้องรำ — `r-singing-dancing`

- ไฟล์ที่ต้องได้: `images/r-singing-dancing.jpg`
- เลข: 55, 56, 256, 356
- คำทำนาย (ต้นฉบับ): ฝันเห็นคนร้องรำทำเพลงสนุกสนานกัน ความฝันนี้ท่านจะอยู่เย็นเป็นสุข ปราศจากโรคภัยไข้เจ็บทุกประการ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: people singing and dancing happily at a village festival with Thai music. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 55; top-right: 56; bottom-left: 256; bottom-right: 356. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 4. ร้องไห้ — `r-crying`

- ไฟล์ที่ต้องได้: `images/r-crying.jpg`
- เลข: 56, 57, 256
- คำทำนาย (ต้นฉบับ): ฝันว่าร้องไห้ ความฝันนี้ ท่านจะได้ลาภของกำนัล คิดสิ่งใดไว้จะบังเกิดความสำเร็จทุกประการ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person wiping tears, then receiving a gift box with a smile. Draw exactly 3 numbers in bold rounded dark-brown digits, one in each position: top-left: 56; top-right: 57; bottom-left: 256. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 5. ระนาด — `r-ranat`

- ไฟล์ที่ต้องได้: `images/r-ranat.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นระนาด หรือเครื่องปี่พาทย์ลาดตะโพน หรือวงระนาดกำลังบรรเลงเพลง ทายว่า ท่านจะต้องประสบเคราะห์ หรือเกี่ยวกับคนใกล้ชิด หรือคนภายในบ้านจะต้องพลัดพรากจากกันไป

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a Thai piphat ensemble with a ranat xylophone and drums playing, a family member waving goodbye in the distance. Do not draw any numbers, words or letters anywhere in the picture.
```

### 6. รังนก — `r-nest`

- ไฟล์ที่ต้องได้: `images/r-nest.jpg`
- เลข: 90, 92, 290, 390
- คำทำนาย (ต้นฉบับ): ฝันเห็นรังนกตามพุ่มไม้ ได้จับต้องรังซึ่งมีไข่หรือลูกนก หรือฝันเห็นรังไข่ของไก่ในเล้ามีไข่และลูกไก่อยู่ด้วย ทายว่า ท่านจะประสบกับความรุ่งเรืองในด้านการค้า หรือมีการขยายหน้าที่การงาน หรือการค้าขายออกไปได้สำเร็จ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a bird nest with eggs and chicks in a bush, a hen with chicks in a coop, a busy shop expanding. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 90; top-right: 92; bottom-left: 290; bottom-right: 390. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. ราชสิงห์ — `r-royal-lion`

- ไฟล์ที่ต้องได้: `images/r-royal-lion.jpg`
- เลข: 39, 79, 459, 479
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นราชสิงห์ ความฝันนี้ ท่านจะได้รับข่าวที่เป็นมงคล และจะมีผู้สูงอายุนำของมากำนัลให้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a majestic Thai mythical royal lion (ratchasingha) statue, an elderly person bringing a gift. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 39; top-right: 79; bottom-left: 459; bottom-right: 479. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 8. ราตรี — `r-night-jasmine`

- ไฟล์ที่ต้องได้: `images/r-night-jasmine.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นหรือได้ดมดอกราตรี ความฝันนี้ทายว่า ถ้าท่านยังไม่มีคู่ครองก็จะได้พบกับคู่ครองที่มีรูปสวย แต่ถ้าท่านแต่งงานแล้วก็จะได้บุตรหญิงที่น่ารัก

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person smelling night-blooming jasmine flowers in a garden under the moon, a beautiful partner and a baby girl nearby. Do not draw any numbers, words or letters anywhere in the picture.
```

### 9. ราหู — `r-rahu`

- ไฟล์ที่ต้องได้: `images/r-rahu.jpg`
- เลข: 50, 60, 050, 060
- คำทำนาย (ต้นฉบับ): ฝันเห็นราหูอมจันทร์ ความฝันนี้ ท่านจะได้เดินทาง หรือได้ท่องเที่ยวตากอากาศอันสดชื่น กิจการงานต่าง ๆ จะสำเร็จลุล่วงไปได้อย่างง่ายดาย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: Thai-art style Rahu swallowing the moon in the night sky, not scary, a person setting off on a holiday trip below. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 50; top-right: 60; bottom-left: 050; bottom-right: 060. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 10. ร่ำรวย — `r-rich`

- ไฟล์ที่ต้องได้: `images/r-rich.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวของเราเองเกิดร่ำรวยขึ้น ความฝันนี้ท่านจะเกิดความยุ่งยากใจในเรื่องการงานและการเงิน หรืออาจจะต้องเกิดการเข้าใจผิดกับคนใกล้ชิดกัน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person surrounded by piles of money looking stressed over account books, a friend frowning in misunderstanding. Do not draw any numbers, words or letters anywhere in the picture.
```

### 11. รุ้งกินน้ำ — `r-rainbow`

- ไฟล์ที่ต้องได้: `images/r-rainbow.jpg`
- เลข: 74, 75, 274, 375
- คำทำนาย (ต้นฉบับ): ฝันเห็นรุ้งกินน้ำบนท้องฟ้า หรือรูปรุ้งเจ็ดสีอย่างชัดเจน ทายว่า ท่านจะได้รับเกียรติยศและชื่อเสียงในหน้าที่การงาน หรือการประกอบกิจกรรมอย่างใดอย่างหนึ่งอยู่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a clear seven-colour rainbow arching over fields, a person receiving an honour certificate. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 74; top-right: 75; bottom-left: 274; bottom-right: 375. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 12. เรือล่ม — `r-boat-sinking`

- ไฟล์ที่ต้องได้: `images/r-boat-sinking.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่านั่งเรือล่ม ทายว่า ท่านจะต้องเดือดร้อนใจ ถ้ามีคู่ก็จะเกิดเรื่องผิดกัน หรือต้องพรากจากกันไปชั่วคราวก่อน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no one drowning: a small boat tipping over near the shore, a couple standing apart on the bank. Do not draw any numbers, words or letters anywhere in the picture.
```

### 13. เรือกลางพายุ — `r-boat-storm`

- ไฟล์ที่ต้องได้: `images/r-boat-storm.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่านั่งเรือเล่น มีพายุฝนตกหนัก ความฝันนี้ท่านจะต้องพลัดพรากจากที่อยู่ ไร้ที่อาศัย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person in a small boat under heavy rain and storm wind, a house far away on the shore. Do not draw any numbers, words or letters anywhere in the picture.
```

### 14. เรือหลุดลอย — `r-boat-drifting`

- ไฟล์ที่ต้องได้: `images/r-boat-drifting.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเรือหลุดลอยมา ความฝันนี้ ท่านจงระวัง จะมีบุคคลอื่นหาเรื่องหาราวให้ หรือคนรอบข้างจะนำความลำบากใจมาให้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an empty boat drifting downstream towards a person on a pier, gossiping people behind them. Do not draw any numbers, words or letters anywhere in the picture.
```

### 15. เรือน — `r-house-collapse`

- ไฟล์ที่ต้องได้: `images/r-house-collapse.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเรือนที่อาศัยพังทลายลง ความฝันนี้ท่านจะเกิดเป็นถ้อยความขึ้นโรงขึ้นศาล ต้องเสียเงินเสียทอง ท่านควรไปแก้ฝันกับทางน้ำ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no one hurt: an old wooden house collapsing, a worried person holding court papers. Do not draw any numbers, words or letters anywhere in the picture.
```

### 16. ไรและมด — `r-mites`

- ไฟล์ที่ต้องได้: `images/r-mites.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวไรตอมหรือมดกัด ความฝันนี้ทายว่า ท่านจะได้พบกับมิตรหน้าใหม่ จะสนิทสนมกันในวันข้างหน้า

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: tiny mites and ants around a person's arm, the person shaking hands with a new friend. Do not draw any numbers, words or letters anywhere in the picture.
```
