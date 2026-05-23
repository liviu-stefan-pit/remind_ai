import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import 'package:remind_ai/config/theme/theme_ui_model.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';

@GenerateAdapters(<AdapterSpec<dynamic>>[
  AdapterSpec<ThemeUiModel>(),
  AdapterSpec<DreamEntry>(),
  AdapterSpec<DreamStyle>(),
])
part 'hive_adapters.g.dart';
