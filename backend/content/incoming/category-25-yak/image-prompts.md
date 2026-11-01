# หมวด ย — prompt สร้างภาพ (8 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-25-yak/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (5 รายการ) ห้ามมีเลขในภาพ
- ยักษ์กินคน / ยิง เขียนให้เป็นภาพเชิงสัญลักษณ์ ไม่มีเลือดหรือคนถูกทำร้าย
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ยวดยาน | `yak-vehicles.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | ยศศักดิ์ | `yak-rank.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | ยักษ์ | `yak-giant.jpg` | 78, 79, 878, 789 |
| 4 | ยันต์ | `yak-amulet-cloth.jpg` | 47, 48, 147, 148 |
| 5 | ย่าม | `yak-shoulder-bag.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 6 | ยิง | `yak-shooting.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 7 | ยุ้งข้าว | `yak-granary.jpg` | 28, 29, 289, 889 |
| 8 | ยูง (นก) | `yak-peacock.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ยวดยาน — `yak-vehicles`

- ไฟล์ที่ต้องได้: `images/yak-vehicles.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเห็นยวดยานวิ่งสับสนไปมา หรือฝันได้นั่งยานพาหนะหรือรถต่าง ๆ ทายว่าท่านจะต้องย้ายที่อยู่หรือที่ทำงาน หรือมิฉะนั้นก็จะต้องมีเรื่องยุ่ง ๆ ภายในครอบครัว

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: busy traffic of cars, buses and tuk-tuks rushing in all directions, a family loading boxes to move house. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. ยศศักดิ์ — `yak-rank`

- ไฟล์ที่ต้องได้: `images/yak-rank.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวเราได้ยศศักดิ์เป็นเจ้าใหญ่นายโต ความฝันนี้ทายว่า ท่านจะต้องประสบกับกิจการงานที่ลำบากยุ่งยาก อันเป็นต้นเหตุทำให้ท่านต้องหนักใจหรือหนักสมอง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person in a grand official uniform with medals, sitting at a desk piled with difficult paperwork, holding their head. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. ยักษ์ — `yak-giant`

- ไฟล์ที่ต้องได้: `images/yak-giant.jpg`
- เลข: 78, 79, 878, 789
- คำทำนาย (ต้นฉบับ): ฝันว่ายักษ์กินคน ทายว่า ท่านจะมีอำนาจวาสนาต่อไป

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no one hurt: a big Thai temple guardian giant (yak) standing powerfully, a person beside it holding a staff of authority. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 78; top-right: 79; bottom-left: 878; bottom-right: 789. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 4. ยันต์ — `yak-amulet-cloth`

- ไฟล์ที่ต้องได้: `images/yak-amulet-cloth.jpg`
- เลข: 47, 48, 147, 148
- คำทำนาย (ต้นฉบับ): ฝันเห็นผ้ายันต์ หรือได้สวมเสื้อยันต์กันเพทภัย ทายว่า ท่านจะทุเลาหรือหายจากโรคภัยไข้เจ็บที่เป็นเรื้อรัง หรือจะได้รับข่าวดีข่าวมงคลเกี่ยวกับญาติพี่น้องภายในบ้าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person wearing a shirt covered in yantra protective patterns, recovering and smiling, relatives bringing good news. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 47; top-right: 48; bottom-left: 147; bottom-right: 148. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 5. ย่าม — `yak-shoulder-bag`

- ไฟล์ที่ต้องได้: `images/yak-shoulder-bag.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นย่ามหรือกระเป๋า หรือได้จับต้องได้หยิบมาสะพายถือคล้องในมือ ทายว่า ท่านจะได้รับเคราะห์หนักจากการเจ็บไข้ได้ป่วย หรือมิฉะนั้น ก็จะต้องเสียทรัพย์สินภายในบ้าน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person carrying a cloth shoulder bag (yam), looking unwell and worried. Do not draw any numbers, words or letters anywhere in the picture.
```

### 6. ยิง — `yak-shooting`

- ไฟล์ที่ต้องได้: `images/yak-shooting.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าเรายิงปืนเล่น หรือถูกคนอื่นยิง ทายว่า ท่านจะพบกับความมีโชคชัยในการงานต่าง ๆ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no one shot: a person aiming a toy gun at a target at a fair, then holding a trophy at work. Do not draw any numbers, words or letters anywhere in the picture.
```

### 7. ยุ้งข้าว — `yak-granary`

- ไฟล์ที่ต้องได้: `images/yak-granary.jpg`
- เลข: 28, 29, 289, 889
- คำทำนาย (ต้นฉบับ): ฝันเห็นยุ้งข้าวของชาวไร่ชาวนา หรือเห็นกองข้าวเปลือกเก็บไว้ในยุ้ง หรือห้องเก็บข้าวเปลือกใหญ่โต ทายว่า ท่านจะได้ลาภทางเสี่ยงโชค หรือการค้าจะเจริญรุ่งเรืองขึ้นอย่างอุ่นหนาฝาคั่ง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a big wooden rice granary full of paddy rice, a farmer smiling beside heaps of rice sacks. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 28; top-right: 29; bottom-left: 289; bottom-right: 889. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 8. ยูง (นก) — `yak-peacock`

- ไฟล์ที่ต้องได้: `images/yak-peacock.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นนกยูงกำลังรำแพนหาง ทายว่า ท่านจะได้เลื่อนตำแหน่งหน้าที่ในการงาน หรือจะได้ลาภเป็นเกียรติยศชื่อเสียง แต่ไม่ใช่ลาภจรหรือลาภเสี่ยงโชค

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a peacock displaying its beautiful fanned tail in a garden. Do not draw any numbers, words or letters anywhere in the picture.
```
