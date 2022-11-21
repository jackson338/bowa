
import 'dart:developer';
import 'dart:io';

import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/main.dart';
import 'package:bowa/models/book.dart';
import 'package:bowa/models/side_notes.dart';
import 'package:bowa/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'writing_bloc.dart';
part 'writing_state.dart';
