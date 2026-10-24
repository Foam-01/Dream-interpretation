# หมวด ข — prompt สร้างภาพรอบ 2 (3 รายการที่ต้องทำใหม่)

> **สถานะ: เสร็จแล้ว** — รูปรอบ 2 ทั้ง 3 รูป (เจ้าของแอปวางทับชื่อเดิม `<id>.jpg`) ตรวจเลขผ่าน และผูกเข้าแอปแล้ว (ครบ 25/25)

รอบแรกได้ครบ 25 รูป ผ่านการตรวจเลข 22 รูป (ผูกเข้าแอปแล้ว) ส่วน 3 รูปด้านล่างมีเลขซ้ำหรือขาด จึงต้องสร้างใหม่

- บันทึกเป็นชื่อใหม่ `<id>-v2.jpg` ใน `images/` (เก็บรูปรอบแรกไว้เทียบ) แล้วบอกผม — ผมจะตรวจเลขอีกครั้งก่อนผูก
- prompt รอบนี้กำหนดตำแหน่งให้แต่ละเลข เพื่อไม่ให้ AI วาดเลขซ้ำ

### 1. ขนม — `kh-dessert`

- ไฟล์ที่ต้องได้: `images/kh-dessert-v2.jpg`
- เลข: 22, 44, 224, 244
- รอบแรกผิดตรงไหน: 44 was drawn twice (5 numbers instead of 4)

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person happily eating Thai desserts (kanom) from a tray, with a family smiling around a low table. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 22; top-right: 44; bottom-left: 224; bottom-right: 244. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 2. ขาย — `kh-selling-goods`

- ไฟล์ที่ต้องได้: `images/kh-selling-goods-v2.jpg`
- เลข: 23, 25, 27, 235, 237
- รอบแรกผิดตรงไหน: 25 was drawn twice and 27 was missing

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a street vendor standing beside a basket of goods, selling to friendly relatives and an elder. Draw exactly 5 numbers in bold rounded dark-brown digits, one in each position: top-left: 23; top-right: 25; bottom-left: 27; bottom-right: 235; bottom-centre: 237. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 3. ข้าวสาร — `kh-uncooked-rice`

- ไฟล์ที่ต้องได้: `images/kh-uncooked-rice-v2.jpg`
- เลข: 20, 64, 66, 609, 660
- รอบแรกผิดตรงไหน: 64 was drawn twice (6 numbers instead of 5)

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a large sack of uncooked rice in a house, with a relative arriving at the door after a long journey. Draw exactly 5 numbers in bold rounded dark-brown digits, one in each position: top-left: 20; top-right: 64; bottom-left: 66; bottom-right: 609; bottom-centre: 660. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```
