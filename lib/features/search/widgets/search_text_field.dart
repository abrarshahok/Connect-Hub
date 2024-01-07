import 'package:connecthub/constants/constants.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.searchController,
    required this.onChanged,
  });

  final TextEditingController searchController;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      style: MyFonts.bodyFont(fontColor: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search by name',
        hintStyle: MyFonts.bodyFont(
          fontColor: Colors.white,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: MyColors.secondaryColor.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: MyColors.secondaryColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: MyColors.secondaryColor,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
