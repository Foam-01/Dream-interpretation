# หมวด ว — prompt สร้างภาพ (9 รายการ)

ใช้กับ AI สร้างภาพตัวเดียวกับที่ทำรูปหมวด ก เพื่อให้ลายเส้นเหมือนกัน

- 1 ภาพต่อ 1 ความฝัน — ตั้งชื่อไฟล์ตามที่ระบุ (`<id>.jpg`) แล้ววางใน `backend/content/incoming/category-28-w/images/`
  จากนั้นบอกผม ผมจะตรวจเลขในภาพกับต้นฉบับ แล้วย่อและผูกเข้ากับคำทำนายให้
- ตรวจเลขในภาพให้ตรงกับรายการทุกครั้ง: ครบทุกตัว ไม่ซ้ำ ไม่มีเลขอื่น และเลข 0 นำหน้าต้องไม่หาย
- รายการ "ไม่ควรเสี่ยง" (6 รายการ) ห้ามมีเลขในภาพ
- เวจ (ส้วม) วาดให้สุภาพ ไม่สกปรก (เช่น หลุมส้วมแบบเก่าในชนบท)
- ทุกภาพไม่มีการสูบบุหรี่ ไม่วาดบุคคลจริง

| # | ชื่อ | ไฟล์ | เลขในภาพ |
|---|---|---|---|
| 1 | วอ | `w-palanquin.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 2 | วัด | `w-temple.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 3 | วิ่งหนี | `w-running-away.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 4 | วิทยุ | `w-radio.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 5 | วิมาน | `w-celestial-palace.jpg` | 63, 65, 263, 569 |
| 6 | วิหาร | `w-vihara.jpg` | 79, 70, 790, 792 |
| 7 | ว่ายน้ำ | `w-swimming.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 8 | เวที | `w-boxing-ring.jpg` | ไม่มีเลข (ไม่ควรเสี่ยง) |
| 9 | เวจ (ส้วม) | `w-latrine.jpg` | 05, 30, 603, 605 |

### 1. วอ — `w-palanquin`

- ไฟล์ที่ต้องได้: `images/w-palanquin.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นวอหรือคานหามที่มีหลังคา และมีคนหามผ่านหน้าไป ทายว่า ท่านจะได้รับโชคลาภทางไกล หรืออาจจะเป็นลาภในตำแหน่งหน้าที่การงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a roofed palanquin carried on poles by bearers passing by, a person watching with a letter from afar. Do not draw any numbers, words or letters anywhere in the picture.
```

### 2. วัด — `w-temple`

- ไฟล์ที่ต้องได้: `images/w-temple.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นวัด ท่านจะพบกับผู้อุปถัมภ์ การทำงานก็จะได้สำเร็จตามเป้าหมายที่ท่านได้ตั้งไว้

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a beautiful Thai temple with golden roofs, a kind patron welcoming a person at the gate. Do not draw any numbers, words or letters anywhere in the picture.
```

### 3. วิ่งหนี — `w-running-away`

- ไฟล์ที่ต้องได้: `images/w-running-away.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าวิ่งหนีสัตว์หรือเพทภัยต่าง ๆ จนเหนื่อยหอบ ความฝันนี้ มักจะได้แก่คนที่กำลังเจ็บไข้หรือมีทุกข์ร้อน ทายว่า จะหายจากเจ็บไข้หรือทุกข์ร้อน จะผ่อนหนักเป็นเบา

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a tired person running away from a wild boar on a path, panting, sunshine breaking through clouds ahead. Do not draw any numbers, words or letters anywhere in the picture.
```

### 4. วิทยุ — `w-radio`

- ไฟล์ที่ต้องได้: `images/w-radio.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเครื่องวิทยุ หรือเครื่องเล่นที่มีเสียง ทายว่า ท่านจะถูกกล่าวร้ายป้ายสี หรือมีคนใกล้ชิดอิจฉาริษยาหาทางขัดขวางงานต่าง ๆ ที่คิดจะลงมือทำก็จะมีคนคอยทำลายมากกว่าช่วยเหลือ

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an old valve radio playing, people whispering behind a person's back. Do not draw any numbers, words or letters anywhere in the picture.
```

### 5. วิมาน — `w-celestial-palace`

- ไฟล์ที่ต้องได้: `images/w-celestial-palace.jpg`
- เลข: 63, 65, 263, 569
- คำทำนาย (ต้นฉบับ): ฝันเห็นวิมาน ซึ่งเป็นที่อยู่หรือที่ประทับของเทวดา ซึ่งล่องลอยอยู่กลางอากาศ ทายว่า สิ่งที่คิดไว้ หรือการค้าที่กำลังดำเนินอยู่จะสำเร็จลุล่วงไปด้วยดี

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a heavenly Thai celestial palace floating in the clouds, a person looking up with hope. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 63; top-right: 65; bottom-left: 263; bottom-right: 569. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 6. วิหาร — `w-vihara`

- ไฟล์ที่ต้องได้: `images/w-vihara.jpg`
- เลข: 79, 70, 790, 792
- คำทำนาย (ต้นฉบับ): ฝันเห็นหรือเข้าไปในวิหาร ทายว่าท่านจะประสบกับความสุขความเจริญรุ่งเรือง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a person walking into a Thai temple vihara hall with a large Buddha image inside, peaceful light. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 79; top-right: 70; bottom-left: 790; bottom-right: 792. Each of these numbers appears exactly once; never draw the same number twice. Do not draw any other numbers, words or letters.
```

