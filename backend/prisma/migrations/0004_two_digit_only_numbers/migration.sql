-- Some sources give only two-digit lucky numbers (e.g. หมวด ง "งู": 33). Such a dream keeps its two-digit list and
-- an empty three-digit list. Rules after this migration:
--   no_lucky_numbers = true  -> both lists and digits empty ("ไม่ควรเสี่ยง")
--   no_lucky_numbers = false -> at least one two-digit number; three-digit numbers may be empty
-- Existing rows all satisfy the new rule (it is strictly looser).
ALTER TABLE "dream" DROP CONSTRAINT "dream_no_lucky_numbers_chk";
ALTER TABLE "dream" ADD CONSTRAINT "dream_no_lucky_numbers_chk"
  CHECK (CASE WHEN "no_lucky_numbers"
              THEN cardinality("two_digit") = 0 AND cardinality("three_digit") = 0 AND cardinality("digits") = 0
              ELSE cardinality("two_digit") > 0 END);
