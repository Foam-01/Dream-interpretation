import { DreamIdPipe } from './dream-id.pipe';

describe('DreamIdPipe', () => {
  const pipe = new DreamIdPipe();

  it.each(['snake', 'tooth-falling-out', 'dead-person', 'a1'])('accepts slug %s', (id) => {
    expect(pipe.transform(id)).toBe(id);
  });

  it.each(['Snake', 'BAD_ID', 'งู', '', 'a'.repeat(65), "x'; drop table dream;--"])('rejects %s', (id) => {
    expect(() => pipe.transform(id)).toThrow(expect.objectContaining({ status: 400, code: 'VALIDATION_ERROR' }));
  });
});
