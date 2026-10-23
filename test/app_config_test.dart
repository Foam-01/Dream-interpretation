// R1/R5: how API_BASE_URL selects the data source. Sample mode only when the
// value is absent; any non-empty value must be a valid API root, and release
// builds must use HTTPS. Invalid values never fall back to sample data.
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/api_dream_repository.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';

void main() {
  test('absent or blank → sample repository', () {
    expect(repositoryFromEnvironment(''), isA<SampleDreamRepository>());
    expect(repositoryFromEnvironment('   '), isA<SampleDreamRepository>());
  });

  test('valid URL → API repository with the normalised base', () {
    final repo = repositoryFromEnvironment(' http://10.0.2.2:3000/api/v1/ ', requireHttps: false);
    expect(repo, isA<ApiDreamRepository>());
    expect((repo as ApiDreamRepository).baseUrl.toString(), 'http://10.0.2.2:3000/api/v1');
    repo.close();
    final prefixed = repositoryFromEnvironment('https://example.test/dream/api/v1', requireHttps: true);
    expect((prefixed as ApiDreamRepository).baseUrl.path, '/dream/api/v1');
    prefixed.close();
  });

  test('invalid values fail instead of falling back to sample data', () {
    for (final bad in [
      'not a url',
      'http://10.0.2.2:3000',
      'http://10.0.2.2:3000/api',
      'http://10.0.2.2:3000/api/v1/dreams',
      'http://10.0.2.2:3000/api/v1/api/v1',
      'postgresql://user:pass@host/db',
    ]) {
      expect(() => repositoryFromEnvironment(bad, requireHttps: false), throwsFormatException, reason: bad);
    }
  });

  test('release builds reject plain http', () {
    expect(() => repositoryFromEnvironment('http://10.0.2.2:3000/api/v1', requireHttps: true), throwsFormatException);
    final ok = repositoryFromEnvironment('https://api.example.test/api/v1', requireHttps: true);
    expect(ok, isA<ApiDreamRepository>());
    ok.close();
  });

  test('tests run in non-release mode, so the default allows http for local development', () {
    final repo = repositoryFromEnvironment('http://localhost:3000/api/v1');
    expect(repo, isA<ApiDreamRepository>());
    repo.close();
  });
}
