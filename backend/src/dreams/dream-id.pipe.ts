import { HttpStatus, Injectable, PipeTransform } from '@nestjs/common';
import { ApiException } from '../common/errors/api-error';

/** Dream ids are lowercase slugs; anything else is rejected before reaching the database. */
@Injectable()
export class DreamIdPipe implements PipeTransform<string, string> {
  transform(value: string): string {
    if (!/^[a-z0-9-]{1,64}$/.test(value)) {
      throw new ApiException(HttpStatus.BAD_REQUEST, 'VALIDATION_ERROR', 'Invalid request', [
        'id must be a lowercase slug (a-z, 0-9, -)',
      ]);
    }
    return value;
  }
}
