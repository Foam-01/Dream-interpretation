import 'design_data.dart';

/// Bundled illustrations of หมวด ก dreams, by stable dream id. Cropped/resized from the owner-supplied
/// images in backend/content/incoming/category-01-k/images (the originals are unchanged); a picture showing
/// two dreams was split left/right. The mapping follows the lucky numbers drawn in each picture.
/// Not used (owner decision): k-06 (shows 157, which is not in the source) and the left half of k-10.
const dreamImagesK = <String, DreamImage>{
  'k-chicken': DreamImage.asset('assets/dreams/k-chicken.jpg', alt: 'ภาพประกอบ: ไก่'),
  'k-taking-medicine': DreamImage.asset('assets/dreams/k-taking-medicine.jpg', alt: 'ภาพประกอบ: กินยา'),
  'k-key': DreamImage.asset('assets/dreams/k-key.jpg', alt: 'ภาพประกอบ: กุญแจ'),
  'k-eating-rice': DreamImage.asset('assets/dreams/k-eating-rice.jpg', alt: 'ภาพประกอบ: กินข้าว'),
  'k-rabbit': DreamImage.asset('assets/dreams/k-rabbit.jpg', alt: 'ภาพประกอบ: กระต่าย'),
  'k-drum': DreamImage.asset('assets/dreams/k-drum.jpg', alt: 'ภาพประกอบ: กลอง'),
  'k-cart-riding': DreamImage.asset('assets/dreams/k-cart-riding.jpg', alt: 'ภาพประกอบ: เกวียน'),
  'k-frog': DreamImage.asset('assets/dreams/k-frog.jpg', alt: 'ภาพประกอบ: กบ'),
  'k-bird-cage': DreamImage.asset('assets/dreams/k-bird-cage.jpg', alt: 'ภาพประกอบ: กรงนก'),
  'k-eating-lotus': DreamImage.asset('assets/dreams/k-eating-lotus.jpg', alt: 'ภาพประกอบ: กินบัว'),
  'k-eating-bees': DreamImage.asset('assets/dreams/k-eating-bees.jpg', alt: 'ภาพประกอบ: กินผึ้ง'),
  'k-glass-vessel': DreamImage.asset('assets/dreams/k-glass-vessel.jpg', alt: 'ภาพประกอบ: แก้ว (ภาชนะ)'),
};

/// The image to show for a dream: the API's image when it has one, else the bundled one, else null
/// (the placeholder). Works the same in offline and API mode.
DreamImage? dreamImageFor(String id, [DreamImage? remote]) => remote ?? dreamImagesK[id];