### 7. ว่ายน้ำ — `w-swimming`

- ไฟล์ที่ต้องได้: `images/w-swimming.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันว่าท่านได้ว่ายน้ำเล่น เกิดความเหน็ดเหนื่อย ความฝันนี้ท่านจะพบกับความยุ่งยากทางด้านการงาน

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: a tired person swimming in a river, out of breath, a pile of paperwork on the bank. Do not draw any numbers, words or letters anywhere in the picture.
```

### 8. เวที — `w-boxing-ring`

- ไฟล์ที่ต้องได้: `images/w-boxing-ring.jpg`
- เลข: **ไม่ควรเสี่ยง** — ไม่มีเลขในภาพ
- คำทำนาย (ต้นฉบับ): ฝันเห็นเวทีสำหรับต่อสู้ของนักกีฬาหรือนักมวย ซึ่งเป็นรูปสี่เหลี่ยม มีเชือกขึงสี่ด้าน ทายว่า การที่ท่านคิดจะลงมือประกอบกิจการอย่างใดอย่างหนึ่งจะประสบกับความล้มเหลว หรือถูกมิตรสหายฉ้อโกงหักหลัง

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: an empty Muay Thai boxing ring with ropes on four sides, a friend sneaking away with a contract. Do not draw any numbers, words or letters anywhere in the picture.
```

### 9. เวจ (ส้วม) — `w-latrine`

- ไฟล์ที่ต้องได้: `images/w-latrine.jpg`
- เลข: 05, 30, 603, 605
- คำทำนาย (ต้นฉบับ): ฝันว่าตกเวจหรือหลุมส้วม ทายว่าท่านจะมีโชคลาภใหญ่หลวง ทำการค้าขายก็จะร่ำรวย

```text
Hand-drawn sepia / dark-brown ink line illustration on warm cream textured paper, vintage Thai storybook style, clean outlines with light hatching, faint pencil construction lines left visible, plenty of empty paper space, no colour fills, no frame, 16:9 landscape (2752×1536). Scene: SYMBOLIC and clean: an old rural outhouse with a simple pit, a person stepping out laughing with a bag of gold coins. Draw exactly 4 numbers in bold rounded dark-brown digits, one in each position: top-left: 05; top-right: 30; bottom-left: 603; bottom-right: 605. Each of these numbers appears exactly once; never draw the same number twice. Keep the leading zero (01 is written 0-1). Do not draw any other numbers, words or letters.
```
