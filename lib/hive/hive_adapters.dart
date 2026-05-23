import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import 'package:remind_ai/config/theme/theme_ui_model.dart';

@GenerateAdapters(<AdapterSpec<dynamic>>[AdapterSpec<ThemeUiModel>()])
part 'hive_adapters.g.dart';
