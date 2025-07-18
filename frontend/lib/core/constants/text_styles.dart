import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final heading = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static final subtitle = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final button = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
