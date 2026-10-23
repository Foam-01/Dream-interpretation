-- AlterTable
ALTER TABLE "dream" ADD COLUMN     "no_lucky_numbers" BOOLEAN NOT NULL DEFAULT false;

-- ---------------------------------------------------------------------------
-- Hand-written constraints. Existing rows all have numbers, so they satisfy the new rules.
-- ---------------------------------------------------------------------------

-- "ไม่ควรเสี่ยง": number lists are empty exactly when no_lucky_numbers is true.
ALTER TABLE "dream" DROP CONSTRAINT "dream_two_digit_chk";
ALTER TABLE "dream" ADD CONSTRAINT "dream_two_digit_chk"
  CHECK (array_position("two_digit", NULL) IS NULL
         AND (cardinality("two_digit") = 0 OR array_to_string("two_digit", ',') ~ '^[0-9]{2}(,[0-9]{2})*$'));
ALTER TABLE "dream" DROP CONSTRAINT "dream_three_digit_chk";
ALTER TABLE "dream" ADD CONSTRAINT "dream_three_digit_chk"
  CHECK (array_position("three_digit", NULL) IS NULL
         AND (cardinality("three_digit") = 0 OR array_to_string("three_digit", ',') ~ '^[0-9]{3}(,[0-9]{3})*$'));
ALTER TABLE "dream" ADD CONSTRAINT "dream_no_lucky_numbers_chk"
  CHECK (CASE WHEN "no_lucky_numbers"
              THEN cardinality("two_digit") = 0 AND cardinality("three_digit") = 0 AND cardinality("digits") = 0
              ELSE cardinality("two_digit") > 0 AND cardinality("three_digit") > 0 END);

-- The content owner may approve (VERIFIED) content without a cited source.
ALTER TABLE "dream" DROP CONSTRAINT "dream_verified_has_source_chk";
