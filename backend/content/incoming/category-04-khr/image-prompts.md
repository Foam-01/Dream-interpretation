# หมวด ฆ — prompt สร้างภาพ (4 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-04-khr/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (2 รายการ) ห้ามมีเลขในภาพ
- ถูกฆ่า / ฆ่าตัวเอง / เฆี่ยน เขียนให้เป็นภาพเชิงสัญลักษณ์: ไม่มีภาพรุนแรง ไม่มีเลือด ไม่มีภาพทำร้ายตัวเอง
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | ฆ้อง | `khr-gong.jpg` | 08, 09, 708, 709 |
| 2 | ถูกฆ่า | `khr-killed-and-revived.jpg` | 04, 08, 104, 108 |
| 3 | ฆ่าตัวเอง | `khr-killing-oneself.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | เฆี่ยน | `khr-whipping.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |

### 1. ฆ้อง — `khr-gong`

- ไฟล์ที่ต้องได้: `images/khr-gong.jpg`
- เลข: 08, 09, 708, 709
- คำทำนาย (ต้นฉบับ): ฝันเห็นฆ้องหรือได้ยินเสียงฆ้อง หรือได้จับต้องตีฆ้อง ทายว่า ท่านจะได้เลื่อนตำแหน่งหน้าที่การงานหรือยศศักดิ์ หรือได้รับเกียรติยศชื่อเสียง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person striking a large hanging Thai gong with a padded mallet in a temple courtyard, an elder presenting them with a rank sash. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 08; top-right: 09; bottom-left: 708; bottom-right: 709. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 2. ถูกฆ่า — `khr-killed-and-revived`

- ไฟล์ที่ต้องได้: `images/khr-killed-and-revived.jpg`
- เลข: 04, 08, 104, 108
- คำทำนาย (ต้นฉบับ): ฝันว่าตัวของเราได้ถูกคนอื่นฆ่าตาย แต่แล้วกลับฟื้นขึ้นมาได้ ตามความฝันอันนี้ ท่านปลอดภัยทุกประการ ศัตรูที่คิดจะทำร้ายเราก็จะแพ้ภัยไปเอง และท่านกำลังจะได้ลาภ พร้อมด้วยได้รับการช่วยเหลือจากผู้อื่น

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no violence or blood: a person waking up and sitting up safely on a mat at dawn, surrounded by soft light, a friend offering a helping hand and a small bag of coins. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 04; top-right: 08; bottom-left: 104; bottom-right: 108. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```

### 3. ฆ่าตัวเอง — `khr-killing-oneself`

- ไฟล์ที่ต้องได้: `images/khr-killing-oneself.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าท่านฆ่าตัวของท่านเอง ความฝันนี้ ทำนายว่าท่านที่ฝันได้รับความยุ่งยากใจ เดือดเนื้อร้อนใจจนถึงกับกลุ้มใจ ถึงแม้จะอยู่ที่ไหนก็ไม่ได้รับความสุขอย่างเต็มที่

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no self-harm depicted: a troubled person sitting alone with head in hands under a grey cloud, an empty room around them. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. เฆี่ยน — `khr-whipping`

- ไฟล์ที่ต้องได้: `images/khr-whipping.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าท่านได้เฆี่ยนตีผู้ที่ท่านรัก หรือถึงแม้จะเป็นสามีภรรยากัน ความฝันนี้ ทำนายว่าท่านต้องหมองใจ จนกระทั่งเป็นปากเสียงกันอย่างรุนแรง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC, no violence: a married couple standing back to back with arms crossed after an argument, a broken twig on the floor between them. Do not draw any numbers, words or letters anywhere in the picture.
```
