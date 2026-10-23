import { Controller, Get, Res } from '@nestjs/common';
import { ApiOkResponse, ApiServiceUnavailableResponse, ApiTags } from '@nestjs/swagger';
import type { Response } from 'express';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('health')
@Controller('health')
export class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  /** Liveness: the process is up. Does not touch the database. */
  @Get()
  @ApiOkResponse({ schema: { example: { status: 'ok' } } })
  live() {
    return { status: 'ok' };
  }

  /** Readiness: 200 when the database answers a trivial query, otherwise 503. */
  @Get('ready')
  @ApiOkResponse({ schema: { example: { status: 'ok', database: 'up' } } })
  @ApiServiceUnavailableResponse({ schema: { example: { status: 'unavailable', database: 'down' } } })
  async ready(@Res({ passthrough: true }) res: Response) {
    if (await this.prisma.isReachable()) return { status: 'ok', database: 'up' };
    res.status(503);
    return { status: 'unavailable', database: 'down' };
  }
}
