import { Module } from '@nestjs/common';
import { DreamsController } from './dreams.controller';
import { DreamsRepository } from './dreams.repository';
import { DreamsService } from './dreams.service';

@Module({ controllers: [DreamsController], providers: [DreamsService, DreamsRepository] })
export class DreamsModule {}
